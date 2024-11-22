log_unused_variables <- function(data,
                                 chapter_structure,
                                 auxiliary_variables = NULL,
                                 log_file = NULL) {
  used_vars <-
    unique(c(
      as.character(chapter_structure$.variable_name_dep),
      as.character(chapter_structure$.variable_name_indep),
      auxiliary_variables
    ))
  not_used_vars <- colnames(data)[!colnames(data) %in% used_vars]
  if (length(not_used_vars) > 0) {
    cli::cli_inform("Not using the following variables in {.arg data}: {.var {cli::ansi_collapse(not_used_vars, trunc = 100)}}.")
    if (is_string(log_file)) {
      cat("\nNot using the following variables:\n", file = log_file, append = TRUE)
      cat(not_used_vars, sep = "; ", file = log_file, append = TRUE)
    }
  }
}
