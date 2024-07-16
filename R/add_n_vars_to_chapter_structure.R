add_n_vars_to_chapter_structure <-
  function(chapter_structure,
           target_variable = ".variable_name_dep",
           variable_name = ".n_dep") {


    grouping_structure <- dplyr::group_vars(chapter_structure)

    chapter_structure |>
    dplyr::group_map(.keep = TRUE,
        .f = ~{
          uniques <- as.character(unique(.x[[target_variable]]))
          .x[[variable_name]] <-
            length(uniques[!is.na(uniques)])
          .x
        }) |>
      dplyr::bind_rows() |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(grouping_structure)))

  }
