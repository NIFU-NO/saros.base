#' Sanitize character vector, for instance useful for variable label in `labelled::update_variable_labels_with()`
#'
#'
#' @param x Character vector or factor vector
#' @param sep String, separates prefix (e.g. main question) from suffix (sub-question)
#' @param multi_sep_replacement String. If multiple separators (`sep`) are found, replace the first ones with this.
#' @param replace_ascii_with_utf Flag. If TRUE, converts HTML characters to Unicode symbol.
#'
#' @return Character vector with sanitized strings
#' @export
#' @examples
#' # Example 1: Basic usage
#' input <- c("<b>Bold</b>", "  Extra spaces   ", "- Selected Choice -")
#' sanitize_chr_vec(input)
#'
#' # Example 2: Replace ASCII with UTF
#' input <- c("&Agrave;", "&Eacute;", "&Ouml;")
#' sanitize_chr_vec(input, replace_ascii_with_utf = TRUE)
#'
#' # Example 3: Custom separators
#' input <- c("Question - Subquestion", "Another - Example")
#' sanitize_chr_vec(input, sep = " - ", multi_sep_replacement = ": ")
sanitize_chr_vec <- function(x,
                             sep = " - ",
                             multi_sep_replacement = ": ",
                             replace_ascii_with_utf = FALSE) {
  if (!is.character(x) && !is.factor(x)) {
    cli::cli_abort("{.arg x} must be a character or factor vector.")
  }

  # Normalize Unicode strings
  x <- stringi::stri_trans_nfc(x)

  # Remove non-printable characters
  x <- stringi::stri_replace_all_regex(x, pattern = "[[:cntrl:]]", replacement = "")

  # Replace common encoding artifacts
  x <- stringi::stri_replace_all_fixed(
    x,
    pattern = c("\u00C2\u20AC\u2122", "\u00C2\u20AC\u0153", "\u00C2\u20AC"),
    replacement = c("'", "\"", ""),
    vectorize_all = FALSE
  )

  # scrape lookup table of accented char html codes, from the 2nd table on this page
  if (isTRUE(replace_ascii_with_utf)) {
    for (i in seq_len(nrow(html_lookup_table))) {
      x <- stringi::stri_replace_all_fixed(
        str = x,
        pattern = html_lookup_table[i, "html_name", drop = TRUE],
        replacement = html_lookup_table[i, "symbol", drop = TRUE]
      )
    }
  }

  x <- stringi::stri_replace_all_regex(x, pattern = "- Selected Choice ", replacement = "- ")
  x <- stringi::stri_replace_all_regex(x, pattern = "<.+?>|\\[.*\\]| - tekst", replacement = "")
  x <- stringi::stri_replace_all_regex(x, pattern = "\\$\\{[[:alnum:]]+[^[:alnum:]]([[:alnum:]]+)\\}", replacement = "$1")
  x <- stringi::stri_replace_all_regex(x, pattern = "\\{%name:([[:alnum:]]+) expression:.+?%\\}", replacement = "$1")
  # Remove Qualtrics reference tags
  x <- stringi::stri_replace_all_regex(x, pattern = "\\{%expression:.+?%\\}", replacement = "")
  # Replace multiple spaces, new lines, tabs with single space
  x <- stringi::stri_replace_all_regex(x, pattern = "[[:space:]\n\r\t]+", replacement = " ")
  # Replace multiple sep with multi_sep_replacement
  x[stringi::stri_count_fixed(x, sep) >= 2] <-
    stringi::stri_replace_last_fixed(x[stringi::stri_count_fixed(x, sep) >= 2],
      pattern = sep, replacement = multi_sep_replacement
    )
  # Reduce multiple sep occurrences to single occurrence
  x <- stringi::stri_replace_all_regex(x, pattern = "([[:space:]]+[-\\.:]+){2,}", replacement = "$1")
  # Remove trailing spaces, hyphens, colons, dots
  x <- stringi::stri_replace_all_regex(x, pattern = "[[:space:]-:\\.]+$", replacement = "")
  x <- stringi::stri_replace_all_regex(x, pattern = "[<{]+", replacement = "(")
  x <- stringi::stri_replace_all_regex(x, pattern = "[>}]+", replacement = ")")
  x <- stringi::stri_replace_all_regex(x, pattern = ":+", replacement = ":")
  x <- stringi::stri_trim_both(x)
  x
}
