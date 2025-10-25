# Helper: Check if argument is a scalar finite numeric
is_scalar_finite_doubleish <- function(x) {
  is.numeric(x) && length(x) == 1 && is.finite(x)
}

# Helper: Check if argument is a boolean
is_bool <- function(x) {
  is.logical(x) && length(x) == 1 && !is.na(x)
}

# Helper: Create argument validator with default values
create_arg_validator <- function(env) {
  function(target, param_name, validation_fun) {
    if (!validation_fun(target[[param_name]])) {
      default <- env[[param_name]]
      cli::cli_abort(c("{.arg {param_name}} is invalid (it is {.obj_type_friendly {target[[param_name]]}}, and specified as {target[[param_name]]}).",
        i = "Consider default: {default}.",
        i = "Argument failed the test of {.fun {deparse(validation_fun)[2]}}."
      ))
    } else {
      target[[param_name]]
    }
  }
}

# Helper: Get validation rules for all parameters
get_arg_validation_rules <- function(params) {
  list(
    # Data frames
    chapter_overview = list(fun = function(x) inherits(x, "data.frame") && nrow(x) > 0),
    data = list(fun = function(x) is.null(x) || inherits(x, "data.frame") || inherits(x, "survey")),
    chunk_templates = list(fun = function(x) is.null(x) || inherits(x, "data.frame")),

    # Character vectors (not enums)
    label_separator = list(fun = function(x) is.null(x) || is.character(x)),
    name_separator = list(fun = function(x) is.null(x) || is.character(x)),
    sep_obj = list(fun = function(x) is_string(x)),
    sep_chunk = list(fun = function(x) is_string(x)),
    sep_file = list(fun = function(x) is_string(x)),
    filename_prefix = list(fun = function(x) is_string(x)),
    always_show_bi_for_indep = list(fun = function(x) is.null(x) || (is.character(x) && all(x %in% colnames(params$data)))),
    variables_show_bi_for_by = list(fun = function(x) is.null(x) || (is.character(x) && all(x %in% colnames(params$data)))),
    n_range_glue_template_1 = list(fun = function(x) is_string(x)),
    n_range_glue_template_2 = list(fun = function(x) is_string(x)),
    variable_group_dep = list(fun = function(x) is_string(x)),
    variable_group_prefix = list(fun = function(x) is.null(x) || is_string(x)),
    log_file = list(fun = function(x) is.null(x) || is_string(x)),

    # Boolean
    hide_variable_if_all_na = list(fun = is_bool),
    keep_dep_indep_if_no_overlap = list(fun = is_bool),
    na_first_in_section = list(fun = is_bool),
    progress = list(fun = is_bool),

    # Numeric and integer
    hide_bi_entry_if_sig_above = list(fun = function(x) is_scalar_finite_doubleish(x) && x >= 0 && x <= 1),
    hide_chunk_if_n_below = list(fun = function(x) rlang::is_scalar_integerish(x) && x >= 0),
    single_y_bivariates_if_indep_cats_above = list(fun = function(x) length(x) == 1 && (rlang::is_scalar_integerish(x) && x >= 0) || is.na(x)),
    single_y_bivariates_if_deps_above = list(fun = function(x) length(x) == 1 && (rlang::is_scalar_integerish(x) && x >= 0) || is.na(x)),
    max_width_file = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE) && x >= 8),
    max_width_obj = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE) && x >= 8),
    max_width_chunk = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE) && x >= 8),
    max_width_folder_name = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE) && x >= 8),

    # Enums
    organize_by = list(fun = function(x) is.character(x)), # BETTER CHECKS NEEDED
    arrange_section_by = list(fun = function(x) {
      is.null(x) || is.character(x) || (is.logical(x) && rlang::is_named(x))
    })
  )
}

# Helper: Validate organize_by and arrange_section_by parameters
validate_organize_arrange_params <- function(params) {
  if (!all(c(".template_name") %in% params$organize_by)) {
    cli::cli_abort(c("{.arg organize_by} must contain {.var {c('.template_name')}}.",
      i = "You provided {.arg {params$organize_by}}."
    ))
  }
  if (!all(params$organize_by %in% .saros.env$core_chapter_structure_cols)) {
    cli::cli_abort(c("{.arg organize_by} is not valid. Must be one or more of {(.saros.env$core_chapter_structure_cols)}.",
      i = "You provided {.arg {params$organize_by}}."
    ))
  }
  # Note: arrange_section_by validation is deferred until arrange_arrangers_and_groups()
  # is called, as it can include any column in the final output dataframe
}

# Helper: Validate chapter_overview parameter
validate_chapter_overview_param <- function(params) {
  if (all(.saros.env$core_chapter_structure_cols %in% names(params$chapter_overview))) {
    cli::cli_abort("{.arg chapter_overview} is already converted to a chapter_structure.")
  }
  if (is.null(params$chapter_overview) && is.null(params$data)) {
    cli::cli_abort("You must provide at least {.arg chapter_overview} or {.arg data}.")
  }
  if (!is.null(params$chapter_overview) &&
    !any(colnames(params$chapter_overview) %in% c("chapter", "dep"))) {
    cli::cli_abort("{.arg chapter_overview} must at least contain columns {.var {c('chapter', 'dep')}} (and optionally {.var indep}).")
  }
  if (is.null(params$chapter_overview)) {
    cli::cli_warn("{.arg chapter_overview} is NULL, placing all variables in {.arg data} in a {.val All} chapter.")
    params$chapter_overview <- data.frame(chapter = "All", dep = "everything()")
  }

  params
}

validate_refine_chapter_overview_args <- function(params) {
  # Check for unwanted arguments
  unwanted_args <- names(params)[!names(params) %in% c(names(formals(refine_chapter_overview)))]
  if (length(unwanted_args) > 0) cli::cli_abort("{.arg {unwanted_args}} are not recognized valid arguments.")

  # Get default values and create validator
  env <- lapply(formals(refine_chapter_overview)[!names(formals(refine_chapter_overview)) %in% .saros.env$ignore_args], eval)
  check_and_abort <- create_arg_validator(env)

  # Get validation rules and validate all parameters
  arg_params <- get_arg_validation_rules(params)
  for (par in names(arg_params)) {
    params[[par]] <-
      check_and_abort(
        target = params,
        param_name = par,
        validation_fun = arg_params[[par]]$fun
      )
  }

  # Validate chunk templates
  params$chunk_templates <- validate_chunk_templates(params$chunk_templates)

  # Validate organize_by and arrange_section_by
  validate_organize_arrange_params(params)

  # Validate chapter_overview and return
  validate_chapter_overview_param(params)
}
