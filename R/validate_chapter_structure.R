# Validation helper: Check input types
validate_input_types <- function(chapter_structure, data) {
  if (!inherits(chapter_structure, "data.frame")) {
    cli::cli_abort("{.arg chapter_structure} must be of type data.frame, not {.obj_type_friendly {chapter_structure}}.")
  }

  if (!is.null(data) && !(inherits(data, "data.frame") || inherits(data, "survey"))) {
    cli::cli_abort("{.arg data} must be of type data.frame or survey-object, not {.obj_type_friendly {data}}.")
  }
}

# Validation helper: Check core columns exist
validate_core_columns <- function(chapter_structure, core_chapter_structure_cols) {
  missing_core_columns <-
    core_chapter_structure_cols[!core_chapter_structure_cols %in% colnames(chapter_structure)]

  if (length(missing_core_columns) > 0) {
    cli::cli_abort("{.arg chapter_structure} is missing {.var {missing_core_columns}}.")
  }

  if (length(grep(x = colnames(chapter_structure), pattern = .saros.env$core_chapter_structure_pattern)) < 2) {
    cli::cli_warn("{.arg chapter_structure} seems to be missing at least 2 columns for {(.saros.env$core_chapter_structure_pattern)}.")
  }
}

# Validation helper: Check variables exist in data
validate_variables_in_data <- function(chapter_structure, data) {
  if (is.null(data)) {
    return(invisible(TRUE))
  }

  data_cols <- if (inherits(data, "survey")) colnames(data$variables) else colnames(data)

  # Check dependent variables
  missing_dep_in_data <- unique(chapter_structure[[".variable_name_dep"]])
  missing_dep_in_data <- missing_dep_in_data[!missing_dep_in_data %in% c(data_cols, NA)]

  if (length(missing_dep_in_data) > 0) {
    cli::cli_abort(c("{.arg chapter_structure} has variables in its {.var dep}-column not found in {.arg data}.",
      i = "Problems with: {.var {missing_dep_in_data}}."
    ))
  }

  # Check independent variables
  missing_indep_in_data <- unique(chapter_structure[[".variable_name_indep"]])
  missing_indep_in_data <- missing_indep_in_data[!missing_indep_in_data %in% c(data_cols, NA)]

  if (length(missing_indep_in_data) > 0) {
    cli::cli_abort(c("{.arg chapter_structure} has variables in its {.var indep}-column not found in {.arg data}.",
      i = "Problems with: {.var {missing_indep_in_data}}."
    ))
  }
}

# Validation helper: Check chapter_structure is not empty
validate_not_empty <- function(chapter_structure) {
  if (nrow(chapter_structure) == 0) {
    cli::cli_abort(c(
      x = "{.var chapter_structure} is empty, which is odd.",
      i = "Are there no factors in your data? Consider `chapter_structure=NULL` for all output in a single phantom chapter"
    ))
  }
}

# Validation helper: Check grouping variables exist
validate_grouping <- function(chapter_structure) {
  grouping_structure <- dplyr::group_vars(chapter_structure)

  if (length(grouping_structure) == 0) {
    cli::cli_abort(c(
      "!" = "No grouping variables found in {.arg chapter_structure}.",
      "x" = "Without grouping variables, groups of variables for contents in {.arg elements} cannot be identified",
      "i" = "Use {.fun refine_chapter_overview()} and grouping-arguments to set such groups."
    ))
  }
}

# Validation helper: Check for dep/indep conflicts within chapters
validate_chapter_conflicts <- function(chapter_structure) {
  chapter_structure |>
    dplyr::grouped_df(vars = "chapter") |>
    dplyr::group_map(
      .keep = TRUE,
      .f = ~ {
        deps <- as.character(.x[[".variable_name_dep"]])
        indeps <- as.character(.x[[".variable_name_indep"]])
        doubles <- deps[deps %in% indeps & !is.na(deps)]
        if (length(doubles) > 0) {
          cli::cli_abort(c("Variable(s) cannot be both dependent and independent in same chapter.",
            i = "Problem with: {.var {doubles}}."
          ))
        }
      }
    )

  if (any(is.na(chapter_structure[["chapter"]]))) {
    cli::cli_abort("{.arg chapter_structure} cannot contain NA on the {.arg chapter}-variable, as this is the main ID used for creating chapter QMDs.")
  }
}

# Validation helper: Complex group-level consistency checks
validate_group_consistency <- function(chapter_structure) {
  chapter_structure |>
    dplyr::group_map(
      .keep = TRUE,
      .f = ~ {
        # Check for NA patterns
        if (all(!is.na(.x[["chapter"]])) &&
          nrow(.x) > 1 &&
          all(is.na(.x[[".variable_name_dep"]]))) {
          cli::cli_abort("{.arg chapter_structure} contains multiple rows for a group with all chapter and variable_name_dep columns NA.")
        }
        if (any(is.na(as.character(.x[[".variable_name_dep"]]))) &&
          !all(is.na(as.character(.x[[".variable_name_dep"]])))) {
          cli::cli_abort("{.arg chapter_structure} cannot contain {.var (.variable_name_dep)} both NA and non-NA.")
        }

        # Check label consistency
        if (dplyr::n_distinct(.x[[".variable_label_prefix_dep"]], na.rm = FALSE) != 1) {
          cli::cli_warn(c("{.arg chapter_structure} has dependent variables containing multiple variable labels:",
            i = "Vars: {unique(.x[['.variable_name_dep']])}",
            i = "Labels: {unique(.x[['.variable_label_prefix_dep']])}."
          ))
        }

        # Check variable type compatibility - dependent variables
        if (any(unique(.x[[".variable_type_dep"]]) %in% c("fct", "ord")) &&
          any(unique(.x[[".variable_type_dep"]]) %in% c("int", "dbl", "chr"))) {
          cli::cli_abort("{.arg chapter_structure} cannot handle combinations of factor/ordinal and integer/numeric/character dependent variables in same section.")
        }
        if (any(unique(.x[[".variable_type_dep"]]) %in% c("int", "dbl")) &&
          any(unique(.x[[".variable_type_dep"]]) %in% c("chr"))) {
          cli::cli_abort("{.arg chapter_structure} cannot handle combinations of integer/numeric and character dependent variables in same section.")
        }

        # Check variable type compatibility - independent variables
        if (any(unique(.x[[".variable_type_indep"]]) %in% c("fct", "ord")) &&
          any(unique(.x[[".variable_type_indep"]]) %in% c("int", "dbl", "chr"))) {
          cli::cli_abort("{.arg chapter_structure} cannot handle combinations of factor/ordinal and integer/numeric/character independent variables in same section.")
        }
        if (any(unique(.x[[".variable_type_indep"]]) %in% c("int", "dbl")) &&
          any(unique(.x[[".variable_type_indep"]]) %in% c("chr"))) {
          cli::cli_abort("{.arg chapter_structure} cannot handle combinations of integer/numeric and character independent variables in same section.")
        }

        # Warn about type variations
        if (dplyr::n_distinct(.x[[".variable_type_dep"]], na.rm = FALSE) != 1) {
          cli::cli_warn(c("{.arg chapter_structure} has dependent variables containing multiple variable types. Assuming these are equivalent. Check your output.",
            i = "Vars: {unique(.x$.variable_name_dep)}",
            i = "Labels: {unique(.x$.variable_type_dep)}."
          ))
        }
        if (dplyr::n_distinct(.x[[".variable_type_indep"]], na.rm = FALSE) != 1) {
          cli::cli_warn(c("{.arg chapter_structure} has independent variables containing multiple variable types. Assuming these are equivalent. Check your output.",
            i = "Vars: {unique(.x$.variable_name_indep)}",
            i = "Labels: {unique(.x$.variable_type_indep)}."
          ))
        }

        # Check template consistency
        if (dplyr::n_distinct(.x[[".template_name"]], na.rm = TRUE) != 1 &&
          !all(is.na(.x[[".template_name"]]))) {
          cli::cli_abort("Each {.arg chapter_structure} section must contain only one kind of {.var .template_name}. Problem with {unique(.x$.template_name)}.")
        }
      }
    )
}

validate_chapter_structure <- function(chapter_structure, data = NULL,
                                       core_chapter_structure_cols = .saros.env$core_chapter_structure_cols) {
  # ENSURE THAT .template_name, chapter etc are part of goruping_sturcture?

  validate_input_types(chapter_structure, data)
  validate_core_columns(chapter_structure, core_chapter_structure_cols)
  validate_variables_in_data(chapter_structure, data)
  validate_not_empty(chapter_structure)
  validate_grouping(chapter_structure)
  validate_chapter_conflicts(chapter_structure)
  validate_group_consistency(chapter_structure)

  TRUE
}
