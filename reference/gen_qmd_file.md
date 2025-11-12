# Generate Quarto Index File That Merges All Chapters

This function creates an index Quarto file (QMD) that merges all
chapters in the specified order. It can also include optional title and
author(s) information.

## Usage

``` r
gen_qmd_file(
  path = NULL,
  filename = "report",
  yaml_file = NULL,
  qmd_start_section_filepath = NULL,
  qmd_end_section_filepath = NULL,
  chapter_structure = NULL,
  include_files = NULL,
  title = NULL,
  authors = NULL,
  output_formats = NULL,
  output_filename = NULL,
  includes_prefix = "{{< include \"",
  includes_suffix = "\" >}}",
  call = rlang::caller_env()
)
```

## Arguments

- path:

  String, where to write qmd-file.

- filename:

  String, bare name of qmd-file. Default: "report". If NULL, generates a
  sanitized version of the title. If both filename and title are NULL,
  errors.

- yaml_file:

  A string containing the filepath to a yaml-file to be inserted at top
  of qmd-file.

- qmd_start_section_filepath, qmd_end_section_filepath:

  String, filepath to a qmd-file inserted at start and end of file.

- chapter_structure:

  *What goes into each chapter and sub-chapter*

  `obj:<data.frame>|obj:<tbl_df>` // Required

  Data frame (or tibble, possibly grouped). One row per chapter. Should
  contain the columns 'chapter' and 'dep', Optionally 'indep'
  (independent variables) and other informative columns as needed.

- title:

  *Title of report*

  `scalar<character>` // *default:* `NULL` (`optional`)

  Added automatically to YAML-header of index.qmd and report.qmd-files.

- authors:

  *Authors of entire report*

  `vector<character>` // *default:* `NULL` (`optional`)

  If NULL, infers from `chapter_structure[[authors_col]]`, and collates
  for entire report. If multiple authors per chapter, separate with
  semicolon. Ensure consistency.

- output_filename, output_formats:

  Character. If applied, will construct list of links to files with said
  `output_filename`.

- call:

  Internal call argument. Not to be fiddled with by the user.

## Value

A string containing the filepath to the generated Quarto report file.
