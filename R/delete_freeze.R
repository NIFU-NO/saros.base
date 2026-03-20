#' Delete Quarto _freeze Cache for Updated QMD Files
#'
#' When Quarto renders `.qmd` files, it caches execution results in a
#' `_freeze` directory. If a `.qmd` file is updated, the corresponding
#' `_freeze` entry becomes stale. This function deletes `_freeze` entries
#' for `.qmd` files that have been modified more recently than their cache.
#'
#' @param path String. Path to the Quarto project directory containing
#'   the `_freeze` folder and `.qmd` files.
#' @param qmd_files Character vector of `.qmd` file paths (relative to
#'   `path`) to check. If `NULL` (default), all `.qmd` files found
#'   recursively under `path` are checked.
#'
#' @return Character vector of deleted `_freeze` directories (invisibly).
#' @export
#'
#' @examples
#' \dontrun{
#' # Delete stale freeze caches in a Quarto project
#' delete_freeze(path = "my_report")
#'
#' # Check specific files only
#' delete_freeze(path = "my_report", qmd_files = "01_intro/01_intro.qmd")
#' }
delete_freeze <- function(path, qmd_files = NULL) {
  path <- fs::path_real(path)
  freeze_dir <- fs::path(path, "_freeze")

  if (!fs::dir_exists(freeze_dir)) {
    cli::cli_inform("No {.path _freeze} directory found in {.path {path}}.")
    return(invisible(character(0)))
  }

  if (is.null(qmd_files)) {
    qmd_files <- fs::dir_ls(path, recurse = TRUE, glob = "*.qmd")
    qmd_files <- fs::path_rel(qmd_files, start = path)
  }

  deleted <- character(0)

  for (qmd in qmd_files) {
    qmd_path <- fs::path(path, qmd)
    if (!fs::file_exists(qmd_path)) next

    freeze_entry <- fs::path(freeze_dir, fs::path_ext_remove(qmd))
    if (!fs::dir_exists(freeze_entry)) next

    qmd_mtime <- fs::file_info(qmd_path)$modification_time
    freeze_mtime <- max(fs::file_info(fs::dir_ls(freeze_entry, recurse = TRUE))$modification_time)

    if (qmd_mtime > freeze_mtime) {
      fs::dir_delete(freeze_entry)
      deleted <- c(deleted, as.character(freeze_entry))
      cli::cli_inform("Deleted stale freeze cache: {.path {freeze_entry}}")
    }
  }

  if (length(deleted) == 0) {
    cli::cli_inform("All {.path _freeze} entries are up to date.")
  }

  invisible(deleted)
}
