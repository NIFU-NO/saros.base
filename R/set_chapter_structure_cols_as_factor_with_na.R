
set_chapter_structure_cols_as_factor_with_na <-
  function(chapter_structure,
           data,
           chunk_template_names) {

    chapter_structure$chapter <- factor(chapter_structure$chapter,
                                        levels = as.character(unique(chapter_structure$chapter)))
    if(!is.null(chapter_structure$.template_name)) {
      has_na <- any(is.na(chapter_structure$.template_name))
      chapter_structure$.template_name <- forcats::fct(x = chapter_structure$.template_name, levels = chunk_template_names)
      if(has_na) {
        chapter_structure$.template_name <- forcats::fct_na_value_to_level(chapter_structure$.template_name)
        chapter_structure$.template_name <- forcats::fct_relevel(chapter_structure$.template_name, NA)
      }
    }

    if(!is.null(chapter_structure$.variable_name_dep)) {
      has_na <- any(is.na(chapter_structure$.variable_name_dep))
      all_na <- all(is.na(chapter_structure$.variable_name_dep))
      if(!all_na) {
        chapter_structure$.variable_name_dep <- forcats::fct(x = chapter_structure$.variable_name_dep,
                                                             levels = colnames(data)[colnames(data) %in% chapter_structure$.variable_name_dep])
        if(has_na) {
          chapter_structure$.variable_name_dep <- forcats::fct_na_value_to_level(chapter_structure$.variable_name_dep)
          chapter_structure$.variable_name_dep <- forcats::fct_relevel(chapter_structure$.variable_name_dep, NA)
        }
      }
    }
    if(!is.null(chapter_structure$.variable_name_indep)) {
      has_na <- any(is.na(chapter_structure$.variable_name_dep))
      all_na <- all(is.na(chapter_structure$.variable_name_dep))
      if(!all_na) {
        chapter_structure$.variable_name_indep <- forcats::fct(x = chapter_structure$.variable_name_indep,
                                                               levels = colnames(data)[colnames(data) %in% chapter_structure$.variable_name_indep])
        if(has_na) {
          chapter_structure$.variable_name_indep <- forcats::fct_na_value_to_level(chapter_structure$.variable_name_indep)
          chapter_structure$.variable_name_indep <- forcats::fct_relevel(chapter_structure$.variable_name_indep, NA)
        }
      }
    }
    chapter_structure
  }
