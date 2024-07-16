


keep_subitem <- function(fct, label_separator = NULL,
                         call = rlang::caller_env()) {
  lvls <- unique(as.character(fct)) # The items (including main question)
  lbls <-
    if(!is.null(label_separator)) {
      stringi::stri_replace(str = lvls,
                            regex = stringi::stri_c(ignore_null=TRUE, "^(.*)", label_separator, "(.*)$"), # Assumes that the main question always comes first, and subitem always last
                            replacement = "$2")
    } else lvls

  factor(x = fct,
         levels = lvls,
         labels = lbls,
         ordered = TRUE)
}

# Helper function to extract main question from the data
get_main_question2 <-
  function(x, label_separator, warn_multiple = TRUE, call=rlang::caller_env()) {
    x <- x[!is.na(x)]
    if(length(x)==0) return("")
    if(!(is.character(x) | is.factor(x) | is.ordered(x))) {
      cli::cli_abort(c(x="{.arg x} must be of type {.cls character} or {.cls factor}.",
                       i="not {.obj_type_friendly {x}}."),
                     call = call)
    }

    x <-
      stringi::stri_replace(str = x,
                           regex = stringi::stri_c(ignore_null=TRUE, "(^.*)", label_separator, "(.*$)"),
                           replacement = "$1") |>
      unique()
    x <- if(length(x)>0) stringi::stri_c(ignore_null=TRUE, x, collapse="\n")
    if(length(x) > 1L && warn_multiple) {
      cli::cli_warn(c(x="There are multiple main questions for these variables.",
                      i="Check your data."), call = call)
    } else if(length(x) == 0L) {
      cli::cli_warn(c(x="No main question found.",
                       i="Check your {.arg label_separator}."), call = call)
    }
    x
  }



# Helper function to extract raw variable labels from the data
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

