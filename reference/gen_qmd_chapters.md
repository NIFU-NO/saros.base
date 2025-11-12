# Generate A Quarto Survey Report

This function generates a set of saros chapters, collectively called a
report.

## Usage

``` r
gen_qmd_chapters(
  chapter_structure,
  data,
  authors_col = "author",
  path = NULL,
  ignore_heading_for_group = NULL,
  replace_heading_for_group = NULL,
  prefix_heading_for_group = NULL,
  suffix_heading_for_group = NULL,
  chapter_yaml_file = NULL,
  chapter_qmd_start_section_filepath = NULL,
  chapter_qmd_end_section_filepath = NULL,
  write_qmd = TRUE,
  attach_chapter_dataset = TRUE,
  auxiliary_variables = NULL,
  serialized_format = "rds",
  filename_prefix = "",
  data_filename_prefix = "data_"
)
```

## Arguments

- chapter_structure:

  *What goes into each chapter and sub-chapter*

  `obj:<data.frame>|obj:<tbl_df>` // Required

  Data frame (or tibble, possibly grouped). One row per chapter. Should
  contain the columns 'chapter' and 'dep', Optionally 'indep'
  (independent variables) and other informative columns as needed.

- data:

  *Survey data*

  `obj:<data.frame>|obj:<tbl_df>|obj:<srvyr>` // Required

  A data frame (or a srvyr-object) with the columns specified in the
  chapter_structure 'dep', etc columns.

- authors_col:

  *Column name for author*

  `scalar<character>` // *default:* `"author"` (`optional`)

  Only used if it exists. Multiple authors are separated by semicolon
  (and optionally with a subsequent space).

- path:

  *Output path*

  `scalar<character>` // *default:*
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) (`optional`)

  Path to save all output. Defaults to a temporary directory.

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

- chapter_yaml_file:

  *Path to YAML-file to insert into each chapter qmd-file*

  `scalar<character>` // *default:* `NULL` (`optional`)

  Path to file used to insert header YAML, in each chapter.

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

- filename_prefix:

  *Prefix string for all qmd filenames*

  `scalar<character>` // *default:* `""` (`optional`)

  For mesos setup it might be useful to set these files (and related
  sub-folders) with an underscore (`filename_prefix = "_"`) in front as
  other stub files will include these main qmd files.

- data_filename_prefix:

  *String attached to beginning of data-file and data-object*

  `scalar<string>` // *default:* `"data_"`

## Value

Side-effects: qmd-files generated in the specified working directory.

## Details

A report consists of multiple chapters, an index file, and optionally a
combined report file that merges them together. A chapter can contain
any user-defined set of dependent, independent or bivariate variable
sets. A chapter consists of multiple sections. A section is defined as a
group in the chapter_structure (ignoring the chapter grouping level)
containing variables of the same type, meaning at a minimum that the
variables in the section sharing the same response options, the same
main question, and being of the same data type.
