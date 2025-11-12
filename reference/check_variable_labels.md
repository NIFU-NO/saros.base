# Check Variable Labels for Saros Use

Checks various label quality issues and returns a data frame with
indications of which label has the issue and what issue.

## Usage

``` r
check_variable_labels(
  data,
  separator = " - ",
  special_chars = "[^\\p{L}\\p{N}\\s!?'#%&/()\\[\\]{}=+\\-*.,:;]"
)
```

## Arguments

- data:

  Data frame or tibble.

- separator:

  String, indicating what to check that there is maximum of 1 of per
  label.

- special_chars:

  String of regular expression.

## Value

Data frame

## Examples

``` r
df <- data.frame(
  a = 1:3,
  b = 4:6,
  c = 7:9,
  d = 11:13,
  e = 14:16,
  f = 17:19
)
attr(df$a, "label") <- "Age"
attr(df$b, "label") <- "Age"
attr(df$c, "label") <- "Gender - Male"
attr(df$e, "label") <- "Gender - Male -  2"
attr(df$f, "label") <- "Gender - Female..."
check_variable_labels(df)
#> Warning: One or more variable labels have issues. See returned table for details.
#>   variable              label    type issue_missing_or_short
#> a        a                Age integer                  FALSE
#> b        b                Age integer                  FALSE
#> d        d               <NA> integer                   TRUE
#> e        e Gender - Male -  2 integer                  FALSE
#>   issue_duplicate_labels issue_multiple_separators issue_whitespace issue_html
#> a                   TRUE                     FALSE            FALSE      FALSE
#> b                   TRUE                     FALSE            FALSE      FALSE
#> d                  FALSE                     FALSE            FALSE      FALSE
#> e                  FALSE                      TRUE             TRUE      FALSE
#>   issue_special_char issue_ellipsis
#> a              FALSE          FALSE
#> b              FALSE          FALSE
#> d              FALSE          FALSE
#> e              FALSE          FALSE
```
