read_main_password_file <- function(file) {
  # Check if file exists
  if (!file.exists(file)) {
    cli::cli_abort("Password file '{.file {file}}' does not exist.")
  }
  # Check if file is readable and non-empty
  if (file.info(file)$size == 0) {
    cli::cli_abort("Password file '{.file {file}}' is empty.")
  }
  # Try reading the file
  result <- tryCatch(
    utils::read.table(file = file, header = TRUE, sep = ":", stringsAsFactors = FALSE),
    error = function(e) {
      cli::cli_abort("Password file '{.file {file}}' is incorrectly formatted: {e$message}")
    }
  )
  # Check for at least two columns
  if (ncol(result) < 2) {
    cli::cli_abort("Password file '{.file {file}}' is incorrectly formatted: must have at least two columns separated by ':'")
  }
  result
}
