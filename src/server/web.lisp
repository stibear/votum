(in-package :cl-user)
(defpackage votum-server.web
  (:use :cl
	:caveman2
	:votum-server.config
	:votum-server.view)
  (:export :*web*))
(in-package :votum-server.web)

(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

@route GET "/"
(defun index ()
  (render #P"index.html"
	  '(:title "VOTUM")))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
