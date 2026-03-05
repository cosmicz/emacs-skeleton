;;; skeleton-settings.el --- Configuration for skeleton  -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; This file is not part of GNU Emacs.

;;; Commentary:

;; User-facing configuration options for skeleton.

;;; Code:

(defgroup skeleton nil
  "Brief description of skeleton."
  :group 'tools
  :prefix "skeleton-")

(defcustom skeleton-log-buffer "*Skeleton Log*"
  "Buffer name for skeleton logging output.
Set to nil to disable logging."
  :type '(choice (string :tag "Buffer name")
                 (const :tag "Disabled" nil))
  :group 'skeleton)

(provide 'skeleton-settings)
;;; skeleton-settings.el ends here
