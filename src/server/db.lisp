(in-package :cl-user)
(defpackage votum-server.db
  (:use :cl :datafly)
  (:import-from :votum-server.config
		:config)
  (:import-from :datafly
		:*connection*
                :connect-cached)
  (:export :connection-settings
	   :db
           :with-connection))
(in-package :votum-server.db)

(defun connection-settings (&optional (db :maindb))
  (cdr (assoc db (config :databases))))

(defun db (&optional (db :maindb))
  (apply #'connect-cached (connection-settings db)))

(defmacro with-connection (conn &body body)
  `(let ((*connection* ,conn))
     ,@body))
