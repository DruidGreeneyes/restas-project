;;;; restas-project.lisp

(in-package #:restas-project)

;;; "restas-project" goes here. Hacks and glory await!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Creating a restas project sceleton ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *tree*
  '("tests"
    "templates"
    ("static"
     "js"
     "css"
     "images")))

(defun princ-to-file (file string)
  (with-open-file (out file
		       :direction :output
		       :if-does-not-exist :create
		       :if-exists :supersede)
    (princ string out)))

(defun merge-pathnames-as-directory (pathname &optional (default *default-pathname-defaults*))
  (cl-fad:pathname-as-directory (merge-pathnames pathname default)))

(defun ensure-directory-tree-exists (pathname tree)
  "pathname is the directory where the tree should be,
tree is a cons tree describing the directory structure.
The car is a string nameing the directory, the cdr is a list of child directories.
A child directory can either be a string if it has no children, or it can be a
cons tree of the same form.
Example:
'(\"webapp\"
  \"tests\"
  \"templates\"
  (\"static\"
   \"js\"
   \"css\"
   \"images\"))

This will corespond to the following directory structure:
webapp/
  tests/
  templates/
  static/
    js/
    css/
    images/"
  (let ((path (merge-pathnames-as-directory pathname (car tree))))
    (ensure-directories-exist path)
    (unless (null (cdr tree))
      (loop for child in (cdr tree)
	 if (atom child)
	 do (ensure-directories-exist (merge-pathnames-as-directory path child))
	 else
	 do (ensure-directory-tree-exists path child)))))

(defun start-restas-project (name &key depends-on (test nil))
  (ensure-directory-tree-exists *local-projects* (cons name *tree*))
  (let* ((path (merge-pathnames-as-directory name *local-projects*))
	 (test-path (merge-pathnames-as-directory "tests" path))
	 (asd (merge-pathnames (make-pathname :name name :type "asd") path))
	 (main (merge-pathnames (make-pathname :name name :type "lisp") path))
	 (defmodule (merge-pathnames "defmodule.lisp" path))
	 (test-package (merge-pathnames "package.lisp" test-path))
	 (test-main (merge-pathnames (concatenate 'string name "-test.lisp") test-path)))
    (princ-to-file asd (asd-template name :depends-on depends-on :test test))
    (princ-to-file main (main-template name))
    (princ-to-file defmodule (module-template name))
    (when test
      (princ-to-file test-package (test-package-template name))
      (princ-to-file test-main (test-main name)))))
