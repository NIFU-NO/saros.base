
validate_labels <- function(data) {
  miss_label_vars <- vctrs::vec_slice(data,
                                      is.na(data[[".variable_label_prefix"]]) &
                                        !is.na(data[[".variable_position"]]))
  if(nrow(miss_label_vars) > 0) {
    cli::cli_warn("Using variable name in place of missing label for {.var {unique(miss_label_vars$.variable_name)}}.")
  }
  # if(data$.variable_label)
  data$.variable_label_prefix <- dplyr::if_else(is.na(data$.variable_label_prefix) & !is.na(data$.variable_position), data$.variable_name, data$.variable_label_prefix)
  data$.variable_label_suffix <- dplyr::if_else(is.na(data$.variable_label_suffix) & !is.na(data$.variable_position), data$.variable_name, data$.variable_label_suffix)
  data
}
