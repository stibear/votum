(in-package :cl-user)
(defpackage votum-server.view
  (:use :cl)
  (:import-from :votum-server.config
                :*template-directory*)
  (:import-from :caveman2
                :*response*
                :response-headers)
  (:import-from :djula
                :add-template-directory
                :compile-template*
                :render-template*
                :*djula-execute-package*)
  (:import-from :datafly
		:encode-json)
  (:export :render
           :render-json))
(in-package :votum-server.view)

(add-template-directory *template-directory*)

(defparameter *template-registry* (make-hash-table :test #'equal))

(defun render (template-path &optional env)
  (let ((template (gethash template-path *template-registry*)))
    (unless template
      (setf template (compile-template* (princ-to-string template-path)))
      (setf (gethash template-path *template-registry*) template))
    (apply #'render-template*
           template nil
           env)))

(defun render-json (object)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (encode-json object))


;;
;; Execute package definition

(defpackage votum-server.djula
  (:use :cl)
  (:import-from :votum-server.config
                :config
                :appenv
                :developmentp
                :productionp)
  (:import-from :caveman2
                :url-for))

(setf djula:*djula-execute-package* (find-package :votum-server.djula))
