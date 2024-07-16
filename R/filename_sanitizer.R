#' File/folder name sanitizer replacing space and punctuation with underscore
#'
#' @param x Character vector of file/folder names
#' @param max_chars Maximum character length
#' @param accept_hyphen Flag, whether a hyphen - is acceptable.
#' @param sep String, replacement for illegal characters and spaces.
#' @param valid_obj Flag, whether output should be valid as R object name.
#' @param to_lower Flag, whether to force all characters to lower.
#' @param make_unique Flag, whether all should be unique.
#'
#' @return Character vector of same length as x
#' @export
#'
#' @examples
#' filename_sanitizer(c("Too long a name", "with invalid *^/&#"))
filename_sanitizer <- function(x,
                               max_chars = NA_integer_,
                               accept_hyphen = FALSE,
                               sep = "_",
                               valid_obj = FALSE,
                               to_lower = FALSE,
                               make_unique = TRUE) {

  pattern <- if(isTRUE(accept_hyphen)) "[^[:alnum:]-+]+" else "[^[:alnum:]+]+"
  out <-
    stringi::stri_replace_all_regex(x,
                                    pattern = pattern,
                                    replacement = sep)
  if(isTRUE(valid_obj)) {
    out <-
      stringi::stri_replace_all_regex(out, pattern = "^[^[:alpha:]]+", replacement = "")
  }

  out <- iconv(out, from ="UTF-8", to="ASCII//TRANSLIT", sub='')

  if(isTRUE(to_lower)) out <- tolower(out)

  out <- truncator(x=out, max_chars = max_chars)
  if(isTRUE(make_unique)) out <- make.unique(out, sep=sep)
  out
}

truncator <- function(x, max_chars = NA_integer_) {
  if(!(is.na(max_chars) || is.null(max_chars)) &&
     length(x)>0) stringi::stri_sub(x, from = 1, to = max_chars) else x
}
