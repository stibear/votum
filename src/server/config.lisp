(in-package :cl-user)
(defpackage votum-server.config
  (:use :cl)
  (:import-from :envy
		:config-env-var
		:defconfig)
  (:export :config
           :*application-root*
           :*static-directory*
           :*template-directory*
	   :*voting-systems*
           :appenv
	   :developmentp
           :productionp))
(in-package :votum-server.config)

(setf (config-env-var) "APP_ENV")

(defparameter *application-root* (asdf:system-source-directory :votum-server))
(defparameter *static-directory* (merge-pathnames #P"static/" *application-root*))
(defparameter *template-directory* (merge-pathnames #P"templates/" *application-root*))

(defparameter *voting-systems* '(("Majority Rule" :majority-rule :radio)
				 ("Borda Count" :borda-count :select)
				 ("Schulze Method" :schulze-method :input)))

(defconfig :common
  '(:databases ((:maindb :mysql :database-name "votum_server" :username "votum_server"))))

(defconfig |development|
  '())

(defconfig |production|
  `(:error-log ,(merge-pathnames #P"log/error.log" *application-root*)))

(defconfig |test|
  '())

(defun config (&optional key)
  (envy:config #.(package-name *package*) key))

(defun appenv ()
  (uiop:getenv (config-env-var #.(package-name *package*))))

(defun developmentp ()
  (string= (appenv) "development"))

(defun productionp ()
  (string= (appenv) "production"))
