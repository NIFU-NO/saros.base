# Write Default Arguments for [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md) to YAML-file

Write Default Arguments for
[`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
to YAML-file

## Usage

``` r
write_default_draft_report_args(
  path,
  ignore_args = c("data", "...", "dep", "indep", "chapter_structure", "chapter_overview",
    "path")
)
```

## Arguments

- path:

  `scalar<character>` // Required. *default:* `settings.yaml`

- ignore_args:

  `vector<character>` // Optional. *default:*
  `c("data", "...", "dep", "indep", "chapter_structure", "chapter_overview")`

  A character vector of argument (names) not to be written to file.

## Value

The defaults as a `yaml`-object.

## Examples

``` r
write_default_draft_report_args(path = tempfile(fileext = ".yaml"))
#> [1] "/tmp/RtmpCzm511/file1fa55bad7a33.yaml"
```
