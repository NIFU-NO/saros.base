add_chapter_foldername_to_chapter_structure <-
  function(chapter_structure,
           max_width_folder_name = 64)  {

    grouping_vars <- dplyr::group_vars(chapter_structure)

    # Handles NA acceptably, as these are converted to string

    if(!is.null(chapter_structure$chapter)) {
      chapter_structure$.chapter_number <- as.integer(as.factor(chapter_structure$chapter))

      digits <- floor(log10(length(unique(chapter_structure$chapter))))+1
      chapter_number_text <- sprintf(paste0("%0", digits, "d"),
                                     chapter_structure$.chapter_number)

      chapter_foldername_clean <-
        filename_sanitizer(as.character(chapter_structure$chapter),
                           max_chars = max_width_folder_name,
                           accept_hyphen = FALSE,
                           make_unique = FALSE)

      chapter_structure$.chapter_foldername <-
        stringi::stri_c(chapter_number_text, "_", chapter_foldername_clean,
                        ignore_null = TRUE)

    }
    chapter_structure |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(grouping_vars)))
  }
