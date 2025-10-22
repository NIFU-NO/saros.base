# Helper: Process template section file with optional glue templating
process_template_section <- function(filepath, chapter_structure = NULL, arg_name) {
  if (is.null(filepath) || !rlang::is_string(filepath)) {
    return(NULL)
  }

  # Read the template file
  content <- stringi::stri_c(
    collapse = "\n",
    ignore_null = TRUE,
    readLines(con = filepath)
  )

  # Apply glue templating if chapter_structure is provided
  if (inherits(chapter_structure, "data.frame")) {
    chapter_structure_simplified <- collapse_chapter_structure_to_chr(chapter_structure)
    tryCatch(
      glue::glue_data(chapter_structure_simplified, content, .na = ""),
      error = function(cnd) glue_err(cnd = cnd, arg_name = arg_name)
    )
  } else {
    content
  }
}

# Helper: Finalize QMD content by removing NAs and normalizing newlines
finalize_qmd_content <- function(sections) {
  out <- stringi::stri_remove_na(sections)
  out <- stringi::stri_c(out, collapse = "\n", ignore_null = TRUE)
  out <- stringi::stri_replace_all_regex(out,
    pattern = "\n{3,}",
    replacement = "\n\n\n"
  )
  out
}

# Helper: Generate markdown links to output files in different formats
generate_report_links <- function(output_filename, output_formats) {
  if (!is.character(output_filename) || !is.character(output_formats)) {
    return(NULL)
  }

  stringi::stri_c(
    lapply(output_formats, function(frmt) {
      # Convert typst to pdf for link purposes
      display_format <- if (frmt == "typst") "pdf" else frmt

      stringi::stri_c(
        "-\t[(", toupper(display_format), ")](",
        output_filename, ".", display_format, ")"
      )
    }),
    collapse = "\n"
  )
}
