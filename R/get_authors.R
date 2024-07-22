unique_authors <- function(vec) {
  vec |>
    as.character() |>
    stringi::stri_split_regex(pattern = ";[[:space:]]*", omit_empty = TRUE) |>
    unlist() |>
    stringi::stri_remove_na() |>
    unique()
}


get_authors <- function(data, col = "author") {
  if(!is.null(data[[col]]) &&
     !all(is.na(data[[col]]))) {

    if(is.factor(data[[col]]) || is.character(data[[col]])) {

      return(unique_authors(data[[col]]))

    } else cli::cli_abort("{.arg {col}} must be factor or character, not {.obj_type_friendly {data[[col]]}}.")
  } else ''
}

