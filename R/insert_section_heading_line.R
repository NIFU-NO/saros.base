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



gen_heading_line <- function(group,
                             cur_section,
                             chapter_overview_section = NULL,
                             added = NULL,
                             ignore_heading_for_group = NULL,
                             replace_heading_for_group = NULL) {




  if(!any(ignore_heading_for_group == group)) {

    # Make exception to heading construction to ensure always pretty heading names
    if(is.data.frame(chapter_overview_section)) {
      for(replace_i in seq_along(replace_heading_for_group)) {
        if(unname(replace_heading_for_group)[replace_i] == group) {
          row_selection <- chapter_overview_section[[unname(replace_heading_for_group)[replace_i]]] == cur_section
          cur_section <-
            chapter_overview_section[row_selection,
                                     names(replace_heading_for_group)[replace_i]][[1]]
        }
      }
    }
    level <- match(group, dplyr::group_vars(chapter_overview_section))

    stringi::stri_c(strrep("#", times = level), " ", cur_section,
                    "{#sec-", filename_sanitizer(cur_section, sep = "-"), "-",
                    stringi::stri_c(sample(0:9, size=1, replace = TRUE), ignore_null=TRUE, collapse=""),
                    "}\n",
                    ignore_null=TRUE)
  }

}
