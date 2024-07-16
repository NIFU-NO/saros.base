
split_chapter_structure_groups_if_single_y_bivariates <-
  function(chapter_structure,
           data,
           single_y_bivariates_if_indep_cats_above = NA,
           single_y_bivariates_if_deps_above = NA,
           variable_group_dep = ".variable_group_dep",
           organize_by = NULL) {

    if(!is.na(single_y_bivariates_if_indep_cats_above)) {
      chapter_structure <-
        dplyr::mutate(chapter_structure,
                      .single_y_bivariate =
                        unlist(lapply(.data$.variable_name_indep,
                                      function(col) {
                                        !is.na(col) && dplyr::n_distinct(data[[col]], na.rm = TRUE) > .env$single_y_bivariates_if_indep_cats_above
                                      })) |
                        (!is.na(.data$.variable_name_indep) & dplyr::n() > .env$single_y_bivariates_if_deps_above),
                      .by = tidyselect::all_of(organize_by))

      chapter_structure <-
        tidyr::unite(chapter_structure,
                     col = !!variable_group_dep,
                     tidyselect::all_of(c(".variable_name_dep", ".variable_name_indep")),
                     sep = "___", remove = FALSE, na.rm = TRUE)

      chapter_structure[[variable_group_dep]] <-
        ifelse(chapter_structure$.single_y_bivariate,
               as.character(chapter_structure[[variable_group_dep]]),
               as.character(chapter_structure[[".variable_label_prefix_dep"]]))

      # browser()
      chapter_structure[[variable_group_dep]] <-
        factor(chapter_structure[[variable_group_dep]],
               levels = unique(chapter_structure[[variable_group_dep]]))
      chapter_structure[[variable_group_dep]] <-
        as.integer(chapter_structure[[variable_group_dep]])
      chapter_structure$.single_y_bivariate <- NULL

      organize_by <- c(organize_by, variable_group_dep)

    }
    chapter_structure

  }
