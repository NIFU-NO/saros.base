# Wrapper to Download and Unzip a Github Repository to A Folder

Wrapper to Download and Unzip a Github Repository to A Folder

## Usage

``` r
download_zip_to_folder(
  github_zip_url = "https://github.com/NIFU-NO/nifutemplates/archive/refs/heads/main.zip",
  zip_path = tempfile(fileext = ".zip"),
  files = NULL,
  out_path,
  prompt = TRUE,
  overwrite = FALSE,
  open_project = FALSE,
  newSession = TRUE
)
```

## Arguments

- github_zip_url:

  URL to zip file, as string.

- zip_path:

  String, where to store zip-file. Defaults to a temporary location.

- files:

  Character vector of files in zip-file to include. See
  [`zip::unzip()`](https://r-lib.github.io/zip/reference/unzip.html).

- out_path:

  String, directory to where to store the unzipped files.

- prompt:

  Flag, whether to ask user if conflicting files should be overwritten,
  if any. Defaults to TRUE.

- overwrite:

  Flag, whether to overwrite files in out_path. Defaults to FALSE.

- open_project:

  Flag or string. If FALSE (default), does nothing. If TRUE (requires
  `rstudioapi`-pkg), opens an assumed .Rproj-file in out_path after
  copying, or gives warning if not found. Alternatively, a string (path)
  can be provided. Defaults to file.path(out_path, ".Rproj") if such
  exists. Set to NULL or FALSE to ignore.

- newSession:

  Flag. Whether to open new project in a new RStudio session. Defaults
  to TRUE.

## Value

Character vector of unzipped files.

## Examples

``` r
download_zip_to_folder(
  github_zip_url = "https://github.com/NIFU-NO/nifutemplates/archive/refs/heads/main.zip",
  out_path = tempdir(), overwrite = TRUE
)
#> Copied: 01_script, 02_resources, and 03_organization_settings
#> [1] "/tmp/RtmpKNAHBN"
```
