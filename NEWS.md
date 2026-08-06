# saros.base 1.2.1.9001

## Bug fixes
- `draft_report(require_common_categories = TRUE)` now performs the check it documents (#232). The argument was validated but never read, and the `check_category_pairs()` helper implementing it had no caller. Dependent variables within a section — the set that ends up in one figure — are now checked for at least one shared response category, before any files are written. Only factor columns are compared, since a "common category" is not meaningful for numeric or free-text variables. Set `require_common_categories = FALSE` to skip.
- `refine_chapter_overview(keep_dep_indep_if_no_overlap = FALSE)` now removes bivariate entries whose dependent and independent variables never co-occur (#232). The call site was short-circuited with `if (FALSE && ...)`, so the argument had no effect. Enabling it exposed a latent crash in `remove_from_chapter_structure_if_no_overlap()`: `.variable_name_dep`/`_indep` are factors that may carry `NA` as an explicit level, for which `is.na()` on the factor is `FALSE`, so such rows reached `data[[NA]]` and aborted. The comparison now runs on the character form.
- `create_r_files(r_add_file_scope = FALSE)` now actually omits the `file_scope` column from the generated placeholder files (#232). The flag was accepted and ignored, so the scope was written either way. The placeholder file is still created in both cases, and the default (`TRUE`) is unchanged.
- `create_email_credentials(ignore_missing_emails = FALSE)` now warns about usernames that exist in the password file but have no email address (#232). This is the direction the argument documents; the function previously only warned about the opposite case, and never read the flag. Such accounts silently received no credentials. **This adds a warning to existing calls** where the password file contains accounts absent from `email_data_frame`; pass `ignore_missing_emails = TRUE` to silence it.
- `setup_mesos()` no longer writes `.na.character` as the title of `<mesos_var>/index.qmd` (#188). `extract_mesos_metadata()` guarded its fallback with `is.null()`, but `get_raw_labels()` returns `NA_character_` for an unlabelled column, so the display name stayed `NA` and was serialised into the site. `setup_mesos_structure()` was unaffected because it always attaches a label internally — which is what made the two entry points produce different output. They now agree on every generated file except the `_metadata.yml` subtitle, which legitimately includes the `main_directory` folder name only when one is supplied.
- Generated mesos stub and `index.qmd` files now end with a newline. Their absence made `readLines()` and other text tools warn about an incomplete final line.
- `draft_report()` is now reproducible (#213). Heading anchors carried two RNG-drawn digits, so identical inputs produced different `.qmd` files on every run. Quarto's `freeze` cache keys on file content, so it missed on every chapter after every regeneration — a one-line change in data preparation forced a full re-render of the entire site. The suffix is now a short hash of the heading's position in the grouping tree, which is stable across runs and a stronger disambiguator than two digits (which collided for 1% of colliding pairs). `draft_report()` no longer draws from the session RNG at all.
- Chapter files no longer contain two first-level headings (#207). `.chapter_number` has been added to the `ignore_heading_for_group` default. The default listed `"chapter"`, but the column grouped on is `.chapter_number`, so the guard never fired and the chapter title was emitted both directly and by the grouping machinery. Remove `.chapter_number` from the argument to restore the previous grouping-generated heading, which carries a `{#sec-}` anchor.
- `setup_mesos()` and `setup_mesos_structure()` no longer overwrite the authored `_*.qmd` chapter sources in `main_directory` (#212). A stub was emitted at the top level, replacing each source file with an include pointing outside `main_directory`. The failure was silent and repeated on every run, so restoring the files from version control was not sufficient.
- Mesos `{{< include >}}` paths now resolve (#212). The relative path scaled with the directory level (`rep("../", path_lvl)`), but consecutive levels always differ by exactly one component, so every level above the innermost skipped a directory and eventually escaped `main_directory`. Quarto does not error on an unresolvable include, so affected group pages rendered as empty documents with correct titles and `_metadata.yml`.
- A multi-component `mesos_var_subfolder` such as `"Rapport/Del1"` now nests instead of erroring (#212). `write_subfolder_metadata()` vectorised over the components rather than nesting them, addressing a non-existent sibling directory and failing with `cannot open the connection` after stub files had already been written. This affected the documented example in `?setup_mesos_structure`, which used `mesos_var_subfolder = "reports/Q1"`.
- Removed the stray `'#\newpage'` element from the tabset chunk templates (#214). The single backslash was re-parsed by R as a newline escape when the generated qmd was rendered, so the text `ewpage` appeared above every tabset on every page. Affected 6 of 7 templates in `get_chunk_template_defaults(2)` and 3 of 7 in variant 4. A page break was meaningless in these HTML templates in any case.
- `delete_freeze()` is now actually exported (#219). It was documented with `@export` and had a generated `man/delete_freeze.Rd`, but `NAMESPACE` had not been regenerated, so `saros.base::delete_freeze()` failed with "not an exported object".
- `draft_report(title = )` is no longer a silent no-op (#208, #184). `process_yaml()` only assigned the title when an explicit `yaml_file` was supplied, so `index.qmd` and `report.qmd` were written without a `title` field in the default case.
- Chapter qmd-files now receive their `chapter` name as the YAML `title` (#208, #184). Previously `gen_qmd_chapters()` passed `title = NULL`, leaving Quarto to infer the page title from the first body heading — which is why titles varied across Quarto versions, and why projects post-processed the heading into the header with regexes that truncated at hyphens.
- Mesos group `_metadata.yml` files now get the `title` field that `?setup_mesos` documents for `subtitle_separator` (#184). The assignment was commented out, and referred to an out-of-scope variable.
- `.variable_label_suffix` is now whitespace-normalised like the prefix (#216). `refine_chapter_overview()` passed `.variable_label_prefix` to `trim_columns()` twice and never passed the suffix, so label suffixes kept leading/trailing spaces and internal runs of spaces. These suffixes become section headings, where leading whitespace is significant in Markdown. Only visible with a `label_separator` that does not itself include surrounding spaces, e.g. `":"`.
- `delete_freeze()` no longer warns `no non-missing arguments to max` when a `_freeze` entry contains no files (#220). Such an entry is stale and is still deleted; only the spurious warning is gone. Staleness now also ignores directory mtimes, and `_freeze` itself is excluded when discovering `.qmd` files.
- Suggested packages are now used conditionally, per R-exts (#215). `srvyr` (in `ungroup_data()`) and `writexl`/`readr`/`haven` (in `tabular_write()`) are guarded with `rlang::check_installed()`, which reports an actionable install prompt instead of "there is no package called ...". The single `purrr::compact()` call was replaced with base R.

## New features
- Added `default_chunk_templates_5`: a new simplified template set for single crowd reports without mesos structure. Uses cleaner helper functions like `get_fig_title_suffix_from_ggplot()` for more streamlined code generation.

## Code quality improvements
- Moved `tibble` from `Suggests` to `Imports` (#215). `.onLoad()` builds the default chunk templates with `tibble::add_row()`, and R-exts requires a package to declare what its own code uses directly. This corrects the declaration; it does not change observable behaviour. `tibble` is a hard dependency of `dplyr`, `tidyr` and `forcats` — all already in `Imports` — so it has always been installed alongside saros.base, and no installation could have lacked it.
- `.saros.env` is now an actual environment (#218). A package-level `.saros.env <- NULL` made `exists(".saros.env")` inside `.onLoad()` always true, so the `new.env()` branch never ran; the first `$<-` coerced `NULL` to a list, and each of the ~50 subsequent assignments copied the whole accumulating list — including the large chunk-template tables — instead of mutating in place. The superassignments (`<<-`) are no longer needed and have been replaced with ordinary `$<-`.
- Removed the empty file `R/utils_qmd.R` (#220), a leftover of the refactor that moved the QMD helpers into `R/qmd_utils.R`.
- Removed the unused and broken `create_text_collapse()` (#217). It read `formals(draft_report)$translations`, but `draft_report()` has no `translations` argument, so the last separator resolved to `NULL` and `c("a", "b", "c")` collapsed to `"a, bc"` rather than erroring. A new test asserts that every `formals(fn)$name` reference in `R/` names a real argument.
- Improved code formatting and readability in `.onLoad()` function for better maintainability.
- Updated template references in `default_chunk_templates_4` for better consistency (using `data` instead of `data_{.chapter_foldername}`, added `save = parameters$save` parameter).
- Better structured code blocks with consistent indentation and spacing.

# saros.base 1.2.1

## Bug fixes
- Fixed bug in `setup_mesos()` where an incorrect assignment to `files_to_process` was causing the search and replace functionality to fail.

# saros.base 1.2.0

## New features
- Added file logging for excluded/ignored variables via `log_file` parameter in `refine_chapter_overview()`. All removal functions now log which variables/entries are excluded and why (all NA, low n, non-significant, no overlap, type mismatch).
- Added `detect_malformed_quarto_project()`: exported function to diagnose malformed Quarto website projects (missing index.qmd, missing title in .qmd files, extensible for future checks).
- New function `check_variable_labels()` to validate variable labels for saros compatibility.
- New function `sanitize_chr_vec` for ensuring that character vectors are clean:
  - Normalized Unicode strings to NFC form.
  - Removed non-printable characters.
  - Replaced common encoding artifacts (e.g., `â€™` to `'`).
- Added chunk template variant 4 (`get_chunk_template_defaults(4)`) for mesos reports using the new saros package functions `crowd_plots_as_tabset()` and `txt_from_cat_mesos_plots()`. This provides a more streamlined approach for generating mesos-specific plots and tables.

## Performance improvements
- Vectorized password lookup in `refer_main_password_file()` for better performance.

## Bug fixes
- Fixed critical sorting bug in `refine_chapter_overview()` where output was incorrectly sorted by variable labels instead of variable positions when using default arguments. The fix includes:
  - Corrected `arrange_expr_producer()` to properly name arrange expressions with column names instead of logical values.
  - Added ungrouping before sorting in `arrange_arrangers_and_groups()` to prevent grouped data from interfering with global sort order.
  - Made chapter reordering stable to preserve within-chapter sorting.
- Fixed regex bugs in `check_variable_labels()`.
- Fixed tidyselect warnings in `look_for_extended()`.
- Improved robustness of `setup_mesos()`.
- Added validation checks for email and username columns in `create_email_credentials()`.

## Code quality improvements
- Refactored long functions by extracting helper functions:
  - `validate_refine_chapter_overview_args()`
  - `validate_draft_report_args()`
  - `create_mesos_stubs_from_main_files()`
  - `gen_qmd_file()`
  - `create_includes_content_path_df()`
  - `validate_chapter_structure()`
  - `look_for_extended()`
  - `process_yaml()`
- Removed broken and unused `create_heading()` function.
- Removed commented-out and unused code.
- Refactored `convert_mesos_groups_to_df` and its helper functions to ensure consistent handling of `mesos_groups`.
- Added a `clean_group_data` internal helper function to:
  - Drop unused levels for factors.
  - Remove `NA` and blank strings.

## Testing
- Added 169 comprehensive tests across multiple modules (from 331 to 500+ tests).
- Added 16 tests for `refine_chapter_overview()`.
- Added comprehensive sorting tests in `test-arrange2.R` to verify position-based sorting with intentionally mismatched variable names, labels, and positions.
- Added 27 tests for logging functionality.
- Added tests for setup_mesos helper functions, utility functions, access restriction setup, and directory structure helpers.

## Documentation
- Added `check_variable_labels()` to pkgdown reference.
- Added Copilot instructions for testing and git workflows.

# saros.base 1.1.0

* `create_directory_structure()` example does not create files and folders on disk to save time. 
* Templates for mesos output now include newlines between target and others. Thanks to Jon Furuholt for the suggestion.
* `draft_report()` now has argument `write_qmd` to toggle the creation of qmd-files.
* Attempted fix of internal arrange2 sorting function. Very hard to get right.

# saros.base 1.0.0

## Major changes

* Total revision of the entire architecture for maximum flexibility, stability and performance. 
* Uses glue templates for creating chunks, see `refine_chapter_structure()`.
* `draft_report()` 
* Breaking changes for mesos setup, now uses `setup_mesos()` as well for creating stub files referring to a smaller set of main files created by `draft_report()`.
* Countless bugfixes.

## Minor changes
* Helper function `remove_entry_from_sidebar()` for post-processing HTML-files
* Many more validations of arguments and better error messages.

# saros.base 0.2.2

* Added vignettes.

# saros.base 0.2.1

* CRAN release.
