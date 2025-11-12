# Removes entries in sidebar if containing a filename regex pattern.

Removes entries in sidebar if containing a filename regex pattern.

## Usage

``` r
remove_entry_from_sidebar(
  path = "_site",
  filename_as_regex = c("report\\.pdf", "report\\.docx")
)
```

## Arguments

- path:

  String, path to where your html-files are located. Defaults to
  "\_site"

- filename_as_regex:

  Character vector of regex patterns to search for. Defaults to
  c("report\\pdf", "report\\docx")

## Value

Invisibly returns files processed
