check_chapter_structure_for_duplicates <- function(chapter_structure, organize_by = NULL) {
    group_by_vars <- unique(c(organize_by, ".variable_label_suffix_dep"))

    duplicates <-
        chapter_structure[, group_by_vars, drop = FALSE] |>
        dplyr::grouped_df(group_by_vars) |>
        dplyr::filter(dplyr::n() > 1) |>
        dplyr::ungroup()


    if (nrow(duplicates) > 0) {
        unique_dups <- unique(duplicates[[".variable_label_suffix_dep"]])
        cli::cli_warn(c(
            x = "Duplicate rows were found for specified {.arg organize_by}: {.val {group_by_vars}}.",
            stats::setNames(unique_dups, nm = rep("i", length(unique_dups)))
        ))
    }
}
