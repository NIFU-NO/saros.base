#' Sanitize character vector, for instance useful for variable xs in `xled::update_variable_xs_with()`
#'
#'
#' @param x character vector or factor vector
#' @param sep String, separates main question from subquestion
#' @param multi_sep_replacement String. If multiple sep are found, replace the first ones with this.
#' @param replace_ascii_with_utf Flag. If TRUE, downloads a list from W3 used to convert html characters as ASCII to UTF8.
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
    pattern = c("â€™", "â€œ", "â€"),
    replacement = c("'", "\"", ""),
    vectorize_all = FALSE
  )

  # scrape lookup table of accented char html codes, from the 2nd table on this page
  if (isTRUE(replace_ascii_with_utf)) {
    ref_url <- "http://www.w3schools.com/charsets/ref_html_8859.asp"
    cols <- c("Character", "Entity Name")
    char_table <- rvest::read_html(ref_url)
    char_table <- rvest::html_table(char_table)
    char_table <- char_table[1:4]
    char_table <- lapply(char_table, function(x) x[, cols])
    char_table <- do.call(rbind, char_table)
    char_table <- char_table[!duplicated(char_table[[cols[2]]]) & char_table[[cols[2]]] != "", ]
    for (i in seq_len(nrow(char_table))) {
      x <- stringi::stri_replace_all_fixed(
        str = x,
        pattern = char_table[i, cols[2], drop = TRUE],
        replacement = char_table[i, cols[1], drop = TRUE]
      )
    }
  }

  # here's a test string loaded with different html accents
  # test_str <- '&Agrave; &Aacute; &Acirc; &Atilde; &Auml; &Aring; &AElig; &Ccedil; &Egrave; &Eacute; &Ecirc; &Euml; &Igrave; &Iacute; &Icirc; &Iuml; &ETH; &Ntilde; &Ograve; &Oacute; &Ocirc; &Otilde; &Ouml; &times; &Oslash; &Ugrave; &Uacute; &Ucirc; &Uuml; &Yacute; &THORN; &szlig; &agrave; &aacute; &acirc; &atilde; &auml; &aring; &aelig; &ccedil; &egrave; &eacute; &ecirc; &euml; &igrave; &iacute; &icirc; &iuml; &eth; &ntilde; &ograve; &oacute; &ocirc; &otilde; &ouml; &divide; &oslash; &ugrave; &uacute; &ucirc; &uuml; &yacute; &thorn; &yuml;'

  # use mgsub from here (it's just gsub with a for loop)
  # http://stackoverflow.com/questions/15253954/replace-multiple-arguments-with-gsub


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
