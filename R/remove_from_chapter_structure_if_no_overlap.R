remove_from_chapter_structure_if_no_overlap <- function(chapter_structure, data) {
    if (is.null(chapter_structure) ||
        is.null(chapter_structure$.variable_name_dep) ||
        is.null(chapter_structure$.variable_name_indep)
    ) {
        return(chapter_structure)
    }
    # Only process rows that have both dep and indep variables
    rows_with_both <-
        !is.na(chapter_structure$.variable_name_dep) &
            !is.na(chapter_structure$.variable_name_indep)

    if (!any(rows_with_both)) {
        return(chapter_structure)
    }

    # Get the combinations to check
    deps <- chapter_structure$.variable_name_dep[rows_with_both]
    indeps <- chapter_structure$.variable_name_indep[rows_with_both]

    # Check each combination
    to_keep <- logical(sum(rows_with_both))
    for (i in seq_along(deps)) {
        dep_vals <- data[[deps[i]]]
        indep_vals <- data[[indeps[i]]]
        to_keep[i] <- any(!is.na(dep_vals) & !is.na(indep_vals))
    }

    # Create logical vector for all rows
    all_rows_keep <- rep(TRUE, nrow(chapter_structure))
    all_rows_keep[rows_with_both] <- to_keep

    # Filter the chapter_structure, ensuring we maintain data.frame/tibble properties
    chapter_structure[all_rows_keep, , drop = FALSE]
}
