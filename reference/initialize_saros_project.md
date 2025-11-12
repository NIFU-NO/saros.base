# Initialize Folder Structure

Can be used programatically from the console, or simply use the New
Project Wizard.

## Usage

``` r
initialize_saros_project(
  path,
  structure_path = NULL,
  numbering_prefix = c("none", "max_local", "max_global"),
  numbering_inheritance = TRUE,
  word_separator = NULL,
  numbering_name_separator = " ",
  replacement_list = NULL,
  numbering_parent_child_separator = word_separator,
  case = c("asis", "sentence", "title", "lower", "upper", "snake"),
  count_existing_folders = FALSE,
  r_files_out_path = NULL,
  r_files_source_path = system.file("templates", "r_files.csv", package = "saros.base"),
  r_optionals = TRUE,
  r_add_file_scope = TRUE,
  r_prefix_file_scope = "### ",
  r_add_folder_scope_as_README = FALSE,
  create = TRUE
)
```

## Arguments

- path:

  String, path to where to create the project files

- structure_path:

  String. Path to the YAML file that defines the folder structure.
  Defaults to system.file("templates", "\_project_structure_en.yaml").

- numbering_prefix:

  String. One of c("none", "max_local", "max_global").

- numbering_inheritance:

  Flag. Whether to inherit numbering from parent folder.

- word_separator:

  String. Replace separators between words in folder names. Defaults to
  NULL.

- numbering_name_separator:

  String. Separator between numbering part and name.

- replacement_list:

  named character vector. Each name in this vector will be replaced with
  its `"{{value}}"` in the structure_path file

- numbering_parent_child_separator:

  String. Defaults to word_separator.

- case:

  String. One of c("asis", "sentence", "lower", "upper", "title",
  "snake").

- count_existing_folders:

  Boolean. Defaults to FALSE.

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

- create:

  Boolean. Defaults to TRUE in initialize_saros_project(), FALSE in
  create_directory_structure().

## Value

Returns invisibly `path`

## Examples

``` r
initialize_saros_project(path = tempdir())
#> RtmpClqKEn
```
