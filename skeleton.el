;;; skeleton.el --- TODO: describe your package  -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author:
;; Keywords:
;; Package-Requires: ((emacs "29.1"))
;; Version: 0.1.0

;; This file is not part of GNU Emacs.

;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;;; Commentary:

;; Entry point for skeleton.
;;
;; This file provides autoloads and top-level require for the package.

;;; Code:

(require 'skeleton-settings)
(require 'skeleton-core)

(defconst skeleton-version "0.1.0"
  "Current version of skeleton.")

;;; ── Module List & Reload ─────────────────────────────────────────────

(defconst skeleton--modules
  '(skeleton-settings skeleton-core skeleton)
  "Skeleton modules to reload, in dependency order.")

;;;###autoload
(defun skeleton-reload ()
  "Force-reload all skeleton modules and invalidate caches."
  (interactive)
  (let ((dir (file-name-directory (or load-file-name
                                      (locate-library "skeleton")
                                      buffer-file-name
                                      default-directory))))
    (unless (member dir load-path)
      (add-to-list 'load-path dir))
    (dolist (mod skeleton--modules)
      (let ((file (locate-library (symbol-name mod))))
        (when file
          (load file nil t t)))))
  ;; Clear any runtime caches here if needed, e.g.:
  ;; (setq skeleton--some-cache nil)
  (message "Reloaded %d skeleton modules"
           (length skeleton--modules)))

(provide 'skeleton)
;;; skeleton.el ends here
