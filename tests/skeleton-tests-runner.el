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

(defun skeleton-run-tests (&optional selector)
  "Run skeleton tests interactively matching SELECTOR."
  (interactive)
  (skeleton-setup-test-environment)
  (ert-run-tests-interactively (or selector "^skeleton-test-")))

(defun skeleton-run-tests-batch (&optional selector)
  "Run skeleton tests in batch mode matching SELECTOR."
  (skeleton-setup-test-environment)
  (let ((selector-regexp (if (or (null selector) (string-empty-p selector))
                             "^skeleton-test-"
                           selector)))
    (ert-run-tests-batch-and-exit selector-regexp)))

(provide 'skeleton-tests-runner)
;;; skeleton-tests-runner.el ends here
