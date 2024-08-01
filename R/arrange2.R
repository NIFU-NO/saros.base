arrange2 <- function(data, arrange_vars = NULL, na_first = FALSE) {
  if (is.null(arrange_vars)) return(data)


  if (is.character(arrange_vars)) {
    arrange_vars <- stats::setNames(rep(FALSE, times = length(arrange_vars)), nm = arrange_vars)
  }


  check_vars <- names(arrange_vars)[!names(arrange_vars) %in% colnames(data)]
  if (length(check_vars) > 0) {
    cli::cli_abort("{.arg arrange_vars} not found in {.arg data}: {check_vars}.")
  }

  arrange_exprs <- lapply(names(arrange_vars), function(var) {
    if (is.factor(data[[var]])) {
      if (na_first) {
        expr <- rlang::expr(forcats::fct_relevel(forcats::fct_na_value_to_level(.data[[var]]), NA))
      } else {
        expr <- rlang::expr(as.integer(.data[[var]]))
      }
    } else if (is.character(data[[var]])) {
      if (na_first) {
        expr <- rlang::expr(forcats::fct_relevel(forcats::fct_na_value_to_level(factor(.data[[var]])), NA))
      } else {
        expr <- rlang::expr(as.integer(.data[[var]]))
      }
    } else {
      if (na_first) {
        expr <- rlang::expr(dplyr::if_else(is.na(.data[[var]]), -Inf, .data[[var]]))
      } else {
        expr <- rlang::expr(.data[[var]])
      }
    }
    if (arrange_vars[[var]]) {
      expr <- rlang::expr(dplyr::desc(!!expr))
    }
    expr
  })

  dplyr::arrange(data, !!!arrange_exprs)
}

