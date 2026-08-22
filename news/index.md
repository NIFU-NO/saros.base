# Changelog

## saros.base 1.2.1.9001

### Documentation

- Corrected the documented default of 24 arguments across 6 functions
  ([\#251](https://github.com/NIFU-NO/saros.base/issues/251)). Every
  `@param` block in this package states the argument’s default on its
  second line, and that line is the only thing most users read before
  calling a function; it had drifted away from the signature everywhere
  it was not being actively edited. **No actual default changed** — this
  is a documentation-only fix, and every one of the package’s 618
  formals deparses identically to before. Three of the corrections
  reverse the reader’s expectation outright:
  `draft_report(combined_report = )`,
  `draft_report(attach_chapter_dataset = )` (and its counterpart in
  [`gen_qmd_chapters()`](https://nifu-no.github.io/saros.base/reference/gen_qmd_chapters.md))
  and `draft_report(require_common_categories = )` were each documented
  as `FALSE`/`NULL` while defaulting to `TRUE`, so three features
  documented as off are in fact on.
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  accounted for eleven:
  `max_width_obj`/`max_width_chunk`/`max_width_file`/`max_width_folder_name`
  were documented `NULL` — unlimited — while actually truncating at
  `128`/`128`/`64`/`12`; `sep_chunk` and `sep_file` were documented
  `"_"` while defaulting to `"-"`, contradicting the prose two lines
  below them, which already said “hyphen for chunk labels and file
  names”; `label_separator`, `organize_by` and `arrange_section_by` were
  documented `NULL` while carrying real values.
  `gen_qmd_chapters(path = )` was documented
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) while defaulting
  to `NULL`, and `n_range_glue_template_2` documented a comma where the
  template uses a hyphen. Three arguments —
  `insert_chunk(grouping_structure = )`,
  `read_default_draft_report_args(path = )` and
  `write_default_draft_report_args(path = )` — were given a documented
  default despite having none at all; they now read `// Required`, the
  form this package already uses for `data` and `chapter_structure`.
  `write_default_draft_report_args(ignore_args = )` was missing `"path"`
  from its listed vector.
- `draft_report(qmd_engine = )` is deliberately **not** part of the
  above, and the check added below encodes that. Its formal is
  `c("recursion", "loop")` — the whole menu
  [`rlang::arg_match()`](https://rlang.r-lib.org/reference/arg_match.html)
  picks from — but only the first element is ever the default, so the
  documented `"recursion"` is both correct and the more useful thing to
  state. The same reasoning covers `case`, `numbering_prefix`,
  `password_input` and `engine`, the package’s four other `arg_match()`
  arguments; none of them currently states a default in this format, but
  they are exempt on the same terms if they ever do.
- Four `@param` tags that named several arguments at once have been
  split, because a tag can carry only one `*default:*` line and the
  arguments sharing it no longer agree:
  `max_width_obj,max_width_chunk,max_width_file`,
  `sep_obj,sep_chunk,sep_file`,
  `n_range_glue_template_1,n_range_glue_template_2` and
  `report_includes_prefix,report_includes_suffix`. This is what had let
  the `max_width_*` and `sep_*` errors above hide — one `NULL` and one
  `"_"` standing in for three arguments each.
  [`gen_qmd_chapters()`](https://nifu-no.github.io/saros.base/reference/gen_qmd_chapters.md)
  likewise now documents `path` and `replace_heading_for_group` itself
  rather than inheriting them from
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  via `@inheritParams`, since its own defaults for both are `NULL` where
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)’s
  are [`tempdir()`](https://rdrr.io/r/base/tempfile.html) and a
  three-entry vector;
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  always passes both explicitly, so the difference is only visible to a
  direct call.
- Two smaller consistency fixes in the same blocks, both found by review
  of the above.
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)’s
  combined `@param` tag for the six `*_qmd_start/end_section_filepath`
  arguments ended in a stray comma, so the generated `.Rd` listed an
  empty seventh argument name alongside them. And
  `write_default_draft_report_args(ignore_args = )` wrote its optional
  marker as `// Optional.` where the other 40 occurrences in the package
  use `` // *default:* `x` (`optional`) ``; it now matches.
- Fixed a stray backslash in four rendered defaults.
  `report_includes_prefix`, `report_includes_suffix` and both
  `n_range_glue_template_*` values contain braces, which the roxygen
  sources escaped by hand as `\{`. roxygen2 then escaped the backslash,
  so
  [`?draft_report`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  displayed `"\{\{< include "` rather than `"{{< include "` — a value no
  user could copy. Inline code spans need no manual brace escaping; what
  they do need is *balanced* braces within the tag, which is why each of
  the two `report_includes_*` blocks now also names its counterpart’s
  value.
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

- [`aggregate_metadata_yml()`](https://nifu-no.github.io/saros.base/reference/aggregate_metadata_yml.md),
  as it existed outside this package, aborted on the empty
  `_metadata.yml` files this package itself writes
  ([\#270](https://github.com/NIFU-NO/saros.base/issues/270)).
  `write_subfolder_metadata()` creates a zero-byte `_metadata.yml` at
  every intermediate level of
  `setup_mesos_structure(mesos_var_subfolder = )`.
  [`yaml::read_yaml()`](https://yaml.r-lib.org/reference/read_yaml.html)
  returns `NULL` for such a file and `utils::modifyList(x, NULL)` errors
  with `is.list(val) is not TRUE`, so the walk died partway up **before
  reaching the group’s own file**, meaning `params$mesos_group` — the
  one parameter the mesos templates exist to consume — was never merged
  either. Any report using `mesos_var_subfolder` was affected. The
  reader that now ships here treats an empty or non-mapping
  `_metadata.yml` as contributing nothing, which is what the writer
  always meant by one. `tests/testthat/test-aggregate_metadata_yml.R`
  pins this against a fixture built by the package’s own writers rather
  than by hand, with a positive control asserting the zero-byte files
  are actually present. Tolerating them in the reader is necessary but
  not sufficient: Quarto rejects a zero-byte `_metadata.yml` outright
  (`Directory metadata validation failed ... YAML value is missing`), so
  a project containing one fails before any R runs. That is a defect in
  the writer rather than the reader and is filed separately as
  [\#272](https://github.com/NIFU-NO/saros.base/issues/272).
- `parameters$save` set in a `_metadata.yml` is now honoured rather than
  discarded ([\#270](https://github.com/NIFU-NO/saros.base/issues/270),
  finding 1). The external file assigns `parameters$save <- TRUE`
  unconditionally *after* aggregating, so of all the keys the
  inheritance chain carries, `save` was the one it could not — a `save:`
  in any `_metadata.yml` was read and immediately overwritten. The chunk
  this package emits floors the value instead of assigning it
  (`if (is.null(parameters$save)) parameters$save <- TRUE`), so the
  chain wins and the default applies only when nothing set one. The
  documented project-level override, assigning `parameters$save` in the
  project’s own `general_formatting.R`, is unaffected: it runs
  afterwards and is unconditional. **Note a consequence for reports that
  supply no `parameters` at all**: `save` was previously passed to
  `saros` as an unforced promise over an undefined symbol, which
  silently behaved as “do not save”, so chapters generated by this
  package alone never wrote figure or table files. They now do, and gain
  the `[CSV]`/`[PNG]` download links that `save` exists to produce. Set
  `draft_report(chapter_setup_parameters = FALSE)`, or `save: false` in
  a `_metadata.yml`, to keep the old behaviour.
- An eleventh template site, found by review of the fix above: variant
  4’s `chr_table` emitted an inline `` `r x` `` while assigning no `x`
  ([\#269](https://github.com/NIFU-NO/saros.base/issues/269)). It is
  that variant’s `cat_table_html` with the `nrange`/`link`/`x` lines
  removed and the inline expression left behind; variants 2 and 5’s
  `chr_table` emit no `` `r x` `` at all, which settles the fix as
  removing the orphan rather than restoring the computation. In a shared
  knitr environment this is not merely `object 'x' not found`: an
  earlier chunk may still have `x` bound, in which case the table
  renders another section’s caption. Neither existing guard reached it —
  `r_chunks()` matches only fenced blocks, and an inline use is not a
  subscript — so a third check now parses inline `` `r ...` `` and
  `` `{r} ...` `` expressions and reports any variable the template
  never assigns.
- Ten more default chunk template sites emitted code that could not run
  ([\#269](https://github.com/NIFU-NO/saros.base/issues/269)). Nine
  passed a bare `data` where the chapter’s own dataset was meant — seven
  as `saros::makeme(data = data, ...)` in variant 4, two as
  `data |> saros::makeme(...)` in variant 5. A generated chapter binds
  `data_<chapter>` and never binds `data`, so `data` resolved to
  [`utils::data`](https://rdrr.io/r/utils/data.html), **the function**,
  and the chunk died with `` `x` must be a vector, not a function. ``
  The tenth is variant 4’s `chr_table`, which assigned `tbl` and then
  read `tbls` — `vapply(tbls, ...)`, `names(tbls)`, `tbls[[.x]]` —
  giving `object 'tbls' not found`; the correct spelling is the plural,
  as its own `cat_table_html` siblings use at four other sites, because
  `makeme()` returns a list of tables there. That one is worse than a
  plain error in a mixed chapter: an earlier chunk does assign `tbls`,
  and knitr shares one environment across chunks, so the chr table would
  have silently rendered the **previous, unrelated table** rather than
  failing. Found by adversarial review of
  [\#267](https://github.com/NIFU-NO/saros.base/issues/267) rather than
  by the guards that PR added, which is the point of the two below. **A
  variant 5 chapter now renders end-to-end**; before this it aborted in
  its first table chunk, which is why render coverage had never extended
  past variant 1.
- Six default chunk template rows emitted code that could not run
  ([\#266](https://github.com/NIFU-NO/saros.base/issues/266)). Four of
  them — the univariate and bivariate `cat_table_html` of variants 2 and
  4 — emitted `x <- I(paste0(c(nrange, link), collapse=', '` with the
  closing parenthesis missing, which is a **parse error** in the
  generated document. The other two, variant 3’s univariate and
  bivariate `cat_table_html`, computed `table` and `nrange` and then
  referenced `link` in `paste0(c(nrange, link), ...)` without ever
  assigning it, giving `object 'link' not found` at render. Both are
  `cat_table_html`, the most-used table template, and between them they
  affect three of the five variants. The missing assignment is restored
  in the sibling form the other variants already use — variant 1 writes
  `link <- saros::make_link(data={.obj_name})` and variant 2
  `link <- saros::make_link(data = tbls[[.x]])`, so this one is
  `link <- saros::make_link(data = table)`; per the repo’s own rule, the
  neighbours settle it rather than it being an open design question.
  Note *where* the parse error sat, and why it survived: in variants 2
  and 4 the broken line is a string inside
  `knitr::knit_child(text = c(...))`, so the parent chunk parses
  perfectly well and the fault only exists once knitr assembles the
  child document at render time.
  **`tests/testthat/_snaps/qmd_snapshots.md` had been pinning the broken
  line as correct output** since the snapshots were introduced, which is
  worth recording: a snapshot proves output has not changed, never that
  it was right to begin with.
- `draft_report(format = )` now sets the Quarto output format of every
  generated file
  ([\#264](https://github.com/NIFU-NO/saros.base/issues/264)).
  `process_yaml()` has always taken a `format` argument, defaulting to
  `"html"`, and neither of its two call sites — `gen_qmd_chapters.R` and
  `gen_qmd_file.R` — ever passed it. So every chapter, `index.qmd` and
  the combined report declared `format: html`, and no argument anywhere
  on
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  could change it; the only escape was to hand-write a complete YAML
  file. That matters more than it sounds, because non-HTML output is
  plainly in scope for the project:
  [`gen_qmd_file()`](https://nifu-no.github.io/saros.base/reference/gen_qmd_file.md)
  takes `output_formats` to build download links, and
  `inst/templates/PowerShell/` ships
  `Convert_docx_to_pdf_with_msword.ps1`. The default remains `"html"`,
  so no existing caller’s output moves. A supplied
  `chapter_yaml_file`/`index_yaml_file`/`report_yaml_file` still wins,
  since that path takes the whole front matter from the file — the
  argument does not merge into it. Note that `fig-dpi` sits in the same
  hardcoded list in `process_yaml()` and remains unreachable at `800`,
  roughly eight times Quarto’s default of 96; that is left alone here
  deliberately rather than overlooked.
- `draft_report(report_filename = NULL)` no longer aborts before writing
  anything ([\#265](https://github.com/NIFU-NO/saros.base/issues/265)).
  The behaviour is documented — “If NULL, will generate a filename based
  on the report title, prefixed with `0_`” — and the validator accepts
  `NULL`, and
  [`gen_qmd_file()`](https://nifu-no.github.io/saros.base/reference/gen_qmd_file.md)
  implements it correctly. The run never reached it: `output_filename`
  for the index was built with
  `stringi::stri_replace_first_regex(str = args$report_filename, ...)`,
  which returns `character(0)` for `NULL`, and
  `check_string(null.ok = TRUE)` rejects an empty character vector as
  distinct from `NULL`. So a documented, validated input was converted
  into an invalid one on the way to the check, and the abort named
  `output_filename` — an internal argument of an internal function —
  rather than the argument the caller actually set. The index’s link
  target is now taken from the file
  [`gen_qmd_file()`](https://nifu-no.github.io/saros.base/reference/gen_qmd_file.md)
  wrote, rather than re-derived from the argument. That is deliberate
  rather than merely keeping `NULL` as `NULL`: when the name is
  title-derived the argument does not carry it, so the index would
  otherwise have no way to name the report that exists. The string case
  is byte-identical to before. **This is the fourth argument in this
  package found declared, documented and inert** — after the four fixed
  in [\#232](https://github.com/NIFU-NO/saros.base/issues/232),
  `log_file` in
  [\#245](https://github.com/NIFU-NO/saros.base/issues/245), and
  `process_yaml(format=)` in the entry above — which is frequent enough
  that a systematic sweep of every formal, asking whether it is read and
  whether it is reachable, would now be worth more than continuing to
  find them one at a time.
- Generated chapters now render
  ([\#119](https://github.com/NIFU-NO/saros.base/issues/119)). The five
  default `chunk_templates` variants called `saros` and `gt` functions
  unqualified — `makeme()`, `make_link()`, `n_range()`/`n_range2()`,
  `girafe()`, `ggsaver`,
  `fig_height_h_barchart()`/`fig_height_h_barchart2()`,
  `get_fig_title_suffix_from_ggplot()` and `gt()` — and **nothing
  attached either package**: not the generated `.qmd`, not this package,
  not the project templates in `inst/`. A chapter produced with the
  documented defaults therefore aborted at render with
  `could not find function "fig_height_h_barchart"`. Note *where* it
  aborted: that call sits in a chunk header (`fig.height=`), which knitr
  evaluates before the chunk body, so the chapter died before executing
  a line of its own code — the reason the failure looked unrelated to
  the template that caused it. All 130 such references are now
  namespace-qualified, and every generated chapter additionally opens
  with a setup chunk attaching `saros` and `gt`. Both, deliberately:
  qualifying fixes the defaults, while the setup chunk also covers a
  project supplying its own `chunk_templates` written the way the
  defaults used to be. That chunk is controlled by the new
  `draft_report(chapter_setup_packages = )`, defaulting to
  `c("saros", "gt")`; `NULL` or
  [`character()`](https://rdrr.io/r/base/character.html) emits no setup
  chunk at all. It is configurable rather than fixed because neither
  package is in this package’s `Imports` or `Suggests` — attaching them
  unconditionally would not merely add a dependency, it would widen the
  blast radius, taking a project whose own templates never touch `gt`
  from “chapters using a gt template fail” to “every chapter fails”.
  Note that empty means no chunk rather than an empty one: knitr
  executes an empty `r` block and renders a cell for it, so the absence
  has to be total. The setup chunk is emitted unconditionally rather
  than beside the dataset import, which `attach_chapter_dataset = FALSE`
  skips entirely. Note that `saros` and `gt` are deliberately **not**
  added to `Suggests`: this package never calls them — the references
  are text inside template strings, executed by Quarto in a separate
  process — and declaring them would oblige `R/` to guard `pkg::` uses
  with `check_installed()`, which is impossible for a string.
- [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  now reports that a combined report will be empty
  ([\#119](https://github.com/NIFU-NO/saros.base/issues/119)).
  `combined_report` defaults to `TRUE` and `report_includes_files` to
  `FALSE`, so out of the box the function always wrote a `report.qmd`
  and always left it with no chapters in it; `index.qmd` likewise. This
  is not a render failure — Quarto renders that file happily, into an
  HTML document whose entire body is the title — which is exactly why it
  went unnoticed for so long. **Neither default is changed**, since
  flipping either would alter the generated output of every existing
  caller; only the silence is fixed. It is a `cli_inform()` rather than
  a warning on purpose: the pairing that triggers it is the *default*
  pairing, so a warning would fire on essentially every call — 55 times
  across this package’s own test suite — which is the shape that trains
  people to ignore warnings. A message is also how
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  already reports a defaulted argument.
- Documented that `*_qmd_start_section_filepath` and
  `*_qmd_end_section_filepath` files are processed as `glue` templates
  ([\#119](https://github.com/NIFU-NO/saros.base/issues/119)). This was
  not stated anywhere, and it is not a detail a caller can afford to
  discover by accident: braces must be doubled, so an R chunk in a
  snippet has to open with ```` ```{{r}} ````. A perfectly ordinary
  ```` ```{r} ```` fence aborts the run with `Template is invalid` /
  `object 'r' not found`, naming glue rather than the snippet. Since
  these snippets were the only mechanism by which a caller could attach
  the packages the templates needed, the two defects compounded: the fix
  for the first bug was booby-trapped by the second.
- `validate_chunk_templates()` now checks its input
  ([\#242](https://github.com/NIFU-NO/saros.base/issues/242)). Its
  core-column loop was
  `for (col in core_columns) if (!col %in% core_columns)` — the list
  compared against itself, so the condition was `FALSE` on every
  iteration and `chunk_templates` was never inspected at all. The
  function has never rejected a malformed template set in any version of
  this package; the string dates to the first commit. **The naive repair
  would have been worse than the bug**: `core_columns` named
  `.variable_type_dep`, which no `chunk_templates` has ever had, so
  changing the condition to `!col %in% names(chunk_templates)` would
  have made
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  abort on
  [`get_chunk_template_defaults()`](https://nifu-no.github.io/saros.base/reference/get_chunk_template_defaults.md)
  — the package’s own defaults, and the default value of the argument.
  That name is **dropped rather than renamed**, which is the third
  possibility the issue did not list: `.variable_type_dep` is a
  *`chapter_structure`* column, documented on
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md),
  consumed by `validate_chapter_structure()` and
  `remove_from_chapter_structure_if_no_type_match()`, and named in
  `draft_report(ignore_heading_for_group = )`. It was a column from the
  neighbouring schema sitting in the wrong validator, not a stale
  spelling of `.template_variable_type_dep`. The required set is now the
  four columns the defaults actually carry: `.template_name`,
  `.template`, `.template_variable_type_dep` and
  `.template_variable_type_indep`. **All four are required because all
  four already failed when absent** — the check adds no new restriction,
  it only moves an existing failure to the point where `chunk_templates`
  can be named. Dropping `.template_name` gave a
  [`tidyselect::all_of()`](https://tidyselect.r-lib.org/reference/all_of.html)
  error from inside
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md);
  either type column gave `Must select at least one item`, from a
  tidyselect call in `remove_from_chapter_structure_if_no_type_match()`
  that the caller never made. The worst was `.template`, which passed
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  outright and surfaced one function later, inside
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md),
  as `chapter_structure is missing .template` — blaming an object the
  caller may never have touched. Not one of the four mentioned
  `chunk_templates`. This also settles the issue’s second question,
  abort versus warn for a cycle: it aborts, because no caller can be
  relying on an omission that has never worked. Missing columns are
  reported together in one message rather than one abort per column,
  since a hand-built template set typically misses more than one. The
  half of the test that would have caught the original bug — every
  default variant must pass — enumerates the variants from `.saros.env`
  rather than hardcoding, as there are five; it was verified by
  reintroducing `.variable_type_dep` into the required set, which breaks
  15 tests.
- `draft_report(log_file = )` now writes the log it documents, and both
  functions’ documented default for `log_file` has been corrected from
  `"_log.txt"` to `NULL`
  ([\#245](https://github.com/NIFU-NO/saros.base/issues/245)). The
  argument was documented, declared as a formal and validated, but never
  read — `draft_report(log_file = "run.log")` produced no file and no
  error. It was not always inert: it once wrote a run-time entry, and
  c73000f (“Remove timing in draft_report as it takes short time now”)
  deleted the timing without removing the argument. Note that
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  does not call
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  — it receives an already-refined `chapter_structure` — so none of the
  removal helpers that accept a `log_file` are on its path, and there
  was nothing to thread through; a new call site was required. The entry
  it now writes is the set of columns in `data` that the report does not
  use, via the existing `log_unused_variables()`. That helper has always
  had an `auxiliary_variables` parameter which no caller ever supplied,
  and
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  has no such argument, so its own list reports auxiliary columns as
  unused even though they are deliberately carried into the chapter
  datasets;
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  is the only function able to supply it, which is what makes this entry
  worth having alongside the existing one rather than a duplicate of it.
  The call is guarded on `log_file` being a string rather than made
  unconditional, because `log_unused_variables()` also informs via cli
  irrespective of `log_file` — calling it always would add a message to
  every existing
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  call. With the default (`NULL`) behaviour is therefore byte-identical
  to before. **The default deliberately remains `NULL`**: the fix is to
  the documentation, not to the default, so no run starts writing a
  `_log.txt` into the user’s working directory. The examples for both
  functions now demonstrate `log_file` with
  [`tempfile()`](https://rdrr.io/r/base/tempfile.html) for the same
  reason — an example writing a relative path would write into the
  user’s filespace, which CRAN policy forbids.
- `log_file = ""` is no longer accepted by either
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  or
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  ([\#245](https://github.com/NIFU-NO/saros.base/issues/245)).
  `cat(file = "")` writes to stdout rather than to a file, and this
  package’s
  [`is_string()`](https://nifu-no.github.io/saros.base/reference/is_string.md)
  is `is.character(x) && length(x) == 1`, so an empty string passed
  validation and the log was printed to the console while no file was
  created anywhere — the one input for which the argument silently did
  something other than what it says. Both validators now require a
  non-empty string. They report it differently, which is each function’s
  pre-existing pattern and is left alone:
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  warns and falls back to `NULL`,
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  aborts. Found by review of the fix above rather than by
  [\#245](https://github.com/NIFU-NO/saros.base/issues/245) itself; it
  predates that fix and affected
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md),
  whose `log_file` already worked, just as much.
- Two default chunk templates now open the div they close
  ([\#246](https://github.com/NIFU-NO/saros.base/issues/246)). Variant
  1’s univariate `int_table_html` and variant 5’s univariate
  `int_plot_html` both ended with a bare `:::` and never emitted an
  opening fence. Both read as a bivariate sibling copied with the opener
  dropped rather than as a spurious close: the caption line survived
  intact, and the shape is otherwise identical to the sibling. The
  unmatched close reached generated `.qmd`, where Pandoc renders it as
  literal text or silently absorbs it depending on context — the benign
  direction, which is why it went unnoticed. An unmatched *open* is the
  dangerous one: it swallows subsequent content into the div and drops
  it from the table of contents, warning only in the render log. The
  templates now open `::: {#tbl-{.chunk_name}}` and
  `::: {#fig-{.chunk_name}}` respectively, each matching what the body
  actually emits — the first is a table, the second a plot. Neither
  template is reachable without a numeric `dep`, and no snapshot fixture
  had one, which is why nothing caught this;
  `tests/testthat/test-qmd_snapshots.R` now carries a numeric fixture
  and pins both bodies.
- Variant 1’s univariate `int_table_html` now returns its summary table
  instead of calling `girafe()` on it
  ([\#246](https://github.com/NIFU-NO/saros.base/issues/246)). This is
  the same template as the missing `#tbl-` fence above and is fixed with
  it, because a table cross-reference anchor on a body emitting a
  ggiraph widget would be a knowingly-broken cross-reference. The
  template was in fact not renderable at all:
  `makeme(type = 'int_table_html')` returns a plain tibble, so
  `{.obj_name}$data` was `NULL` and the download link silently resolved
  to nothing, and the following `make_link(..., save_fn = ggsaver)`
  aborted the whole chapter with
  `no applicable method for 'grid.draw' applied to an object of class "tbl_df"`
  — reported as a misleading `Do you have write access to '.'?`. The
  render never reached the `girafe()` call. The body now takes its
  download link from the table itself and wraps the result in `gt()`,
  following the `cat_table_html` siblings
  (`make_link(data = {.obj_name})`, `gt({.obj_name})`). `gt()` matters
  here rather than returning the bare tibble: a data frame printed by
  knitr becomes a verbatim console dump inside the table float, and
  tibble’s print method drops trailing columns at the default width —
  the `Max` column vanished from the rendered report. With `gt()` the
  chapter renders a real HTML table carrying all eleven columns, and
  `@tbl-` resolves to “Table 1”. **The `[PNG]` download link is gone
  from this template**, deliberately: there is no plot to save. It is
  the only default template that called `girafe()` on a table, and there
  is no bivariate `int_table_html` anywhere — it exists once, in variant
  1, univariate.
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
  is rejected too, by the entry immediately below
  ([\#253](https://github.com/NIFU-NO/saros.base/issues/253)); this
  check did not reach it, because such a column was filtered to length
  zero upstream and a length-zero vector has nothing empty or duplicated
  in it. One caveat on the wording of the error: reached through
  [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)’s
  legacy two-column path, an *empty* explicit abbreviation is reported
  as a *duplicate* one, because `handle_legacy_format()` drops the empty
  string and `[[<-.data.frame` recycles the shortened column,
  fabricating a copy of the neighbouring group’s abbreviation before the
  check ever sees it
  ([\#248](https://github.com/NIFU-NO/saros.base/issues/248)). The abort
  still happens and nothing is written, which is what matters here; the
  fabrication itself, and that mis-wording with it, is fixed by the
  entry immediately below.
- [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)
  no longer copies one mesos group’s value onto another when a legacy
  `mesos_groups` data frame needs cleaning
  ([\#248](https://github.com/NIFU-NO/saros.base/issues/248)).
  `handle_legacy_format()` cleaned the two columns of such a frame
  independently and in place — `df[[1]] <- clean_group_data(df[[1]])`,
  and the same for `df[[2]]`. `clean_group_data()` drops `NA` and `""`,
  so it can hand back a vector shorter than the column it replaces, and
  `[[<-.data.frame` then recycles that vector back over the original
  number of rows.
  `data.frame(Skole = c("Skole A", "Skole B"), abbr = c("SK", ""))` came
  back with `abbr` of `c("SK", "SK")`: the empty abbreviation was not
  rejected, it was replaced by the previous group’s. Where the shortened
  length did not divide evenly the conversion died instead, with the raw
  base R message `replacement has 2 rows, data has 3`, which names an
  internal assignment rather than anything the caller supplied. Rows are
  now filtered as rows, so a group name and its abbreviation stay on the
  same row. The abbreviation case had been contained since
  [\#244](https://github.com/NIFU-NO/saros.base/issues/244) — the
  fabricated duplicate collided, so `validate_mesos_groups_abbr()`
  aborted before anything was written — but only because it collided,
  and it was reported as a uniqueness fault when it was an emptiness
  one. **The shape that containment did not cover is a fabricated group
  *name***: `data.frame(Skole = c("Skole A", ""), abbr = c("A", "B"))`
  recycled `"Skole A"` onto the second row while the abbreviations
  stayed distinct and non-empty, so nothing objected — the run wrote
  `Skole/A` and `Skole/B`, both recording `params$mesos_group: Skole A`,
  and reported `Mesos structure created successfully`. One group was
  addressable under two folders, and the row that should have been
  dropped was not. An empty abbreviation is now left in the column
  rather than dropped, so `validate_mesos_groups_abbr()` rejects it by
  naming the group it belongs to; `NA` is normalised to `""` alongside
  it, which matters precisely because the column is no longer filtered —
  an `NA` left as it is would have been dropped further downstream by
  `extract_mesos_metadata()`, which filtered the group names and the
  abbreviations separately until
  [\#253](https://github.com/NIFU-NO/saros.base/issues/253) below, and
  the run would then have got as far as writing the stubs before
  aborting on the resulting length mismatch. `clean_group_data()`’s
  `Group data must be a non-empty character vector.` abort stays where
  it is and keeps serving `handle_named_list()` and
  `handle_data_frame()`, which build a data frame *from* a bare vector
  and so have no second column to fall out of step with; the legacy path
  carries its own emptiness check instead, which can say which of the
  supplied data frames was empty. Group names of only whitespace are
  unaffected — [`nzchar()`](https://rdrr.io/r/base/nchar.html) is the
  test, not [`trimws()`](https://rdrr.io/r/base/trimws.html), so `" "`
  remains a usable if odd group name, as
  [\#244](https://github.com/NIFU-NO/saros.base/issues/244) pinned.
- [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  no longer pairs a mesos group with another group’s abbreviation
  ([\#253](https://github.com/NIFU-NO/saros.base/issues/253)). This is
  [\#248](https://github.com/NIFU-NO/saros.base/issues/248) at the
  second entry point. `extract_mesos_metadata()` filtered two parallel
  vectors for `NA` independently —
  `mesos_groups_pretty <- mesos_groups_pretty[!is.na(mesos_groups_pretty)]`,
  and the same for `mesos_groups_abbr` — and nothing held them in step,
  so an `NA` in one column but not the other shifted every later element
  of that vector relative to the other.
  `data.frame(Skole = c("Skole A", "Skole B"), abbr = c(NA, "B"))` came
  back with two group names and the single abbreviation `"B"`, giving
  `"Skole A"` — the group with no abbreviation — the folder belonging to
  `"Skole B"`. `validate_mesos_groups_abbr()`
  ([\#244](https://github.com/NIFU-NO/saros.base/issues/244)) did not
  catch it: a borrowed abbreviation is neither empty nor duplicated. End
  to end the misalignment did not stay silent, but it never reached a
  guard in this package either — the shortened vector was recycled into
  a [`data.frame()`](https://rdrr.io/r/base/data.frame.html) beside a
  full-length one and the run died in base R with
  `arguments imply differing number of rows: 1, 2`, which names neither
  the mesos variable, nor the group, nor the fact that an abbreviation
  was what was missing. A single `keep` mask, derived from the group
  names, now indexes both vectors, so they are aligned by construction
  rather than by coincidence; the group names are what it is derived
  from because a missing group name is what makes a row unusable, which
  is the rule `handle_legacy_format()` already applies. **An
  abbreviation column of nothing but `NA` is now an error rather than a
  silent length-zero vector**, which is the intended change and the
  reason the pinned test at `tests/testthat/test-setup_mesos.R` was
  rewritten. That length-zero vector looked like “no abbreviations
  supplied, so generate them” and was not: it made
  `create_includes_content_path_df()` skip the group-folder level and
  `create_metadata_yml()` abort on its length guard, *after*
  `<mesos_var>/_metadata.yml`, `index.qmd` and the stubs had been
  written — a failed run leaving a directory standing that a retry would
  have to overwrite, reported with a message naming
  `mesos_groups_pretty` and `mesos_groups_abbr`, two internal variables
  the caller never supplied. The legacy route had reported that same
  input properly since
  [\#248](https://github.com/NIFU-NO/saros.base/issues/248), so the two
  entry points disagreed; both now abort by naming the groups, and
  neither writes anything. Only an *absent* column still means “generate
  them”.
- [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)
  now keeps the label on a legacy `mesos_groups` column, so both entry
  points title the mesos variable the same way
  ([\#254](https://github.com/NIFU-NO/saros.base/issues/254)).
  `handle_legacy_format()` row-subsets with `[.data.frame`, which
  subsets each column with `[` and so keeps names/dim/dimnames and drops
  everything else — a `label` among them. `extract_mesos_metadata()`
  reads that label through `get_raw_labels(col_pos = 1)` and falls back
  to the column name
  ([\#188](https://github.com/NIFU-NO/saros.base/issues/188)), so a
  labelled data frame produced a human-readable `mesos_var_pretty`
  through
  [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  and the bare column name through
  [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md)
  — the same asymmetry between the two routes that
  [\#188](https://github.com/NIFU-NO/saros.base/issues/188) closed. Not
  a regression from
  [\#248](https://github.com/NIFU-NO/saros.base/issues/248): the
  `clean_group_data()` call the row filter replaced began with
  [`as.character()`](https://rdrr.io/r/base/character.html), which drops
  the label just as thoroughly, so the label had never survived this
  path; [\#248](https://github.com/NIFU-NO/saros.base/issues/248)
  changed the mechanism, not the outcome. Labels belong here, and the
  question did not need a judgement call — the two sibling handlers in
  the same file both set one explicitly, `handle_named_list()` assigning
  the variable name and `handle_data_frame()` carrying the source label
  through with a fallback to the column name, and
  `handle_legacy_format()` was the only one of the three that did not.
  The attribute is captured before the filter and restored after the
  abbreviation column has been rebuilt, so that replacing that column
  does not undo the restoration. Only `label` is restored, because
  nothing downstream reads any other attribute, and columns are
  addressed by position rather than by name, because a legacy data frame
  may repeat a column name. No column-name fallback is added here, since
  `extract_mesos_metadata()` already has one and duplicating it would
  put the same fallback in two places. One divergence of the same class
  is left open deliberately: `handle_legacy_format()` drops rows whose
  group name is `""` while `extract_mesos_metadata()` keeps them, and
  [`?setup_mesos`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md)
  documents only that `NA` is ignored — closing it would renegotiate
  [\#244](https://github.com/NIFU-NO/saros.base/issues/244)’s pin that a
  whitespace-only group name stays usable.
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

- [`aggregate_metadata_yml()`](https://nifu-no.github.io/saros.base/reference/aggregate_metadata_yml.md)
  reads the `_metadata.yml` inheritance chain this package has always
  written, and `draft_report(chapter_setup_parameters = )` makes every
  generated chapter build its `parameters` object from it
  ([\#270](https://github.com/NIFU-NO/saros.base/issues/270)). Until now
  `saros.base` emitted `_metadata.yml` files carrying `params:` at the
  mesos variable and group levels (`setup_mesos.R`) while the only
  function able to read them back lived in an organization’s
  `general_formatting.R`, outside any repository — so the two ends of
  the chain could disagree, and did. The stated reason for the split,
  avoiding a `yaml` dependency, had already lapsed: `yaml` is in
  `Imports`. The new function collects every `_metadata.yml` from the
  Quarto project root down to `path` and merges them with
  [`utils::modifyList()`](https://rdrr.io/r/utils/modifyList.html), so a
  deeper folder overrides a shallower one and `params$mesos_group` set
  beside a chapter beats a `params:` set for the whole wave. Generated
  chapters now open with a second setup chunk — separate from the
  [`library()`](https://rdrr.io/r/base/library.html) one, because
  `chapter_setup_packages = NULL` is the documented escape hatch for a
  project needing neither `saros` nor `gt` and must not silently take
  `parameters` with it — which assigns `parameters` only when nothing
  has assigned it already. That keeps it a floor rather than an
  override: a project sourcing its own `general_formatting.R` first
  keeps its object, and one sourcing it afterwards overwrites this
  exactly as before. **What this does not do is unblock the mesos
  variants**, and an earlier draft of this entry claimed otherwise.
  Counted rather than assumed: variants 4 and 5 read `parameters$` at
  four sites each, variants 2 and 3 read only Quarto’s `params`, and
  variant 1 neither. A standalone variant 4 chapter fails identically
  before and after this change, inside `saros::makeme()` with
  \``mesos_var` and `mesos_group` must be specified (as
  strings)`, because a generated chapter's YAML declares no`params:`— that is Quarto's mechanism, not this one, and reaching it needs a`\_metadata.yml`inside a project, which `[`#272`](https://github.com/NIFU-NO/saros.base/issues/272)` currently prevents. Variant 5 already rendered before this change too, since`parameters\$save`was an unforced promise over an undefined symbol; what changes for it is that`save\`
  now carries a real value and therefore actually saves.
- **Two deliberate differences from the external function that is being
  replaced**, both visible to any project that switches to this one.
  First, the walk is bounded by the Quarto project root — the nearest
  ancestor holding a `_quarto.yml` *or* a `_quarto.yaml`, both spellings
  being live in the wild — rather than by the first ancestor lacking a
  `_metadata.yml`. The original broke at the first gap, so a
  project-level `_metadata.yml` was unreachable from any chapter with an
  intervening folder that had none; the new rule reaches it. A
  `_metadata.yml` *above* the project root is not read, and when no
  project file is found at all only `path` itself is, so the walk can
  never escape into unrelated folders. Second, it takes a `path`
  (default `"."`, correct at render time because Quarto executes a
  document with the working directory set to that document’s own folder)
  instead of calling
  [`knitr::current_input()`](https://rdrr.io/pkg/knitr/man/current_input.html);
  `knitr` is in neither `Imports` nor `Suggests` here, and a function
  that only works inside a knit cannot be tested at all. Both
  `_metadata.yml` and `_metadata.yaml` are read, the latter winning if a
  folder somehow holds both.
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
- `draft_report(glue_heading_for_group = )` rewrites the *text* of the
  headings at one level of the grouping tree, which nothing could
  previously reach. Names are grouping columns, as in
  `ignore_heading_for_group`; values are `glue` templates in which
  `{heading}` is the label that would otherwise have been written.
  `c(.variable_name_indep = "By {tolower(heading)}")` turns `### Gender`
  into `### By gender`, so a reader who sees the sub-heading and the
  figure without the parent heading above them still knows the section
  is about self-efficacy. Note the key: `.variable_name_indep` is the
  column *grouped on*, while `replace_heading_for_group` makes
  `.variable_label_suffix_indep` supply the label — the four
  `*_heading_for_group` arguments all key on the former, and this one
  follows them rather than inventing a second convention. Because each
  grouping column occupies a fixed position in `organize_by`, naming a
  column is how a heading *level* is targeted. Arbitrary R runs inside
  the braces, so `{sub("^(.)", "\\L\\1", heading, perl = TRUE)}`
  lowercases only the first letter and a template with no placeholder at
  all gives a fixed heading; a malformed template aborts through the
  package’s existing `glue_err()`, naming the argument. **The existing
  `prefix_heading_for_group`/`suffix_heading_for_group` are not this**
  and are unchanged: they emit whole lines above and below the heading —
  `stri_c(prefix, "\n", "##", ...)` — so they can add a paragraph around
  a section but cannot alter the heading itself. The two compose. The
  template is applied after `replace_heading_for_group` has chosen the
  source column and before the `{#sec-}` anchor is appended, so the
  anchor stays derived from the group’s *value*: editing a template
  moves no cross-reference and invalidates no Quarto `freeze` cache, the
  property [\#213](https://github.com/NIFU-NO/saros.base/issues/213)
  established. A group listed in `ignore_heading_for_group` emits no
  heading and is therefore unaffected. The default is `NULL` and output
  is byte-identical to before when it is not set. Both `qmd_engine`
  engines hand the argument to `gen_qmd_node()` separately, so
  `test-qmd_engines.R` pins them equal with a template in force —
  threading it into only one would otherwise have left every other test
  green, since the integration test runs the default engine alone.

### Testing

- `tests/testthat/test-aggregate_metadata_yml.R` and
  `tests/testthat/test-chapter_parameters_chunk.R`
  ([\#270](https://github.com/NIFU-NO/saros.base/issues/270)). Every
  assertion in both was watched failing first, and the ones that matter
  were then verified by mutation rather than trusted: dropping
  `_quarto.yaml` from the project-root markers, dropping
  `_metadata.yaml`, merging deepest-first, removing the
  [`exists()`](https://rdrr.io/r/base/exists.html) guard, gating the
  parameters chunk on `chapter_setup_packages`, and emitting it after
  the templates instead of before — each killed exactly one test and no
  others. The three behavioural claims made against the previous
  implementation were checked against that implementation itself, run
  verbatim over the same fixtures, rather than against a synthetic
  stand-in: it loses the project-level file across a gap, aborts on the
  package’s own empty `_metadata.yml`, and merges a `_metadata.yml` from
  above the project root. The chunk tests run the emitted code rather
  than matching its text, so `save` defaulting to `TRUE`, a
  `save: false` in the chain beating that default, and a pre-existing
  `parameters` surviving untouched are all asserted on the resulting
  object.
- A guard that `parameters` is assigned above the first template that
  reads it, in a generated chapter
  ([\#270](https://github.com/NIFU-NO/saros.base/issues/270)).
  [\#270](https://github.com/NIFU-NO/saros.base/issues/270) predicted
  the `parameters` entry in `test-generated_code_parses.R`’s allowlist
  could be deleted once the package supplied the object itself. It
  cannot: that check asks whether *a template* assigns what *that
  template* subscripts, and the assignment lives in the chapter, above
  every template in the file. The entry stays with a corrected
  justification — the same one the `data_` names already carry — and the
  ordering property it cannot express is pinned end-to-end instead.
- Two broader guards in `tests/testthat/test-generated_code_parses.R`,
  alongside the narrow one added in
  [\#267](https://github.com/NIFU-NO/saros.base/issues/267) rather than
  replacing it
  ([\#269](https://github.com/NIFU-NO/saros.base/issues/269)). That
  check stays because it is not subsumed: it looks for a variable used
  as a bare value, as `link` is in `paste0(c(nrange, link), ...)`, where
  the new check below looks for subscripted variables. The first rejects
  any template that uses a bare `data`, walking the parsed chunk for
  `data` as a *value* — argument names come free, since in `f(data = x)`
  the string `"data"` is a name of the call rather than an element of
  it, and `$`/`@`/`::` right-hand sides are skipped so that
  `make_link(data = plot$data)` is not misread as a bare `data`. The
  second is the variable-agnostic form of
  [\#267](https://github.com/NIFU-NO/saros.base/issues/267)’s
  used-but-never-assigned check, which was hard-coded to `link` and
  `link_plot` — the reason it did not see `tbls`. It now flags any
  subscripted variable a template never assigns. Both were written
  before the fix and both reported exactly the defects above and nothing
  else, after two false positives in the checks themselves were removed.
- `parameters` and `params` are on an explicit allowlist in that second
  check, because they are legitimately supplied from outside the
  template: `params` by Quarto from each file’s YAML, `parameters` by an
  external formatting file sourced into every generated qmd, which
  aggregates the `_metadata.yml` inheritance chain. Two independent
  reviews have now misread `parameters$save` as an undefined symbol, so
  the allowlist carries the explanation and an anti-vacuity test asserts
  `parameters` really does appear in the templates — otherwise the
  allowlist would be inert and its coverage untested. See
  [\#270](https://github.com/NIFU-NO/saros.base/issues/270), which
  proposes moving that aggregation into this package; the allowlist
  entry for `parameters` goes when it does.
- The render tests now cover variant 5 as well as variant 1
  ([\#269](https://github.com/NIFU-NO/saros.base/issues/269)). Variant 5
  could not render before this fix, so the test is new coverage rather
  than a gap being filled. Variants 2, 3 and 4 remain out of reach: they
  are the mesos variants and need a fixture supplying both `params` and
  `parameters`
  ([\#270](https://github.com/NIFU-NO/saros.base/issues/270)). Verified
  by reverting `R/zzz.R` to its previous state, against which the new
  test fails on all three of its assertions.
- Added `tests/testthat/test-generated_code_parses.R`, which parses
  every R chunk of a chapter generated from each of the five default
  variants ([\#266](https://github.com/NIFU-NO/saros.base/issues/266)).
  This is the cheap half of the guard
  [\#263](https://github.com/NIFU-NO/saros.base/issues/263) was missing:
  it needs no Quarto, no `saros` and no `gt`, and covers all five
  variants in seconds, where the render tests are slow enough that their
  fixture reaches only variant 1. It descends into
  `knitr::knit_child(text = c(...))` rather than stopping at the parent
  chunk, which is essential rather than thorough — the parse error it
  was written for lives inside child text, so a guard that stopped at
  the parent would have reported all-clear on exactly the case that
  motivated it. The child’s string literals are read off the parse tree
  rather than evaluated, so nothing in a template is executed. Two
  anti-vacuity controls sit alongside: one asserting chunks were found
  at all, one asserting child text was found, since every other
  assertion in the file would pass trivially on an empty set.
- A companion static check that no template references `link` or
  `link_plot` without assigning it
  ([\#266](https://github.com/NIFU-NO/saros.base/issues/266)).
  Deliberately static rather than a render test, and not for speed:
  **variants 2, 3 and 4 are the mesos variants**, carrying 14 to 19
  `params$` references each, 7 to 9 of them `params$mesos_var`, so they
  cannot render standalone without a mesos fixture — and variant 3 is
  precisely where the unassigned `link` lived. A render test would not
  have covered it at any price. Verified by mutation, by removing the
  four restored assignments and confirming the check names variant 3
  rows 3 and 4.
- Added `tests/testthat/test-generated_qmd_renders.R`, which actually
  renders a generated chapter with Quarto
  ([\#119](https://github.com/NIFU-NO/saros.base/issues/119)). **Nothing
  in this package had ever done so.** The suite’s only `quarto_render()`
  call, in `test-draft_report.R`, was guarded by `if (FALSE && ...)` —
  dead from commit `72d9487`, the first commit, in July 2024.
  [\#119](https://github.com/NIFU-NO/saros.base/issues/119) was filed
  four months into that gap and stayed unreproduced for the twenty-one
  months after it. The dead block is removed and replaced by tests that
  run: a chapter generated with **no** start section must render, and
  the rendered HTML must contain the section heading and a figure div,
  the latter as a positive control so that templates silently emitting
  nothing cannot pass. The file is necessarily heavy — it shells out to
  Quarto, which executes R calling `saros` and `gt` — so it guards on
  `skip_on_cran()` plus `skip_if_not_installed()` for `quarto`, `saros`
  and `gt`, and on the Quarto CLI being present. Contributing nothing on
  CRAN is the intent rather than a defect.
- Added `tests/testthat/test-documented_defaults.R`, which reads the
  `*default:*` value out of every documented argument and compares it
  against [`formals()`](https://rdrr.io/r/base/formals.html)
  ([\#251](https://github.com/NIFU-NO/saros.base/issues/251)). Verified
  to report exactly the 24 corrections listed above, and nothing else,
  when run against the pre-fix sources. The comparison is made on R code
  rather than on text — both sides are parsed and re-deparsed — so
  `c("a" = 1)` and `c(a = 1)` count as equal. It takes the value from
  the parsed `Rd` node rather than from the raw `.Rd` bytes, so it
  compares what `?topic` actually displays, which is what makes it catch
  the stray-backslash class above. Two things are deliberately outside
  it: a block stating `*default:* see Usage` in prose rather than as a
  value states nothing to compare and is skipped, which is how
  `ignore_heading_for_group` stays as it is; and the `arg_match()`
  exemption applies only to arguments genuinely handed to
  [`rlang::arg_match()`](https://rlang.r-lib.org/reference/arg_match.html)/[`match.arg()`](https://rdrr.io/r/base/match.arg.html),
  discovered by deparsing the package’s own function bodies rather than
  listed in the test, so it cannot quietly widen to any argument that
  merely happens to default to a character vector — `organize_by` and
  `ignore_heading_for_group` are such arguments, and a second test pins
  that they do not qualify. `qmd_engine` reaches `arg_match()` under the
  name `engine`, so it is mapped across explicitly, and the mapping is
  written so the exemption lapses if `gen_qmd_structure()` ever stops
  calling `arg_match()`. The test reads the installed help and the
  installed function bodies when package sources are absent, so unlike
  the other source-scanning tests in this suite it runs under
  `R CMD check` rather than skipping there — which is where CI would
  otherwise have missed it — and it asserts a floor on how many
  arguments it matched, so a future roxygen2 that renders `*default:*`
  differently fails the test rather than silently disarming it. This
  supersedes the narrower `log_file` check added in
  [\#245](https://github.com/NIFU-NO/saros.base/issues/245), which is
  kept because it reads the roxygen in `R/` rather than the generated
  `man/`.
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

- The roxygen2 pin moved from 7.3.3 to 8.0.0, in `DESCRIPTION` and in
  the `roxygen-drift` workflow, which must agree or the job aborts
  before it checks anything. **No generated documentation changed**:
  [`roxygen2::roxygenise()`](https://roxygen2.r-lib.org/reference/roxygenize.html)
  under 8.0.0 reproduces the checked-in `man/` and `NAMESPACE` byte for
  byte, so the entire upgrade is the pin plus a field rename — 8.0.0
  records its version as `Config/roxygen2/version` where 7.x used
  `RoxygenNote`, and appends it at the end of the file rather than
  writing it in place. The workflow needed nothing beyond the pin,
  because it already read whichever of the two fields is present and
  already excluded `DESCRIPTION` from its diff. The pin remains
  deliberately not `latest`: 8.1.0 reflows multiple `importFrom()`
  entries from one package into a multi-line call, so it would disagree
  with the checked-in `NAMESPACE` without either version being wrong,
  which is the reason the job pins at all
  ([\#219](https://github.com/NIFU-NO/saros.base/issues/219)). This
  retires the last of the recurring working-tree artifacts
  [\#257](https://github.com/NIFU-NO/saros.base/issues/257) addressed —
  with a local roxygen2 newer than the pin, every `devtools::document()`
  rewrote `DESCRIPTION` as a side effect of documenting something else,
  and the rewrite had to be reverted by hand before staging or it rode
  along in an unrelated commit.
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
  [`roxygen2::roxygenise()`](https://roxygen2.r-lib.org/reference/roxygenize.html)
  produces from the roxygen comments in `R/`
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
- Updated template references in `default_chunk_templates_4`, adding
  `save = parameters$save`. **The other half of this change was a
  regression and is corrected below.** Switching
  `data_{.chapter_foldername}` to a bare `data` was described here as
  consistency; it is not. A generated chapter binds `data_<chapter>` and
  never binds `data`, so a bare `data` resolves to
  [`utils::data`](https://rdrr.io/r/utils/data.html) — the function —
  and the chunk dies with `` `x` must be a vector, not a function. ``
  Nine sites across variants 4 and 5 are affected; tracked in
  [\#269](https://github.com/NIFU-NO/saros.base/issues/269) and not
  fixed here. The `save = parameters$save` half is correct and stays:
  `parameters` is supplied by an external formatting file sourced into
  every generated qmd, which is how one location controls settings
  across all of them — Quarto’s `params` cannot, since it resolves to
  each file’s own YAML.
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
