;;; skeleton-core.el --- Core domain logic for skeleton  -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Core data structures and domain logic.

;;; Code:

(require 'cl-lib)

;;; ─── Data Structures ──────────────────────────────────────────────────

(cl-defstruct (skeleton-thing (:constructor skeleton-thing--create)
                              (:copier nil))
  "A thing in the skeleton domain."
  (name nil :type string :read-only t)
  (value nil :read-only t))

;;; ─── Constructors ─────────────────────────────────────────────────────

(defun skeleton-make-thing (name &optional value)
  "Create a new thing with NAME and optional VALUE."
  (skeleton-thing--create :name name :value value))

;;; ─── Core Operations ──────────────────────────────────────────────────

(defun skeleton-process (thing)
  "Process THING and return the result."
  (skeleton-thing-name thing))

(provide 'skeleton-core)
;;; skeleton-core.el ends here
