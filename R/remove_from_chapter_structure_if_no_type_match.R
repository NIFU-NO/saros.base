remove_from_chapter_structure_if_no_type_match <-
  function(chapter_structure) {


    out <-
      chapter_structure |>
      tidyr::separate_wider_delim(cols = tidyselect::starts_with(".template_variable_type_dep"),
                                  delim = ";", names_sep = "_", names_repair = "universal",
                                  too_few = "align_start",
                                  cols_remove = TRUE) |>
      tidyr::separate_wider_delim(cols = tidyselect::starts_with(".template_variable_type_indep"),
                                  delim = ";", names_sep = "_", names_repair = "universal",
                                  too_few = "align_start",
                                  cols_remove = TRUE)
    # Temporarily fixing a bug in tidyr (https://github.com/tidyverse/tidyr/issues/1499)
    colnames(out)[colnames(out) %in% ".template_variable_type_dep_.template_variable_type_dep"] <- ".template_variable_type_dep"
    colnames(out)[colnames(out) %in% ".template_variable_type_indep_.template_variable_type_indep"] <- ".template_variable_type_indep"
    out <-
      out |>
      dplyr::rowwise() |>
      dplyr::mutate(.keep_row =
                      (is.na(.data$.variable_type_dep) & is.na(.data$.variable_type_dep)) |
                      (.data$.variable_type_dep %in%
                      dplyr::c_across(tidyselect::starts_with(".template_variable_type_dep")) &
                      .data$.variable_type_indep %in%
                      dplyr::c_across(tidyselect::starts_with(".template_variable_type_indep")))) |>
      dplyr::ungroup()
    out <- vctrs::vec_slice(out, out$.keep_row)
    out$.keep_row <- NULL
    out <- dplyr::group_by(out, dplyr::pick(tidyselect::all_of(dplyr::group_vars(chapter_structure))))
    out
  }
