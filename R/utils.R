


###  Check that all pairs of cols share at least one observed response category
check_category_pairs <-
  function(data, cols_pos, call = rlang::caller_env(), return_error=TRUE) {
    lapply(X = seq_along(cols_pos), FUN = function(i) {
      x <- unname(cols_pos)[[i]]
      y <- names(cols_pos)[[i]]

      cols_rest <-
        cols_pos[-c(1:match(y, names(cols_pos)))]
      lapply(X = seq_along(cols_rest), FUN = function(e) {
        x2 <- unname(cols_rest)[[e]]
        y2 <- names(cols_rest)[[e]]

                     val_y <- if(is.factor(data[[y]])) levels(data[[y]]) else unique(data[[y]])
                     val_y2 <- if(is.factor(data[[y2]])) levels(data[[y2]]) else unique(data[[y2]])
                     common <- dplyr::intersect(val_y, val_y2)
                     if(length(common) == 0L) {
                       cli::cli_abort(
                         c("Unequal variables.",
                           "!" = "All variables must share at least one common category.",
                           "i" = "Column {.var {y}} and column {.var {y2}} lack common categories."
                         ),
                         call = call)
                     }
                   })
    })
    TRUE
  }

trim_columns <- function(data, cols = c(".variable_label_prefix_dep", ".variable_label_prefix_dep",
                                        ".variable_label_prefix_indep", ".variable_label_suffix_indep")) {
  for(col in cols) {
    if(is.character(data[[col]])) {
      data[[col]] <- stringi::stri_trim_both(data[[col]])
      data[[col]] <- stringi::stri_replace_all_regex(data[[col]], pattern = "[[:space:]]+", replacement = " ")
    }
  }
  data
}

# get_main_question <-
#   function(data, cols_pos, label_separator) {
#   x <- unlist(lapply(data[, cols_pos], FUN = function(.x) attr(.x, "label")))
#   x <- unname(x)
#   x <-
#     stringi::stri_replace(string = x,
#                          regex = stringi::stri_c(ignore_null=TRUE, "(^.*)", label_separator, "(.*$)"),
#                          replacement = "$1")
#   x <- unique(x)
#   x <-
#     stringi::stri_c(ignore_null=TRUE, x, collapse="\n")
#   x
# }


create_text_collapse <-
  function(text = NULL,
           last_sep = NULL) {
    if(!is_string(last_sep)) last_sep <-
        eval(formals(draft_report)$translations)$last_sep
    cli::ansi_collapse(text, sep2 = last_sep, last = last_sep)
  }

# are all elements of list x identical to each other?
compare_many <- function(x) {
  all(unlist(lapply(as.list(x[-1]),
                    FUN = function(.x) identical(.x, x[[1]])))) ||
    nrow(x[[1]])==1
}



