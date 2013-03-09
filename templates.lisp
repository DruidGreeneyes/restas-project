;;;; templates.lisp

(in-package #:restas-project)

;;;;;;;;;;;;;;;;;;;;;;
;;; File templates ;;;
;;;;;;;;;;;;;;;;;;;;;;

(cl-interpol:enable-interpol-syntax)

(defun asd-template (name &key
			    (description "Your description here")
			    (author "Your name here")
			    (license "Your license here")
			    (depends-on nil)
			    (test nil))
  (let ((depends-on (cons :restas depends-on)))
    (concatenate
     'string
     #?"(defpackage #:${name}-config (:export #:*base-directory*))
(defparameter ${name}-config:*base-directory* 
  (make-pathname :name nil :type nil :defaults *load-truename*))

(asdf:defsystem #:${name}
  :serial t
  :description \"${description}\"
  :author \"${author}\"
  :license \"${license}\"
  :depends-on ${(prin1-to-string depends-on)}
  :components ((:file \"defmodule\")
               (:file \"${name}\")))"
      (when test
        #?"

(asdf:defsystem #:${name}-test
  :serial t
  :depends-on (#:fiveam #:${name})
  :pathname \"tests/\"
  :components ((:file \"package\")
	       (:file \"${name}-test\")))"))))

(defun main-template (name)
  #?";;;; ${name}.lisp

(in-package #:${name})

;;; \"${name}\" goes here. Hacks and glory await!")

(defun module-template (name)
  #?";;;; defmodule.lisp

(restas:define-module #:${name}
  (:use #:cl))

(in-package #:${name})

(defparameter *template-directory*
  (merge-pathnames #P\"templates/\" ${name}-config:*base-directory*))

(defparameter *static-directory*
  (merge-pathnames #P\"static/\" ${name}-config:*base-directory*))


")

(defun test-package-template (name)
  #?";;;; package.lisp

(defpackage #:${name}-test
  (:use #:cl :5am))")

(defun test-main (name)
  #?";;;; #{name}-test.lisp

(in-package #:{name}-test)")


(cl-interpol:disable-interpol-syntax)
