(in-package :cl-user)
(defpackage votum-server.config
  (:use :cl
	:caveman2))
(in-package :votum-server.web)

(syntax:use-syntax :annot)

(defclass <web> (<app>))
