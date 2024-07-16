add_obj_name_to_chapter_structure <-
  function(chapter_structure,
           variable_name = ".obj_name",
           sep = "_",
           max_width = 128,
           valid_obj = TRUE,
           make_unique = TRUE,
           to_lower = TRUE
  ) {


    grouping_structure_original <- dplyr::group_vars(chapter_structure)
    out <- replace_label_groups_with_name_groups(chapter_structure)
    grouping_structure_reduced <- dplyr::group_vars(out)
    grouping_structure_temporary <- ".variable_group_id"

    collapsed <-
      out |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(c(grouping_structure_temporary)))) |>
      dplyr::group_map(.keep = FALSE,
                       .f = ~{

                         .x[[variable_name]] <-
                           get_common_names_from_data(.x[, grouping_structure_reduced],
                                                      sep = sep,
                                                      max_width = max_width)
                         .x
                       }) |>
      dplyr::bind_rows() |>
      dplyr::distinct(dplyr::pick(tidyselect::all_of(c(grouping_structure_original, variable_name))))

    collapsed[[variable_name]] <-
      filename_sanitizer(x = collapsed[[variable_name]],
                         max_chars = max_width,
                         sep = sep,
                         valid_obj = valid_obj,
                         to_lower = to_lower,
                         make_unique = make_unique)

    dplyr::left_join(x = out,
                     y = collapsed,
                     by = grouping_structure_original) |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(grouping_structure_original)))
  }
