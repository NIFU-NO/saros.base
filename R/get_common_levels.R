get_common_levels <- function(data, col_pos=NULL) {
  # if(length(col_pos)==1 && any(col_pos == "open_comments") && is.factor(data$open_comments)) browser()
  if(any(is.na(col_pos))) cli::cli_abort("{.arg col_pos} cannot be NA.")
  data_out <- if(!inherits(data, "survey.design")) data[, col_pos, drop=FALSE] else data$variables[, col_pos, drop=FALSE]
  if(lapply(data_out, function(x) inherits(x, "factor")) |>
     unlist() |>
     all()) {
    fct_unions <- forcats::fct_unify(fs = data_out)[[1]]
    return(levels(fct_unions))
  }
  if(length(get_common_data_type(data_out)>1) && length(col_pos)>1) {
    # browser()
    cli::cli_abort(c(x="{.arg data} contains columns without a common data type.",
                     i="Problem with: {.val {colnames(data_out)}};",
                     i="which have the types {.val {get_common_data_type(data_out)}}."))
  }

  data_out <-
    data_out |>
    lapply(function(x) unique(x)) |>
    unlist() |>
    unname() |>
    unique()
  return(data_out)
}


get_common_data_type <- function(data, col_pos=NULL) {
  x <- unique(unlist(lapply(data[, col_pos, drop=FALSE], function(x) class(x)[1])))
  if(length(x)==1) return(x)
  if(all(x %in% c("ordered", "factor"))) return("factor")
  x
}
