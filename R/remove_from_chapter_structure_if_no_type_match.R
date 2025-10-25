remove_from_chapter_structure_if_no_type_match <-
  function(chapter_structure, log_file = NULL) {
    out <-
      chapter_structure |>
      tidyr::separate_wider_delim(
        cols = tidyselect::starts_with(".template_variable_type_dep"),
        delim = ";", names_sep = "_", names_repair = "universal",
        too_few = "align_start",
        cols_remove = TRUE
      ) |>
      tidyr::separate_wider_delim(
        cols = tidyselect::starts_with(".template_variable_type_indep"),
        delim = ";", names_sep = "_", names_repair = "universal",
        too_few = "align_start",
        cols_remove = TRUE
      )
    # Temporarily fixing a bug in tidyr (https://github.com/tidyverse/tidyr/issues/1499)
    colnames(out)[colnames(out) %in% ".template_variable_type_dep_.template_variable_type_dep"] <- ".template_variable_type_dep"
    colnames(out)[colnames(out) %in% ".template_variable_type_indep_.template_variable_type_indep"] <- ".template_variable_type_indep"
    out <-
      out |>
      dplyr::rowwise() |>
      dplyr::mutate(
        .keep_row =
          (is.na(.data$.variable_type_dep) & is.na(.data$.variable_type_dep)) |
            (.data$.variable_type_dep %in%
              dplyr::c_across(tidyselect::starts_with(".template_variable_type_dep")) &
              .data$.variable_type_indep %in%
                dplyr::c_across(tidyselect::starts_with(".template_variable_type_indep")))
      ) |>
      dplyr::ungroup()

    # Log removed entries
    removed_entries <- out[!out$.keep_row, ]
    if (nrow(removed_entries) > 0 &&
      ".variable_name_dep" %in% colnames(removed_entries) &&
      ".variable_type_dep" %in% colnames(removed_entries)) {
      removed_vars_dep <- unique(paste0(
        removed_entries$.variable_name_dep,
        " (",
        removed_entries$.variable_type_dep,
        ")"
      ))

      all_removed <- removed_vars_dep

      if (".variable_name_indep" %in% colnames(removed_entries) &&
        ".variable_type_indep" %in% colnames(removed_entries)) {
        removed_vars_indep <- unique(paste0(
          removed_entries$.variable_name_indep,
          " (",
          removed_entries$.variable_type_indep,
          ")"
        ))
        removed_vars_indep <- removed_vars_indep[removed_vars_indep != "NA (NA)"]

        if (length(removed_vars_indep) > 0) {
          all_removed <- c(removed_vars_dep, removed_vars_indep)
        }
      }

      cli::cli_inform("Hiding {nrow(removed_entries)} entr{?y/ies} due to no type match: {.var {cli::ansi_collapse(all_removed, trunc = 100)}}.")
      if (is_string(log_file)) {
        cat("\nHiding entries due to no type match:\n", file = log_file, append = TRUE)
        cat(all_removed, sep = "; ", file = log_file, append = TRUE)
        cat("\n", file = log_file, append = TRUE)
      }
    }

    out <- vctrs::vec_slice(out, out$.keep_row)
    out$.keep_row <- NULL
    out <- dplyr::grouped_df(out, vars = dplyr::group_vars(chapter_structure))
    out
  }
