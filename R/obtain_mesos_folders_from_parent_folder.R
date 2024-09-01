
obtain_mesos_folders_from_parent_folder <- function(x) {
  if(!rlang::is_string(x) || !file.exists(x)) {
    cli::cli_abort("{.arg x} does not exist: {.file {x}}")
  }
  list.dirs(path = x, full.names = FALSE, recursive = FALSE)
}

