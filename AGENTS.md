# AGENTS.md

## Project overview

## Build and test commands

```sh
make compile                          # Byte-compile all .el files
make lint                             # Byte-compile with warnings + checkdoc
make test                             # Run all tests
make test SELECT="^skeleton-test-core" # Run tests matching pattern
make clean                            # Remove .elc files and build artifacts
```

Emacs is invoked via `EMACS ?= emacs`; override with
`make test EMACS=/path/to/emacs`.

## Code style

- `lexical-binding: t` in every file
- Public symbols: `skeleton-name`, internal: `skeleton--name`
- Immutable structs (`cl-defstruct` with `:read-only t`, private constructors)
- Docstrings on all public functions
- Section dividers: `;;; ─── Section Name ──────`
- Standard Emacs Lisp file headers (`;;; file.el --- Description`)

## File structure

```
skeleton.el              Entry point, requires all modules
skeleton-core.el         Core domain logic and data structures
skeleton-settings.el     defgroup + defcustom configuration

tests/
  skeleton-tests-runner.el    Test runner (batch + interactive)
  skeleton-test-helpers.el    Shared test utilities
  skeleton-core-tests.el      Core domain tests
```

## Adding a module

1. Create `skeleton-foo.el` with standard header
2. Add `(require 'skeleton-foo)` to `skeleton.el`
3. Create `tests/skeleton-foo-tests.el`
4. Add `(require 'skeleton-foo-tests)` to `tests/skeleton-tests-runner.el`
5. Run `make test`

## Testing

- Tests use `ert` (Emacs Lisp Regression Testing)
- Test names follow `skeleton-test-*` pattern
- One test file per module
- Helper macros in `skeleton-test-helpers.el` provide temp dirs and
  message capture

## PR and commit guidelines

- Present tense commit messages ("Add feature" not "Added feature")
- First line under 72 characters
- All tests must pass and byte-compile must be clean before merging
