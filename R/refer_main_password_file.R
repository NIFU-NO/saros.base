
refer_main_password_file <- function(x=".main_htpasswd_private",
                                     usernames = "admin",
                                     ...,
                                     log_rounds = 12,
                                     append_users = FALSE,
                                     password_input = c("prompt", "8", "10", "12", "16")) {

  password_input <- rlang::arg_match(password_input, multiple = FALSE)
  # Read in x, split it into usernames and plaintext passwords, encrypt the passwords, return a table
  if(!file.exists(x)) {
    cli::cli_abort(c(x="Cannot find {.file {x}}.",
                     i="Check that the file has been made available to you"))
  }
  master_table <- read_main_password_file(file = x)
  out <-
    lapply(usernames, FUN = function(user) {
      passwd <- master_table[master_table$username == user, "password"]
      if(length(passwd)>1) cli::cli_abort("Multiple entries found for username {user}.")
      if(!rlang::is_string(passwd) || nchar(passwd)==0) {
        if(isFALSE(append_users)) cli::cli_abort("Unable to find password for username {user}.")
        if(password_input == "prompt") {

          passwd <- rstudioapi::askForPassword(prompt = stringi::stri_c("Enter password for new user: ", user))
          if(is.null(passwd)) return(NULL)

        } else {
          if(length(password_input)>1 ||
             is.na(as.integer(password_input)) ||
             as.integer(password_input)<1) {

            cli::cli_abort("Password input must be a positive integer stored as string.")

          }
          passwd <- sample(x = c(letters, LETTERS, 0:9),
                           size = as.integer(password_input),
                           replace = TRUE)
          passwd <- stringi::stri_c(passwd, collapse="", ignore_null = TRUE)
        }

        append_main_password_file(x = x,
                                  usernames = user,
                                  plaintext_passwords = passwd)
      }
      passwd <- bcrypt::hashpw(password = passwd, salt = bcrypt::gensalt(log_rounds = log_rounds))
      rlang::set_names(x = passwd, nm = user)
    })
  unlist(out)
}


