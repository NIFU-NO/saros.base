
read_main_password_file <- function(file) {
  utils::read.table(file = file, header = TRUE,
                    sep=":")
}

