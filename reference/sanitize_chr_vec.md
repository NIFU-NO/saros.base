# Sanitize character vector, for instance useful for variable label in `labelled::update_variable_labels_with()`

Sanitize character vector, for instance useful for variable label in
[`labelled::update_variable_labels_with()`](https://larmarange.github.io/labelled/reference/update_variable_labels_with.html)

## Usage

``` r
sanitize_chr_vec(
  x,
  sep = " - ",
  multi_sep_replacement = ": ",
  replace_ascii_with_utf = FALSE
)
```

## Arguments

- x:

  Character vector or factor vector

- sep:

  String, separates prefix (e.g. main question) from suffix
  (sub-question)

- multi_sep_replacement:

  String. If multiple separators (`sep`) are found, replace the first
  ones with this.

- replace_ascii_with_utf:

  Flag. If TRUE, converts HTML characters to Unicode symbol.

## Value

Character vector with sanitized strings

## Examples

``` r
# Example 1: Basic usage
input <- c("<b>Bold</b>", "  Extra spaces   ", "- Selected Choice -")
sanitize_chr_vec(input)
#> [1] "Bold"         "Extra spaces" ""            

# Example 2: Replace ASCII with UTF
input <- c("&Agrave;", "&Eacute;", "&Ouml;")
sanitize_chr_vec(input, replace_ascii_with_utf = TRUE)
#> [1] "À" "É" "Ö"

# Example 3: Custom separators
input <- c("Question - Subquestion", "Another - Example")
sanitize_chr_vec(input, sep = " - ", multi_sep_replacement = ": ")
#> [1] "Question - Subquestion" "Another - Example"     
```
