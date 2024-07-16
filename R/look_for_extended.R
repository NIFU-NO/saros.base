
look_for_extended <- function(data,
                              cols = colnames(data),
                              label_separator = NULL,
                              name_separator = NULL) {
  ### Assume that related columns always have identical label prefix AND overlapping response categories.
  ### Assume that variables with identical label prefix may not be related.
  ### Assume that related columns are always next to each other OR share same variable name prefix.

  data_part <- data[,cols, drop=FALSE]
  if(ncol(data_part) == 0 || nrow(data_part) == 0) cli::cli_abort("data.frame is of 0 length.")


  .variable_position <- match(colnames(data_part), colnames(data))
  .variable_name <- colnames(data_part)
  .variable_label <- get_raw_labels(data = data_part)
  .variable_type <- as.character(unlist(lapply(names(data_part), function(.x) vctrs::vec_ptype_abbr(data_part[[.x]]))))
  if(length(.variable_position) != length(.variable_name) ||
     length(.variable_name) != length(.variable_label) ||
     length(.variable_label) != length(.variable_type)) browser()

  x <- data.frame(.variable_position = .variable_position,
                  .variable_name = .variable_name,
                  .variable_label = .variable_label,
                  .variable_type = .variable_type,
                  row.names = NULL
  )
  check_duplicates <- duplicated(x$.variable_label)
  if(any(check_duplicates)) {
    duplicates <- unique(x$.variable_label[check_duplicates])
    cli::cli_warn(c(i="Found duplicated variable labels, which will likely cause problems if you only group on variable_label(_prefix):"))
    cli::cli_ul(duplicates)
  }

  if(is.character(name_separator)) {
    if(is.character(names(name_separator)) &&
       all(c(".variable_name_prefix", ".variable_name_suffix") %in% names(name_separator))) {
      x <-
        tidyr::separate_wider_regex(x,
                                    cols = ".variable_name",
                                    patterns = name_separator,
                                    cols_remove = FALSE,
                                    too_few = "align_start")
      # if(sum(stringi::stri_count_fixed(str = x$.variable_name_suffix, pattern = name_separator), na.rm=TRUE) > 0) {
      #   cli::cli_warn(c("{.arg name_separator} matches more than one delimiter, your output is likely ugly.",
      #                   i="Consider renaming your variables with e.g. {.fun dplyr::rename_with()}."))
      # }


    } else if(is_string(name_separator) &&
              is.null(names(name_separator))) {
      x <-
        tidyr::separate_wider_delim(x,
                                    cols = ".variable_name",
                                    delim = name_separator,
                                    names = c(".variable_name_prefix", ".variable_name_suffix"),
                                    cols_remove = FALSE,
                                    too_few = "align_end",
                                    too_many = "merge")
      if(sum(stringi::stri_count_fixed(str = x$.variable_name_suffix, pattern = name_separator), na.rm=TRUE) > 0) {
        cli::cli_warn(c("{.arg name_separator} matches more than one delimiter, your output is likely ugly.",
                        i="Consider renaming your variables with e.g. {.fun dplyr::rename_with()}."))
      }

    } else cli::cli_abort("Unrecognizable {.arg name_separator}: {name_separator}.")


  } else {
    x$.variable_name_prefix <- x$.variable_name
    x$.variable_name_suffix <- x$.variable_name
  }

  if(is.character(label_separator)) {
    separator_fun <-
      if(is.character(names(label_separator)) &&
         all(c(".variable_label_prefix", ".variable_label_suffix") %in% names(label_separator))) {
        x <-
          tidyr::separate_wider_regex(x,
                                      cols = ".variable_label",
                                      patterns = label_separator,
                                      cols_remove = FALSE,
                                      too_few = "align_start")

      } else if(is_string(label_separator) &&
                is.null(names(label_separator))) {
        x <-
          tidyr::separate_wider_delim(x,
                                      cols = ".variable_label",
                                      delim = label_separator,
                                      names = c(".variable_label_prefix", ".variable_label_suffix"),
                                      cols_remove = FALSE,
                                      too_few = "align_end",
                                      too_many = "merge")
        if(sum(stringi::stri_count_fixed(str = x$.variable_label_suffix, pattern = label_separator), na.rm=TRUE) > 0) {
          cli::cli_warn(c("{.arg label_separator} matches more than one delimiter, your output is likely ugly.",
                          i="Consider renaming your variables with e.g. {.fun labelled::set_variable_labels}."))
        }
      } else cli::cli_abort("Unrecognizable {.arg label_separator}: {label_separator}.")


  } else {
    x$.variable_label_prefix <- x$.variable_label
    x$.variable_label_suffix <- x$.variable_label
  }

  grouping_vars <-
    c(if(!is.null(label_separator)) ".variable_label_prefix",
      if(!is.null(name_separator)) ".variable_name_prefix")

  x |>
    dplyr::mutate(

      .variable_name_prefix = dplyr::if_else(
        is.na(.data$.variable_name_prefix) & !is.na(.data$.variable_name_suffix),
        .data$.variable_name_suffix,
        .data$.variable_name_prefix),


      .variable_name_suffix = dplyr::if_else(
        is.na(.data$.variable_name_suffix) & !is.na(.data$.variable_name_prefix),
        .data$.variable_name_prefix,
        .data$.variable_name_suffix),

      .variable_label_prefix = dplyr::if_else(
        is.na(.data$.variable_label_prefix) & !is.na(.data$.variable_label_suffix),
        .data$.variable_label_suffix,
        .data$.variable_label_prefix),

      .variable_label_suffix = dplyr::if_else(
        is.na(.data$.variable_label_suffix) & !is.na(.data$.variable_label_prefix),
        .data$.variable_label_prefix,
        .data$.variable_label_suffix),

    ) |>
    dplyr::relocate(tidyselect::any_of(c(".variable_position", ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
                                         ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
                                         ".variable_type"))) |>
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
