
validate_access_folder_paths <- function(remote_basepath,
                                         local_basepath = "_site",
                                         rel_path_base_to_parent_of_user_restricted_folder =
                                           file.path( "Reports",
                                                      "2023",
                                                      "Mesos"),
                                         warn = FALSE) {
  if(!is.character(rel_path_base_to_parent_of_user_restricted_folder)) {
    warnabort_fn("{.arg rel_path_base_to_parent_of_user_restricted_folder} must be a string.")
  }
  rel_path_base_to_parent_of_user_restricted_folder <- file.path(local_basepath, rel_path_base_to_parent_of_user_restricted_folder)
  warnabort_fn <- if(isTRUE(warn)) cli::cli_warn else cli::cli_abort
  if(!rlang::is_string(remote_basepath)) {
    warnabort_fn("{.arg remote_basepath} must be a string.")
  }
  if(!rlang::is_string(local_basepath)) {
    warnabort_fn("{.arg local_basepath} must be a string.")
  }
}

