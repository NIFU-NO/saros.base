
validate_chapter_structure_has_not_chapter_with_all_vars <-
  function(chapter_structure, data) {

  tapplied <- unlist(lapply(split(chapter_structure, chapter_structure$chapter),
                            function(df) length(unique(df$.variable_name_dep))))
  # tapplied <- tapply(out, out$chapter, FUN = function(df) length(unique(df$.variable_name_dep)))
  if(length(unique(chapter_structure$chapter)) > 1 &&
     max(tapplied) == ncol(data)) {
    cli::cli_warn("One of your chapters contain all the variables in the dataset. Is this what you intend?")
  }

}
