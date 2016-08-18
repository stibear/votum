(in-package :cl-user)
(defpackage votum-test
  (:use :cl
        :votum
        :prove))
(in-package :votum-test)

;; NOTE: To run this test file, execute `(asdf:test-system :votum)' in your Lisp.
(plan 2)

(let ((c '(x y z))
      (rl (append (loop :repeat 4 :collect '(1 2 3))
		  (loop :repeat 4 :collect '(1 3 2))
		  (loop :repeat 7 :collect '(3 1 2))
		  (loop :repeat 6 :collect '(3 2 1)))))
  (is (borda-count c rl) 'Y)
  (is (multiple-value-call #'majority-rule (borda-to-majority c rl)) 'X))

(finalize)
