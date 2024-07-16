add_core_info_to_chapter_structure <-
  function(chapter_structure) {

    col_headers <- c("dep", "indep")
    delim_regex <- "[,[:space:]]+"
    attr(delim_regex, "options") <-
      list(case_insensitive = FALSE,
           comments = FALSE,
           dotall = FALSE,
           multiline = FALSE)
    class(delim_regex) <- c("stringr_regex", "stringr_pattern", "character")

    out <-
      tidyr::pivot_longer(chapter_structure,
                          cols = tidyselect::any_of(col_headers),
                          values_to = ".variable_selection")
    out <-
      vctrs::vec_slice(out,
                       !(out$name == "indep" &
                           (is.na(out$.variable_selection) |
                              out$.variable_selection == "")))
    out <-
      tidyr::separate_longer_delim(out,
                                   cols = ".variable_selection",
                                   delim = delim_regex)
    out <-
      tidyr::separate(out,
                      col = .data$name,
                      into = ".variable_role",
                      sep="_")

    out[[".variable_role"]] <-
      ifelse(is.na(out[[".variable_selection"]]) |
               out[[".variable_selection"]] == "", NA_character_, out[[".variable_role"]])

    out[[".variable_selection"]] <-
      dplyr::if_else(!stringi::stri_detect(out$.variable_selection,
                                           regex = "matches\\(") &
                       stringi::stri_detect(out$.variable_selection,
                                            regex = "\\*"),
                     true = stringi::stri_c(ignore_null=TRUE,
                                            "matches('",
                                            out$.variable_selection,
                                            "')"),
                     false = out$.variable_selection)
    out <-
      dplyr::distinct(out, .keep_all = TRUE)
    out <-
      dplyr::relocate(out, tidyselect::all_of(c(".variable_role", ".variable_selection")))
    out
  }
