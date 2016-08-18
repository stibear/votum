(in-package :cl-user)
(defpackage votum.utilities
  (:use :cl
	:iterate)
  (:export :borda-to-majority))
(in-package :votum.utilities)

(defun borda-to-majority (candidates rank-lists)
  (values
   candidates
   (iter (for n below (list-length candidates))
     (collecting
       (iter (for l in rank-lists)
	 (counting (= 1 (nth n l))))))))
