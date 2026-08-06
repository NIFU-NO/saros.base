###  Check that all pairs of cols share at least one observed response category
check_category_pairs <-
  function(data, cols_pos, call = rlang::caller_env(), return_error = TRUE) {
    lapply(X = seq_along(cols_pos), FUN = function(i) {
      x <- unname(cols_pos)[[i]]
      y <- names(cols_pos)[[i]]

      cols_rest <-
        cols_pos[-c(1:match(y, names(cols_pos)))]
      lapply(X = seq_along(cols_rest), FUN = function(e) {
        x2 <- unname(cols_rest)[[e]]
        y2 <- names(cols_rest)[[e]]

        val_y <- if (is.factor(data[[y]])) levels(data[[y]]) else unique(data[[y]])
        val_y2 <- if (is.factor(data[[y2]])) levels(data[[y2]]) else unique(data[[y2]])
        common <- dplyr::intersect(val_y, val_y2)
        if (length(common) == 0L) {
          cli::cli_abort(
            c("Unequal variables.",
              "!" = "All variables must share at least one common category.",
              "i" = "Column {.var {y}} and column {.var {y2}} lack common categories."
            ),
            call = call
          )
        }
      })
    })
    TRUE
  }


# Check that the dependent variables making up each section share at least one
# response category. A section is one group of the chapter_structure, i.e. the
# set of variables that end up in a single figure or table.
#
# Only factor columns are compared. "Common categories" is meaningful for the
# categorical variables sharing a bar plot, which is what the check is for;
# check_category_pairs() falls back to unique() for anything else, so including
# numeric or free-text variables would abort on values that merely happen not to
# coincide.
check_common_categories_in_sections <-
  function(chapter_structure, data, call = rlang::caller_env()) {
    if (!inherits(chapter_structure, "data.frame") ||
      !inherits(data, "data.frame") ||
      is.null(chapter_structure[[".variable_name_dep"]])) {
      return(invisible(TRUE))
    }

    grouping_structure <- dplyr::group_vars(chapter_structure)
    if (length(grouping_structure) == 0) {
      return(invisible(TRUE))
    }

    sections <-
      dplyr::group_split(dplyr::grouped_df(chapter_structure, vars = grouping_structure))

    for (section in sections) {
      deps <- unique(stringi::stri_remove_empty_na(as.character(section[[".variable_name_dep"]])))
      deps <- deps[deps %in% colnames(data)]
      deps <- deps[vapply(deps, function(col) is.factor(data[[col]]), logical(1))]

      if (length(deps) > 1) {
        check_category_pairs(
          data = data,
          cols_pos = stats::setNames(seq_along(deps), deps),
          call = call
        )
      }
    }

    invisible(TRUE)
  }

trim_columns <- function(data, cols = c(
                           ".variable_label_prefix_dep", ".variable_label_suffix_dep",
                           ".variable_label_prefix_indep", ".variable_label_suffix_indep"
                         )) {
  for (col in cols) {
    if (is.character(data[[col]])) {
      data[[col]] <- stringi::stri_trim_both(data[[col]])
      data[[col]] <- stringi::stri_replace_all_regex(data[[col]], pattern = "[[:space:]]+", replacement = " ")
    }
  }
  data
}
