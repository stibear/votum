(in-package :cl-user)
(defpackage votum
  (:use :cl
	:votum.utilities
        :votum.voting-system)
  (:export :borda-to-majority
	   :majority-rule
	   :borda-count
	   :schulze-method))
(in-package :votum)

