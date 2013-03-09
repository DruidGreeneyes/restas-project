;;;; package.lisp

(defpackage #:restas-project
  (:use #:cl)
  (:export #:start-restas-project))

(in-package #:restas-project)

(defparameter *local-projects* (first ql:*local-project-directories*))

