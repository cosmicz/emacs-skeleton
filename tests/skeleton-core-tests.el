;;; skeleton-core-tests.el --- Tests for skeleton-core  -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Tests for core domain logic.

;;; Code:

(require 'ert)
(require 'skeleton-core)
(require 'skeleton-test-helpers)

;;; ─── Struct Tests ─────────────────────────────────────────────────────

(ert-deftest skeleton-test-make-thing ()
  "Test creation of a thing struct."
  (let ((thing (skeleton-make-thing "test" 42)))
    (should (skeleton-thing-p thing))
    (should (equal (skeleton-thing-name thing) "test"))
    (should (= (skeleton-thing-value thing) 42))))

(ert-deftest skeleton-test-make-thing-no-value ()
  "Test creation of a thing with no value."
  (let ((thing (skeleton-make-thing "empty")))
    (should (skeleton-thing-p thing))
    (should (equal (skeleton-thing-name thing) "empty"))
    (should (null (skeleton-thing-value thing)))))

;;; ─── Core Operation Tests ─────────────────────────────────────────────

(ert-deftest skeleton-test-process ()
  "Test processing a thing."
  (let ((thing (skeleton-make-thing "hello" 99)))
    (should (equal (skeleton-process thing) "hello"))))

(provide 'skeleton-core-tests)
;;; skeleton-core-tests.el ends here
