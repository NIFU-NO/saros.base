remove_from_chapter_structure_if_all_na <-
  function(chapter_structure,
           data,
           hide_variable_if_all_na = TRUE) {
    if(isTRUE(hide_variable_if_all_na)) {
      na_vars <- c()

      for(var in unique(chapter_structure$.variable_name)) {
        if(!is.na(var) && all(is.na(data[[var]]))) {
          na_vars <- c(na_vars, var)
        }
      }

      chapter_structure <- chapter_structure[!chapter_structure$.variable_name %in% na_vars, ]
    }
    chapter_structure
  }
