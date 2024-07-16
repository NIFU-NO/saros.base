log_unused_variables <- function(data,
                                 chapter_structure,
                                 auxiliary_variables = NULL,
                                 mesos_var = NULL,
                                 log_file = NULL) {
  used_vars <-
    unique(c(as.character(chapter_structure$.variable_name_dep),
             as.character(chapter_structure$.variable_name_indep),
             auxiliary_variables,
             mesos_var))
  not_used_vars <- colnames(data)[!colnames(data) %in% used_vars]
  if(length(not_used_vars)>0) {
    cli::cli_inform("Not using the following variables in {.arg data}: {.var {not_used_vars}}.")
    if(is_string(log_file)) {
      cat("\nVariables in dataset but not used:\n", file = log_file, append = TRUE)
      cat(not_used_vars, sep = "; ", file = log_file, append = TRUE)
    }
  }
}
