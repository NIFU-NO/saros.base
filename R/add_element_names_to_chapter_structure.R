
add_chunk_templates_to_chapter_structure <- function(chapter_structure, chunk_templates) {

  out <- vctrs::vec_slice(chapter_structure,
                          !is.na(chapter_structure$.variable_name_dep))
  out <- tidyr::crossing(out, chunk_templates)
  out_na <- vctrs::vec_slice(chapter_structure,
                             is.na(chapter_structure$.variable_name_dep))

  out <- dplyr::bind_rows(out_na, out)
  out
}
