;;;; restas-utils.asd

(defpackage #:restas-project-config (:export #:*base-directory*))
(defparameter restas-project-config:*base-directory* 
  (make-pathname :name nil :type nil :defaults *load-truename*))

(asdf:defsystem #:restas-project
  :serial t
  :description "Generate a restas project tree"
  :author "Pavel Penev <pvl.penev@gmail.com"
  :license "MIT"
  :depends-on (#:cl-interpol
               #:cl-fad
               #:alexandria)
  :components ((:file "package")
	       (:file "templates")
               (:file "restas-project")))

