add_group_id_to_chapter_structure <-
  function(chapter_structure,
           grouping_vars = NULL) {

    if(length(grouping_vars)>0) {
      chapter_structure |>
        dplyr::mutate(.variable_group_id = dplyr::cur_group_id(),
                      .by = tidyselect::all_of(grouping_vars))
    } else chapter_structure

  }
