remove_from_chapter_structure_if_n_below <-
  function(chapter_structure,
           n_variable_name = ".n",
           hide_chunk_if_n_below = 10,
           log_file = NULL) {
    if (is.null(chapter_structure[[n_variable_name]])) {
      cli::cli_abort("{.arg n_variable_name} does not exist in {.arg chapter_structure}: {.arg {n_variable_name}}.")
    }

    # Identify which rows will be kept
    keep_rows <- is.na(as.character(chapter_structure[[".variable_name_dep"]])) | # Introduction chapter or ..
      (!is.na(chapter_structure[[n_variable_name]]) &
        chapter_structure[[n_variable_name]] >= hide_chunk_if_n_below)

    # Log removed entries
    removed_entries <- chapter_structure[!keep_rows, ]
    if (nrow(removed_entries) > 0) {
      removed_vars <- paste0(
        removed_entries$.variable_name_dep,
        " (n=",
        removed_entries[[n_variable_name]],
        ")"
      )
      cli::cli_inform("Hiding {nrow(removed_entries)} entr{?y/ies} with n < {hide_chunk_if_n_below}: {.var {cli::ansi_collapse(removed_vars, trunc = 100)}}.")
      if (is_string(log_file)) {
        cat("\nHiding entries with n < ", hide_chunk_if_n_below, ":\n", file = log_file, append = TRUE, sep = "")
        cat(removed_vars, sep = "; ", file = log_file, append = TRUE)
        cat("\n", file = log_file, append = TRUE)
      }
    }

    vctrs::vec_slice(chapter_structure, keep_rows) |>
      dplyr::grouped_df(vars = dplyr::group_vars(chapter_structure))
  }
