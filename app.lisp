#+sbcl
(setf sb-impl::*default-external-format* :utf-8
      sb-alien::*default-c-string-external-format* :utf-8)

(ql:quickload :votum-server)

(defpackage votum-server.app
  (:use :cl)
  (:import-from :lack.builder
		:builder))
(in-package :votum-server.app)

