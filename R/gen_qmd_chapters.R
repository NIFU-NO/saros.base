#' Generate A Quarto Survey Report
#'
#' This function generates a set of saros chapters, collectively called a report.
#'
#' @details
#' A report consists of multiple chapters, an index file, and optionally a combined report file that merges them together.
#' A chapter can contain any user-defined set of dependent, independent or bivariate variable sets.
#' A chapter consists of multiple sections.
#' A section is defined as a group in the chapter_structure (ignoring the chapter
#' grouping level) containing variables of the same type, meaning at a minimum
#' that the variables in the section sharing the same response options, the same
#' main question, and being of the same data type.
#'
#' @inheritParams draft_report
#'
#' @return Side-effects: qmd-files generated in the specified working directory.
#' @keywords internal
#'
gen_qmd_chapters <-
  function(chapter_structure,
           data,
           authors_col = "author",
           path = NULL,
           ignore_heading_for_group = NULL,
           replace_heading_for_group = NULL,
           prefix_heading_for_group = NULL,
           suffix_heading_for_group = NULL,
           chapter_yaml_file = NULL,
           chapter_qmd_start_section_filepath = NULL,
           chapter_qmd_end_section_filepath = NULL,
           attach_chapter_dataset = TRUE,
           auxiliary_variables = NULL,
           serialized_format = "rds"
  ) {



    path <- fs::as_fs_path(path)

    grouping_structure <- dplyr::group_vars(chapter_structure)

    chapter_structure_chapter_groups <-
      dplyr::group_by(chapter_structure,
                      dplyr::pick(tidyselect::all_of(grouping_structure[1])))


    ## Generate each chapter. Returns paths to files, which are then used for index.qmd
    chapter_filepaths <-
      chapter_structure_chapter_groups |> # CONVERT TO unlist(lapply(names(attr(chapter_structure_chapter, "groups"))[names(.) != ".rows"])) by taking dplyr::
      dplyr::group_map(
        .keep = TRUE,
        ## ALL OF THIS MOVED TO NEW FUNCTION gen_qmd_chapter and convert group_map to a for-loop?
        .f = function(chapter_structure_chapter,
                      key_chapter) {





          chapter_structure_chapter <-
            dplyr::group_by(chapter_structure_chapter,
                            dplyr::pick(tidyselect::all_of(grouping_structure)))

          # Paths

          chapter <- unique(chapter_structure_chapter$chapter)
          chapter_number <- unique(chapter_structure_chapter$.chapter_number)
          chapter_foldername_clean <- unique(chapter_structure_chapter$.chapter_foldername)


          chapter_folderpath_absolute <- file.path(path, chapter_foldername_clean)
          dir.create(path = chapter_folderpath_absolute, recursive = TRUE, showWarnings = FALSE)

          chapter_filepath_relative <- stringi::stri_c(chapter_foldername_clean, ".qmd", ignore_null=TRUE)
          chapter_filepath_absolute <- file.path(path, chapter_filepath_relative)


          authors <- get_authors(data = chapter_structure_chapter, col = authors_col)
          yaml_section <- process_yaml(yaml_file = chapter_yaml_file,
                                       title = NULL,
                                      authors = authors,
                                      chapter_number = chapter_number)

          if(!all(is.na(chapter_structure_chapter$.variable_name_dep))) {

            chapter_contents <-
              gen_qmd_structure(chapter_structure = chapter_structure_chapter,
                                ignore_heading_for_group = ignore_heading_for_group,
                                replace_heading_for_group = replace_heading_for_group,
                                prefix_heading_for_group = prefix_heading_for_group,
                                suffix_heading_for_group = suffix_heading_for_group)

          } else chapter_contents <- NULL

          ###
          if(inherits(chapter_structure_chapter, "data.frame")) {
            chapter_structure_chapter_simplified <-
              collapse_chapter_structure_to_chr(chapter_structure_chapter)
          }

          qmd_start_section <-
            if(rlang::is_string(chapter_qmd_start_section_filepath)) {
              out <-
                stringi::stri_c(collapse = "\n",
                              ignore_null = TRUE,
                              readLines(con = chapter_qmd_start_section_filepath)
                              )

              if(inherits(chapter_structure_chapter, "data.frame")) {
                tryCatch(glue::glue_data(chapter_structure_chapter_simplified, out, .na = ""),
                         error = function(cnd) glue_err(cnd=cnd, arg_name="chapter_qmd_start_section"))
              }
            }

          qmd_end_section <-
            if(rlang::is_string(chapter_qmd_end_section_filepath)) {
              out <-
                stringi::stri_c(collapse = "\n",
                              ignore_null = TRUE,
                              readLines(con = chapter_qmd_end_section_filepath)
                              )
              if(inherits(chapter_structure_chapter, "data.frame")) {
                tryCatch(glue::glue_data(chapter_structure_chapter_simplified, out, .na = ""),
                         error = function(cnd) glue_err(cnd=cnd, arg_name="chapter_qmd_end_section"))
              }
            }

          load_dataset <-
            if(isTRUE(attach_chapter_dataset)) {
              attach_chapter_dataset(data = data,
                                     chapter_structure_chapter = chapter_structure_chapter,
                                     chapter_foldername_clean = chapter_foldername_clean,
                                     path = path,
                                     auxiliary_variables = auxiliary_variables,
                                     serialized_format = serialized_format)
            }

          out <- c(yaml_section,
                   stringi::stri_c("# ", chapter), # Should use generalized function to get also reference, prefix and suffix
                   load_dataset,
                   qmd_start_section,
                   chapter_contents,
                   qmd_end_section)
          out <- stringi::stri_remove_na(out)
          out <- stringi::stri_c(out, collapse = "\n", ignore_null=TRUE)
          out <- stringi::stri_replace_all_regex(out,
                                                 pattern = "\n{3,}",
                                                 replacement = "\n\n\n")

          cat(out, file = chapter_filepath_absolute, append = FALSE)

          chapter_filepath_relative

        })

    unlist(chapter_filepaths)


  }
