(in-package :cl-user)
(defpackage votum-server.model
  (:use :cl
	:sxql
	:cl-annot.class
	:datafly))
(in-package :votum-server.model)

(syntax:use-syntax :annot)

@export-accessors
@export
@model
(defstruct (voting-form
	    (:inflate candidates #'(lambda (str) (cl-csv:read-csv-row str)))
	    (:inflate closed #'tinyint-to-boolean)
	    (:has-many (votes vote)
	     (select :*
	       (from :vote)
	       (where (:= :form_id id)))))
  id
  name
  password
  subject
  explanation
  voting-system
  candidates
  closed)
@export 'voting-form-votes

@export-accessors
@export
@model
(defstruct vote
  id
  form-id
  vote)
