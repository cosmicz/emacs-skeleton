;;; skeleton-tests-runner.el --- Test runner for skeleton  -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Test runner and utilities for skeleton tests.

;;; Code:

(require 'ert)
(require 'skeleton)

;;; ─── Test Environment Setup ───────────────────────────────────────────

(defun skeleton-setup-test-environment ()
  "Setup the test environment for skeleton.
Configure project-specific settings for clean test execution."
  (setq max-lisp-eval-depth 1000
        print-level 1000
        print-length 1000)
  (message "skeleton test environment setup complete."))

;;; ─── Load Test Files ──────────────────────────────────────────────────

(require 'skeleton-test-helpers)
(require 'skeleton-core-tests)

;;; ─── Test Runner Functions ────────────────────────────────────────────

(defvar skeleton-test-verbose nil
  "Non-nil lets `message' output through to stderr during tests.
Set via SKELETON_TEST_VERBOSE env var or VERBOSE make variable.")

(defun skeleton-run-tests (&optional selector)
  "Run skeleton tests interactively matching SELECTOR."
  (interactive)
  (skeleton-setup-test-environment)
  (ert-run-tests-interactively (or selector "^skeleton-test-")))

(defun skeleton-run-tests-batch (&optional selector)
  "Run skeleton tests in batch mode matching SELECTOR.
When `skeleton-test-verbose' is non-nil, test messages are printed
to stderr instead of being captured by ERT."
  (skeleton-setup-test-environment)
  (let ((env (getenv "SKELETON_TEST_VERBOSE")))
    (when (and env (not (string-empty-p env)))
      (setq skeleton-test-verbose t)))
  (when skeleton-test-verbose
    ;; Redirect `message' to stderr so ERT can't swallow it
    (advice-add 'message :after
                (lambda (fmt &rest args)
                  (let ((text (apply #'format-message fmt args)))
                    (princ (concat text "\n") #'external-debugging-output)))
                '((name . skeleton-test-verbose))))
  (let ((selector-regexp (if (or (null selector) (string-empty-p selector))
                             "^skeleton-test-"
                           selector)))
    (ert-run-tests-batch-and-exit selector-regexp)))

(provide 'skeleton-tests-runner)
;;; skeleton-tests-runner.el ends here
