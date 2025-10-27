# Helper function to split variable names or labels using separator
split_by_separator <- function(x, col_name, separator,
                               prefix_name, suffix_name,
                               context = "variable") {
  if (!is.character(separator)) {
    # No separator - use the same value for both prefix and suffix
    x[[prefix_name]] <- x[[col_name]]
    x[[suffix_name]] <- x[[col_name]]
    return(x)
  }

  if (is.character(names(separator)) &&
    all(c(prefix_name, suffix_name) %in% names(separator))) {
    # Named separator pattern (regex)
    x <- tidyr::separate_wider_regex(x,
      cols = tidyselect::all_of(col_name),
      patterns = separator,
      cols_remove = FALSE,
      too_few = "align_start"
    )
  } else if (is_string(separator) && is.null(names(separator))) {
    # Simple string delimiter
    x <- tidyr::separate_wider_delim(x,
      cols = tidyselect::all_of(col_name),
      delim = separator,
      names = c(prefix_name, suffix_name),
      cols_remove = FALSE,
      too_few = "align_end",
      too_many = "merge"
    )

    # Warn if separator appears multiple times
    if (sum(stringi::stri_count_fixed(
      str = x[[suffix_name]],
      pattern = separator
    ), na.rm = TRUE) > 0) {
      suggestion <- if (context == "variable") {
        "Consider renaming your variables with e.g. {.fun dplyr::rename_with()}."
      } else {
        "Consider renaming your variables with e.g. {.fun labelled::set_variable_labels}."
      }
      cli::cli_warn(c(
        "{.arg {context}_separator} matches more than one delimiter, your output is likely ugly.",
        i = suggestion
      ))
    }
  } else {
    cli::cli_abort("Unrecognizable {.arg {context}_separator}: {separator}.")
  }

  return(x)
}

# Helper function to fill missing prefix/suffix values
fill_missing_prefix_suffix <- function(x) {
  x |>
    dplyr::mutate(
      .variable_name_prefix = dplyr::if_else(
        is.na(.data$.variable_name_prefix) & !is.na(.data$.variable_name_suffix),
        .data$.variable_name_suffix,
        .data$.variable_name_prefix
      ),
      .variable_name_suffix = dplyr::if_else(
        is.na(.data$.variable_name_suffix) & !is.na(.data$.variable_name_prefix),
        .data$.variable_name_prefix,
        .data$.variable_name_suffix
      ),
      .variable_label_prefix = dplyr::if_else(
        is.na(.data$.variable_label_prefix) & !is.na(.data$.variable_label_suffix),
        .data$.variable_label_suffix,
        .data$.variable_label_prefix
      ),
      .variable_label_suffix = dplyr::if_else(
        is.na(.data$.variable_label_suffix) & !is.na(.data$.variable_label_prefix),
        .data$.variable_label_prefix,
        .data$.variable_label_suffix
      )
    )
}

get_variable_types <- function(data, cols) {
  as.character(unlist(lapply(cols, function(.x) vctrs::vec_ptype_abbr(data[[.x]]))))
}

look_for_extended <- function(data,
                              cols = colnames(data),
                              label_separator = NULL,
                              name_separator = NULL) {
  ### Assume that related columns always have identical label prefix AND overlapping response categories.
  ### Assume that variables with identical label prefix may not be related.
  ### Assume that related columns are always next to each other OR share same variable name prefix.

  data_part <- data[, cols, drop = FALSE]
  if (ncol(data_part) == 0 || nrow(data_part) == 0) cli::cli_abort("data.frame is of 0 length.")


  .variable_position <- match(colnames(data_part), colnames(data))

  .variable_name <- colnames(data_part)
  .variable_label <- get_raw_labels(data = data_part)
  .variable_type <- get_variable_types(data = data_part, cols = names(data_part))
  if (length(.variable_position) != length(.variable_name) ||
    length(.variable_name) != length(.variable_label) ||
    length(.variable_label) != length(.variable_type)) {
    browser()
  }

  x <- data.frame(
    .variable_position = .variable_position,
    .variable_name = .variable_name,
    .variable_label = .variable_label,
    .variable_type = .variable_type,
    row.names = NULL
  )

  # Split variable names by separator
  x <- split_by_separator(x,
    col_name = ".variable_name",
    separator = name_separator,
    prefix_name = ".variable_name_prefix",
    suffix_name = ".variable_name_suffix",
    context = "name"
  )

  # Split variable labels by separator
  x <- split_by_separator(x,
    col_name = ".variable_label",
    separator = label_separator,
    prefix_name = ".variable_label_prefix",
    suffix_name = ".variable_label_suffix",
    context = "label"
  )

  # Fill missing prefix/suffix values
  x <- fill_missing_prefix_suffix(x)

  # Return organized data frame
  x |>
    dplyr::relocate(tidyselect::any_of(c(
      ".variable_position", ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
      ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
      ".variable_type"
    ))) |>
    as.data.frame()

  ### Return a grouped data frame with
  ### main question variable name prefix,
  ### main question variable label (prefix),
  ### subquestion variable name suffix,
  ### subquestion variable label (suffix)
  ### var_group,
  ### .variable_type,
  ### .variable_role, designated_type, uni_bi_variate,
}
