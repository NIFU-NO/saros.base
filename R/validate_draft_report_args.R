validate_draft_report_args <- function(params) {
  if (!"data" %in% names(params) || is.null(params$data)) cli::cli_abort("{.arg data} argument must be provided.")

  unwanted_args <- names(params)[!names(params) %in% c(names(formals(draft_report)))]
  if (length(unwanted_args) > 0) cli::cli_abort("{.arg {unwanted_args}} are not recognized valid arguments.")

  env <- lapply(formals(draft_report)[!names(formals(draft_report)) %in% .saros.env$ignore_args], eval)
  check_and_set_default <- function(target,
                                    param_name,
                                    validation_fun) {
    if (!validation_fun(target[[param_name]])) {
      default <- env[[param_name]]
      cli::cli_warn(paste0("{.arg {(param_name)}} is invalid (it is {.obj_type_friendly {target[[param_name]]}}, and specified as {target[[param_name]]}). Using default: {default}"))
      default
    } else {
      target[[param_name]]
    }
  }
  is_scalar_finite_doubleish <- function(x) {
    is.numeric(x) && length(x) == 1 && is.finite(x)
  }
  is_bool <- function(x) is.logical(x) && length(x) == 1 && !is.na(x)

  core_chapter_structure_cols <-
    .saros.env$core_chapter_structure_cols


  arg_params <-
    list(
      # Data frames
      data = list(fun = function(x) inherits(x, "data.frame") || inherits(x, "survey")),
      chapter_structure = list(fun = function(x) validate_chapter_structure(x, core_chapter_structure_cols = core_chapter_structure_cols)),

      # Character vectors (not enums)
      auxiliary_variables = list(fun = function(x) is.null(x) || (is.character(x) && all(x %in% colnames(params$data)))),
      path = list(fun = function(x) is_string(x)),
      chapter_yaml_file = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      index_yaml_file = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      report_yaml_file = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      chapter_qmd_start_section_filepath = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      chapter_qmd_end_section_filepath = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      index_qmd_start_section_filepath = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      index_qmd_end_section_filepath = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      report_qmd_start_section_filepath = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      report_qmd_end_section_filepath = list(fun = function(x) is.null(x) || (is_string(x) && file.exists(x))),
      index_filename = list(fun = function(x) is_string(x) || is.null(x)),
      report_filename = list(fun = function(x) is_string(x) || is.null(x)),
      ignore_heading_for_group = list(fun = function(x) is.null(x) || is.character(x) && !rlang::is_named(x)),
      replace_heading_for_group = list(fun = function(x) is.null(x) || (is.character(x) && rlang::is_named(x) && sum(duplicated(names(x))) == 0)),
      prefix_heading_for_group = list(fun = function(x) is.null(x) || (is.character(x) && rlang::is_named(x) && sum(duplicated(names(x))) == 0)),
      suffix_heading_for_group = list(fun = function(x) is.null(x) || (is.character(x) && rlang::is_named(x) && sum(duplicated(names(x))) == 0)),
      filename_prefix = list(fun = function(x) is_string(x) || is.null(x)),
      data_filename_prefix = list(fun = function(x) is_string(x) || is.null(x)),
      log_file = list(fun = function(x) is.null(x) || is_string(x)),


      # Boolean
      attach_chapter_dataset = list(fun = is_bool),
      require_common_categories = list(fun = is_bool),
      combined_report = list(fun = is_bool),

      # Numeric and integer
      # hide_chunk_if_n_below = list(fun = function(x) rlang::is_scalar_integerish(x) && x >= 0),

      # Enums
      serialized_format = list(fun = function(x) is.character(x) && any(env$serialized_format == x[1]))
    )

  for (par in names(arg_params)) {
    params[[par]] <-
      check_and_set_default(
        target = params,
        param_name = par,
        validation_fun = arg_params[[par]]$fun
      )
  }

  params$serialized_format <- params$serialized_format[1]


  pkg <- switch(params$serialized_format,
    "qs" = "qs",
    "rds" = "base"
  )
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cli::cli_abort("Needs {.pkg {pkg}} to use {.arg serialized_format}={params$serialized_format}: {.run [install.packages(pkg)](install.packages())}")
  }

  params
}
