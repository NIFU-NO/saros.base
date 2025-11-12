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
    ".variable_type_indep", ".variable_group_dep", "chapter"),
  replace_heading_for_group = c(chapter = ".chapter_number", .variable_label_suffix_dep =
    ".variable_name_dep", .variable_label_suffix_indep = ".variable_name_indep"),
  prefix_heading_for_group = NULL,
  suffix_heading_for_group = NULL,
  require_common_categories = TRUE,
  combined_report = TRUE,
  write_qmd = TRUE,
  attach_chapter_dataset = TRUE,
  auxiliary_variables = NULL,
  serialized_format = c("rds", "qs"),
  max_path_warning_threshold = 260,
  filename_prefix = "",
  data_filename_prefix = "data_",
  report_includes_prefix = "{{< include \"",
  report_includes_suffix = "\" >}}",
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

  Added automatically to YAML-header of index.qmd and report.qmd-files.

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
  report_qmd_start_section_filepath, report_qmd_end_section_filepath, :

  *Path to qmd-bit for start/end of each qmd*

  `scalar<character>` // *default:* `NULL` (`optional`)

  Path to qmd-snippet placed before/after body of all
  chapter/index/report qmd-files.

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

  `vector<character>` // *default:* `NULL` (`optional`)

  Type of refined chapter_structure data for which to suppress the
  heading in the report output. Typically variable_name_dep,
  variable_name_indep, etc.

- replace_heading_for_group:

  *Replacing heading for group*

  `named vector<character>` // *default:*
  `c(".variable_label_suffix_dep" = ".variable_name_dep")`

  Occasionally, one needs to replace the heading with another piece of
  information in the refined chapter_structure. For instance, one may
  want to organize output by variable_name_indep, but to display the
  variable_label_indep instead. Use the name for the replacement and the
  value for the original.

- prefix_heading_for_group, suffix_heading_for_group:

  *Prefix and suffix headings*

  `vector<named character>` // *default:* `NULL` (`optional`)

  Names are heading_groups, values are the prefixes and suffixes. Note
  that prefixes should end with a `\n` as headings must begin on a new
  line.

- require_common_categories:

  *Check common categories*

  `scalar<logical>` // *default:* `NULL` (`optional`)

  Whether to check if all items share common categories.

- combined_report:

  *Create a combined report?*

  `scalar<logical>` // *default:* `FALSE` (`optional`)

  Whether to create a qmd file that merges all chapters into a combined
  report.

- write_qmd:

  *Toggle whether to make qmd-files*

  `scalar<logical>` // *default:* `TRUE`

  Sometimes it is useful to only create chapter_dataset files if these
  have been updated, without having to overwrite the qmd files.

- attach_chapter_dataset:

  *Toggle inclusion of chapter-specific datasets in qmd-files*

  `scalar<logical>` // *default:* `FALSE`

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

  Format for serialized data when storing chapter dataset. One of
  `"rds"` (default), `"qs"` or `"fst"`. The latter two requires the
  respective packages to be installed. `"qs"` is usually the fastest and
  most space efficient, but sets package dependencies on the report
  project.

- max_path_warning_threshold:

  *Maximum number of characters in paths warning*

  `scalar<integer>` // *default:* `260` (`optional`)

  Microsoft has set an absolute limit of 260 characters for its
  Sharepoint/OneDrive file paths. This will mean that files with cache
  (hash suffixes are added) will quickly breach this limit. When set, a
  warning will be returned if files are found to be longer than this
  threshold. Also note that spaces count as three characters due to its
  URL-conversion: %20. To avoid test, set to Inf

- filename_prefix:

  *Prefix string for all qmd filenames*

  `scalar<character>` // *default:* `""` (`optional`)

  For mesos setup it might be useful to set these files (and related
  sub-folders) with an underscore (`filename_prefix = "_"`) in front as
  other stub files will include these main qmd files.

- data_filename_prefix:

  *String attached to beginning of data-file and data-object*

  `scalar<string>` // *default:* `"data_"`

- report_includes_prefix, report_includes_suffix:

  *Strings around files in report.qmd*

  `scalar<string>` // *default:* `"\{\{< include "` and `" >\}\}"`

  The prefix and suffix for each of the chapters being included in the
  report.qmd file if `report_includes_files = TRUE`.

- log_file:

  *Path to log file*

  `scalar<string>` // *default:* `"_log.txt"` (`optional`)

  Path to log file. Set to NULL to disable logging.

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
# }
```
