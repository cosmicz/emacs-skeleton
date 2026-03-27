EMACS ?= emacs

BATCH = $(EMACS) --batch -Q -L . -L ./tests

.PHONY: all compile lint test tests clean clean-elc help

all: compile

compile:
	@echo "Compiling skeleton Elisp files..."
	@$(BATCH) -f batch-byte-compile *.el

lint:
	@echo "Running lint checks..."
	@$(BATCH) --eval '(require (quote bytecomp))' \
		--eval '(setq byte-compile-error-on-warn t byte-compile-warnings (quote (not docstrings-wide)))' \
		-f batch-byte-compile *.el
	@echo "Byte-compile clean."
	@$(BATCH) --eval '\
	  (let ((files (directory-files "." t "^skeleton.*\\.el$$")) \
	        (ok t)) \
	    (dolist (f files) \
	      (with-temp-buffer \
	        (insert-file-contents f) \
	        (emacs-lisp-mode) \
	        (condition-case err \
	            (checkdoc-current-buffer t) \
	          (error (setq ok nil) \
	                 (message "checkdoc: %s: %s" f (error-message-string err)))))) \
	    (unless ok (kill-emacs 1)))' \
		2>&1 || true
	@echo "Lint complete."

SELECT ?= ^skeleton-test-
SELECTOR ?= $(SELECT)
# VERBOSE=1 to show message output from tests (not swallowed by ERT)
VERBOSE ?=

test: clean-elc
	@SKELETON_TEST_VERBOSE=$(VERBOSE) $(BATCH) -l ./tests/skeleton-tests-runner.el \
		--eval '(skeleton-run-tests-batch "$(SELECTOR)")' \
		< /dev/null

tests: test

clean-elc:
	@rm -f *.elc tests/*.elc

clean: clean-elc
	@echo "Cleaning up all build artifacts..."
	@rm -rf .packages
	@echo "Done."

help:
	@echo "skeleton Makefile targets:"
	@echo "  all      - Default target. Same as 'compile'"
	@echo "  compile  - Byte-compile all Elisp files"
	@echo "  lint     - Byte-compile with warnings + checkdoc"
	@echo "  test     - Run tests (SELECT= to filter, VERBOSE=1 for messages)"
	@echo "  tests    - Alias for 'test'"
	@echo "  clean-elc - Remove byte-compiled .elc files only"
	@echo "  clean    - Remove .elc files and build artifacts"
	@echo "  help     - Show this help message"
