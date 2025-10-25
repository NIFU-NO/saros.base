arrange_expr_producer <- function(
    data,
    arrange_vars = NULL,
    na_first = TRUE) {
  if (!is.data.frame(data)) cli::cli_abort("{.arg data} must be a data.frame.")
  if (isFALSE(is.character(arrange_vars) || (is.logical(arrange_vars) && rlang::is_named(arrange_vars)))) {
    cli::cli_abort("{.arg arrange_vars} must be a character vector or a named logical vector.")
  }
  if (is.null(arrange_vars)) {
    return(list(data = data, arrange_vars = list(NULL)))
  }
  if (is.character(arrange_vars)) {
    arrange_vars <- stats::setNames(rep(FALSE, times = length(arrange_vars)), nm = arrange_vars)
  }
  
  # Check that arrange_vars exist in data
  check_arrange_vars <- names(arrange_vars)[!names(arrange_vars) %in% colnames(data)]
  if (length(check_arrange_vars) > 0) {
    cli::cli_abort("{.arg arrange_vars} not found in {.arg data}: {.var {check_arrange_vars}}.")
  }


  arrange_exprs <- lapply(names(arrange_vars), function(var) {
    if (is.factor(data[[var]]) && isTRUE(na_first)) {
      expr <- rlang::expr(forcats::fct_relevel(forcats::fct_na_value_to_level(.data[[var]]), NA))
    }
    if (is.factor(data[[var]]) && isFALSE(na_first)) {
      expr <- rlang::expr(as.integer(.data[[var]]))
    }
    if (is.character(data[[var]]) && isTRUE(na_first)) {
      expr <- rlang::expr(forcats::fct_relevel(forcats::fct_na_value_to_level(factor(.data[[var]], levels = unique(.data[[var]]))), NA))
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
    if (arrange_vars[[var]]) {
      expr <- rlang::expr(dplyr::desc(!!expr))
    }
    expr
  })

  stats::setNames(arrange_exprs, arrange_vars)
}

arrange2 <- function(
    data,
    arrange_vars = NULL,
    na_first = TRUE) {
  if (is.null(arrange_vars)) {
    return(data)
  }
  arrange_expr <-
    arrange_expr_producer(
      data = data,
      arrange_vars = arrange_vars,
      na_first = na_first
    )
  dplyr::arrange(data, !!!arrange_expr)
}

arrange_arrangers_and_groups <- function(
    chapter_structure,
    arrange_vars = NULL,
    group_by_vars = NULL,
    na_first = TRUE) {
  # Do same for arrange_vars and group_by_vars
  arrange_vars_expr <-
    arrange_expr_producer(
      data = chapter_structure,
      arrange_vars = arrange_vars,
      na_first = na_first
    )
  group_by_vars_expr <-
    arrange_expr_producer(
      data = chapter_structure,
      arrange_vars = group_by_vars,
      na_first = na_first
    )

  combined <- c(arrange_vars_expr)
  combined <- combined[!duplicated(names(combined))]

  data_sorted <- dplyr::arrange(chapter_structure, !!!combined)
  data_sorted <- dplyr::mutate(data_sorted, dplyr::across(
    tidyselect::all_of(names(group_by_vars)),
    ~ factor(.x, levels = unique(.x), exclude = character())
  ))

  group_by_vars <- if (is.character(group_by_vars)) {
    group_by_vars
  } else if (is.logical(group_by_vars) && rlang::is_named(group_by_vars)) {
    names(group_by_vars)
  } else {
    character()
  }
  data_sorted <- dplyr::grouped_df(data_sorted, vars = group_by_vars)
  data_sorted
}
