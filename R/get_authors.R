
get_authors <- function(data, col) {
  if(!is.null(data[[col]]) &&
     !all(is.na(data[[col]]))) {

    if(is.factor(data[[col]])) {

      return(levels(data[[col]]))

    } else if(is.character(data[[col]])) {

      return(unique(data[[col]]))

    } else cli::cli_abort("{.arg {col}} must be factor or character, not {.obj_type_friendly {data[[col]]}}.")
  } else ''
}

