# Delete Quarto \_freeze Cache for Updated QMD Files

When Quarto renders `.qmd` files, it caches execution results in a
`_freeze` directory. If a `.qmd` file is updated, the corresponding
`_freeze` entry becomes stale. This function deletes `_freeze` entries
for `.qmd` files that have been modified more recently than their cache.

## Usage

``` r
delete_freeze(path, qmd_files = NULL)
```

## Arguments

- path:

  String. Path to the Quarto project directory containing the `_freeze`
  folder and `.qmd` files.

- qmd_files:

  Character vector of `.qmd` file paths (relative to `path`) to check.
  If `NULL` (default), all `.qmd` files found recursively under `path`
  are checked.

## Value

Character vector of deleted `_freeze` directories (invisibly).

## Examples

``` r
if (FALSE) { # \dontrun{
# Delete stale freeze caches in a Quarto project
delete_freeze(path = "my_report")

# Check specific files only
delete_freeze(path = "my_report", qmd_files = "01_intro/01_intro.qmd")
} # }
```
