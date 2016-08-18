(in-package :cl-user)
(defpackage votum-server.web
  (:use :cl
	:caveman2
	:votum-server.config)
  (:export :*web*))
(in-package :votum-server.web)

(syntax:use-syntax :annot)


(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(defmethod lack.component:call :around ((app <web>) env)
  )
