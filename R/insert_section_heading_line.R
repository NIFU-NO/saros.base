insert_section_heading_line <- function(
    output = NULL,
    grouped_data,
    level = 1,
    chapter_structure,
    value,
    added = NULL,
    ignore_heading_for_group = NULL,
    replace_heading_for_group = NULL) {


  # Drop heading if among ignore_heading_for_group
  if(!names(grouped_data)[level] %in% ignore_heading_for_group &&
     level < ncol(grouped_data)) {

    # Make exception to heading construction to ensure always pretty heading names
    if(names(grouped_data)[level] == ".variable_name_dep") {
      heading <- chapter_structure[chapter_structure[[".variable_name_dep"]] == value,
                                  ".variable_label_suffix_dep"][[1]]
    } else heading <- value

    heading <-
      stringi::stri_c(strrep("#", times = level), " ", heading,
                      "{#sec-", filename_sanitizer(value, sep="-"), "-",
                      stringi::stri_c(sample(0:9, size=2, replace = TRUE), ignore_null=TRUE, collapse=""),
                      "}\n",
                      ignore_null=TRUE)

    heading <- stringi::stri_remove_empty_na(heading)
    output <- stringi::stri_remove_empty_na(output)
    stringi::stri_c(output,
                      heading,
                      sep="\n",
                      ignore_null=TRUE)
  }

}
