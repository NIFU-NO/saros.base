# Read Default Arguments for [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md) from YAML-file

Read Default Arguments for
[`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md)
from YAML-file

## Usage

``` r
read_default_draft_report_args(path)
```

## Arguments

- path:

  `scalar<character>` // Required. *default:* `settings.yaml`

## Value

The defaults as a `yaml`-object.

## Examples

``` r
tmpfile <- tempfile(fileext = ".yaml")
write_default_draft_report_args(path = tmpfile)
#> [1] "/tmp/RtmpnCjZ8Q/file20b48628934.yaml"
read_default_draft_report_args(path = tmpfile)
#> $title
#> NULL
#> 
#> $authors
#> NULL
#> 
#> $authors_col
#> [1] "author"
#> 
#> $chapter_yaml_file
#> NULL
#> 
#> $chapter_qmd_start_section_filepath
#> NULL
#> 
#> $chapter_qmd_end_section_filepath
#> NULL
#> 
#> $index_filename
#> [1] "index"
#> 
#> $index_yaml_file
#> NULL
#> 
#> $index_qmd_start_section_filepath
#> NULL
#> 
#> $index_qmd_end_section_filepath
#> NULL
#> 
#> $report_filename
#> [1] "report"
#> 
#> $report_yaml_file
#> NULL
#> 
#> $report_qmd_start_section_filepath
#> NULL
#> 
#> $report_qmd_end_section_filepath
#> NULL
#> 
#> $report_includes_files
#> [1] FALSE
#> 
#> $ignore_heading_for_group
#> [1] ".template_name"       ".variable_type_dep"   ".variable_type_indep"
#> [4] ".variable_group_dep"  "chapter"             
#> 
#> $replace_heading_for_group
#>                      chapter   .variable_label_suffix_dep 
#>            ".chapter_number"         ".variable_name_dep" 
#> .variable_label_suffix_indep 
#>       ".variable_name_indep" 
#> 
#> $prefix_heading_for_group
#> NULL
#> 
#> $suffix_heading_for_group
#> NULL
#> 
#> $require_common_categories
#> [1] TRUE
#> 
#> $combined_report
#> [1] TRUE
#> 
#> $write_qmd
#> [1] TRUE
#> 
#> $attach_chapter_dataset
#> [1] TRUE
#> 
#> $auxiliary_variables
#> NULL
#> 
#> $serialized_format
#> NULL
#> 
#> $max_path_warning_threshold
#> [1] 260
#> 
#> $filename_prefix
#> [1] ""
#> 
#> $data_filename_prefix
#> [1] "data_"
#> 
#> $report_includes_prefix
#> [1] "{{< include \""
#> 
#> $report_includes_suffix
#> [1] "\" >}}"
#> 
#> $log_file
#> NULL
#> 
```
