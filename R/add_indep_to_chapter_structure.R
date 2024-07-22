add_indep_to_chapter_structure <- function(chapter_structure) {

  if(!is.null(chapter_structure$.variable_role)) {

    indep_df <- chapter_structure
    indep_df <- dplyr::bind_rows(indep_df, data.frame(.variable_name = NA_character_)) # Must add NA-row to allow univariates.
    indep_df <- dplyr::ungroup(indep_df)
    indep_df <- vctrs::vec_slice(indep_df,
                                 !is.na(indep_df[[".variable_role"]]) &
                                   indep_df[[".variable_role"]] == "indep")
    colnames(indep_df) <- stringi::stri_replace_all_regex(colnames(indep_df), pattern="^(.variable_.+)$", replacement = "$1_indep")

    dep_df <- chapter_structure
    dep_df <- vctrs::vec_slice(dep_df,
                               !is.na(dep_df[[".variable_role"]]) &
                                 dep_df[[".variable_role"]] == "dep")
    colnames(dep_df) <- stringi::stri_replace_all_regex(colnames(dep_df), pattern="^(.variable_.+)$", replacement = "$1_dep")

    na_df <- vctrs::vec_slice(chapter_structure, is.na(chapter_structure[[".variable_role"]]))
    colnames(na_df) <- stringi::stri_replace_all_regex(colnames(na_df), pattern="^(.variable_.+)$", replacement = "$1_dep")

    join_variables <- stringi::stri_subset_regex(names(dep_df),
                                                 pattern = "^\\.variable_.+",
                                                 negate = TRUE)
    if(length(join_variables)>0) {
      bi_out <- dplyr::full_join(x = dep_df,
                                 y = indep_df,
                                 by = join_variables,
                                 relationship = "many-to-many")
    } else {
      bi_out <- dplyr::cross_join(x = dep_df, y = indep_df)
    }


    dplyr::bind_rows(na_df, dep_df, bi_out)

  } else {
    cli::cli_warn("No column {.var .variable_role} found, no bivariates possible.")
    chapter_structure
  }
}
