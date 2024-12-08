add_n_cats_to_chapter_structure <-
  function(chapter_structure,
           data,
           target_variable = ".variable_name_dep",
           variable_name_n_cats = ".n_cats_dep",
           variable_name_max_label_char = ".max_chars_labels_dep",
           variable_name_max_cat_char = ".max_chars_cats_dep",
           drop_na = TRUE) {
    if (is.null(chapter_structure[[target_variable]])) {
      cli::cli_abort("{.arg target_variable} ({.var {target_variable}}) not found in {.arg chapter_structure}.")
    }

    chapter_structure |>
      dplyr::group_map(
        .keep = TRUE,
        .f = ~ {
          if (all(!is.na(as.character(.x[[target_variable]])))) {
            out <-
              get_common_levels(data, col_pos = as.character(.x[[target_variable]]))
            if (isTRUE(drop_na)) out <- out[!is.na(out)]

            .x[[variable_name_n_cats]] <- length(out)
            if (is.na(length(out))) {
              .x[[variable_name_n_cats]] <- 0
            } else {
              .x[[variable_name_n_cats]] <- length(out)
            }
            if (is.na(max(nchar(out), na.rm = TRUE))) {
              .x[[variable_name_max_cat_char]] <- 0
            } else {
              .x[[variable_name_max_cat_char]] <- max(nchar(out), na.rm = TRUE)
            }
          }
          .x
        }
      ) |>
      dplyr::bind_rows() |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(dplyr::group_vars(chapter_structure))))
  }
