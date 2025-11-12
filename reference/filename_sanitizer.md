# File/folder name sanitizer replacing space and punctuation with underscore

File/folder name sanitizer replacing space and punctuation with
underscore

## Usage

``` r
filename_sanitizer(
  x,
  max_chars = NA_integer_,
  accept_hyphen = FALSE,
  sep = "_",
  valid_obj = FALSE,
  to_lower = FALSE,
  make_unique = TRUE
)
```

## Arguments

- x:

  Character vector of file/folder names

- max_chars:

  Maximum character length

- accept_hyphen:

  Flag, whether a hyphen - is acceptable.

- sep:

  String, replacement for illegal characters and spaces.

- valid_obj:

  Flag, whether output should be valid as R object name.

- to_lower:

  Flag, whether to force all characters to lower.

- make_unique:

  Flag, whether all should be unique.

## Value

Character vector of same length as x

## Examples

``` r
filename_sanitizer(c("Too long a name", "with invalid *^/&#"))
#> [1] "Too_long_a_name" "with_invalid"   
```
