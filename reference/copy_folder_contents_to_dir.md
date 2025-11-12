# Convenience Function to Copy Only the Contents of A Folder to Another Folder

Convenience Function to Copy Only the Contents of A Folder to Another
Folder

## Usage

``` r
copy_folder_contents_to_dir(
  from,
  to,
  overwrite = FALSE,
  only_copy_folders = FALSE
)
```

## Arguments

- to, from:

  String, path from where to copy the contents, and where to copy them
  to.

- overwrite:

  Flag. Defaults to FALSE.

- only_copy_folders:

  Flag. Defaults to FALSE. If TRUE, only copies folders.

## Value

No return value, called for side effects

## Examples

``` r
copy_folder_contents_to_dir(
  from = system.file("help", "figures", package = "dplyr"),
  to = tempdir()
)
#> Copied:
```
