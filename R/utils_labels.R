#' Helper function to extract raw variable labels from the data
#'
#' @param data Dataset
#' @param col_pos Optional, character vector of column names or integer vector of positions
#' @param return_as_list Flag, whether to return as list or character vector
#'
#' @return List or character vector
#'
get_raw_labels <-
  function(data, col_pos = NULL, return_as_list = FALSE) {
    if(is.null(col_pos)) col_pos <- colnames(data)
    out <- lapply(X = stats::setNames(col_pos, nm=col_pos),
                  FUN = function(.x) {
                    y <- attr(data[[.x]], "label")
                    if(is_string(y)) y else NA_character_
                  })
    if(isFALSE(return_as_list)) out <- unlist(out)
    out
  }


set_var_labels <- function(data, cols=colnames(data), overwrite=TRUE) {
  cols_enq <- rlang::enquo(arg = cols)
  cols_pos <- tidyselect::eval_select(expr = cols_enq, data = data)
  col_names <- colnames(data)
  data <-
    lapply(colnames(data), FUN = function(.x) {
      if(
        .x %in% cols &&
        (overwrite || is.null(attr(data[[.x]], "label")))
      ) {
        attr(data[[.x]], "label") <- cols[.x]
      }
      data[[.x]]
    })
  names(data) <- cols
  vctrs::new_data_frame(vctrs::df_list(data))
}

