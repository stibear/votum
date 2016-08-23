(in-package :cl-user)
(defpackage votum-test
  (:use :cl
        :votum
        :prove))
(in-package :votum-test)

;; NOTE: To run this test file, execute `(asdf:test-system :votum)' in your Lisp.
(plan 3)

(let* ((c '(x y z))
       (rl (append (loop :repeat 4 :collect '(1 2 3))
		   (loop :repeat 4 :collect '(1 3 2))
		   (loop :repeat 7 :collect '(3 1 2))
		   (loop :repeat 6 :collect '(3 2 1))))
       (c2 '(a b c d e))
       (rl2 (mapcar #'(lambda (p) (votum.voting-system::order-to-rank c2 p))
		    (apply #'append
			   `(,(loop :repeat 5 :collect '(a c b e d))
			      ,(loop :repeat 5 :collect '(a d e c b))
			      ,(loop :repeat 8 :collect '(b e d a c))
			      ,(loop :repeat 3 :collect '(c a b e d))
			      ,(loop :repeat 7 :collect '(c a e b d))
			      ,(loop :repeat 2 :collect '(c b a d e))
			      ,(loop :repeat 7 :collect '(d c e b a))
			      ,(loop :repeat 8 :collect '(e b a d c)))))))
  (is (borda-count c rl) 'Y)
  (is (multiple-value-call #'majority-rule (borda-to-majority c rl)) 'X)
  (is (schulze-method c2 rl2) 'E))

(finalize)
