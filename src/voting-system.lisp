(in-package :cl-user)
(defpackage votum.voting-system
  (:use :cl
	:iterate)
  (:export :majority-rule
	   :borda-count
	   :schulze-method))
(in-package :votum.voting-system)

;; Utility
(defun max-position (lst)
  (position (iter (for i in lst) (finding i maximizing i)) lst))

(defun normalize-rank-lists (lst)
  (mapcar #'(lambda (l)
	      (mapcar #'(lambda (n)
			  #+sbcl
			  (if (= n 0) sb-ext:single-float-positive-infinity n))
		      l))
	  lst))

(defun order-to-rank (can order)
  "(B A D E C) -> (2 1 5 3 4)"
  (iter (for c in can)
    (collect (1+ (position c order)))))

(defun rank-to-order (can rank)
  "(2 1 5 3 4) -> (B A D E C)"
  (let* ((n (list-length can))
	 (lst (make-list n)))
    (iter (for r in rank)
          (for i below n)
      (setf (nth (1- r) lst) (nth i can)))
    lst))

;; Voting Systems
(defun majority-rule (candidates vote-list)
  "CANDIDATES---a list.
VOTE-LIST---a list of numbers of votes obtained
Return values---the winner of candidates & his number of votes obtained"
  (let* ((nth (max-position vote-list))
	 (max (apply #'max vote-list)))
    (if (= 1 (count max vote-list))
	(values (nth nth candidates)
		(nth nth vote-list))
	(multiple-value-bind (c v) (majority-rule (nthcdr (1+ nth) candidates)
						  (nthcdr (1+ nth) vote-list))
	  (if (listp c)
	      (values (cons (nth nth candidates) c)
		      (cons (nth nth vote-list) v))
	      (values (cons (nth nth candidates) (list c))
		      (cons (nth nth vote-list) (list v))))))))

(defun borda-count (candidates rank-lists)
  "CANDIDATES---a list.
RANK-LISTS---a list of list which contains ranks of each candidate.
Return values---the winner of candidates & a list of scores."
  (let* ((n (list-length candidates))
	 (lst (iter (for lst in rank-lists)
		(reducing (mapcar #'(lambda (m) (- (1+ n) m)) lst)
			  by #'(lambda (x y) (mapcar #'+ x y))))))
    (values (nth (position (apply #'max lst) lst)
		 candidates)
	    lst)))

(defun schulze-method (candidates rank-lists)
  "CANDIDATES---a list.
RANK-LISTS---a list of list which contains ranks of each candidate.
Return values---the winner of cadidates & an array(N*N) of p[*,*]."
  (let* ((n (list-length candidates))
	 (ds (make-array (list n n)))
	 (ps (make-array (list n n)))
	 (rank-lists (normalize-rank-lists rank-lists)))
    (iter (for i below n)
      (iter (for j below n)
	(iter (for l in rank-lists)
	  (counting (< (nth i l) (nth j l)) into x)
	  (finally (setf (aref ds i j) x)))))
    
    (iter (for i below n)
      (iter (for j below n)
	(unless (= i j)
	  (setf (aref ps i j)
		(if (> (aref ds i j) (aref ds j i)) (aref ds i j) 0)))))
    (iter (for i below n)
      (iter (for j below n)
	(unless (= i j)
	  (iter (for k below n)
	    (when (and (/= i k) (/= j k))
	      (setf (aref ps j k) (max (aref ps j k) (min (aref ps j i) (aref ps i k)))))))))

    (let ((lst (iter (for i below n)
		 (collect
		     (iter (for j below n)
		       (counting (> (aref ps i j) (aref ps j i))))))))
      (values (nth (position (apply #'max lst) lst) candidates)
	      ps))))

