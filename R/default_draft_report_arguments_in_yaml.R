#' Write Default Arguments for [saros.base::draft_report()] to YAML-file
#'
#' @param path
#'
#'   `scalar<character>` // Required
#'
#'   Path of the YAML-file to write. There is no default; pass an explicit
#'   path, e.g. `"settings.yaml"`.
#'
#' @param ignore_args
#'
#'   `vector<character>` // *default:* `c("data", "...", "dep", "indep", "chapter_structure", "chapter_overview", "path")` (`optional`)
#'
#'   A character vector of argument (names) not to be written to file. `"path"`
#'   is excluded because it names the output file of this call rather than a
#'   setting worth recording.
#'
#' @return The defaults as a `yaml`-object.
#' @export
#'
#' @examples
#' write_default_draft_report_args(path = tempfile(fileext = ".yaml"))
write_default_draft_report_args <-
  function(path, ignore_args = c("data", "...", "dep", "indep", "chapter_structure", "chapter_overview", "path")) {
    args <- formals(saros.base::draft_report)
    args <- args[!names(args) %in% ignore_args]
    args$serialized_format <- args$serialized_format[1]
    args <- lapply(args, eval)
    args <- lapply(args, function(x) if (any(rlang::have_name(x))) as.list(x) else x)
    args <- yaml::as.yaml(args)
    dir.create(fs::path_dir(path), recursive = TRUE, showWarnings = FALSE)
    cat(args, file = path)
    path
  }


#' Read Default Arguments for [saros.base::draft_report()] from YAML-file
#'
#' @param path
#'
#'   `scalar<character>` // Required
#'
#'   Path of the YAML-file to read. There is no default; pass an explicit path,
#'   e.g. the one given to [write_default_draft_report_args()].
#'
#' @return The defaults as a `yaml`-object.
#' @export
#'
#' @examples
#' tmpfile <- tempfile(fileext = ".yaml")
#' write_default_draft_report_args(path = tmpfile)
#' read_default_draft_report_args(path = tmpfile)
read_default_draft_report_args <-
  function(path) {
    x <- yaml::read_yaml(file = as.character(path))
    x$translations <- unlist(x$translations, recursive = FALSE)
    x$replace_heading_for_group <-
      unlist(x$replace_heading_for_group)

    x
  }
