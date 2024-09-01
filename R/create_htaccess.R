
create_htaccess <-
  function(remote_basepath = "/home/",
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

    lapply(seq_along(local_subfolders_sets), function(i) {

      lapply(X = seq_along(local_subfolders_sets[[i]]), function(j) {
        ### .htaccess
        folder_name <- local_subfolders_sets[[i]][j]
        user_names <-
          if(is.data.frame(username_folder_matching_df)) {
            username_folder_matching_df$username[username_folder_matching_df$folder == folder_name]
          } else {
            folder_name
          }

        content <- paste0('AuthName "Saros-report access: ', folder_name,
                          '"
AuthUserFile "', file.path(remote_basepath,
                          names(local_subfolders_sets)[i],
                          folder_name,
                          '.htpasswd'), '"
AuthType Basic
Require valid-user
AddHandler server-parsed .html')
        outpath <- file.path(local_basepath,
                             names(local_subfolders_sets)[i],
                             folder_name,
                             ".htaccess")

        writeLines(text = content, con = outpath)

        ### .htpasswd

        credentials <- refer_main_password_file(x = local_main_password_path,
                                                usernames = unique(c(user_names, universal_usernames)),
                                                log_rounds = log_rounds,
                                                append_users = append_users,
                                                password_input = password_input)
        credentials <- data.frame(username=names(credentials),
                                  password=unname(credentials),
                                  row.names = NULL, stringsAsFactors = FALSE)

        write_htpasswd_file(x= credentials,
                            file = file.path(local_basepath,
                                             names(local_subfolders_sets)[i],
                                             folder_name,
                                             ".htpasswd"),
                            header=FALSE)
      })
    })
    invisible()

  }

