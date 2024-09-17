#' Create Folder with Placeholder R-files Based on Structure in CSV-file
#'
#' @inheritParams initialize_saros_project
#'
#' @return No return value, called for side effects
#' @export
#'
#' @examples create_r_files(r_files_out_path = tempdir())
create_r_files <- function(r_files_out_path,
                           r_files_source_path = system.file("templates", "r_files.csv", package = "saros.base"),
                           r_optionals = TRUE,
                           r_add_file_scope = TRUE,
                           r_prefix_file_scope = "### ",
                           r_add_folder_scope_as_README = FALSE,
                           word_separator = NULL,
                           case = c("asis", "sentence", "title", "lower", "upper", "snake"),
                           numbering_prefix = c("none", "max_local", "max_global"),
                           numbering_inheritance = TRUE,
                           numbering_parent_child_separator = word_separator,
                           numbering_name_separator = " ") {
  numbering_prefix <- rlang::arg_match(numbering_prefix)
  data <- utils::read.csv2(file = r_files_source_path)
  if (!all(c("folder_name", "file_name") %in% colnames(data))) cli::cli_abort("Cannot find columns {.var {c('folder_name', 'file_name')}} in {.file {r_files_source_path}}.")
  data <- data[!is.na(data$folder_name) &
    !is.na(data$r_files_source_path), ]
  if (isFALSE(r_optionals)) data <- data[as.integer(data$optional) == 1L, ]

  data$folder_name <- handle_naming_conventions(data$folder_name)
  data$file_name <- handle_naming_conventions(data$file_name)

  # Folder stuff

  data_folders <- data[unique(data$folder_name), ]

  for (i in seq_len(nrow(data_folders))) {
    # if(numbering_prefix %in% c("max_local", "max_global")) {
    #   data_folders$folder_name <- paste0(seq_along(data_folders$folder_name),
    #                                      numbering_name_separator,
    #                                      data_folders$folder_name)
    # }
    dir.create(path = paste0(r_files_out_path, .Platform$file.sep, data_folders[i, "folder_name"]), showWarnings = FALSE, recursive = TRUE)
    if (r_add_folder_scope_as_README) {
      README_filepath <- file.path(r_files_out_path, data[i, "folder_name"], "README.txt")
      cat(data[i, "folder_scope"], "\n", file = README_filepath)
    }
  }


  # Files stuff
  counter <- 1
  for (i in seq_len(nrow(data))) {
    r_filepath <- file.path(r_files_out_path, paste0(data[i, "file_name"], ".R"))
    if (!file.exists(r_filepath)) cat(r_prefix_file_scope, data[i, "file_scope"], "\n", file = r_filepath)
  }
}
