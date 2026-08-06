# Changelog

## saros.base 1.2.1.9001

### Bug fixes

- Removed the stray `'#\newpage'` element from the tabset chunk
  templates ([\#214](https://github.com/NIFU-NO/saros.base/issues/214)).
  The single backslash was re-parsed by R as a newline escape when the
  generated qmd was rendered, so the text `ewpage` appeared above every
  tabset on every page. Affected 6 of 7 templates in
  `get_chunk_template_defaults(2)` and 3 of 7 in variant 4. A page break
  was meaningless in these HTML templates in any case.
- [`delete_freeze()`](https://nifu-no.github.io/saros.base/reference/delete_freeze.md)
  is now actually exported
  ([\#219](https://github.com/NIFU-NO/saros.base/issues/219)). It was
  documented with `@export` and had a generated `man/delete_freeze.Rd`,
  but `NAMESPACE` had not been regenerated, so
  [`saros.base::delete_freeze()`](https://nifu-no.github.io/saros.base/reference/delete_freeze.md)
  failed with “not an exported object”.
- `draft_report(title = )` is no longer a silent no-op
  ([\#208](https://github.com/NIFU-NO/saros.base/issues/208),
  [\#184](https://github.com/NIFU-NO/saros.base/issues/184)).
  `process_yaml()` only assigned the title when an explicit `yaml_file`
  was supplied, so `index.qmd` and `report.qmd` were written without a
  `title` field in the default case.
- Chapter qmd-files now receive their `chapter` name as the YAML `title`
  ([\#208](https://github.com/NIFU-NO/saros.base/issues/208),
  [\#184](https://github.com/NIFU-NO/saros.base/issues/184)). Previously
  [`gen_qmd_chapters()`](https://nifu-no.github.io/saros.base/reference/gen_qmd_chapters.md)
  passed `title = NULL`, leaving Quarto to infer the page title from the
  first body heading — which is why titles varied across Quarto
  versions, and why projects post-processed the heading into the header
  with regexes that truncated at hyphens.
- Mesos group `_metadata.yml` files now get the `title` field that
  [`?setup_mesos`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  documents for `subtitle_separator`
  ([\#184](https://github.com/NIFU-NO/saros.base/issues/184)). The
  assignment was commented out, and referred to an out-of-scope
  variable.
- `.variable_label_suffix` is now whitespace-normalised like the prefix
  ([\#216](https://github.com/NIFU-NO/saros.base/issues/216)).
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  passed `.variable_label_prefix` to `trim_columns()` twice and never
  passed the suffix, so label suffixes kept leading/trailing spaces and
  internal runs of spaces. These suffixes become section headings, where
  leading whitespace is significant in Markdown. Only visible with a
  `label_separator` that does not itself include surrounding spaces,
  e.g. `":"`.
- [`delete_freeze()`](https://nifu-no.github.io/saros.base/reference/delete_freeze.md)
  no longer warns `no non-missing arguments to max` when a `_freeze`
  entry contains no files
  ([\#220](https://github.com/NIFU-NO/saros.base/issues/220)). Such an
  entry is stale and is still deleted; only the spurious warning is
  gone. Staleness now also ignores directory mtimes, and `_freeze`
  itself is excluded when discovering `.qmd` files.
- Moved `tibble` from `Suggests` to `Imports`
  ([\#215](https://github.com/NIFU-NO/saros.base/issues/215)).
  `.onLoad()` builds the default chunk templates with
  [`tibble::add_row()`](https://tibble.tidyverse.org/reference/add_row.html),
  so the package could not be attached at all on installations without
  `tibble`
  (e.g. [`install.packages()`](https://rdrr.io/r/utils/install.packages.html)
  without `dependencies = TRUE`). No new installation burden: `dplyr`
  already imports `tibble`.
- Suggested packages are now used conditionally, per R-exts
  ([\#215](https://github.com/NIFU-NO/saros.base/issues/215)). `srvyr`
  (in `ungroup_data()`) and `writexl`/`readr`/`haven` (in
  `tabular_write()`) are guarded with
  [`rlang::check_installed()`](https://rlang.r-lib.org/reference/is_installed.html),
  which reports an actionable install prompt instead of “there is no
  package called …”. The single
  [`purrr::compact()`](https://purrr.tidyverse.org/reference/keep.html)
  call was replaced with base R.

### New features

- Added `default_chunk_templates_5`: a new simplified template set for
  single crowd reports without mesos structure. Uses cleaner helper
  functions like `get_fig_title_suffix_from_ggplot()` for more
  streamlined code generation.

### Code quality improvements

- `.saros.env` is now an actual environment
  ([\#218](https://github.com/NIFU-NO/saros.base/issues/218)). A
  package-level `.saros.env <- NULL` made `exists(".saros.env")` inside
  `.onLoad()` always true, so the
  [`new.env()`](https://rdrr.io/r/base/environment.html) branch never
  ran; the first `$<-` coerced `NULL` to a list, and each of the ~50
  subsequent assignments copied the whole accumulating list — including
  the large chunk-template tables — instead of mutating in place. The
  superassignments (`<<-`) are no longer needed and have been replaced
  with ordinary `$<-`.
- Removed the empty file `R/utils_qmd.R`
  ([\#220](https://github.com/NIFU-NO/saros.base/issues/220)), a
  leftover of the refactor that moved the QMD helpers into
  `R/qmd_utils.R`.
- Removed the unused and broken `create_text_collapse()`
  ([\#217](https://github.com/NIFU-NO/saros.base/issues/217)). It read
  `formals(draft_report)$translations`, but
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  has no `translations` argument, so the last separator resolved to
  `NULL` and `c("a", "b", "c")` collapsed to `"a, bc"` rather than
  erroring. A new test asserts that every `formals(fn)$name` reference
  in `R/` names a real argument.
- Improved code formatting and readability in `.onLoad()` function for
  better maintainability.
- Updated template references in `default_chunk_templates_4` for better
  consistency (using `data` instead of `data_{.chapter_foldername}`,
  added `save = parameters$save` parameter).
- Better structured code blocks with consistent indentation and spacing.

## saros.base 1.2.1

### Bug fixes

- Fixed bug in
  [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  where an incorrect assignment to `files_to_process` was causing the
  search and replace functionality to fail.

## saros.base 1.2.0

CRAN release: 2025-11-12

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
