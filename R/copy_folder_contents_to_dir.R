#' Convenience Function to Copy Only the Contents of A Folder to Another Folder
#'
#' @param to,from String, path from where to copy the contents, and where to copy them to.
#' @param overwrite Flag. Defaults to FALSE.
#' @param only_copy_folders Flag. Defaults to FALSE. If TRUE, only copies folders.
#'
#' @return NULL
#' @export
#'
#' @examples
#' copy_folder_contents_to_dir(from = system.file("help", "figures", package = "dplyr"),
#'                             to = tempdir())
copy_folder_contents_to_dir <-
  function(from,
           to,
           overwrite = FALSE,
           only_copy_folders = FALSE) {

    if(isFALSE(only_copy_folders)) {
    subfolders <- list.dirs(path = from, full.names = FALSE, recursive = FALSE)
    lapply(subfolders, function(x) fs::dir_copy(path = fs::path_dir(fs::path(from, x)),
                                                new_path = fs::path(to),
                                                overwrite = overwrite))
    } else {
      subfolders <- list.dirs(path = from, full.names = FALSE, recursive = TRUE)
      lapply(subfolders, function(x) dir.create(path = fs::path_dir(fs::path(to, x)),
                                                recursive = TRUE, showWarnings = FALSE))
    }
    cli::cli_inform("Copied: {subfolders}")
  }
