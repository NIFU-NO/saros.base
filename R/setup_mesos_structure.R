#' Create directory structure for mesos reports (improved version)
#'
#' This is an improved, easier-to-use version of [setup_mesos()]. It creates the
#' directory structure, QMD stub files, and YAML metadata files needed for mesos
#' (multi-group) reports without requiring manual working directory management.
#'
#' @param main_directory String. Path to where the structure will be created. Can be
#'   an absolute path or relative path. The path will be created if it doesn't exist.
#'   Unlike [setup_mesos()], this parameter is required and has no default to avoid
#'   accidental file creation in unexpected locations.
#' @param files_to_process Character vector of paths to template QMD files to use
#'   as the basis for creating stub files. These files should typically have
#'   filenames starting with underscore (e.g., `_report.qmd`).
#' @param mesos_groups A named list or data frame specifying the grouping structure.
#'   - If a **named list**: names are mesos variable names, values are character
#'     vectors of group names. Example: `list(region = c("North", "South", "East"))`
#'   - If a **data frame**: Use the same format as [setup_mesos()] - a list of
#'     single-column data frames with optional variable labels.
#' @param mesos_var_subfolder Optional character vector. Subfolder path(s) within
#'   each mesos variable folder where group folders should be placed. Default is
#'   no subfolder (empty character vector).
#' @param files_taking_title Character vector of filenames that should receive
#'   title metadata. Default is `c("index.qmd", "report.qmd")`.
#' @param subtitle_separator String or NULL. If a string, adds title and subtitle
#'   fields to `_metadata.yml` files in the deepest child folders. The subtitle
#'   is a concatenation of the output directory basename, mesos variable label,
#'   and group name. Default is `" - "`. Set to `NULL` to disable.
#' @param include_prefix,include_suffix Strings for the include directive in stub
#'   QMD files. Default creates Quarto-style includes: `{{< include "..." >}}`
#'
#' @return Invisibly returns a list with information about created files.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Simple example with a named list
#' setup_mesos_structure(
#'   main_directory = "reports/2024",
#'   files_to_process = c("_report.qmd", "_index.qmd"),
#'   mesos_groups = list(
#'     region = c("North", "South", "East", "West"),
#'     department = c("Sales", "Marketing", "IT")
#'   )
#' )
#'
#' # With subfolder and custom labels
#' setup_mesos_structure(
#'   main_directory = "./output",
#'   files_to_process = "_analysis.qmd",
#'   mesos_groups = list(
#'     country = c("Norway", "Sweden", "Denmark")
#'   ),
#'   mesos_var_subfolder = "reports/Q1"
#' )
#' }
setup_mesos_structure <- function(
    main_directory,
    files_to_process,
    mesos_groups,
    mesos_var_subfolder = character(),
    files_taking_title = c("index.qmd", "report.qmd"),
    subtitle_separator = " - ",
    include_prefix = '{{< include \"',
    include_suffix = '\" >}}') {
  ## Input validation

  # Validate main_directory
  if (missing(main_directory) || !rlang::is_string(main_directory)) {
    cli::cli_abort("{.arg main_directory} is required and must be a single string path.")
  }

  # Normalize to absolute path to avoid reliance on working directory
  main_directory <- normalizePath(main_directory, mustWork = FALSE, winslash = "/")

  # Validate files_to_process
  if (missing(files_to_process) || !is.character(files_to_process) || length(files_to_process) == 0) {
    cli::cli_abort("{.arg files_to_process} is required and must be a character vector of file paths.")
  }

  # Normalize template file paths
  files_to_process <- normalizePath(files_to_process, mustWork = TRUE, winslash = "/")

  # Check files exist
  missing_files <- files_to_process[!file.exists(files_to_process)]
  if (length(missing_files) > 0) {
    cli::cli_abort(c(
      "{.arg files_to_process} contains paths to files that don't exist:",
      "x" = "{missing_files}"
    ))
  }

  # Check for underscore prefix in template files
  check_files <- stringi::stri_extract_last_regex(files_to_process, pattern = "/[^_/\\\\]+$")
  check_files <- check_files[!is.na(check_files)]
  if (length(check_files) > 0) {
    cli::cli_warn(c(
      "!" = "Template files are expected to have filenames starting with underscore for most mesos setups.",
      "i" = "These files do not: {check_files}"
    ))
  }

  # Validate and convert mesos_groups
  if (missing(mesos_groups)) {
    cli::cli_abort("{.arg mesos_groups} is required.")
  }

  mesos_df <- convert_mesos_groups_to_df(mesos_groups)

  # Validate other parameters
  if (!inherits(files_taking_title, "character")) {
    cli::cli_abort("{.arg files_taking_title} must be a character vector, not {.obj_type_friendly {files_taking_title}}")
  }
  if (!rlang::is_string(include_prefix)) {
    cli::cli_abort("{.arg include_prefix} must be a string, not {.obj_type_friendly {include_prefix}}")
  }
  if (!rlang::is_string(include_suffix)) {
    cli::cli_abort("{.arg include_suffix} must be a string, not {.obj_type_friendly {include_suffix}}")
  }

  ## Create the structure

  cli::cli_alert_info("Creating mesos structure in {.path {main_directory}}")

  create_mesos_stubs_from_main_files(
    mesos_df = mesos_df,
    main_directory = main_directory,
    mesos_var_subfolder = mesos_var_subfolder,
    files_to_process = files_to_process,
    files_taking_title = files_taking_title,
    subtitle_separator = subtitle_separator,
    prefix = include_prefix,
    suffix = include_suffix
  )

  cli::cli_alert_success("Mesos structure created successfully")

  invisible(list(
    main_directory = main_directory,
    files_to_process = files_to_process,
    mesos_df = mesos_df
  ))
}


#' Convert mesos_groups to internal data frame format
#'
#' @param mesos_groups Named list or data frame
#' @return List of single-column data frames (internal format)
#' @keywords internal
convert_mesos_groups_to_df <- function(mesos_groups) {
  # If already in the old format (list of data frames), validate and return
  if (is.list(mesos_groups) && all(sapply(mesos_groups, is.data.frame))) {
    # Validate structure
    for (i in seq_along(mesos_groups)) {
      if (ncol(mesos_groups[[i]]) == 0) {
        cli::cli_abort(c(
          "Data frame {i} in {.arg mesos_groups} has no columns.",
          "i" = "Each data frame should have 1-2 columns: group names (required) and abbreviations (optional)."
        ))
      }
    }
    return(mesos_groups)
  }

  # If it's a simple named list, convert to data frame format
  if (is.list(mesos_groups) && !is.data.frame(mesos_groups)) {
    if (is.null(names(mesos_groups)) || any(names(mesos_groups) == "")) {
      cli::cli_abort(c(
        "{.arg mesos_groups} must be a named list.",
        "i" = "Example: list(region = c('North', 'South'), department = c('Sales', 'IT'))"
      ))
    }

    result <- lapply(names(mesos_groups), function(var_name) {
      groups <- mesos_groups[[var_name]]

      if (!is.character(groups) || length(groups) == 0) {
        cli::cli_abort(c(
          "Value for {.field {var_name}} in {.arg mesos_groups} must be a non-empty character vector.",
          "i" = "Got: {.obj_type_friendly {groups}}"
        ))
      }

      # Create single-column data frame with group names
      # extract_mesos_metadata will auto-generate abbreviations from the group names
      df <- data.frame(groups, stringsAsFactors = FALSE)
      names(df) <- var_name

      # Set variable label attribute to use the variable name as pretty name
      attr(df[[1]], "label") <- var_name

      df
    })

    return(result)
  }

  # If it's a single data frame, convert to list of data frames
  if (is.data.frame(mesos_groups)) {
    if (ncol(mesos_groups) == 0) {
      cli::cli_abort("{.arg mesos_groups} data frame has no columns.")
    }

    # Treat each column as a mesos variable
    result <- lapply(seq_len(ncol(mesos_groups)), function(i) {
      col_data <- mesos_groups[[i]]
      col_name <- names(mesos_groups)[i]

      # Remove NAs
      col_data <- col_data[!is.na(col_data)]

      if (length(col_data) == 0) {
        cli::cli_warn("Column {.field {col_name}} in {.arg mesos_groups} has no non-NA values and will be skipped.")
        return(NULL)
      }

      df <- data.frame(group = as.character(col_data), stringsAsFactors = FALSE)
      names(df) <- col_name

      # Preserve label if it exists
      label <- attr(mesos_groups[[i]], "label")
      if (!is.null(label)) {
        attr(df[[1]], "label") <- label
      } else {
        attr(df[[1]], "label") <- col_name
      }

      df
    })

    # Remove NULL entries
    result <- result[!sapply(result, is.null)]

    return(result)
  }

  cli::cli_abort(c(
    "{.arg mesos_groups} must be one of:",
    "*" = "A named list (e.g., list(region = c('North', 'South')))",
    "*" = "A data frame with columns representing mesos variables",
    "*" = "A list of single-column data frames (legacy format from setup_mesos)",
    "i" = "Got: {.obj_type_friendly {mesos_groups}}"
  ))
}
