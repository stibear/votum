(in-package :cl-user)
(defpackage votum.voting-system
  (:use :cl
	:iterate)
  (:export :majority-rule
	   :borda-count))
(in-package :votum.voting-system)

;; Utility
(defun max-position (lst)
  (declare (type list lst))
  (position (iter (for i in lst) (finding i maximizing i)) lst))

;; Voting Systems
(defun majority-rule (candidates vote-list)
  "CANDIDATES---a list.
VATE-LIST---a list of numbers of votes obtained
Return values---the winner of candidates & his number of votes obtained"
  (let ((nth (max-position vote-list)))
    (values (nth nth candidates)
	    (nth nth vote-list))))

(defun borda-count (candidates rank-lists)
  "CANDIDATES---a list.
RANK-LISTS---a list of list which contains ranks of each candidate.
Return values---the winner of candidates & a list of scores."
  (let ((n (list-length candidates)))
    (let ((lst (iter (for lst in rank-lists)
		 (reducing (mapcar #'(lambda (m) (- (1+ n) m)) lst)
			   by #'(lambda (x y) (mapcar #'+ x y))))))
      (values (nth (position (iter (for i in lst) (finding i maximizing i)) lst)
		   candidates)
	      lst))))

;; (defun condorcet)
