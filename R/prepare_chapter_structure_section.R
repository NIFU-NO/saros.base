prepare_chapter_structure_section <- function(chapter_structure,
                                              grouping_structure) {
  # Create new metadata with bare minimum needed, and reapply grouping

  if(all(is.na(chapter_structure$chapter)) && nrow(chapter_structure)>1) {
    cli::cli_abort(c("x"="Internal error in {.fn gen_qmd_structure}",
                     "!" = "{.val chapter_structure$chapter} has NA but length of {nrow(chapter_structure)}",
                     "i"="Please create a bug report at {.url https://github.com/NIFU-NO/saros.base/issues}."))
  }

  for(i in seq_along(grouping_structure)) {
    variable <- as.character(chapter_structure[[grouping_structure[[i]]]])
    lgl_filter <-
      (!is.na(names(grouping_structure)[i]) & !is.na(variable) & variable == names(grouping_structure)[i]) |
      (is.na(names(grouping_structure)[i]) & is.na(variable))

    chapter_structure <-
      vctrs::vec_slice(chapter_structure, lgl_filter)
  }
  droplevels(chapter_structure)
}
