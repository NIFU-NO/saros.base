# Changelog

## saros.base 1.2.1.9001

### Documentation

- Added four conceptual vignettes, porting the orientation material that
  previously existed only as Norwegian prose on the Saros website
  ([\#185](https://github.com/NIFU-NO/saros.base/issues/185)).
  `vig_00_about_saros` covers what Saros is, its goals and success
  criteria, the macro/mesos/micro levels, the three-phase production
  process and the PISVEEP pass, the technology stack, and the analysis
  of the traditional report format that motivates generating it.
  `vig_08_adopting_saros` is written for project leads: what adoption
  costs, what the package can generate, and the ethics of offering
  institution-specific reports as an incentive to participate.
  `vig_09_projects_using_saros` lists the projects the system is built
  for. `vig_10_objections_and_limitations` collects the standard
  objections with their answers, plus the limitations expected to
  persist. All four are text-only — no figures, no executed code — and
  are picked up automatically by pkgdown, which has no `articles:` key.
- The “possible element types” table is no longer accurate and has been
  rewritten rather than translated. It documented an `element_names`
  argument enumerating compound names such as `uni_cat_prop_plot` and
  `bi_catcat_freq_plot2`, in which the number of variables involved, the
  variable type, the output form and the statistic were all encoded in
  one string. No such argument exists in saros.base —
  `git log -S"element_names" -- R/` returns nothing, so it never did.
  The successor is `refine_chapter_overview(chunk_templates = )`, whose
  rows carry `.template_name` plus
  `.template_variable_type_dep`/`.template_variable_type_indep`;
  univariate is now `NA` in the indep column rather than a `uni_`
  prefix, and proportions versus frequencies moved into a
  `saros::makeme()` argument. `vig_08_adopting_saros` documents the five
  default variants as they actually are, and includes a mapping table
  for anyone arriving from the old vocabulary. Worth noting for future
  readers: `.template_name` is not a validated, fixed set of permitted
  values — `chunk_templates` accepts arbitrary names — so the only
  genuinely closed vocabulary is `saros::get_makeme_types()`.
- `inst/WORDLIST` gained the Norwegian project and process names the new
  vignettes introduce (`Kompetansebarometeret`, `Spørringene`, `Plukk`,
  `Sammenfatt`, …), the acronyms (`PISVEEP`, `AGU`, `KYU`, `SSN`), and
  the tool names (`Typst`, `Pandoc`, `renv`, `nifutypst`, …). Note that
  `tests/spelling.R` runs with `error = FALSE` and there is no spelling
  job in CI, so the check reports without failing; the pre-existing
  British spellings in `NEWS.md` (`behaviour`, `serialised`,
  `normalised`) are left as they are.

### Bug fixes

- A mesos group whose name sanitizes to an empty string no longer
  overwrites `<mesos_var>/_metadata.yml`
  ([\#244](https://github.com/NIFU-NO/saros.base/issues/244)).
  [`filename_sanitizer()`](https://nifu-no.github.io/saros.base/reference/filename_sanitizer.md)
  returned `""` for a group name in which every character was illegal —
  `"***"` became separators only, and `avoid_ending_with_specials()`
  then removed those — and
  [`fs::path()`](https://fs.r-lib.org/reference/path.html) drops an
  empty segment silently, so the group’s `_metadata.yml` was written to
  the *mesos variable’s* metadata file instead of to a folder of its
  own. That destroyed `params$mesos_var` and `params$mesos_var_pretty`
  for every sibling group, and the group’s own folder was never created;
  its stub also landed at `<mesos_var>/<file>.qmd`.
  [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)
  reported `Mesos structure created successfully` throughout. Note which
  group was hit:
  [`make.unique()`](https://rdrr.io/r/base/make.unique.html)
  disambiguated the second and later collisions into `_1`, `_2`, so the
  *first* group with an unsanitizable name got the empty name and the
  ones after it were merely renamed oddly. Same failure shape as
  [\#212](https://github.com/NIFU-NO/saros.base/issues/212) — a path
  computation that silently escapes its intended directory, with a
  success message. Two independent guards now:
  [`filename_sanitizer()`](https://nifu-no.github.io/saros.base/reference/filename_sanitizer.md)
  substitutes `"unnamed"` for any element that would come back empty,
  and `extract_mesos_metadata()` aborts if any abbreviation is empty or
  duplicated. The substitute is one fixed word rather than anything
  derived from the element’s position, because the function must map
  equal inputs to equal outputs:
  `add_chapter_foldername_to_chapter_structure()` sanitizes the whole
  `chapter` column — one element per row, so a chapter repeats — with
  `make_unique = FALSE`, and a positional substitute would give a single
  chapter a different folder name in each of its rows. Two *different*
  names that both sanitize away therefore collapse onto each other,
  which is ordinary behaviour for this function (`"a b"` and `"a-b"`
  already both give `"a_b"`) and is what `make_unique` exists to
  resolve. `"unnamed"` is purely alphanumeric, so it survives
  `valid_obj`, `to_lower`, the trailing-separator trim and any `sep`; it
  is deliberately not truncated to `max_chars`, since a name a few
  characters too long is harmless where an empty one is not. `NA` is
  still passed through as `NA`, which callers distinguish from a name
  that sanitized away.
- [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  and
  [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)
  now abort when two mesos groups share an abbreviation
  ([\#244](https://github.com/NIFU-NO/saros.base/issues/244)).
  [`make.unique()`](https://rdrr.io/r/base/make.unique.html) is applied
  to generated abbreviations only, never to a user-supplied abbreviation
  column, so two groups given the same explicit abbreviation collapsed
  into one folder and the last one written won — again silently, and
  again with a success message. The check is in
  `extract_mesos_metadata()`, so it covers both entry points and any
  future route to a bad abbreviation, and metadata for every mesos
  variable is now extracted before the writing loop begins, so a fault
  in the second mesos variable no longer leaves the first one
  half-written. **This turns two previously silent cases into errors**,
  which is the intended change: both destroy files that already exist,
  so continuing is worse than stopping. An all-`NA` abbreviation column
  is unaffected — such a column is filtered to length zero upstream, has
  nothing empty or duplicated in it, and its existing pinned behaviour
  in `tests/testthat/test-setup_mesos.R` is unchanged. One caveat on the
  wording of the error: reached through
  [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)’s
  legacy two-column path, an *empty* explicit abbreviation is reported
  as a *duplicate* one, because `handle_legacy_format()` drops the empty
  string and `[[<-.data.frame` recycles the shortened column,
  fabricating a copy of the neighbouring group’s abbreviation before the
  check ever sees it
  ([\#248](https://github.com/NIFU-NO/saros.base/issues/248)). The abort
  still happens and nothing is written, which is what matters here; the
  fabrication itself is left for
  [\#248](https://github.com/NIFU-NO/saros.base/issues/248).
- [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  now warns when a `.template` repeats the same `insert_text()` call
  ([\#210](https://github.com/NIFU-NO/saros.base/issues/210)). Projects
  inject auxiliary text by wrapping every template with a
  `before=TRUE`/`before=FALSE` pair, and that wrap is written out
  longhand in two places — the generation script and
  `apply_template_mutations()`. Neither knows about the other, so
  applying both wraps each template twice and every inserted passage is
  emitted twice in the generated qmd. Neither `insert_text()` nor
  `apply_template_mutations()` lives in saros.base, so nothing here can
  prevent the doubling; the package only ever sees the already-doubled
  string arriving in `chunk_templates$.template`. This is therefore a
  lint on the incoming data: it names the affected templates and the
  repeated call, and returns the templates unchanged. **This adds a
  warning to existing calls** that pass doubly-wrapped templates — which
  are already producing doubled output. The check keys on an *identical*
  repeated call rather than a count of `insert_text()` calls, because a
  template may legitimately address several insertion points; those
  calls differ in their arguments, whereas re-wrapping reproduces one
  verbatim. Whitespace is ignored when comparing, since the two copies
  of the wrap are separately authored and drift in spacing.
- A section that matches no rows no longer emits the previous sibling’s
  chunk under its own heading
  ([\#239](https://github.com/NIFU-NO/saros.base/issues/239)). `new_out`
  was threaded through the sibling loop in `gen_qmd_node()` and
  reassigned only when a section was non-empty, so an empty section kept
  whatever the sibling before it produced — a figure or table appearing
  under a heading it does not belong to, with no error and no warning,
  and looking entirely plausible in the rendered report. This was latent
  rather than live: `grouped_data` is
  [`distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)
  over the grouping columns of `chapter_structure`, so every traversal
  path corresponds to at least one real row and no empty section arises
  today (instrumenting 66 deepest-level calls across five report shapes
  found none). But that is an invariant held elsewhere, not a local
  guarantee — a change to how `grouped_data` is derived, to `NA`
  handling in `prepare_chapter_structure_section()`’s filter, or a new
  grouping column whose values do not round-trip through
  [`as.character()`](https://rdrr.io/r/base/character.html) would have
  made it live. `new_out` is now local to each node, so an empty section
  contributes nothing, not even its heading. Both `qmd_engine` values
  were affected identically and both are fixed by the one change; the
  now-dead `new_out` state has been dropped from the recursion’s loop
  variable and the loop engine’s stack frame.
  `tests/testthat/test-qmd_empty_section.R` constructs the empty section
  directly, since the integration path cannot produce one.
- `draft_report(require_common_categories = TRUE)` now performs the
  check it documents
  ([\#232](https://github.com/NIFU-NO/saros.base/issues/232)). The
  argument was validated but never read, and the
  `check_category_pairs()` helper implementing it had no caller.
  Dependent variables within a section — the set that ends up in one
  figure — are now checked for at least one shared response category,
  before any files are written. Only factor columns are compared, since
  a “common category” is not meaningful for numeric or free-text
  variables. Set `require_common_categories = FALSE` to skip.
- `refine_chapter_overview(keep_dep_indep_if_no_overlap = FALSE)` now
  removes bivariate entries whose dependent and independent variables
  never co-occur
  ([\#232](https://github.com/NIFU-NO/saros.base/issues/232)). The call
  site was short-circuited with `if (FALSE && ...)`, so the argument had
  no effect. Enabling it exposed a latent crash in
  `remove_from_chapter_structure_if_no_overlap()`:
  `.variable_name_dep`/`_indep` are factors that may carry `NA` as an
  explicit level, for which [`is.na()`](https://rdrr.io/r/base/NA.html)
  on the factor is `FALSE`, so such rows reached `data[[NA]]` and
  aborted. The comparison now runs on the character form.
- `create_r_files(r_add_file_scope = FALSE)` now actually omits the
  `file_scope` column from the generated placeholder files
  ([\#232](https://github.com/NIFU-NO/saros.base/issues/232)). The flag
  was accepted and ignored, so the scope was written either way. The
  placeholder file is still created in both cases, and the default
  (`TRUE`) is unchanged.
- `create_email_credentials(ignore_missing_emails = FALSE)` now warns
  about usernames that exist in the password file but have no email
  address ([\#232](https://github.com/NIFU-NO/saros.base/issues/232)).
  This is the direction the argument documents; the function previously
  only warned about the opposite case, and never read the flag. Such
  accounts silently received no credentials. **This adds a warning to
  existing calls** where the password file contains accounts absent from
  `email_data_frame`; pass `ignore_missing_emails = TRUE` to silence it.
- [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  no longer writes `.na.character` as the title of
  `<mesos_var>/index.qmd`
  ([\#188](https://github.com/NIFU-NO/saros.base/issues/188)).
  `extract_mesos_metadata()` guarded its fallback with
  [`is.null()`](https://rdrr.io/r/base/NULL.html), but
  [`get_raw_labels()`](https://nifu-no.github.io/saros.base/reference/get_raw_labels.md)
  returns `NA_character_` for an unlabelled column, so the display name
  stayed `NA` and was serialised into the site.
  [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)
  was unaffected because it always attaches a label internally — which
  is what made the two entry points produce different output. They now
  agree on every generated file except the `_metadata.yml` subtitle,
  which legitimately includes the `main_directory` folder name only when
  one is supplied.
- Generated mesos stub and `index.qmd` files now end with a newline.
  Their absence made
  [`readLines()`](https://rdrr.io/r/base/readLines.html) and other text
  tools warn about an incomplete final line.
- [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  is now reproducible
  ([\#213](https://github.com/NIFU-NO/saros.base/issues/213)). Heading
  anchors carried two RNG-drawn digits, so identical inputs produced
  different `.qmd` files on every run. Quarto’s `freeze` cache keys on
  file content, so it missed on every chapter after every regeneration —
  a one-line change in data preparation forced a full re-render of the
  entire site. The suffix is now a short hash of the heading’s position
  in the grouping tree, which is stable across runs and a stronger
  disambiguator than two digits (which collided for 1% of colliding
  pairs).
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  no longer draws from the session RNG at all.
- Chapter files no longer contain two first-level headings
  ([\#207](https://github.com/NIFU-NO/saros.base/issues/207)).
  `.chapter_number` has been added to the `ignore_heading_for_group`
  default. The default listed `"chapter"`, but the column grouped on is
  `.chapter_number`, so the guard never fired and the chapter title was
  emitted both directly and by the grouping machinery. Remove
  `.chapter_number` from the argument to restore the previous
  grouping-generated heading, which carries a `{#sec-}` anchor.
- [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  and
  [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)
  no longer overwrite the authored `_*.qmd` chapter sources in
  `main_directory`
  ([\#212](https://github.com/NIFU-NO/saros.base/issues/212)). A stub
  was emitted at the top level, replacing each source file with an
  include pointing outside `main_directory`. The failure was silent and
  repeated on every run, so restoring the files from version control was
  not sufficient.
- Mesos `{{< include >}}` paths now resolve
  ([\#212](https://github.com/NIFU-NO/saros.base/issues/212)). The
  relative path scaled with the directory level
  (`rep("../", path_lvl)`), but consecutive levels always differ by
  exactly one component, so every level above the innermost skipped a
  directory and eventually escaped `main_directory`. Quarto does not
  error on an unresolvable include, so affected group pages rendered as
  empty documents with correct titles and `_metadata.yml`.
- A multi-component `mesos_var_subfolder` such as `"Rapport/Del1"` now
  nests instead of erroring
  ([\#212](https://github.com/NIFU-NO/saros.base/issues/212)).
  `write_subfolder_metadata()` vectorised over the components rather
  than nesting them, addressing a non-existent sibling directory and
  failing with `cannot open the connection` after stub files had already
  been written. This affected the documented example in
  [`?setup_mesos_structure`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md),
  which used `mesos_var_subfolder = "reports/Q1"`.
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
- `draft_report(qmd_engine = )` selects how the grouping tree is
  traversed when assembling each chapter
  ([\#19](https://github.com/NIFU-NO/saros.base/issues/19)).
  `"recursion"` (the default, and the original implementation) makes one
  R call per node, so a deep `organize_by` is bounded by
  `options("expressions")` and the C stack. `"loop"` walks the same tree
  with an explicit stack, bounded by heap instead. The two produce
  byte-identical output; `tests/testthat/test-qmd_engines.R` asserts
  that across five report shapes, including the bundled example, and
  `tests/testthat/test-qmd_engines_ordering.R` additionally pins
  ordering, grouping and sorting across five `organize_by` shapes, three
  `arrange_section_by` directions, both `na_first_in_section` settings,
  reversed chapter declaration and a degenerate single-value tree.
  Measured on the bundled example the two are within noise of each other
  (5.3s vs 4.8s at the default depth, 18.1s vs 18.2s with one extra
  grouping level), so this is about depth headroom and having a
  fallback, not speed.

### Testing

- Added snapshot tests of the `.qmd` text
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  writes (`tests/testthat/test-qmd_snapshots.R`). Nothing previously
  asserted anything about the generated content — the existing test
  checks file counts and file *sizes* — which is why
  [\#207](https://github.com/NIFU-NO/saros.base/issues/207),
  [\#208](https://github.com/NIFU-NO/saros.base/issues/208)/#184 and
  [\#216](https://github.com/NIFU-NO/saros.base/issues/216) all shipped.
  Each of those was re-introduced and confirmed to fail the new tests.
  Only possible now that
  [\#213](https://github.com/NIFU-NO/saros.base/issues/213) made the
  output deterministic; `test-anchor_determinism.R` pins that property
  separately.

### Code quality improvements

- Moved `tibble` from `Suggests` to `Imports`
  ([\#215](https://github.com/NIFU-NO/saros.base/issues/215)).
  `.onLoad()` builds the default chunk templates with
  [`tibble::add_row()`](https://tibble.tidyverse.org/reference/add_row.html),
  and R-exts requires a package to declare what its own code uses
  directly. This corrects the declaration; it does not change observable
  behaviour. `tibble` is a hard dependency of `dplyr`, `tidyr` and
  `forcats` — all already in `Imports` — so it has always been installed
  alongside saros.base, and no installation could have lacked it.
- CI now fails when `man/` or `NAMESPACE` differ from what
  `roxygen2::roxygenise()` produces from the roxygen comments in `R/`
  ([\#219](https://github.com/NIFU-NO/saros.base/issues/219)). This is
  the drift that hid
  [`delete_freeze()`](https://nifu-no.github.io/saros.base/reference/delete_freeze.md):
  `R CMD check` accepts a package whose `NAMESPACE` is missing an export
  — it is simply a package without that function — and pkgdown indexes
  `.Rd` topics rather than exports, so neither caught it.
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
