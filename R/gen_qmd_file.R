#' Generate Quarto Index File That Merges All Chapters
#'
#' This function creates an index Quarto file (QMD) that merges all chapters in the specified order. It can also include optional title and author(s) information.
#'
#' @inheritParams draft_report
#' @param path String, where to write qmd-file.
#' @param filename String, bare name of qmd-file. Default: "report". If NULL,
#' generates a sanitized version of the title. If both filename and title are NULL, errors.
#' @param yaml_file A string containing the filepath to a yaml-file to be inserted at top of qmd-file.
#' @param qmd_start_section_filepath,qmd_end_section_filepath String, filepath
#' to a qmd-file inserted at start and end of file.
#' @param output_filename,output_formats Character. If applied, will construct
#' list of links to files with said `output_filename`.
#' @param call Internal call argument. Not to be fiddled with by the user.
#'
#' @return A string containing the filepath to the generated Quarto report file.
#' @keywords internal
gen_qmd_file <-
  function(path = NULL,
           filename = "report",
           yaml_file = NULL,
           qmd_start_section_filepath = NULL,
           qmd_end_section_filepath = NULL,
           chapter_structure = NULL,
           include_files = NULL,
           title = NULL,
           authors = NULL,
           output_formats = NULL,
           output_filename = NULL,
           includes_prefix = '{{< include "',
           includes_suffix = '" >}}',
           call = rlang::caller_env()) {
    check_string(path, n = 1, null.ok = TRUE, call = call)
    check_string(filename, n = 1, null.ok = TRUE, call = call)
    check_string(yaml_file, n = 1, null.ok = TRUE, call = call)
    check_string(qmd_start_section_filepath, n = 1, null.ok = TRUE, call = call)
    check_string(qmd_end_section_filepath, n = 1, null.ok = TRUE, call = call)
    check_string(title, n = 1, null.ok = TRUE, call = call)
    check_string(authors, n = NULL, null.ok = TRUE, call = call)
    check_string(output_formats, n = NULL, null.ok = TRUE, call = call)
    check_string(output_filename, n = 1, null.ok = TRUE, call = call)
    if (is.null(title) && is.null(filename)) {
      cli::cli_abort("{.arg filename} and {.arg title} cannot be both `NULL`.")
    }

    yaml_section <-
      process_yaml(
        yaml_file = yaml_file,
        title = title,
        authors = authors[!is.na(authors)]
      )

    # Generate links to output files
    report_links <- generate_report_links(output_filename, output_formats)

    # Process template sections
    qmd_start_section <- process_template_section(
      filepath = qmd_start_section_filepath,
      chapter_structure = chapter_structure,
      arg_name = paste0(filename, "_qmd_start_section")
    )

    qmd_end_section <- process_template_section(
      filepath = qmd_end_section_filepath,
      chapter_structure = chapter_structure,
      arg_name = paste0(filename, "_qmd_end_section")
    )
    if (!is.null(include_files)) {
      include_files <-
        paste0(includes_prefix, include_files, includes_suffix, collapse = "\n\n")
    }

    out <-
      c(
        yaml_section, "\n",
        qmd_start_section,
        report_links,
        include_files,
        qmd_end_section
      )

    # Finalize content
    out <- finalize_qmd_content(out)
    filepath <-
      if (is.character(filename)) {
        file.path(path, stringi::stri_c(filename, ".qmd"))
      } else if (is.null(filename)) { # Produce unique report file name based on title
        file.path(path, stringi::stri_c("0_", filename_sanitizer(title), ".qmd", ignore_null = TRUE))
      }
    cat(out, file = filepath, append = FALSE)
    filepath
  }
