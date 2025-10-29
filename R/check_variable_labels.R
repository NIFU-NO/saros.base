#' Check Variable Labels for Saros Use
#'
#' Checks various label quality issues and returns a data frame with indications of which label has the issue and what issue.
#'
#' @param data Data frame or tibble.
#' @param separator String, indicating what to check that there is maximum of 1 of per label.
#' @param special_chars String of regular expression.
#'
#' @returns Data frame
#' @export
#'
#' @examples
#' df <- data.frame(
#'   a = 1:3,
#'   b = 4:6,
#'   c = 7:9,
#'   d = 11:13,
#'   e = 14:16,
#'   f = 17:19
#' )
#' attr(df$a, "label") <- "Age"
#' attr(df$b, "label") <- "Age"
#' attr(df$c, "label") <- "Gender - Male"
#' attr(df$e, "label") <- "Gender - Male -  2"
#' attr(df$f, "label") <- "Gender - Female..."
#' check_variable_labels(df)
check_variable_labels <- function(data,
                                  separator = " - ",
                                  special_chars = "[^\\p{L}\\p{N}\\s!?'#%&/()\\[\\]{}=+\\-*.,:;]") {
  stopifnot(is.data.frame(data))


  get_label <- function(var) attr(var, "label") %||% NA_character_

  labels <- vapply(data, get_label, FUN.VALUE = character(1), USE.NAMES = FALSE)
  types <- vapply(data, typeof, FUN.VALUE = character(1))
  names <- names(data)

  problems <- data.frame(
    variable = names,
    label = labels,
    type = types,
    issue_missing_or_short = is.na(labels) | nchar(labels) < 3,
    issue_duplicate_labels = stats::ave(labels, types, FUN = function(x) duplicated(x) | duplicated(x, fromLast = TRUE)) == "TRUE",
    issue_multiple_separators = !is.na(stringi::stri_count_fixed(labels, pattern = separator)) & stringi::stri_count_fixed(labels, pattern = separator) > 1,
    issue_whitespace = !is.na(stringi::stri_detect_regex(labels, pattern = "^\\s|\\s$|\\s{2,}")) & stringi::stri_detect_regex(labels, pattern = "^\\s|\\s$|\\s{2,}"),
    issue_html = !is.na(stringi::stri_detect_regex(labels, pattern = "<[^>]+>")) & stringi::stri_detect_regex(labels, pattern = "<[^>]+>"),
    issue_special_char = !is.na(stringi::stri_detect_regex(labels, pattern = special_chars)) & stringi::stri_detect_regex(labels, pattern = special_chars),
    issue_ellipsis = !is.na(stringi::stri_detect_regex(labels, pattern = "(?<!\\.)\\.\\.(?!\\.)|\\.\\.{3,}")) & stringi::stri_detect_regex(labels, pattern = "(?<!\\.)\\.\\.(?!\\.)|\\.\\.{3,}") # catches exactly 2 dots or 4+ dots (not 3)
  )

  # Any issue?
  flagged <- problems[rowSums(problems[, 4:ncol(problems)], na.rm = TRUE) > 0, ]

  if (nrow(flagged) > 0) {
    cli::cli_warn("One or more variable labels have issues. See returned table for details.")
    return(flagged)
  } else {
    cli::cli_inform("All variable labels passed the checks.")
    return(invisible())
  }
}
