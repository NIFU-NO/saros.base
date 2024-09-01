#' Setup files needed for basic password-based access restriction for website
#'
#' Create a _headers file for 'Netlify' publishing or a set of .htaccess and .htpasswd files (FTP)
#'  placed in the specific subfolders.
#'
#' @param remote_basepath String. Folder where site will be located if using FTP-server. Needed for .htaccess-files.
#' @param local_basepath String. Local folder for website, typically "_site".
#' @param rel_path_base_to_parent_of_user_restricted_folder String, relative path from basepath to the folder where the restricted folders are located. (E.g. the "mesos"-folder)
#' @param warn Flag. Whether to provide warning or error if paths do not exist.
#' @param local_main_password_path String. Path to main file containing all usernames and passwords formatted with a colon between username and password.
#' @param username_folder_matching_df Data frame. If NULL (default), will use folder names as usernames. Otherwise, a data frame with two columns: "folder" and "username" where "folder" is the name of the folder and "username" is the username for that folder.
#' @param universal_usernames Character vector. Usernames in local_main_htpasswd_path which always have access to folder
#' @param log_rounds Integer, number of rounds in the bcrypt algorithm. The higher the more time consuming and harder to brute-force.
#' @param append_users Boolean, if TRUE (default) will create new users and add them to local_main_password_path. See also password_input.
#' @param password_input String, either "prompt" which asks the user for input. Alternatively, a number stored as string for a generated random password of said length: "8", "10", "12", "16"
#' @param type Character vector. "netlify" will create _headers file used for Netlify. "apache" will create .htaccess and .htpasswd files used for general FTP-servers.
#'
#' @return String, the path to the newly created _headers-file or .htaccess files.
#' @export
setup_access_restrictions <- function(remote_basepath = "/home/",
                                      local_basepath,
                                      rel_path_base_to_parent_of_user_restricted_folder = file.path("Reports", "2022", "Mesos"),
                                      warn = TRUE,
                                      local_main_password_path = ".main_htpasswd_public",
                                      username_folder_matching_df = NULL,
                                      universal_usernames = c("admin"),
                                      log_rounds = 12,
                                      append_users = TRUE,
                                      password_input = "prompt",
                                      type = c("netlify", "apache")) {

  remote_basepath <- stringi::stri_replace_last_regex(remote_basepath, pattern = "/", "")

  for(rel_path_base_to_parent_of_user_restricted_folder_string in rel_path_base_to_parent_of_user_restricted_folder) {
    validate_access_folder_paths(remote_basepath = remote_basepath,
                                 local_basepath = local_basepath,
                                 rel_path_base_to_parent_of_user_restricted_folder = rel_path_base_to_parent_of_user_restricted_folder)
  }

  if(!is.null(username_folder_matching_df) &&
     (!inherits(username_folder_matching_df, "data.frame") ||
     !all(c("folder", "username") %in% colnames(username_folder_matching_df)))) {
    cli::cli_abort("{.arg username_folder_matching_df} must be a data.frame with columns 'folder' and 'username', not {.obj_type_friendly {username_folder_matching_df}}.")
    ## Assume df has multiple usernames per folder, and multiple folders per username
  }


  if(any("netlify" == type)) {
    create__headers_file(remote_basepath = remote_basepath, # Not used in this function, included for consistency
                         local_basepath = local_basepath,
                         rel_path_base_to_parent_of_user_restricted_folder = rel_path_base_to_parent_of_user_restricted_folder,
                         local_main_password_path = local_main_password_path,
                         username_folder_matching_df = username_folder_matching_df,
                         universal_usernames = universal_usernames,
                         log_rounds = log_rounds,
                         append_users = append_users,
                         password_input = password_input)
  }
  if(any("apache" == type)) {
    create_htaccess(remote_basepath = remote_basepath, # Not used in this function, included for consistency
                    local_basepath = local_basepath,
                    rel_path_base_to_parent_of_user_restricted_folder = rel_path_base_to_parent_of_user_restricted_folder,
                    local_main_password_path = local_main_password_path,
                    username_folder_matching_df = username_folder_matching_df,
                    universal_usernames = universal_usernames,
                    log_rounds = log_rounds,
                    append_users = append_users,
                    password_input = password_input)
  }

}
