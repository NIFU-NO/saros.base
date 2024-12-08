add_max_chars_labels_to_chapter_structure <-
  function(chapter_structure,
           target_variable = ".variable_label_suffix_dep",
           variable_name_max_label_char = ".max_chars_labels_dep") {
    if (is.null(chapter_structure[[target_variable]])) {
      cli::cli_abort("{.arg target_variable} ({.var {target_variable}}) not found in {.arg chapter_structure}.")
    }

    chapter_structure |>
      dplyr::mutate("{variable_name_max_label_char}" := max(c(nchar(.data[[target_variable]]), 0), na.rm = TRUE))
  }
