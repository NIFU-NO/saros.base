
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

copy_content <- function(from_files, from_folders, to_folder) {
  # Create the destination directory if it doesn't exist
  if (!dir.exists(to_folder)) {
    dir.create(to_folder, recursive = TRUE, showWarnings = TRUE)
  } else {
    # If the directory exists, clear its contents
    file.remove(list.files(to_folder, full.names = TRUE))
  }


  # Copy each file to the destination folder
  for (file in from_files) {
    if (file.exists(file)) {
      file.copy(file, to_folder)
    }
  }

  # Copy each folder to the destination folder
  for (folder in from_folders) {
    if (dir.exists(folder)) {
      recursive_copy(folder, file.path(to_folder, basename(folder)))
    }
  }
}
