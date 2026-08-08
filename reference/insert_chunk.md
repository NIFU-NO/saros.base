# Mass Create Elements of A Certain Type

Mass Create Elements of A Certain Type

## Usage

``` r
insert_chunk(
  chapter_structure_section,
  grouping_structure,
  template_variable_name = ".template"
)
```

## Arguments

- chapter_structure_section:

  *Overview of chapter section*

  `obj:<data.frame>|obj:<tbl_df>` // Required

  Data frame (or tibble, possibly grouped). Must contain column 'dep'
  with similar items. See
  [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md).

- grouping_structure:

  *Vector of groups*

  `vector<character>` // Required

  Internal usage. There is no default: the argument is read before
  anything else happens, so a call that omits it fails.

## Value

Named list of elements, where each element can UNFINISHED.
