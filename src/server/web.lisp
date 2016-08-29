(in-package :cl-user)
(defpackage votum-server.web
  (:use :cl
	:caveman2
	:iterate
	:votum-server.config
	:votum-server.view
	:votum-server.db
	:votum-server.model
	:datafly
	:sxql
	:votum)
  (:export :*web*))
(in-package :votum-server.web)

(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

@route GET "/"
(defun index ()
  (render #P"index.html"))

@route GET "/new"
(defun new ()
  (render #P"new.html"
	  `(:voting-systems ,*voting-systems*)))

@route GET "/list"
(defun form-list ()
  (render #P"list.html"
	  `(:forms
	    ,(with-connection (db)
	       (retrieve-all
		(select (:id :name :subject :explanation) (from :voting_form)))))))

@route GET "/list/:id"
(defun form (&key id)
  (let ((form-content (with-connection (db)
			(retrieve-one
			 (select :* (from :voting_form) (where (:= :id id)))
			 :as 'voting-form))))
    (setf (gethash :form-id *session*) id)
    (if (voting-form-closed form-content)
	(let ((candidates (voting-form-candidates form-content))
	      (system (voting-form-voting-system form-content))
	      (votes (with-connection (db) (voting-form-votes form-content))))
	  (flet ((rank (scores)
		   (iter (for e in scores) (for n from 1 to (list-length scores))
		     (with r = 1) (with before)
		     (unless (and before (= e before)) (setf r n))
		     (setf before e)
		     (collect r))))
	    (cond
	      ((string= system :majority-rule)
	       (let* ((score (iter (for cand in (voting-form-candidates form-content))
			       (collect
				   (iter (for vote in votes)
				     (counting (string= cand (vote-vote vote)))))))
		      (winner (majority-rule candidates score)))
		 (render #P"result.html"
			 `(:form-content ,(object-to-plist form-content)
			   :multi-win ,(listp winner)
			   :winner ,winner
			   :cand-score-rank ,(sort (mapcar #'list candidates score (rank score))
						   #'> :key #'second))))))))
	(render #P"form.html"
		`(:form-content ,(object-to-plist form-content)
		  :how-to-vote ,(symbol-name
				 (third
				  (find-if
				   #'(lambda (l)
				       (member
					(voting-form-voting-system form-content) l :test #'string=))
				   *voting-systems*))))))))

@route POST "/list/voted"
(defun voted (&key |voted_cand|)
  (with-connection (db)
    (execute
     (insert-into :vote
       (set= :form_id (gethash :form-id *session*)
	     :vote |voted_cand|))))
  (render #P"submitted.html"
	  `(:status "succeeded")))

@route POST "/submit"
(defun submit (&key |name| |password| |subject|
		 |explanation| |voting_system| |candidates|)
  (unless |name| (return-from submit "Failed."))
  (with-connection (db)
    (execute
     (insert-into :voting_form
       (set= :name |name|
	     :password |password|
	     :subject |subject|
	     :explanation |explanation|
	     :voting_system |voting_system|
	     :candidates |candidates|)))))

@route GET "/submitted/:status"
(defun submitted (&key status)
  (render #P"submitted.html"
	  `(:status ,status)))

@route GET "/signin"
(defun signin ()
  (let ((form-id (gethash :form-id *session*)))
    (unless form-id (redirect "/list"))
    (let ((form-subject (with-connection (db)
			  (second
			   (retrieve-one
			    (select :subject (from :voting_form) (where (:= :id form-id))))))))
      (render #P"signin.html"
	      `(:form-id ,form-id
		:form-subject ,form-subject)))))

@route POST "/signin"
(defun validate (&key |name| |password|)
  (let* ((form-id (gethash :form-id *session*))
	 (form-name-password (with-connection (db)
			      (retrieve-one
			       (select (:name :password) (from :voting_form) (where (:= :id form-id)))))))
    (if (and (string= |name| (getf form-name-password :name))
	     (string= |password| (getf form-name-password :password)))
	(progn (setf (gethash :signed *session*) t) (redirect "/config"))
	(throw-code 403))))

@route GET "/config"
(defun config-page ()
  (let ((form-id (gethash :form-id *session*))
	(signed (gethash :signed *session*)))
    (unless (and form-id signed) (redirect "/list"))
    (let ((form-subject (with-connection (db)
			  (second
			   (retrieve-one
			    (select :subject (from :voting_form) (where (:= :id form-id))))))))
      (setf (gethash :signed *session*) nil)
      (render #P"config.html"
	      `(:form-id ,form-id
		:form-subject ,form-subject)))))

@route POST "/close"
(defun form-close ()
  (with-connection (db)
    (execute
     (update :voting_form
       (set= :closed 1)
       (where (:= :id (gethash :form-id *session*))))))
  (redirect (format nil "/list/~A" (gethash :form-id *session*))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))


(defmethod on-exception ((app <web>) (code (eql 403)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/403.html"
		   *template-directory*))
