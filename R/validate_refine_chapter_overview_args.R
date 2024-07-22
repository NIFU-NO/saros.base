validate_refine_chapter_overview_args <- function(params) {

  unwanted_args <- names(params)[!names(params) %in% c(names(formals(refine_chapter_overview)))]
  if(length(unwanted_args) > 0) cli::cli_abort("{.arg {unwanted_args}} are not recognized valid arguments.")

  env <- lapply(formals(refine_chapter_overview)[!names(formals(refine_chapter_overview)) %in% .saros.env$ignore_args], eval)
  check_and_abort <- function(target,
                                    param_name,
                                    validation_fun) {

    if (!validation_fun(target[[param_name]])) {
      default <- env[[param_name]]
      cli::cli_abort(c("{.arg {param_name}} is invalid (it is {.obj_type_friendly {target[[param_name]]}}, and specified as {target[[param_name]]}).",
                       i="Consider default: {default}.",
                       i="Argument failed the test of {.fun {deparse(validation_fun)[2]}}."))
    } else target[[param_name]]
  }
  is_scalar_finite_doubleish <- function(x) {
    is.numeric(x) && length(x) == 1 && is.finite(x)
  }
  is_bool <- function(x) is.logical(x) && length(x) == 1 && !is.na(x)


  arg_params <-
    list(
      # Data frames
      chapter_overview = list(fun = function(x) inherits(x, "data.frame") && nrow(x)>0),
      data = list(fun = function(x) is.null(x) || inherits(x, "data.frame") || inherits(x, "survey")),
      chunk_templates = list(fun = function(x) is.null(x) || inherits(x, "data.frame")),

      # Character vectors (not enums)
      label_separator = list(fun = function(x) is.null(x) || is.character(x)),
      name_separator = list(fun = function(x) is.null(x) || is.character(x)),
      sep_obj = list(fun = function(x) is_string(x)),
      sep_chunk = list(fun = function(x) is_string(x)),
      sep_file = list(fun = function(x) is_string(x)),
      mesos_var = list(fun = function(x) is.null(x) || is_string(x)),
      auxiliary_variables = list(fun = function(x) is.null(x) || (is.character(x) && all(x %in% colnames(params$data)))),
      always_show_bi_for_indep = list(fun = function(x) is.null(x) || (is.character(x) && all(x %in% colnames(params$data)))),
      variables_show_bi_for_by = list(fun = function(x) is.null(x) || (is.character(x) && all(x %in% colnames(params$data)))),
      n_range_glue_template_1 = list(fun = function(x) is_string(x)),
      n_range_glue_template_2 = list(fun = function(x) is_string(x)),
      variable_group_dep = list(fun = function(x) is_string(x)),
      variable_group_prefix = list(fun = function(x) is.null(x) || is_string(x)),
      log_file = list(fun = function(x) is.null(x) || is_string(x)),


      # Boolean
      hide_variable_if_all_na = list(fun = is_bool),
      na_first_in_section = list(fun = is_bool),
      progress = list(fun = is_bool),

      # Numeric and integer
      hide_bi_entry_if_sig_above = list(fun = function(x) is_scalar_finite_doubleish(x) && x >= 0 && x <= 1),
      hide_chunk_if_n_below = list(fun = function(x) rlang::is_scalar_integerish(x) && x >= 0),
      single_y_bivariates_if_indep_cats_above = list(fun = function(x) length(x)== 1 && (rlang::is_scalar_integerish(x) && x >= 0) || is.na(x)),
      single_y_bivariates_if_deps_above = list(fun = function(x) length(x)== 1 && (rlang::is_scalar_integerish(x) && x >= 0) || is.na(x)),
      hide_test_if_n_below = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE)),
      max_width_file = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE) && x >= 8),
      max_width_obj = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE) && x >= 8),
      max_width_chunk = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE) && x >= 8),
      max_clean_folder_name = list(fun = function(x) rlang::is_integerish(x, n = 1, finite = TRUE) && x >= 8),

      # Enums
      organize_by = list(fun = function(x) is.character(x)), # BETTER CHECKS NEEDED
      arrange_section_by = list(fun = function(x) is.null(x) ||
                                  (is.character(x) && all(x %in% .saros.env$core_chapter_structure_cols)) ||
                                  (is.logical(x) && rlang::is_named(x) && all(names(x) %in% .saros.env$core_chapter_structure_cols)))
    )

  for(par in names(arg_params)) {

    params[[par]] <-
      check_and_abort(target = params,
                      param_name = par,
                      validation_fun = arg_params[[par]]$fun)
  }


  params$chunk_templates <- validate_chunk_templates(params$chunk_templates)

  if(is_string(params$mesos_var)) {
    if(!any(colnames(params$data) == params$mesos_var)) {
      cli::cli_abort("{.arg mesos_var}: {.arg {params$mesos_var}} not found in data.")
    }
    if(all(is.na(params$data[[params$mesos_var]]))) {
      cli::cli_abort("{.arg mesos_var}: All mesos_var entries are NA.")
    }
  }


  if(!all(c("chapter", ".template_name") %in% params$organize_by)) {
    cli::cli_abort(c("{.arg organize_by} must contain both {.var {c('chapter', '.template_name')}}.",
                     i = "You provided {.arg {params$organize_by}}."))
  }
  if(!all(params$organize_by %in% .saros.env$core_chapter_structure_cols)) {
    cli::cli_abort(c("{.arg organize_by} is not valid. Must be one or more of {(.saros.env$core_chapter_structure_cols)}.",
                     i = "You provided {.arg {params$organize_by}}."))
  }
  if(!all(params$arrange_section_by %in% .saros.env$core_chapter_structure_cols) &&
     !all(names(params$arrange_section_by %in% .saros.env$core_chapter_structure_cols))) {
    cli::cli_abort(c("{.arg arrange_section_by} is not valid. Must be one or more of {(.saros.env$core_chapter_structure_cols)}.",
                     i = "You provided {.arg {params$arrange_section_by}}."))
  }

  # params$chunk_templates <- validate_chunk_templates(params$chunk_templates)


  if(all(.saros.env$core_chapter_structure_cols %in% names(params$chapter_overview))) {
    cli::cli_abort("{.arg chapter_overview} is already converted to a chapter_structure.")
  }
  if(is.null(params$chapter_overview) && is.null(params$data)) {
    cli::cli_abort("You must provide at least {.arg chapter_overview} or {.arg data}.")
  }
  if(!is.null(params$chapter_overview) &&
     !any(colnames(params$chapter_overview) %in% c("chapter", "dep"))) {

    cli::cli_abort("{.arg chapter_overview} must at least contain columns {.var {c('chapter', 'dep')}} (and optionally {.var indep}).")

  }
  if(is.null(params$chapter_overview)) {
    cli::cli_warn("{.arg chapter_overview} is NULL, placing all variables in {.arg data} in a {.val All} chapter.")
    params$chapter_overview <- data.frame(chapter = "All", dep = "everything()")
  }


  params
}
