# Automatically Draft a Quarto Report

The `draft_report()` function takes a raw dataset (`data`-argument) and
the output from the
[`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)-function
as the `chapter_structure`-argument and outputs a set of pre-populated
qmd-files in the specified `path`-folder. You can edit, render, and
ultimately publish these as usual with Quarto features in RStudio. See
also `{saros.post}`-package for post-processing tools.

## Usage

``` r
draft_report(
  data,
  chapter_structure,
  ...,
  path = tempdir(),
  title = NULL,
  authors = NULL,
  authors_col = "author",
  chapter_yaml_file = NULL,
  chapter_qmd_start_section_filepath = NULL,
  chapter_qmd_end_section_filepath = NULL,
  index_filename = "index",
  index_yaml_file = NULL,
  index_qmd_start_section_filepath = NULL,
  index_qmd_end_section_filepath = NULL,
  report_filename = "report",
  report_yaml_file = NULL,
  report_qmd_start_section_filepath = NULL,
  report_qmd_end_section_filepath = NULL,
  report_includes_files = FALSE,
  ignore_heading_for_group = c(".template_name", ".variable_type_dep",
    ".variable_type_indep", ".variable_group_dep", ".chapter_number", "chapter"),
  replace_heading_for_group = c(chapter = ".chapter_number", .variable_label_suffix_dep =
    ".variable_name_dep", .variable_label_suffix_indep = ".variable_name_indep"),
  prefix_heading_for_group = NULL,
  suffix_heading_for_group = NULL,
  glue_heading_for_group = NULL,
  chapter_setup_packages = c("saros", "gt"),
  chapter_setup_parameters = TRUE,
  format = "html",
  require_common_categories = TRUE,
  combined_report = TRUE,
  write_qmd = TRUE,
  attach_chapter_dataset = TRUE,
  auxiliary_variables = NULL,
  serialized_format = "rds",
  max_path_warning_threshold = 260,
  data_filename_prefix = "data_",
  report_includes_prefix = "{{< include \"",
  report_includes_suffix = "\" >}}",
  qmd_engine = c("recursion", "loop"),
  log_file = NULL
)
```

## Arguments

- data:

  *Survey data*

  `obj:<data.frame>|obj:<tbl_df>|obj:<srvyr>` // Required

  A data frame (or a srvyr-object) with the columns specified in the
  chapter_structure 'dep', etc columns.

- chapter_structure:

  *What goes into each chapter and sub-chapter*

  `obj:<data.frame>|obj:<tbl_df>` // Required

  Data frame (or tibble, possibly grouped). One row per chapter. Should
  contain the columns 'chapter' and 'dep', Optionally 'indep'
  (independent variables) and other informative columns as needed.

- ...:

  *Dynamic dots*

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>

  Arguments forwarded to the corresponding functions that create the
  elements.

- path:

  *Output path*

  `scalar<character>` // *default:*
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) (`optional`)

  Path to save all output. Defaults to a temporary directory.

- title:

  *Title of report*

  `scalar<character>` // *default:* `NULL` (`optional`)

  Added automatically to the YAML-header of the index.qmd and
  report.qmd-files. If `NULL`, no `title` field is written to those
  files.

  Each chapter qmd-file instead receives its own value of the
  `chapter`-column as its YAML title, so chapters are titled correctly
  regardless of this argument.

- authors:

  *Authors of entire report*

  `vector<character>` // *default:* `NULL` (`optional`)

  If NULL, infers from `chapter_structure[[authors_col]]`, and collates
  for entire report. If multiple authors per chapter, separate with
  semicolon. Ensure consistency.

- authors_col:

  *Column name for author*

  `scalar<character>` // *default:* `"author"` (`optional`)

  Only used if it exists. Multiple authors are separated by semicolon
  (and optionally with a subsequent space).

- chapter_yaml_file:

  *Path to YAML-file to insert into each chapter qmd-file*

  `scalar<character>` // *default:* `NULL` (`optional`)

  Path to file used to insert header YAML, in each chapter.

- chapter_qmd_start_section_filepath, chapter_qmd_end_section_filepath,
  index_qmd_start_section_filepath, index_qmd_end_section_filepath,
  report_qmd_start_section_filepath, report_qmd_end_section_filepath:

  *Path to qmd-bit for start/end of each qmd*

  `scalar<character>` // *default:* `NULL` (`optional`)

  Path to qmd-snippet placed before/after body of all
  chapter/index/report qmd-files.

  **The contents are processed as a
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html)
  template**, with the chapter's own metadata available as `{.chapter}`,
  `{.variable_name_dep}` and so on. Braces that are meant to survive
  into the generated file must therefore be doubled: an R chunk has to
  open with ```` ```{{r}} ````, not ```` ```{r} ````, or the run aborts
  with `object 'r' not found`.

  Note that a start section is no longer needed merely to make a chapter
  render. The default `chunk_templates` are namespace-qualified, and
  every generated chapter opens with a setup chunk attaching `saros` and
  `gt`, so a chapter renders as generated. A snippet is still the place
  for anything project-specific, including further
  [`library()`](https://rdrr.io/r/base/library.html) calls if your own
  `chunk_templates` reach for other packages.

- index_filename:

  *Index filename*

  `scalar<character>` // *default:* `"index"` (`optional`)

  The name of the main index Quarto file used as landing page for each
  report. Will link to a PDF (report.qmd) which collects all chapters.

- index_yaml_file, report_yaml_file:

  *Path to YAML-file to insert into index.qmd and report.qmd
  respectively*

  `scalar<character>` // *default:* `NULL` (`optional`)

  Path to file used to insert header YAML, in index and report files.

- report_filename:

  *Report filename*

  `scalar<character>` // *default:* `"report"` (`optional`)

  The name of the main report QMD-file used when compiling a complete
  report collecting all chapters in its folder (except itself). If
  provided, will be linked to in the index. If NULL, will generate a
  filename based on the report title, prefixed with "0\_". To turn off,
  set `pdf=FALSE`.

- report_includes_files:

  *Whether report.qmd includes {{\< include 'chapter.qmd' \>}}*

  `scalar<logical>` // *default:* `FALSE`

  Useful to have in mesos reports. However, bear in mind that including
  other qmd files with conflicting YAML-headers might be risky.

- ignore_heading_for_group:

  *Ignore heading for group*

  `vector<character>` // *default:* see Usage (`optional`)

  Grouping columns of the refined chapter_structure for which to
  suppress the heading in the report output. Typically
  variable_name_dep, variable_name_indep, etc. Names must match the
  columns actually grouped on, i.e. the `organize_by`-argument of
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md);
  an entry that is not a grouping column simply has no effect.

  `.chapter_number` is suppressed by default because the chapter heading
  is written directly by the chapter file, so leaving it enabled
  produces two first-level headings. Remove it from this argument to get
  the chapter heading from the grouping machinery instead, which gives
  it a `{#sec-}` anchor and makes
  `prefix_heading_for_group`/`suffix_heading_for_group` apply to it.

- replace_heading_for_group:

  *Replacing heading for group*

  `named vector<character>` // *default:*
  `c("chapter" = ".chapter_number", ".variable_label_suffix_dep" = ".variable_name_dep", ".variable_label_suffix_indep" = ".variable_name_indep")`

  Occasionally, one needs to replace the heading with another piece of
  information in the refined chapter_structure. For instance, one may
  want to organize output by variable_name_indep, but to display the
  variable_label_indep instead. Use the name for the replacement and the
  value for the original.

- prefix_heading_for_group, suffix_heading_for_group:

  *Prefix and suffix headings*

  `vector<named character>` // *default:* `NULL` (`optional`)

  Names are heading_groups, values are the prefixes and suffixes. These
  are placed on their own lines, above and below the heading; to change
  the heading text itself use `glue_heading_for_group`. Note that
  prefixes should end with a `\n` as headings must begin on a new line.

- glue_heading_for_group:

  *Glue templates for heading text*

  `vector<named character>` // *default:* `NULL` (`optional`)

  Rewrites the text of the headings at one level of the grouping tree.
  Names are grouping columns, following the same rule as
  `ignore_heading_for_group`: they must match the columns actually
  grouped on, i.e. the `organize_by`-argument of
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md),
  and an entry that is not a grouping column simply has no effect. Note
  that this is the grouped column, not the one
  `replace_heading_for_group` may have chosen to supply the label – with
  the defaults, `.variable_name_indep` rather than
  `.variable_label_suffix_indep`.

  Values are
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html)
  templates in which `{heading}` is the heading text that would
  otherwise have been written. Because each grouping column occupies a
  fixed level, this targets a heading level:
  `c(.variable_name_indep = "By {tolower(heading)}")` turns

      ## Self-efficacy
      ### Gender

  into

      ## Self-efficacy
      ### By gender

  which reads correctly for someone who sees the sub-heading and the
  figure without the parent heading above them. Arbitrary R runs inside
  the braces, so `{sub("^(.)", "\\L\\1", heading, perl = TRUE)}`
  lowercases only the first letter, and a template needs no placeholder
  at all if a fixed heading is wanted.

  The `{#sec-}` anchor is derived from the group's value rather than
  from the heading text, so changing a template moves no cross-reference
  and invalidates no Quarto `freeze` cache. A group listed in
  `ignore_heading_for_group` emits no heading and so is unaffected.

- chapter_setup_packages:

  *Packages attached at the top of each chapter*

  `vector<character>` // *default:* `c("saros", "gt")` (`optional`)

  Every generated chapter opens with a setup chunk attaching these, so
  that a chunk template calling `makeme(...)` or `gt(...)` unqualified
  still works. The default `chunk_templates` do not rely on this — they
  are namespace-qualified — but a project supplying its own templates
  written the older way does.

  Set to `NULL` or
  [`character()`](https://rdrr.io/r/base/character.html) to emit no
  setup chunk at all. That matters because neither `saros` nor `gt` is a
  dependency of this package: if your own `chunk_templates` need
  neither, attaching them would fail every chapter of a project that has
  not installed them.

- chapter_setup_parameters:

  *Build `parameters` at the top of each chapter*

  `scalar<logical>` // *default:* `TRUE` (`optional`)

  Every generated chapter opens with a chunk that builds `parameters`
  from the `_metadata.yml` inheritance chain, using
  [`aggregate_metadata_yml()`](https://nifu-no.github.io/saros.base/reference/aggregate_metadata_yml.md),
  and falls back to `parameters$save = TRUE` when nothing in the chain
  sets it. The mesos `chunk_templates` read `parameters$save`, so
  without this a chapter generated without a
  `chapter_qmd_start_section_filepath` refers to an object nothing
  assigns.

  The chunk leaves an existing `parameters` untouched, so a project that
  establishes its own — typically by sourcing a `general_formatting.R`
  earlier in the render — keeps it. A `save:` set anywhere in the
  `_metadata.yml` chain likewise wins over the fallback.

  Independent of `chapter_setup_packages`: suppressing the attached
  packages does not suppress this chunk. Set to `FALSE` if your project
  supplies `parameters` some other way.

- format:

  *Quarto output format written into each file's YAML*

  `scalar<character>` // *default:* `"html"` (`optional`)

  Written as the `format:` field of the YAML front matter of every
  generated chapter, plus `index.qmd` and the combined report. Passed
  through verbatim, so any value Quarto accepts works — `"html"`,
  `"pdf"`, `"docx"`, or a format with options such as `"html: default"`.

  Ignored for any file whose YAML comes from a file instead: when
  `chapter_yaml_file`, `index_yaml_file` or `report_yaml_file` is
  supplied, that file provides the whole front matter, `format:`
  included. Supplying a YAML file remains the way to set anything beyond
  the format itself.

- require_common_categories:

  *Check common categories*

  `scalar<logical>` // *default:* `TRUE` (`optional`)

  Whether to check if all items share common categories. On by default:
  a section whose factor `dep` columns have no response category in
  common aborts the run, before any file is written. Set to `FALSE` to
  skip.

- combined_report:

  *Create a combined report?*

  `scalar<logical>` // *default:* `TRUE` (`optional`)

  Whether to create a qmd file that merges all chapters into a combined
  report.

- write_qmd:

  *Toggle whether to make qmd-files*

  `scalar<logical>` // *default:* `TRUE`

  Sometimes it is useful to only create chapter_dataset files if these
  have been updated, without having to overwrite the qmd files.

- attach_chapter_dataset:

  *Toggle inclusion of chapter-specific datasets in qmd-files*

  `scalar<logical>` // *default:* `TRUE`

  Whether to save in each chapter folder an 'Rds'-file with the
  chapter-specific dataset, and load it at the top of each QMD-file.

- auxiliary_variables:

  *Auxiliary variables to be included in datasets*

  `vector<character>` // *default:* `NULL` (`optional`)

  Column names in `data` that should always be included in datasets for
  chapter qmd-files, if `attach_chapter_dataset=TRUE`. Not publicly
  available.

- serialized_format:

  *Serialized format*

  `scalar<string>` // *default:* `"rds"`

  Format for serialized data when storing chapter dataset. Currently
  only `"rds"` is supported.

- max_path_warning_threshold:

  *Maximum number of characters in paths warning*

  `scalar<integer>` // *default:* `260` (`optional`)

  Microsoft has set an absolute limit of 260 characters for its
  Sharepoint/OneDrive file paths. This will mean that files with cache
  (hash suffixes are added) will quickly breach this limit. When set, a
  warning will be returned if files are found to be longer than this
  threshold. Also note that spaces count as three characters due to its
  URL-conversion: %20. To avoid test, set to Inf

- data_filename_prefix:

  *String attached to beginning of data-file and data-object*

  `scalar<string>` // *default:* `"data_"`

- report_includes_prefix:

  *String before each file in report.qmd*

  `scalar<string>` // *default:* `'{{< include "'`

  The prefix placed before each of the chapters being included in the
  report.qmd file if `report_includes_files = TRUE`. Shown single-quoted
  because the value itself ends in the double quote that opens the
  included filename, which `report_includes_suffix` then closes with
  `'" >}}'`.

- report_includes_suffix:

  *String after each file in report.qmd*

  `scalar<string>` // *default:* `'" >}}'`

  The suffix placed after each of the chapters being included in the
  report.qmd file if `report_includes_files = TRUE`. It opens with the
  double quote that closes the filename opened by
  `report_includes_prefix`, whose default is `'{{< include "'`.

- qmd_engine:

  *Traversal engine for the grouping tree*

  `scalar<string>` // *default:* `"recursion"`

  Which implementation walks the grouping tree when assembling each
  chapter. Both produce byte-identical output; this exists so the newer
  one can be adopted, benchmarked and backed out of independently.

  - `"recursion"`: the original implementation. One R function call per
    node, so a deep `organize_by` is bounded by the expression nesting
    limit (`options("expressions")`) and by C stack size.

  - `"loop"`: the same traversal driven by an explicit stack, so depth
    is bounded by heap instead.

  Equivalence is asserted in `tests/testthat/test-qmd_engines.R`, which
  compares the two engines' output byte-for-byte across several report
  shapes.

- log_file:

  *Path to log file*

  `scalar<string>` // *default:* `NULL` (`optional`)

  Path to a log file, which is appended to rather than overwritten.
  `NULL`, the default, disables logging entirely; nothing is written and
  no file is created.

  When a path is given, the columns of `data` that this report does not
  use are recorded. `auxiliary_variables` counts as used, since those
  columns are deliberately carried into the chapter datasets — which is
  why this entry is worth having in addition to the one
  [`refine_chapter_overview()`](https://nifu-no.github.io/saros.base/reference/refine_chapter_overview.md)
  writes: that function has no `auxiliary_variables` argument, so its
  own list reports auxiliary columns as unused.

  Nothing is written, and the file is therefore not created, when every
  column of `data` is used. An absent log file means there was nothing
  to report rather than that logging failed.

  The same path may be passed to both functions; entries accumulate.

## Value

The `path`-argument.

## Details

Note that saros treats data as they are stored: numeric, integer,
factor, ordinal, character, and datetime. Currently, only factor/ordinal
and character are implemented.

## Examples

``` r
# \donttest{
ex_survey_ch_structure <-
  refine_chapter_overview(
    chapter_overview = ex_survey_ch_overview,
    data = ex_survey
  )
#> `chunk_templates` is NULL. Using global defaults.
#> Refining chapter_overview into a chapter_structure ...
#> Hiding 266 entries due to no type match: `a_1 (fct), a_2 (fct), a_3 (fct), a_4
#> (fct), a_5 (fct), a_6 (fct), a_9 (fct), b_1 (fct), b_2 (fct), b_3 (fct), c_1
#> (dbl), c_2 (dbl), e_1 (fct), e_2 (fct), e_3 (fct), e_4 (fct), open_comments
#> (chr), p_1 (fct), p_2 (fct), p_3 (fct), p_4 (fct), d_1 (fct), d_2 (fct), d_3
#> (fct), d_4 (fct), x1_sex (fct), x3_nationality (fct), and f_uni (chr)`.
#> Not using the following variables in `data`: `x2_human, a_7, a_8, f_uni, and
#> resp_status`.
index_filepath <-
  draft_report(
    chapter_structure = ex_survey_ch_structure,
    data = ex_survey,
    path = tempdir()
  )
#> ! `combined_report` is `TRUE` but `report_includes_files` is `FALSE`, so
#>   report.qmd will contain no chapters.
#> ℹ Set `report_includes_files = TRUE` to include them, or `combined_report =
#>   FALSE` to stop writing the file.

# Recording which columns of `data` went unused. Write the log to a
# tempfile(), not to a bare filename -- a relative path would land in the
# user's working directory.
log_file <- tempfile(fileext = ".txt")
index_filepath_logged <-
  draft_report(
    chapter_structure = ex_survey_ch_structure,
    data = ex_survey,
    path = tempdir(),
    auxiliary_variables = "resp_status",
    log_file = log_file
  )
#> ! `combined_report` is `TRUE` but `report_includes_files` is `FALSE`, so
#>   report.qmd will contain no chapters.
#> ℹ Set `report_includes_files = TRUE` to include them, or `combined_report =
#>   FALSE` to stop writing the file.
#> Not using the following variables in `data`: `x2_human, a_7, a_8, and f_uni`.
cat(readLines(log_file), sep = "\n")
#> 
#> Not using the following variables:
#> x2_human; a_7; a_8; f_uni
# }
```
