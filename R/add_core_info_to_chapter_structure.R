add_core_info_to_chapter_structure <-
  function(chapter_structure) {
    col_headers <- c("dep", "indep")

    out <-
      tidyr::pivot_longer(chapter_structure,
        cols = tidyselect::any_of(col_headers),
        values_to = ".variable_selection"
      )
    out <-
      vctrs::vec_slice(
        out,
        !(out$name == "indep" &
          (is.na(out$.variable_selection) |
            out$.variable_selection == ""))
      )

    # Split .variable_selection but preserve spaces within backtick-quoted names
    # First, normalize the delimiters outside of backticks
    out$.variable_selection <- vapply(
      out$.variable_selection,
      function(str) {
        if (is.na(str) || str == "") {
          return(str)
        }

        # Find all backtick-quoted variable names
        backtick_pattern <- "`[^`]+`"
        matches <- stringi::stri_extract_all_regex(str, backtick_pattern)[[1]]

        if (all(is.na(matches))) {
          # No backtick-quoted names, process normally
          stringi::stri_replace_all_regex(str, "[,[:space:]]+", ",")
        } else {
          # Replace backtick sections with placeholders, process, then restore
          placeholders <- paste0("__BQUOTE_", seq_along(matches), "__")
          temp_str <- str
          for (i in seq_along(matches)) {
            temp_str <- stringi::stri_replace_first_fixed(temp_str, matches[i], placeholders[i])
          }
          # Now replace spaces/commas in the non-backtick parts
          temp_str <- stringi::stri_replace_all_regex(temp_str, "[,[:space:]]+", ",")
          # Restore backtick-quoted names
          for (i in seq_along(matches)) {
            temp_str <- stringi::stri_replace_first_fixed(temp_str, placeholders[i], matches[i])
          }
          temp_str
        }
      },
      character(1),
      USE.NAMES = FALSE
    )

    # Now split by comma (which won't be inside backticks after our processing)
    out <-
      tidyr::separate_longer_delim(out,
        cols = ".variable_selection",
        delim = ","
      )
    out <-
      tidyr::separate(out,
        col = .data$name,
        into = ".variable_role",
        sep = "_"
      )

    out[[".variable_role"]] <-
      ifelse(is.na(out[[".variable_selection"]]) |
        out[[".variable_selection"]] == "", NA_character_, out[[".variable_role"]])

    out[[".variable_selection"]] <-
      dplyr::if_else(
        !stringi::stri_detect(out$.variable_selection,
          regex = "matches\\("
        ) &
          stringi::stri_detect(out$.variable_selection,
            regex = "\\*"
          ),
        true = stringi::stri_c(
          ignore_null = TRUE,
          "matches('",
          out$.variable_selection,
          "')"
        ),
        false = out$.variable_selection
      )
    out <-
      dplyr::distinct(out, .keep_all = TRUE)
    out <-
      dplyr::relocate(out, tidyselect::all_of(c(".variable_role", ".variable_selection")))
    out
  }
