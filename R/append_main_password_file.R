
append_main_password_file <- function(x=".main_htpasswd_private",
                                      usernames="admin",
                                      plaintext_passwords="admin") {
  if(!file.exists(x)) {
    cli::cli_abort(c("Cannot find {.file {x}}.",
                     "An empty file must be created manually first, due to security precautions.",
                     "Check that the file has been made available to you."))
  }
  if(length(usernames) != length(plaintext_passwords)) {
    cli::cli_abort("Lengths of {.arg usernames} and {.arg plaintext_passwords} do not match.")
  }
  master_table <- read_main_password_file(file = x)
  new_table <- data.frame(username = usernames, password = plaintext_passwords)
  duplicates <- new_table$username[new_table$username %in% master_table$username]
  if(length(duplicates)>0) cli::cli_warn(c(i="usernames {usernames} already exist in {.file {x}}, ignoring these.",
                                           i="Delete these lines manually in the file if you want to change passwords."))
  new_table <- new_table[!new_table$username %in% master_table$username, ]
  out <- rbind(master_table, new_table)
  write_htpasswd_file(x = out, file = x, header=TRUE)
  cli::cli_progress_done("Successfully registered password credentials!")
  x
}

