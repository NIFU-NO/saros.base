arrange2 <- function(
    data,
    arrange_vars = NULL,
    organize_by_vars = NULL,
    na_first = TRUE) {
  if (is.null(arrange_vars)) {
    return(data)
  }


  if (is.character(arrange_vars)) {
    arrange_vars <- stats::setNames(rep(FALSE, times = length(arrange_vars)), nm = arrange_vars)
  }
  if (is.character(organize_by_vars)) {
    organize_by_vars <- stats::setNames(rep(FALSE, times = length(organize_by_vars)), nm = organize_by_vars)
  }


  check_arrange_vars <- names(arrange_vars)[!names(arrange_vars) %in% colnames(data)]
  if (length(check_arrange_vars) > 0) {
    cli::cli_abort("{.arg arrange_vars} not found in {.arg data}: {check_arrange_vars}.")
  }
  check_grouping_vars <- names(organize_by_vars)[!names(organize_by_vars) %in% colnames(data)]
  if (length(check_grouping_vars) > 0) {
    cli::cli_abort("{.arg organize_by_vars} not found in {.arg data}: {check_grouping_vars}.")
  }

  combined <- c(arrange_vars, organize_by_vars)
  combined <- combined[!duplicated(names(combined))]

  arrange_exprs <- lapply(names(combined), function(var) {
    if (is.factor(data[[var]]) && isTRUE(na_first)) {
      expr <- rlang::expr(forcats::fct_relevel(forcats::fct_na_value_to_level(.data[[var]]), NA))
    }
    if (is.factor(data[[var]]) && isFALSE(na_first)) {
      expr <- rlang::expr(as.integer(.data[[var]]))
    }
    if (is.character(data[[var]]) && isTRUE(na_first)) {
      expr <- rlang::expr(forcats::fct_relevel(forcats::fct_na_value_to_level(factor(.data[[var]])), NA))
    }
    if (is.character(data[[var]]) && isFALSE(na_first)) {
      expr <- rlang::expr(.data[[var]])
    }
    if (isFALSE(is.factor(data[[var]])) && isFALSE(is.character(data[[var]])) && isTRUE(na_first)) {
      expr <- rlang::expr(dplyr::if_else(is.na(.data[[var]]), -Inf, as.numeric(.data[[var]])))
    }
    if (isFALSE(is.factor(data[[var]])) && isFALSE(is.character(data[[var]])) && isFALSE(na_first)) {
      expr <- rlang::expr(.data[[var]])
    }
    if (combined[[var]]) {
      expr <- rlang::expr(dplyr::desc(!!expr))
    }
    expr
  })

  out <- dplyr::arrange(data, !!!arrange_exprs)
  # Fix order to avoid that grouped_df later reorders it
  # out <- dplyr::mutate(out, dplyr::across(tidyselect::all_of(names(combined)), ~ factor(.x, exclude = character())))

  out <- dplyr::grouped_df(out, vars = names(organize_by_vars)[names(organize_by_vars) %in% colnames(out)])

  list(x = out, expr = arrange_exprs)
}
