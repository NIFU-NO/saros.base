attach_new_output_to_output <- function(output,
                                        heading_line = NULL,
                                        new_out = NULL,
                                        level = 1,
                                        grouping_structure = character()) {

  new_out <- stringi::stri_remove_empty_na(new_out)
  output <- stringi::stri_remove_empty_na(output)

  if((length(new_out) == 1 && nchar(new_out) >= 4) ||
     level < length(grouping_structure)
     ) {
    output <- stringi::stri_c(output, heading_line, new_out, sep = "\n\n", ignore_null = TRUE)
  } else {
    output <- stringi::stri_c(output, new_out, sep = "\n\n", ignore_null = TRUE)
  }

  stringi::stri_remove_empty_na(output)
}

# attach_new_output_to_output <- function(new_out,
#                                         output,
#                                         level,
#                                         grouped_data,
#                                         heading_line) {
#   new_out <- unlist(new_out)
#   new_out <- stringi::stri_remove_empty_na(new_out)
#   output <- stringi::stri_remove_empty_na(output)
#   new_out <- stringi::stri_c(new_out, collapse = "\n\n", ignore_null=TRUE) # Space between elements
#
#   out <-
#   stringi::stri_c(output,
#                   if(level == ncol(grouped_data) &&
#                      names(grouped_data)[level] != ".template_name" &&
#                      nchar(new_out) > 4) heading_line,
#                   new_out,
#                   sep = "\n",
#                   ignore_null=TRUE) # Space between heading and first element
#   stringi::stri_remove_empty_na(out)
#
# }

