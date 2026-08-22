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
  glue_heading_for_group = NULL,
  chapter_setup_packages = c("saros", "gt"),
  chapter_setup_parameters = TRUE,
  format = "html",
  chapter_yaml_file = NULL,
  chapter_qmd_start_section_filepath = NULL,
  chapter_qmd_end_section_filepath = NULL,
  write_qmd = TRUE,
  attach_chapter_dataset = TRUE,
  auxiliary_variables = NULL,
  serialized_format = "rds",
  filename_prefix = "",
  data_filename_prefix = "data_",
  qmd_engine = c("recursion", "loop")
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

  `scalar<character>` // *default:* `NULL` (`optional`)

  Path to save all output. Documented here rather than inherited from
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md),
  whose default is [`tempdir()`](https://rdrr.io/r/base/tempfile.html)
  instead. This function has no such fallback, and the default is not
  usable: `fs::as_fs_path(NULL)` is `character(0)`, so the first
  [`dir.create()`](https://rdrr.io/r/base/files2.html) aborts with
  `invalid 'path' argument` before anything is written. A direct call
  must therefore supply a path.
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  always does.

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

  `named vector<character>` // *default:* `NULL` (`optional`)

  As in
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md),
  but documented here rather than inherited because no replacements are
  made unless asked for, whereas
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  defaults to a three-entry vector. Use the name for the replacement and
  the value for the original.
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
  always supplies this explicitly, so the default only applies to a
  direct call.

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

  *Quarto output format written into each chapter's YAML*

  `scalar<character>` // *default:* `"html"` (`optional`)

  Written as the `format:` field of the YAML front matter of every
  chapter this function writes, and passed through verbatim. Documented
  here rather than inherited from
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md),
  whose description also covers `index.qmd` and the combined report and
  names `index_yaml_file` and `report_yaml_file` — this function writes
  chapters only, and its sole YAML argument is `chapter_yaml_file`.

  Ignored when `chapter_yaml_file` is supplied, since that file then
  provides the whole front matter, `format:` included.

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

- data_filename_prefix:

  *String attached to beginning of data-file and data-object*

  `scalar<string>` // *default:* `"data_"`

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
