#|
  This file is a part of votum project.
  Copyright (c) 2016 Wataru NAKANISHI (stibear)
|#

#|
  This provides voting forms with variable voting systems

  Author: Wataru NAKANISHI (stibear)
|#

(in-package :cl-user)
(defpackage votum-asd
  (:use :cl :asdf))
(in-package :votum-asd)

(defsystem votum
  :version "0.1"
  :author "Wataru NAKANISHI (stibear)"
  :license "MIT"
  :depends-on (:iterate)
  :components ((:module "src"
		:serial t
                :components
                ((:file "voting-system")
		 (:file "utilities")
		 (:file "votum"))))
  :description "This provides voting forms with variable voting systems"
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op votum-test))))
