add_parsed_vars_to_chapter_structure <-
  function(chapter_structure,
           data,
           call = rlang::caller_env()) {
    chapter_structure$.variable_selection <-
      stringi::stri_replace_all_fixed(chapter_structure$.variable_selection,
        pattern = '\"',
        replacement = "'"
      )

    chapter_structure$.cols <-
      eval_cols(
        x = chapter_structure$.variable_selection,
        data = data,
        call = call
      )

    chapter_structure <-
      tidyr::unnest_longer(chapter_structure,
        col = ".cols",
        values_to = ".variable_position",
        indices_to = ".variable_name"
      )
    chapter_structure$.variable_position <- unname(chapter_structure$.variable_position)
    chapter_structure$.variable_name <-
      ifelse(chapter_structure$.variable_name %in% c("1", ""),
        NA_character_,
        chapter_structure$.variable_name
      )

    chapter_structure
  }
