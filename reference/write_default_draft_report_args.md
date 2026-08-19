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

  `scalar<character>` // Required

  Path of the YAML-file to write. There is no default; pass an explicit
  path, e.g. `"settings.yaml"`.

- ignore_args:

  `vector<character>` // *default:*
  `c("data", "...", "dep", "indep", "chapter_structure", "chapter_overview", "path")`
  (`optional`)

  A character vector of argument (names) not to be written to file.
  `"path"` is excluded because it names the output file of this call
  rather than a setting worth recording.

## Value

The defaults as a `yaml`-object.

## Examples

``` r
write_default_draft_report_args(path = tempfile(fileext = ".yaml"))
#> [1] "/tmp/RtmpBTNcfC/file1c9f41647f3e.yaml"
```
