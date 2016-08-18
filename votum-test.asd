#|
  This file is a part of votum project.
  Copyright (c) 2016 Wataru NAKANISHI (stibear)
|#

(in-package :cl-user)
(defpackage votum-test-asd
  (:use :cl :asdf))
(in-package :votum-test-asd)

(defsystem votum-test
  :author "Wataru NAKANISHI (stibear)"
  :license "MIT"
  :depends-on (:votum
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "votum"))))
  :description "Test system for votum"
  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
