
#' Generate YAML File from Directory Structure
#'
#' @param input_path String. The path to the directory whose structure needs to be captured.
#' @param output_yaml_path String. The path where the YAML file will be saved.
#' @param remove_prefix_numbers Boolean. Whether to remove numeric prefixes and any resulting leading non-alphanumeric characters from folder names. Defaults to FALSE.
#' @return NULL
#' @export
#' @examples
#' generate_yaml_from_directory(output_yaml_path = tempfile("_project_structure_en", fileext=".yaml"))
generate_yaml_from_directory <- function(input_path = getwd(),
                                         output_yaml_path = "_project_structure_en.yaml",
                                         remove_prefix_numbers = FALSE) {
  # Recursive function to traverse directory and build list
  traverse_directory <- function(dir_path) {
    folders <- list.dirs(dir_path, recursive = FALSE, full.names = FALSE)
    folder_structure <- list()

    for (folder in folders) {
      # Remove numeric prefixes if required
      folder_name <- if (remove_prefix_numbers) {
        cleaned_name <- stringi::stri_replace_first_regex(folder, "^[0-9\\s_-]+", "")
        if (stringi::stri_length(cleaned_name) == 0) {
          folder  # Keep original name if cleaning results in an empty string
        } else {
          cleaned_name
        }
      } else {
        folder
      }

      sub_path <- file.path(dir_path, folder)
      if (file.info(sub_path)$isdir) {
        folder_structure[[folder_name]] <- traverse_directory(sub_path)
      }
    }

    return(folder_structure)
  }

  # Generate the folder structure list
  folder_structure <- traverse_directory(input_path)

  # Write to YAML file
  yaml::write_yaml(folder_structure, output_yaml_path)
}

