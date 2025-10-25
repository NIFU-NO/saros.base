remove_from_chapter_structure_if_all_na <-
  function(chapter_structure,
           data,
           hide_variable_if_all_na = TRUE,
           log_file = NULL) {
    if (isTRUE(hide_variable_if_all_na)) {
      na_vars <- c()

      for (var in unique(chapter_structure$.variable_name)) {
        if (!is.na(var) && all(is.na(data[[var]]))) {
          na_vars <- c(na_vars, var)
        }
      }

      if (length(na_vars) > 0) {
        cli::cli_inform("Hiding {length(na_vars)} variable{?s} containing all NA: {.var {cli::ansi_collapse(na_vars, trunc = 100)}}.")
        if (is_string(log_file)) {
          cat("\nHiding variables containing all NA:\n", file = log_file, append = TRUE)
          cat(na_vars, sep = "; ", file = log_file, append = TRUE)
          cat("\n", file = log_file, append = TRUE)
        }
      }

      chapter_structure <- chapter_structure[!chapter_structure$.variable_name %in% na_vars, ]
    }
    chapter_structure
  }
