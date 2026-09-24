split_chapter_structure_groups_if_single_y_bivariates <-
  function(chapter_structure,
           data,
           single_y_bivariates_if_indep_cats_above = NA_integer_,
           single_y_bivariates_if_deps_above = NA_integer_,
           variable_group_dep = ".variable_group_dep",
           organize_by = NULL) {
    if (!is.na(single_y_bivariates_if_indep_cats_above)) {
      chapter_structure <-
        dplyr::mutate(chapter_structure,
          .single_y_bivariate =
            unlist(lapply(
              .data$.variable_name_indep,
              function(col) {
                !is.na(as.character(col)) && dplyr::n_distinct(data[[col]], na.rm = TRUE) > .env$single_y_bivariates_if_indep_cats_above
              }
            )) |
              (!is.na(as.character(.data$.variable_name_indep)) & dplyr::n() > .env$single_y_bivariates_if_deps_above),
          .by = tidyselect::all_of(organize_by)
        )

      chapter_structure <-
        tidyr::unite(chapter_structure,
          col = !!variable_group_dep,
          tidyselect::all_of(c(".variable_name_dep", ".variable_name_indep")),
          sep = "___", remove = FALSE, na.rm = TRUE
        )

      # Rows that are not split share one value, so appending
      # `variable_group_dep` to `organize_by` separates the split rows and
      # nothing else, whatever `organize_by` the caller chose. `%in% TRUE`:
      # `single_y_bivariates_if_deps_above = NA` makes the condition NA.
      chapter_structure[[variable_group_dep]] <-
        ifelse(chapter_structure$.single_y_bivariate %in% TRUE,
          as.character(chapter_structure[[variable_group_dep]]),
          ""
        )


      chapter_structure[[variable_group_dep]] <-
        factor(chapter_structure[[variable_group_dep]],
          levels = unique(chapter_structure[[variable_group_dep]],
            exclude = character()
          )
        )
      chapter_structure[[variable_group_dep]] <-
        as.integer(chapter_structure[[variable_group_dep]])
      chapter_structure$.single_y_bivariate <- NULL

      organize_by <- c(organize_by, variable_group_dep)
    }
    list(chapter_structure = chapter_structure, organize_by = organize_by)
  }
