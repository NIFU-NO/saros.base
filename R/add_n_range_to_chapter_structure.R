#' Add Sample Size Range to Chapter Structure
#'
#' Takes `chapter_structure` and `data` and returns the `chapter_structure` with
#' an attached variable containing a string with the sample size-range (or
#' single value if min=max). Allows specifying the glue_template_1 (single value)
#' and glue_template_2 (for min and max values).
#'
#'
#' @param chapter_structure A grouped tibble. If not grouped, will give a warning
#' and continue with rowwise processing, which is unlikely what you want.
#'
#' @param data The raw data, with matching column names as in
#' `chapter_structure$.variable_name_dep`.
#'
#' @param glue_template_1,glue_template_2 Glue templates.
#' @param variable_name String, name of new variable to attach.
#' Defaults to ".n_range"
#'
#' @return chapter_structure with a new variable added. Grouped as before.
#'
add_n_range_to_chapter_structure <-
  function(chapter_structure, data,
           glue_template_1 = "{n}",
           glue_template_2 = "[{n[1]}-{n[2]}]",
           variable_name = ".n_range") {

    chapter_structure |>
      dplyr::group_map(.keep = TRUE, .f = ~{
        deps <- as.character(unique(.x$.variable_name_dep))
        deps <- deps[!is.na(deps)]
        n <-
          lapply(deps, function(v) {
            length(data[[v]][!is.na(data[[v]])])
          }) |>
          unlist()
        if(!is.null(n)) {
          n <-
            range(n, na.rm = TRUE) |>
            unique()
          if(all(is.na(n))) {
            .x[[variable_name]] <- 0
          } else {
            template <- if(length(n)==1) glue_template_1 else glue_template_2
            tryCatch(.x[[variable_name]] <-  glue::glue(template),
                     error = function(cnd) glue_err(cnd=cnd, arg_name="glue_template_*"))
          }

        }
        .x
      }) |>
      dplyr::bind_rows() |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(dplyr::group_vars(chapter_structure))))
  }

