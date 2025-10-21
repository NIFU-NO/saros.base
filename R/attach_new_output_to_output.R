attach_new_output_to_output <- function(output,
                                        heading_line = NULL,
                                        new_out = NULL,
                                        level = 1,
                                        grouping_structure = character()) {
  new_out <- stringi::stri_remove_empty_na(new_out)
  output <- stringi::stri_remove_empty_na(output)

  if ((length(new_out) == 1 && nchar(new_out) >= 4) ||
    level < length(grouping_structure)
  ) {
    output <- stringi::stri_c(output, heading_line, new_out, sep = "\n\n", ignore_null = TRUE)
  } else {
    output <- stringi::stri_c(output, new_out, sep = "\n\n", ignore_null = TRUE)
  }

  stringi::stri_remove_empty_na(output)
}
