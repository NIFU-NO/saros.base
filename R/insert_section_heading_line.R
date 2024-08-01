insert_section_heading_line <- function(grouped_data,
                                        level,
                                        chapter_structure,
                                        value,
                                        ignore_heading_for_group = NULL,
                                        replace_heading_for_group = NULL,
                                        prefix_heading_for_group = NULL,
                                        suffix_heading_for_group = NULL) {

  current_group <- names(grouped_data)[level]


  if(current_group %in% ignore_heading_for_group) return(character())

  if (is.character(replace_heading_for_group) && current_group %in% unname(replace_heading_for_group)) {
    renamed_group <- names(replace_heading_for_group)[replace_heading_for_group == current_group]
  } else renamed_group <- current_group

  heading <-
    unique(chapter_structure[chapter_structure[[current_group]] %in% value, renamed_group][[1]])

  prefix <- if(current_group %in% names(prefix_heading_for_group)) {
    prefix_heading_for_group[current_group]
  } else {
    ""
  }
  suffix <- if(current_group %in% names(suffix_heading_for_group)) {
    suffix_heading_for_group[current_group]
  } else {
    ""
  }

  heading_line <-
    stringi::stri_c(prefix, "\n",
                    strrep("#", level),
                    " ",
                    heading,
                    "{#sec-", filename_sanitizer(value, sep = "-"), "-",
                        stringi::stri_c(sample(0:9, size = 2, replace = TRUE), collapse = ""), "}\n",
                    suffix,
                    ignore_null = TRUE) |>
    stringi::stri_remove_empty_na()
}
