# Add Sample Size Range to Chapter Structure

Takes `chapter_structure` and `data` and returns the `chapter_structure`
with an attached variable containing a string with the sample size-range
(or single value if min=max). Allows specifying the glue_template_1
(single value) and glue_template_2 (for min and max values).

## Usage

``` r
add_n_range_to_chapter_structure(
  chapter_structure,
  data,
  glue_template_1 = "{n}",
  glue_template_2 = "[{n[1]}-{n[2]}]",
  variable_name = ".n_range"
)
```

## Arguments

- chapter_structure:

  A grouped tibble. If not grouped, will give a warning and continue
  with rowwise processing, which is unlikely what you want.

- data:

  The raw data, with matching column names as in
  `chapter_structure$.variable_name_dep`.

- glue_template_1, glue_template_2:

  Glue templates.

- variable_name:

  String, name of new variable to attach. Defaults to ".n_range"

## Value

chapter_structure with a new variable added. Grouped as before.
