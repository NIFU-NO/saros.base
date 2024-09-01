create__headers_file <- function(remote_basepath = "/home/", # Not used in this function, included for consistency
                                 local_basepath = "_site",
                                 rel_path_base_to_parent_of_user_restricted_folder = file.path("Reports", "2022", "Mesos"),
                                 local_main_password_path = ".main_htpasswd_public",
                                 username_folder_matching_df = NULL,
                                 universal_usernames = c("admin"),
                                 log_rounds = 12,
                                 append_users = TRUE,
                                 password_input = "prompt") {

  abs_path_parents <-
    file.path(local_basepath,
              rel_path_base_to_parent_of_user_restricted_folder)


  local_subfolders_sets <- lapply(abs_path_parents, obtain_mesos_folders_from_parent_folder)
  names(local_subfolders_sets) <- rel_path_base_to_parent_of_user_restricted_folder


  out <-
    lapply(seq_along(local_subfolders_sets), function(i) {

      lapply(seq_along(local_subfolders_sets[[i]]), FUN = function(j) {

        folder_name <- local_subfolders_sets[[i]][j]
        user_names <- if(is.data.frame(username_folder_matching_df)) {
          username_folder_matching_df$username[username_folder_matching_df$folder == folder_name]
        } else {
          folder_name
        }

        credentials <- refer_main_password_file(x = local_main_password_path,
                                                usernames = unique(c(user_names, universal_usernames)),
                                                log_rounds = log_rounds,
                                                append_users = append_users,
                                                password_input = password_input)

        path <- file.path(names(local_subfolders_sets)[i], folder_name)
        credentials_flattened <- stringi::stri_c(user_names,
                                                 ":", unname(credentials[user_names]),
                                                 collapse = " ", ignore_null = TRUE)
        stringi::stri_c(path, "/*\n  Basic-Auth: ", credentials_flattened)
      })
    })

  out_file <- stringi::stri_c(local_basepath, .Platform$file.sep, "_headers") #No file.path because of _headers lacking extension
  out <- unlist(unlist(out))
  cat(out, file = out_file, sep = "\n")

  out_file


}
