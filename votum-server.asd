(in-package :cl-user)
(defpackage votum-server-asd
  (:use :cl :asdf))
(in-package :votum-server-asd)

(defsystem votum-server
  :version "0.1"
  :author "Wataru NAKANISHI (stibear)"
  :license "MIT"
  :depends-on (:clack
	       :lack
               :caveman2
	       :envy
	       :cl-ppcre
	       :uiop
	       :cl-syntax-annot
	       :djula
	       :datafly
	       :sxql
	       :iterate
	       :cl-csv
	       :votum)
  :components ((:module "src/server"
		:serial t
                :components
                ((:file "config")
		 (:file "db")
		 (:file "model")
		 (:file "view")
		 (:file "web")
		 (:file "main"))))
  :in-order-to ((test-op (test-op votum-server-test))))
