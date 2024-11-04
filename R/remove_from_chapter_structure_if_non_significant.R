remove_from_chapter_structure_if_non_significant <-
  function(chapter_structure,
           data,
           hide_bi_entry_if_sig_above = .05,
           always_show_bi_for_indep = c(),
           progress = TRUE,
           call = rlang::caller_env()) {
    check_data_frame(chapter_structure)
    check_data_frame(data)

    chapter_structure$.bi_test <- NA_character_
    chapter_structure$.p_value <- NA_real_

    if (is.null(hide_bi_entry_if_sig_above) ||
      is.na(hide_bi_entry_if_sig_above) ||
      hide_bi_entry_if_sig_above == 1) {
      chapter_structure
    } else {
      if (progress) cli::cli_progress_message("Removing bivariate occurences if {.arg hide_bi_entry_if_sig_above}: {.arg {hide_bi_entry_if_sig_above}}, except {.arg {always_show_bi_for_indep}}.")

      out_keep_anyway <-
        vctrs::vec_slice(chapter_structure, is.na(chapter_structure[[".variable_name_indep"]]))

      out_bivariates <-
        vctrs::vec_slice(
          chapter_structure,
          !is.na(chapter_structure[[".variable_name_dep"]]) &
            !is.na(chapter_structure[[".variable_name_indep"]]) &
            chapter_structure[[".variable_name_dep"]] !=
              chapter_structure[[".variable_name_indep"]]
        )

      if (nrow(out_bivariates) > 0) {
        out_bivariates <- dplyr::rowwise(out_bivariates)
        out_bivariates <- dplyr::group_map(out_bivariates,
          .keep = TRUE,
          .f = function(df_col_row, df_col_key) {
            df_col_row$.keep_indep <- FALSE


            if (is.null(df_col_row$.variable_name_dep) ||
              length(df_col_row$.variable_name_dep) == 0 ||
              is.na(df_col_row$.variable_name_dep)) {
              browser()
            }

            df_chitest <-
              data[
                !is.na(data[[df_col_row$.variable_name_dep]]) &
                  !is.na(data[[df_col_row$.variable_name_indep]]),
                c(df_col_row$.variable_name_dep, df_col_row$.variable_name_indep)
              ]

            if (nrow(df_chitest) < 1) {
              return()
            }


            count_uniques <- dplyr::count(df_chitest,
              .data[[df_col_row$.variable_name_dep]],
              .data[[df_col_row$.variable_name_indep]],
              name = ".n_count"
            )


            df_col_row$.keep_indep <-
              (dplyr::n_distinct(df_chitest[[df_col_row$.variable_name_dep]], na.rm = TRUE) > 1 ||
                dplyr::n_distinct(df_chitest[[df_col_row$.variable_name_indep]], na.rm = TRUE) > 1) &&
                df_col_row$.variable_type_dep != "chr" &&
                df_col_row$.variable_type_indep != "chr"

            if (df_col_row$.keep_indep) {
              stat_result <-
                find_test2(
                  y = df_chitest[[df_col_row$.variable_name_dep]],
                  x = df_chitest[[df_col_row$.variable_name_indep]]
                )
              df_col_row$.bi_test <- stat_result$.bi_test
              df_col_row$.p_value <- stat_result$.p_value
            }
            df_col_row
          }
        )
        out_bivariates <- dplyr::bind_rows(out_bivariates)
        out_bivariates$.keep_bi_rows <-
          (!is.na(out_bivariates$.p_value) &
            out_bivariates$.p_value <= hide_bi_entry_if_sig_above) |
            (out_bivariates$.variable_name_indep %in% always_show_bi_for_indep)

        # browser()
        out_bivariates <- vctrs::vec_slice(out_bivariates,
          out_bivariates$.keep_bi_rows,
          error_call = call
        )
      }
      dplyr::bind_rows(
        out_keep_anyway,
        out_bivariates
      )
    }
  }
