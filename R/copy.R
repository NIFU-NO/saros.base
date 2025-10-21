# Function to recursively copy folders
recursive_copy <- function(from, to) {
  # Create the directory structure in the destination
  dir.create(to, recursive = TRUE, showWarnings = FALSE)

  # List all files in the source directory
  files <- list.files(from, full.names = TRUE)

  for (file in files) {
    # If it's a directory, recursively copy its contents
    if (file.info(file)$isdir) {
      recursive_copy(file, file.path(to, basename(file)))
    } else {
      # If it's a file, copy it to the destination
      file.copy(file, to)
    }
  }
}
