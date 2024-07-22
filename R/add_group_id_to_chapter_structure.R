#' @importFrom rlang :=
add_group_id_to_chapter_structure <-
  function(chapter_structure,
           grouping_vars = NULL,
           variable_group_id = ".variable_group_id",
           variable_group_prefix = NULL) {

    if(length(grouping_vars)>0) {
      if(is.null(variable_group_prefix)) {
          chapter_structure |>
          dplyr::mutate("{(variable_group_id)}" := dplyr::cur_group_id(),
                      .by = tidyselect::all_of(grouping_vars))
      } else {
          chapter_structure |>
          dplyr::mutate("{(variable_group_id)}" := paste0(variable_group_prefix, dplyr::cur_group_id()),
                        .by = tidyselect::all_of(grouping_vars))

      }
    } else chapter_structure

  }
