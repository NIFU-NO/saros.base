#' Initialize Folder Structure
#'
#' Can be used programatically from the console, or simply use the New Project Wizard.
#'
#' @param path String, path to where to create the project files
#' @param structure_path String. Path to the YAML file that defines the folder structure. Defaults to system.file("templates", "_project_structure_en.yaml").
#' @param numbering_prefix String. One of c("none", "max_local", "max_global").
#' @param numbering_inheritance Flag. Whether to inherit numbering from parent folder.
#' @param word_separator String. Replace separators between words in folder names. Defaults to NULL.
#' @param numbering_parent_child_separator String. Defaults to word_separator.
#' @param numbering_name_separator String. Separator between numbering part and name.
#' @param case String. One of c("asis", "sentence", "lower", "upper", "title", "snake").
#' @param replacement_list named character vector. Each name in this vector will be replaced with its `"{{value}}"` in the structure_path file
#' @param create Boolean. Defaults to TRUE in initialize_saros_project(), FALSE in create_directory_structure().
#' @param count_existing_folders Boolean. Defaults to FALSE.
#' @param r_files_source_path String, path to where to find CSV-field containing the columns folder_name, folder_scope, file_name, file_scope. If NULL, defaults to system.file("templates", "r_files.csv")).
#' @param r_files_out_path String, path to where to place R placeholder files. If NULL, will not create any.
#' @param r_add_file_scope Flag. Whether to add value from column 'file_scope' to beginning of each file. Default to TRUE.
#' @param r_prefix_file_scope String to add before file_scope. Defaults to "### "
#' @param r_add_folder_scope_as_README Flag. Whether to create README file in each folder with the folder_scope column cell in r_files_source_path. Defaults to FALSE.
#' @param r_optionals Flag. Whether to add files marked as 1 (or TRUE) in the optional column. Defaults to TRUE.
#'
#' @return NULL
#' @export
#'
#' @examples initialize_saros_project(path = tempdir())
initialize_saros_project <-
  function(path,
           structure_path = NULL,
           numbering_prefix = c("none", "max_local", "max_global"),
           numbering_inheritance = TRUE,
           word_separator = NULL,
           numbering_name_separator = " ",
           replacement_list = NULL,
           numbering_parent_child_separator = word_separator,
           case = c("asis", "sentence", "title", "lower", "upper", "snake"),
           count_existing_folders = FALSE,

           r_files_out_path = NULL,
           r_files_source_path = system.file("templates", "r_files.csv", package="saros.base"),
           r_optionals = TRUE,
           r_add_file_scope = TRUE,
           r_prefix_file_scope = "### ",
           r_add_folder_scope_as_README = FALSE,
           create = TRUE) {

    if(missing(structure_path) ||
       !rlang::is_string(structure_path) ||
       structure_path=="") structure_path <- system.file("templates", "_project_structure_en.yaml",
                                                         package="saros.base")

    if(rlang::is_string(word_separator) && word_separator=="NULL") word_separator <- NULL
    word_separator <- stringi::stri_replace_all_fixed(word_separator, "'", "")
    if(rlang::is_string(numbering_name_separator) && numbering_name_separator=="NULL") numbering_name_separator <- NULL
    numbering_name_separator <- stringi::stri_replace_all_fixed(numbering_name_separator, "'", "")
    if(rlang::is_string(numbering_parent_child_separator) && numbering_parent_child_separator=="NULL") numbering_parent_child_separator <- NULL
    numbering_parent_child_separator <- stringi::stri_replace_all_fixed(numbering_parent_child_separator, "'", "")


    folder_structure <-
      create_directory_structure(path = path,
                               structure_path = structure_path,
                               numbering_prefix = numbering_prefix,
                               numbering_inheritance = numbering_inheritance,
                               word_separator = word_separator,
                               numbering_name_separator = numbering_name_separator,
                               numbering_parent_child_separator = numbering_parent_child_separator,
                               case = case,
                               replacement_list = replacement_list,
                               create = TRUE,
                               count_existing_folders = count_existing_folders)



    if(!is.null(r_files_out_path)) {
      create_r_files(r_files_out_path = r_files_out_path,
                     r_files_source_path = r_files_source_path,
                     r_optionals = r_optionals,
                     r_add_file_scope = r_add_file_scope,
                     r_prefix_file_scope = r_prefix_file_scope,
                     r_add_folder_scope_as_README = r_add_folder_scope_as_README)
      # saros_path <-
      #   unname(unlist(sapply(folder_structure, function(x) grep("saros.base", x = x, value = TRUE, ignore.case = TRUE))))
      # if(length(saros_path)==1) {
      #   saros_path <- dir(path = path, pattern = saros_path, full.names = TRUE, recursive = TRUE, ignore.case = TRUE, include.dirs = FALSE, no.. = TRUE)
      #   usethis::create_project(path = paste0(path, .Platform$file.sep, saros_path))
      # }
    }
    new_folder_name <- stringi::stri_extract_last_regex(path, pattern = "([^/]+)$")
    print(new_folder_name) # Only remove if folder is otherwise empty
    # stuff_to_remove <- paste0(path, .Platform$file.sep, ".", c(new_folder_name, "Rproj"))
    # unlink()
}
