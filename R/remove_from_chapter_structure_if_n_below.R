remove_from_chapter_structure_if_n_below <-
  function(chapter_structure,
           n_variable_name = ".n",
           hide_chunk_if_n_below = 10) {

    if(is.null(chapter_structure[[n_variable_name]])) {
      cli::cli_abort("{.arg n_variable_name} does not exist in {.arg chapter_structure}: {.arg {n_variable_name}}.")
    }
    check_integerish(hide_chunk_if_n_below)
    vctrs::vec_slice(chapter_structure,
                     is.na(as.character(chapter_structure[[".variable_name_dep"]])) | # Introduction chapter or ..
                     (!is.na(chapter_structure[[n_variable_name]]) &
                     chapter_structure[[n_variable_name]] >= hide_chunk_if_n_below)) |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(dplyr::group_vars(chapter_structure))))
  }
