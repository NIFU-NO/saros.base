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
  pattern <- if (isTRUE(accept_hyphen)) "[^[:alnum:]-+]+" else "[^[:alnum:]+]+"
  out <-
    stringi::stri_replace_all_regex(x,
      pattern = pattern,
      replacement = sep
    )
  if (isTRUE(valid_obj)) {
    out <-
      stringi::stri_replace_all_regex(out, pattern = "^[^[:alpha:]]+", replacement = "")
  }

  out <- iconv(out, from = "UTF-8", to = "ASCII//TRANSLIT", sub = "")

  if (isTRUE(to_lower)) out <- tolower(out)

  out <- truncator(x = out, max_chars = max_chars)
  out <- avoid_ending_with_specials(out)
  out <- avoid_empty(out)
  if (isTRUE(make_unique)) out <- make.unique(out, sep = sep)
  out
}

truncator <- function(x, max_chars = NA_integer_) {
  if (!(is.na(max_chars) || is.null(max_chars)) &&
    length(x) > 0) {
    stringi::stri_sub(x, from = 1, to = max_chars)
  } else {
    x
  }
}

avoid_ending_with_specials <- function(x) {
  stringi::stri_replace_last_regex(x, pattern = "[^[:alnum:]]+$", replacement = "")
}

# Guarantee a non-empty name for every non-NA element (GH #244)
#
# Every character can be stripped: "***" becomes separators only, and
# avoid_ending_with_specials() then removes those, leaving "". Truncation can do
# the same to a name whose first `max_chars` characters are all illegal. An
# empty string is not a name -- fs::path() drops the segment entirely, so a
# caller composing <parent>/<name>/file.yml silently writes to
# <parent>/file.yml and overwrites whatever lives there.
#
# The substitute is one fixed word rather than anything derived from the
# element's position, because filename_sanitizer() must map equal inputs to
# equal outputs: add_chapter_foldername_to_chapter_structure() passes the whole
# chapter column -- one element per row, so a chapter repeats -- with
# make_unique = FALSE, and a positional substitute would give one chapter a
# different folder name in each of its rows. Two *different* names that both
# sanitize away therefore collapse onto each other, which is ordinary behaviour
# for this function ("a b" and "a-b" already both give "a_b") and is what
# `make_unique` exists to resolve.
#
# "unnamed" is purely alphanumeric, so it survives `valid_obj`, `to_lower`,
# avoid_ending_with_specials() and any `sep`. It is deliberately not truncated
# to `max_chars`: a name a few characters too long is harmless, an empty one is
# not. NA is left alone -- callers distinguish "no name given" from "a name that
# sanitized away".
avoid_empty <- function(x) {
  is_empty <- !is.na(x) & !nzchar(x)
  if (any(is_empty)) x[is_empty] <- "unnamed"
  x
}
