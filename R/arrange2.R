arrange2 <- function(data, arrange_vars = NULL, na_first = FALSE) {
  if(is.null(arrange_vars)) return(data)

  if(is.character(arrange_vars)) {
    arrange_vars <-
      stats::setNames(rep(FALSE, times = length(arrange_vars)),
                      nm = arrange_vars)
  }
  check_vars <- names(arrange_vars)[!names(arrange_vars) %in% colnames(data)]
  if(length(check_vars)>0) {
    cli::cli_abort("{.arg arrange_vars} not found in {.arg data}: {check_vars}.")
  }

  # forcats::fct_relevel(forcats::fct_na_value_to_level(a_1), NA)
  arrange_vars_modified <- arrange_vars

  ### Set NA first in levels if argument na_first = TRUE
  if(isTRUE(na_first)) {
    names(arrange_vars_modified) <-
      ifelse(unlist(lapply(names(arrange_vars), function(v) is.factor(data[[v]]))),
             paste0("forcats::fct_relevel(forcats::fct_na_value_to_level(", names(arrange_vars_modified), "), NA)"),
             names(arrange_vars_modified))

  }

  ### Sort on factor's integer values, not labels
  names(arrange_vars_modified) <-
    ifelse(unlist(lapply(names(arrange_vars), function(v) is.factor(data[[v]]))),
           paste0("as.integer(", names(arrange_vars_modified), ")"),
           names(arrange_vars_modified))

  ### Descending if value is TRUE
  arrange_vars_modified <-
    ifelse(unname(arrange_vars),
           paste0("dplyr::desc(", names(arrange_vars_modified), ")"),
           names(arrange_vars_modified))

  dplyr::arrange(data, !!!rlang::parse_exprs(arrange_vars_modified))

}
