# Create Folder with Placeholder R-files Based on Structure in CSV-file

Create Folder with Placeholder R-files Based on Structure in CSV-file

## Usage

``` r
create_r_files(
  r_files_out_path,
  r_files_source_path = system.file("templates", "r_files.csv", package = "saros.base"),
  r_optionals = TRUE,
  r_add_file_scope = TRUE,
  r_prefix_file_scope = "### ",
  r_add_folder_scope_as_README = FALSE,
  word_separator = NULL,
  case = c("asis", "sentence", "title", "lower", "upper", "snake"),
  numbering_prefix = c("none", "max_local", "max_global"),
  numbering_inheritance = TRUE,
  numbering_parent_child_separator = word_separator,
  numbering_name_separator = " "
)
```

## Arguments

- r_files_out_path:

  String, path to where to place R placeholder files. If NULL, will not
  create any.

- r_files_source_path:

  String, path to where to find CSV-field containing the columns
  folder_name, folder_scope, file_name, file_scope. If NULL, defaults to
  system.file("templates", "r_files.csv")).

- r_optionals:

  Flag. Whether to add files marked as 1 (or TRUE) in the optional
  column. Defaults to TRUE.

- r_add_file_scope:

  Flag. Whether to add value from column 'file_scope' to beginning of
  each file. Default to TRUE.

- r_prefix_file_scope:

  String to add before file_scope. Defaults to "### "

- r_add_folder_scope_as_README:

  Flag. Whether to create README file in each folder with the
  folder_scope column cell in r_files_source_path. Defaults to FALSE.

- word_separator:

  String. Replace separators between words in folder names. Defaults to
  NULL.

- case:

  String. One of c("asis", "sentence", "lower", "upper", "title",
  "snake").

- numbering_prefix:

  String. One of c("none", "max_local", "max_global").

- numbering_inheritance:

  Flag. Whether to inherit numbering from parent folder.

- numbering_parent_child_separator:

  String. Defaults to word_separator.

- numbering_name_separator:

  String. Separator between numbering part and name.

## Value

No return value, called for side effects

## Examples

``` r
create_r_files(r_files_out_path = tempdir())
```
