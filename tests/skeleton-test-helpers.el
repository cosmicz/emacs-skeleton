;;; skeleton-test-helpers.el --- Test utilities for skeleton  -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Shared test utilities, macros, and helpers.

;;; Code:

(require 'cl-lib)

;;; ─── Message Capture ──────────────────────────────────────────────────

(defvar skeleton-test--message-log 'inactive
  "Message capture state: symbol `inactive' outside tests, a list during.
Bound to nil by test macros to activate capture.")

(defun skeleton-test--capture-message (fn fmt &rest args)
  "Around advice for `message': capture formatted string when active.
Active when `skeleton-test--message-log' is a list (including nil).
Calls FN with FMT and ARGS unconditionally."
  (when (and fmt (listp skeleton-test--message-log))
    (push (apply #'format-message fmt args) skeleton-test--message-log))
  (apply fn fmt args))

(advice-add 'message :around #'skeleton-test--capture-message)

;;; ─── Output Dump on Failure ───────────────────────────────────────────

(defun skeleton-test--dump-captured-output (output-buf)
  "Print captured output to stderr for debugging a failed test.
OUTPUT-BUF is the `standard-output' buffer (may be dead).
Also prints messages from `skeleton-test--message-log'."
  (let ((msgs (nreverse skeleton-test--message-log))
        (output (when (buffer-live-p output-buf)
                  (with-current-buffer output-buf
                    (buffer-string)))))
    (when (or msgs (and output (not (string-empty-p output))))
      (let ((inhibit-message nil))
        (message "── captured test output ──")
        (when msgs
          (message "[messages]")
          (dolist (m msgs)
            (message "  %s" m)))
        (when (and output (not (string-empty-p output)))
          (message "[stdout]")
          (message "%s" output))
        (message "── end captured output ──")))))

;;; ─── Temp Directory Lifecycle ─────────────────────────────────────────

(defun skeleton-test--cleanup-temp (temp-dir output-buf)
  "Clean up TEMP-DIR and output buffer OUTPUT-BUF.
Kills any buffers visiting files under TEMP-DIR before deletion."
  (when (buffer-live-p output-buf)
    (kill-buffer output-buf))
  (dolist (buf (buffer-list))
    (when (and (buffer-file-name buf)
               (string-prefix-p temp-dir (buffer-file-name buf)))
      (with-current-buffer buf
        (set-buffer-modified-p nil)
        (kill-buffer buf))))
  (delete-directory temp-dir t))

(defmacro skeleton-test--with-suppressed-output (temp-dir &rest body)
  "Run BODY with output suppression; dump captured output on error.
TEMP-DIR is the root temp directory for cleanup."
  (declare (indent 1))
  `(let ((skeleton-test--message-log nil)
         (inhibit-message t)
         (standard-output (generate-new-buffer " *skeleton-test-output*")))
     (unwind-protect
         (condition-case err
             (progn ,@body)
           (error
            (skeleton-test--dump-captured-output standard-output)
            (signal (car err) (cdr err))))
       (skeleton-test--cleanup-temp ,temp-dir standard-output))))

(defmacro skeleton-test-with-temp-dir (&rest body)
  "Execute BODY in a temporary directory with output suppression.
Binds `default-directory' to a fresh temp dir.  Suppresses messages
and stdout during execution; dumps captured output on test failure."
  (declare (indent 0) (debug t))
  `(let ((temp-dir (make-temp-file "skeleton-test-" t)))
     (skeleton-test--with-suppressed-output temp-dir
       (let ((default-directory (file-name-as-directory temp-dir)))
         ,@body))))

;;; ─── Message Log ──────────────────────────────────────────────────────

(defmacro skeleton-test-with-messages (&rest body)
  "Execute BODY while capturing messages.
Bind `skeleton-test--message-log' to a list during execution."
  (declare (indent 0) (debug t))
  `(let ((skeleton-test--message-log nil))
     ,@body
     (nreverse skeleton-test--message-log)))

(provide 'skeleton-test-helpers)
;;; skeleton-test-helpers.el ends here
