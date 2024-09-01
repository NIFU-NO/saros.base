
validate_access_folder_paths <- function(remote_basepath,
                                         local_basepath = "_site",
                                         rel_path_base_to_parent_of_user_restricted_folder =
                                           file.path( "Reports",
                                                      "2023",
                                                      "Mesos"),
                                         warn = FALSE) {
  rel_path_base_to_parent_of_user_restricted_folder <- file.path(local_basepath, rel_path_base_to_parent_of_user_restricted_folder)
  warnabort_fn <- if(isTRUE(warn)) cli::cli_warn else cli::cli_abort
  for(path in c(remote_basepath, local_basepath, rel_path_base_to_parent_of_user_restricted_folder)) {
    if(!rlang::is_string(path)) {
      warnabort_fn("{.arg {path}} must be a string.")
    }
  }
}

