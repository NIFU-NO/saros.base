# Processes A 'chapter_overview' Data Frame

Processes A 'chapter_overview' Data Frame

## Usage

``` r
refine_chapter_overview(
  chapter_overview = NULL,
  data = NULL,
  chunk_templates = NULL,
  label_separator = " - ",
  name_separator = NULL,
  single_y_bivariates_if_indep_cats_above = 3,
  single_y_bivariates_if_deps_above = 20,
  always_show_bi_for_indep = NULL,
  hide_bi_entry_if_sig_above = 1,
  hide_chunk_if_n_below = 10,
  hide_variable_if_all_na = TRUE,
  keep_dep_indep_if_no_overlap = FALSE,
  organize_by = c(".chapter_number", ".variable_label_prefix_dep",
    ".variable_name_indep", ".template_name"),
  arrange_section_by = c(.chapter_number = FALSE, chapter = FALSE, .variable_position_dep
    = FALSE, .variable_position_indep = FALSE, .template_name = FALSE),
  na_first_in_section = TRUE,
  max_width_obj = 128,
  max_width_chunk = 128,
  max_width_file = 64,
  max_width_folder_name = 12,
  sep_obj = "_",
  sep_chunk = "-",
  sep_file = "-",
  filename_prefix = "",
  ...,
  progress = TRUE,
  variable_group_dep = ".variable_group_dep",
  variable_group_prefix = NULL,
  n_range_glue_template_1 = "{n}",
  n_range_glue_template_2 = "[{n[1]}-{n[2]}]",
  log_file = NULL
)
```

## Arguments

- chapter_overview:

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

- chunk_templates:

  *Chunk templates*

  `obj:<data.frame>|obj:<tbl_df>|NULL` // *default:* `NULL` (`optional`)

  Must contain columns `name` (user-specified unique name for the
  template), `template` (the chunk template as `{glue}`-specification,
  `variable_type_dep` and optionally `variable_type_indep`. The latter
  two are list-columns of prototype vectors specifying which data the
  template will be applied to. Can optionally contain columns whose
  names match the default options for the function. These will then
  override the default function-wide options for the specific template.

- label_separator:

  *Variable label separator*

  `scalar<character>` // *default:* `NULL` (`optional`)

  String to split labels on main question and sub-items.

- name_separator:

  *Variable name separator*

  `scalar<character>` // *default:* `NULL` (`optional`)

  String to split column names in data between main question and
  sub-items

- single_y_bivariates_if_indep_cats_above:

  *Single y bivariates if indep-cats above ...*

  `scalar<integer>` // *default:* `3` (`optional`)

  Figures and tables for bivariates can become very long if the
  independent variable has many categories. This argument specifies the
  number of indep categories above which only single y bivariates should
  be shown.

- single_y_bivariates_if_deps_above:

  *Single y bivariates if dep-vars above ...*

  `scalar<integer>` // *default:* `20` (`optional`)

  Figures and tables for bivariates can become very long if there are
  many dependent variables in a battery/question matrix. This argument
  specifies the number of dep variables above which only single y
  bivariates should be shown. Set to 0 to always show single y
  bivariates.

- always_show_bi_for_indep:

  *Always show bivariate for indep-variable*

  `vector<character>` // *default:* `NULL` (`optional`)

  Specific combinations with a by-variable where bivariates should
  always be shown.

- hide_bi_entry_if_sig_above:

  *p-value threshold for hiding bivariate entry*

  `scalar<double>` // *default:* `1` (`optional`)

  Whether to hide bivariate entry if significance is above this value.
  Defaults to showing all.

- hide_chunk_if_n_below:

  *Hide result if N below*

  `scalar<integer>` // *default:* `10` (`optional`)

  Whether to hide result if N for a given dataset is below this value.
  NOTE: Exceptions will be made to chr_table and chr_plot as these are
  typically exempted in the first place. This might change in the future
  with a separate argument.

- hide_variable_if_all_na:

  *Hide variable from outputs if containing all NA*

  `scalar<boolean>` // *default:* `TRUE` (`optional`)

  Whether to remove variables if all values are NA.

- keep_dep_indep_if_no_overlap:

  *Keep dep-indep if no overlap*

  `scalar<boolean>` // *default:* `FALSE` (`optional`)

  Whether to keep dep-indep rows if there is no overlap.

- organize_by:

  *Grouping columns*

  `vector<character>` // *default:* `NULL` (`optional`)

  Column names used for identifying chapters and sections.

- arrange_section_by:

  *Sorting columns*

  `vector<character>` or `named vector<logical>` // *default:* `NULL`
  (`optional`)

  Column names used for sorting sections within each organize_by group.
  Can include any column present in the output dataframe (both original
  and generated columns). If character vector, will assume all are to be
  arranged in ascending order. If a named logical vector, FALSE will
  indicate ascending, TRUE descending. An error will be thrown if any
  specified column does not exist in the output. Defaults to sorting in
  ascending order (alphabetical) for commonly needed variable name/label
  info, and in descending order for chunk_templates as one typically
  wants *u*nivariates before *b*ivariates.

- na_first_in_section:

  *Whether to place NAs first when sorting*

  `scalar<logical>` // *default:* `TRUE` (`optional`)

  Default ascending and descending sorting with
  [`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html)
  is to place NAs at the end. This would have placed univariates at the
  end, etc. Thus, saros places NAs first in the section. Set this to
  FALSE to override.

- max_width_obj, max_width_chunk, max_width_file:

  *Maximum object width*

  `scalar<integer>` // *default:* `NULL` (`optional`)

  Maximum width for names of objects (in R/Python environment), chunks
  (#\| label: ) and optional files. Note, will always replace variable
  labels with variable names, to avoid very long file names. Note for
  filenames: Due to OneDrive having a max path of about 400 characters,
  this can quickly be exceeded with a long path base path, long file
  names if using labels as part of structure, and hashing with Quarto's
  `cache: true` feature. Thus consider restricting max_width_file to
  lower than what you optimally would have wished for.

- max_width_folder_name:

  *Maximum clean folder name length*

  `scalar<integer>` // *default:* `NULL` (`optional`)

  Whereas `max_width_file` truncates the file name, this argument
  truncates the folder name. It will not impact the report or chapter
  names in website, only the folders.

- sep_obj, sep_chunk, sep_file:

  *Separator string*

  `scalar<character>` // *default:* `"_"` (`optional`)

  Separator to use between grouping variables. Defaults to underscore
  for object names and hyphen for chunk labels and file names.

- filename_prefix:

  *Prefix string for all qmd filenames*

  `scalar<character>` // *default:* `""` (`optional`)

  For mesos setup it might be useful to set these files (and related
  sub-folders) with an underscore (`filename_prefix = "_"`) in front as
  other stub files will include these main qmd files.

- ...:

  *Dynamic dots*

  \<[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)\>

  Arguments forwarded to the corresponding functions that create the
  elements.

- progress:

  *Whether to display progress message*

  `scalar<logical>` // *default:* `TRUE`

  Mostly useful when hide_bi_entry_if_sig_above \< 1

- variable_group_dep:

  *Name for the variable_group_dep column*

  `scalar<string>` // *default:* `".variable_group_dep"`

  This column is used to group variables that are part of the same
  bivariate analysis.

- variable_group_prefix:

  *Set a prefix to more easily find it in your labels*

  `scalar<string>` // *default:* `NULL`

  By default, the .variable_group column is just integers. If you wish
  to use this as part of your object/label/filename numbering scheme, a
  number by itself will not be very informative. Hence you could set a
  prefix such as "Group" to distinguish this column from other columns
  in the chapter_structure.

- n_range_glue_template_1, n_range_glue_template_2:

  `scalar<string>` // *default:* `"{n}" and "[{n[1]}, {n[2]}]`
  (`optional`)

  Glue templates for the n_range columns to be created.

- log_file:

  *Path to log file*

  `scalar<string>` // *default:* `"_log.txt"` (`optional`)

  Path to log file. Set to NULL to disable logging.

## Value

A grouped tibble (data.frame) with columns that fall into two main
categories:

**Input columns (from user data):**

- `chapter` (character): Chapter name (input)

- `dep` (character): Dependent variable selector (input)

- `indep` (character, optional): Independent variable selector (input)

**Constructed columns (all start with a dot):**

- `.variable_name`, `.variable_position` (character/integer): Variable
  name and position

- `.variable_label`, `.variable_label_prefix`, `.variable_label_suffix`
  (character): Variable label and its components

- `.variable_type`, `.variable_type_dep`, `.variable_type_indep`
  (character): Variable type(s)

- `.variable_name_dep`, `.variable_name_indep` (character): Names of
  dependent/independent variables

- `.variable_label_prefix_dep`, `.variable_label_prefix_indep`
  (character): Label prefixes for dep/indep

- `.variable_group_dep` (character/factor): Grouping variable for
  bivariate analysis

- `.variable_group_id` (integer): Numeric group identifier for bivariate
  analysis

- `.chapter_number` (integer): Chapter number

- `.template_name` (character): Name of chunk template used

- `.obj_name`, `.chunk_name`, `.file_name` (character): Object, chunk,
  and file names (for output)

- `.n`, `.n_range` (integer/character): Sample size and range

- `.n_cats_dep`, `.n_cats_indep` (integer): Number of categories for
  dep/indep

- `.max_chars_labels_dep`, `.max_chars_labels_indep` (integer): Max
  label length for dep/indep

- `.max_chars_cats_dep`, `.max_chars_cats_indep` (integer): Max category
  label length for dep/indep

- `.n_dep`, `.n_indep` (integer): Number of dep/indep variables in group

- `.bi_test`, `.p_value` (character/numeric): Statistical test name and
  p-value for bivariates

- `.keep_bi_rows` (logical): Whether bivariate row is kept

- Other columns may be present depending on chunk templates and options.

**Row count estimate:**

- The number of rows in the output depends on the number of chapters,
  dep/indep combinations, and chunk templates. Typically, it is the sum
  of all unique variable combinations specified in `chapter_overview`,
  expanded by chunk templates and filtered by significance and other
  options. For a simple overview, expect one row per variable per
  chapter; for bivariates, one row per dep-indep pair.

**Grouping variables:**

- The columns used for grouping (i.e.,
  [`dplyr::grouped_df`](https://dplyr.tidyverse.org/reference/grouped_df.html))
  are determined by the `organize_by` argument. By default, this
  includes `.chapter_number`, `.variable_label_prefix_dep`,
  `.variable_name_indep`, and `.template_name`, but can be customized.
  These columns define how the output is grouped for further analysis or
  reporting.

See function source and documentation for details on each column's
meaning and usage.

## Examples

``` r
ref_df <- refine_chapter_overview(
  chapter_overview = ex_survey_ch_overview
)
#> `chunk_templates` is NULL. Using global defaults.
#> Refining chapter_overview into a chapter_structure ...
#> Warning: `data` is empty
```
