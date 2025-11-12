# Handle numbering inheritance

Handle numbering inheritance

## Usage

``` r
handle_numbering_inheritance(
  counter = 1,
  numbering_prefix = c("none", "max_global", "max_local"),
  max_folder_count_digits = 0,
  parent_path = "Journal manuscripts",
  parent_numbering = NA,
  numbering_parent_child_separator = "_",
  count_existing_folders = FALSE
)
```

## Arguments

- counter:

  digit

- numbering_prefix:

  One of "none" (no zero-leading prefix), "max_global" (counts with
  leading zeroes matching the maximally observed items in any of the
  subfolders), "max_local" (same as max_global, but only considering the
  current folder of the item)

- max_folder_count_digits:

  Integer. The fixed width of the counting.

- parent_path:

  String, path to parent folder.

- parent_numbering:

  String, or NA. If not NA, adds the parent_numbering to the left side
  of the counter.

- numbering_parent_child_separator:

  String, separates the parent number from the child number, if
  parent_numbering is not NA.

- count_existing_folders:

  Flag. Whether to consider existing folders when counting. Defaults to
  FALSE.

## Value

String
