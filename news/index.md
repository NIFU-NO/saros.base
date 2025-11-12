# Changelog

## saros.base 1.2.0

### New features

- Added file logging for excluded/ignored variables via `log_file`
  parameter in
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md).
  All removal functions now log which variables/entries are excluded and
  why (all NA, low n, non-significant, no overlap, type mismatch).
- Added
  [`detect_malformed_quarto_project()`](https://nifu-no.github.io/saros.base/reference/detect_malformed_quarto_project.md):
  exported function to diagnose malformed Quarto website projects
  (missing index.qmd, missing title in .qmd files, extensible for future
  checks).
- New function
  [`check_variable_labels()`](https://nifu-no.github.io/saros.base/reference/check_variable_labels.md)
  to validate variable labels for saros compatibility.
- New function `sanitize_chr_vec` for ensuring that character vectors
  are clean:
  - Normalized Unicode strings to NFC form.
  - Removed non-printable characters.
  - Replaced common encoding artifacts (e.g., `â€™` to `'`).
- Added chunk template variant 4 (`get_chunk_template_defaults(4)`) for
  mesos reports using the new saros package functions
  `crowd_plots_as_tabset()` and `txt_from_cat_mesos_plots()`. This
  provides a more streamlined approach for generating mesos-specific
  plots and tables.

### Performance improvements

- Vectorized password lookup in `refer_main_password_file()` for better
  performance.

### Bug fixes

- Fixed critical sorting bug in
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  where output was incorrectly sorted by variable labels instead of
  variable positions when using default arguments. The fix includes:
  - Corrected `arrange_expr_producer()` to properly name arrange
    expressions with column names instead of logical values.
  - Added ungrouping before sorting in `arrange_arrangers_and_groups()`
    to prevent grouped data from interfering with global sort order.
  - Made chapter reordering stable to preserve within-chapter sorting.
- Fixed regex bugs in
  [`check_variable_labels()`](https://nifu-no.github.io/saros.base/reference/check_variable_labels.md).
- Fixed tidyselect warnings in `look_for_extended()`.
- Improved robustness of
  [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md).
- Added validation checks for email and username columns in
  [`create_email_credentials()`](https://nifu-no.github.io/saros.base/reference/create_email_credentials.md).

### Code quality improvements

- Refactored long functions by extracting helper functions:
  - `validate_refine_chapter_overview_args()`
  - `validate_draft_report_args()`
  - `create_mesos_stubs_from_main_files()`
  - [`gen_qmd_file()`](https://nifu-no.github.io/saros.base/reference/gen_qmd_file.md)
  - `create_includes_content_path_df()`
  - `validate_chapter_structure()`
  - `look_for_extended()`
  - `process_yaml()`
- Removed broken and unused `create_heading()` function.
- Removed commented-out and unused code.
- Refactored `convert_mesos_groups_to_df` and its helper functions to
  ensure consistent handling of `mesos_groups`.
- Added a `clean_group_data` internal helper function to:
  - Drop unused levels for factors.
  - Remove `NA` and blank strings.

### Testing

- Added 169 comprehensive tests across multiple modules (from 331 to
  500+ tests).
- Added 16 tests for
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md).
- Added comprehensive sorting tests in `test-arrange2.R` to verify
  position-based sorting with intentionally mismatched variable names,
  labels, and positions.
- Added 27 tests for logging functionality.
- Added tests for setup_mesos helper functions, utility functions,
  access restriction setup, and directory structure helpers.

### Documentation

- Added
  [`check_variable_labels()`](https://nifu-no.github.io/saros.base/reference/check_variable_labels.md)
  to pkgdown reference.
- Added Copilot instructions for testing and git workflows.

## saros.base 1.1.0

CRAN release: 2025-06-01

- [`create_directory_structure()`](https://nifu-no.github.io/saros.base/reference/create_directory_structure.md)
  example does not create files and folders on disk to save time.
- Templates for mesos output now include newlines between target and
  others. Thanks to Jon Furuholt for the suggestion.
- [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  now has argument `write_qmd` to toggle the creation of qmd-files.
- Attempted fix of internal arrange2 sorting function. Very hard to get
  right.

## saros.base 1.0.0

CRAN release: 2025-01-10

### Major changes

- Total revision of the entire architecture for maximum flexibility,
  stability and performance.
- Uses glue templates for creating chunks, see
  `refine_chapter_structure()`.
- [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
- Breaking changes for mesos setup, now uses
  [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  as well for creating stub files referring to a smaller set of main
  files created by
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md).
- Countless bugfixes.

### Minor changes

- Helper function
  [`remove_entry_from_sidebar()`](https://nifu-no.github.io/saros.base/reference/remove_entry_from_sidebar.md)
  for post-processing HTML-files
- Many more validations of arguments and better error messages.

## saros.base 0.2.2

- Added vignettes.

## saros.base 0.2.1

CRAN release: 2024-09-18

- CRAN release.
