# The reader for the `_metadata.yml` inheritance chain this package writes
# (GH #270).
#
# `setup_mesos.R` emits `_metadata.yml` files carrying `params:` at the
# mesos_var level (`:342`) and the group level (`:192`), plus deliberately
# empty ones at every level in between (`:362`). Until this function moved in,
# nothing here could read any of them back: the only reader lived in an
# organization's `general_formatting.R`, outside version control. Writer and
# reader disagreed about the empty files, and no test anywhere could have
# noticed.
#
# Quarto's own `params` cannot serve instead. It resolves to the individual
# qmd file's YAML, so it carries no inheritance -- which is the whole reason
# this chain exists.

# The nearest ancestor of `path` (inclusive) that holds a Quarto project file,
# or NULL if there is none up to the filesystem root.
#
# Both spellings are matched. This is not defensive padding: the one real
# saros project available while this was written uses `_quarto.yaml`, and a
# check matching only `_quarto.yml` would find no root, silently fall back to
# the starting directory, and reduce every chain to a single folder -- a
# failure indistinguishable from a project that inherits nothing.
find_quarto_project_root <- function(path) {
  current <- path
  repeat {
    markers <- fs::path(current, c("_quarto.yml", "_quarto.yaml"))
    if (any(fs::file_exists(markers))) {
      return(current)
    }
    parent <- fs::path_norm(fs::path(current, ".."))
    if (parent == current) {
      return(NULL)
    }
    current <- parent
  }
}

# `root` down to `path`, inclusive, outermost first. `root` is always an
# ancestor of `path` here, being what find_quarto_project_root() walked up to.
directory_chain <- function(root, path) {
  out <- path
  current <- path
  while (current != root) {
    current <- fs::path_norm(fs::path(current, ".."))
    out <- c(current, out)
  }
  out
}

# One file's contents, or NULL if it contributes nothing.
#
# Read via yaml.load() on lines rather than yaml::read_yaml(), because the
# empty `_metadata.yml` files write_subfolder_metadata() produces make
# read_yaml() return NULL and readLines() warn about an incomplete final line.
read_metadata_file <- function(file) {
  if (!fs::file_exists(file)) {
    return(NULL)
  }
  contents <- yaml::yaml.load(
    stringi::stri_c(readLines(file, warn = FALSE), collapse = "\n")
  )
  # An empty file yields NULL and a scalar file yields a length-one vector;
  # utils::modifyList() accepts neither. Both mean "no overrides at this
  # level", so both contribute nothing rather than ending the walk.
  #
  # write_subfolder_metadata() writes zero-byte `_metadata.yml` files, which is
  # what makes this reachable from the package's own output. Note that Quarto
  # rejects such a file outright ("Directory metadata validation failed ... YAML
  # value is missing"), so tolerating them here is necessary but not sufficient
  # -- see the follow-up filed against that writer.
  if (!is.list(contents)) NULL else contents
}

#' Aggregate the `_metadata.yml` Inheritance Chain
#'
#' @description
#' Collects every `_metadata.yml` from the Quarto project root down to `path`
#' and merges them, so that a deeper folder overrides a shallower one. This is
#' the inheritance chain [setup_mesos()] writes — project, then wave, then
#' chapter — and the mechanism behind the `parameters` object that generated
#' chapters use.
#'
#' Quarto's own `params` cannot provide this: it resolves to the individual
#' `.qmd` file's YAML and carries no inheritance.
#'
#' @param path *Folder to resolve the chain for*
#'
#'   `scalar<character>` // *default:* `"."` (`optional`)
#'
#'   The folder to treat as the deepest level of the chain, normally the one
#'   holding the `.qmd` being rendered. The default is correct at render time:
#'   Quarto executes a document with the working directory set to that
#'   document's own folder unless the project sets `execute-dir: project`.
#'
#' @details
#' The walk is bounded by the Quarto project root — the nearest ancestor of
#' `path` holding a `_quarto.yml` or a `_quarto.yaml`. A `_metadata.yml` above
#' that root is not read. When no project file is found anywhere above `path`,
#' only `path` itself is read, so the walk can never escape into unrelated
#' folders.
#'
#' A folder without a `_metadata.yml` does not end the walk; it simply
#' contributes nothing. Neither does an empty or non-mapping one, which is what
#' [setup_mesos()] writes at intermediate levels.
#'
#' Both `_metadata.yml` and `_metadata.yaml` are read. In the unlikely event
#' that one folder holds both, `_metadata.yml` is merged first, so
#' `_metadata.yaml` wins.
#'
#' Merging is [utils::modifyList()], which descends into nested lists: a deeper
#' folder overriding `params$mesos_group` leaves its siblings under `params`
#' intact.
#'
#' @return A named `list` of the merged YAML, empty if nothing was found. The
#'   `params` element is the part generated chapters use.
#' @export
#'
#' @examples
#' project <- fs::path(tempdir(), "example_project")
#' fs::dir_create(fs::path(project, "Chapter"))
#' cat("project:\n  type: website\n", file = fs::path(project, "_quarto.yml"))
#' yaml::write_yaml(
#'   list(params = list(save = TRUE, wave = "2025")),
#'   file = fs::path(project, "_metadata.yml")
#' )
#' yaml::write_yaml(
#'   list(params = list(wave = "2026")),
#'   file = fs::path(project, "Chapter", "_metadata.yml")
#' )
#'
#' # The deeper `wave` wins; `save` is inherited from the project level.
#' aggregate_metadata_yml(fs::path(project, "Chapter"))$params
aggregate_metadata_yml <- function(path = ".") {
  if (!is_string(path)) {
    cli::cli_abort("{.arg path} must be a single string.")
  }
  if (!fs::dir_exists(path)) {
    cli::cli_abort("{.arg path} is not an existing folder: {.path {path}}")
  }
  path <- fs::path_norm(fs::path_abs(path))

  root <- find_quarto_project_root(path)
  dirs <- if (is.null(root)) path else directory_chain(root, path)

  out <- list()
  for (dir in dirs) {
    for (filename in c("_metadata.yml", "_metadata.yaml")) {
      contents <- read_metadata_file(fs::path(dir, filename))
      if (!is.null(contents)) {
        out <- utils::modifyList(out, contents)
      }
    }
  }
  out
}
