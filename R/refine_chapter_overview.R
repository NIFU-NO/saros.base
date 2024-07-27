#' Processes A 'chapter_overview' Data Frame
#'
#' @param chapter_overview *What goes into each chapter and sub-chapter*
#'
#'   `obj:<data.frame>|obj:<tbl_df>` // Required
#'
#'   Data frame (or tibble, possibly grouped). One row per chapter. Should
#'   contain the columns 'chapter' and 'dep', Optionally 'indep' (independent
#'   variables) and other informative columns as needed.
#'
#' @param data *Survey data*
#'
#'   `obj:<data.frame>|obj:<tbl_df>|obj:<srvyr>` // Required
#'
#'   A data frame (or a srvyr-object) with the columns specified in the
#'   chapter_structure 'dep', etc columns.
#'
#' @param chunk_templates *Chunk templates*
#'
#'   `obj:<data.frame>|obj:<tbl_df>|NULL` // *default:* `NULL` (`optional`)
#'
#'   Must contain columns `name` (user-specified unique name for the template),
#'   `template` (the chunk template as `{glue}`-specification, `variable_type_dep`
#'   and optionally `variable_type_indep`. The latter two are list-columns of
#'   prototype vectors specifying which data the template will be applied to.
#'   Can optionally contain columns whose names match the default options for
#'   the function. These will then override the default function-wide options
#'   for the specific template.
#'
#' @param ... *Dynamic dots*
#'
#'   <[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)>
#'
#'   Arguments forwarded to the corresponding functions that create the elements.
#' @param label_separator *Variable label separator*
#'
#'   `scalar<character>` // *default:* `NULL` (`optional`)
#'
#'   String to split labels on main question and sub-items.
#'
#' @param name_separator *Variable name separator*
#'
#'   `scalar<character>` // *default:* `NULL` (`optional`)
#'
#'   String to split column names in data between main question and sub-items
#' @param organize_by *Grouping columns*
#'
#'   `vector<character>` // *default:* `NULL` (`optional`)
#'
#'   Column names used for identifying chapters and sections.
#'
#' @param arrange_section_by *Grouping columns*
#'
#'   `vector<character>` or `named vector<logical>` // *default:* `NULL` (`optional`)
#'
#'   Column names used for sorting section within each organize_by group. If
#'   character vector, will assume all are to be arranged in ascending order.
#'   If a named logical vector, FALSE will indicate ascending, TRUE descending.
#'   Defaults to sorting in ascending order (alphabetical) for commonly needed
#'   variable name/label info, and in descending order for chunk_templates as one
#'   typically wants *u*nivariates before *b*ivariates.
#'
#' @param na_first_in_section *Whether to place NAs first when sorting*
#'
#'   `scalar<logical>` // *default:* `TRUE` (`optional`)
#'
#'   Default ascending and descending sorting with `dplyr::arrange()` is to place
#'   NAs at the end. This would have placed univariates at the end, etc. Thus,
#'   saros places NAs first in the section. Set this to FALSE to override.
#'
#' @param always_show_bi_for_indep *Always show bivariate for indep-variable*
#'
#'   `vector<character>` // *default:* `NULL` (`optional`)
#'
#'   Specific combinations with a by-variable where bivariates should always be shown.
#'
#' @param single_y_bivariates_if_indep_cats_above *Single y bivariates if indep-cats above ...*
#'
#'  `scalar<integer>` // *default:* `3` (`optional`)
#'
#'  Figures and tables for bivariates can become very long if the independent
#'  variable has many categories. This argument specifies the number of indep categories
#'  above which only single y bivariates should be shown.
#'
#' @param single_y_bivariates_if_deps_above *Single y bivariates if dep-vars above ...*
#'
#'  `scalar<integer>` // *default:* `20` (`optional`)
#'
#'  Figures and tables for bivariates can become very long if there are many dependent
#'  variables in a battery/question matrix. This argument specifies the number of dep variables
#'  above which only single y bivariates should be shown. Set to 0 to always show single y bivariates.
#'
#' @param hide_bi_entry_if_sig_above *p-value threshold for hiding bivariate entry*
#'
#'   `scalar<double>` // *default:* `1` (`optional`)
#'
#'   Whether to hide bivariate entry if significance is above this value.
#'   Defaults to showing all.
#'
#' @param hide_chunk_if_n_below *Hide result if N below*
#'
#'  `scalar<integer>` // *default:* `10` (`optional`)
#'
#'  Whether to hide result if N for a given dataset is below
#'  this value. NOTE: Exceptions will be made to chr_table and chr_plot as these are
#'  typically exempted in the first place. This might change in the future with
#'  a separate argument.
#'
#' @param hide_variable_if_all_na *Hide variable from outputs if containing all NA*
#'
#'   `scalar<boolean>` // *default:* `TRUE` (`optional`)
#'
#'   Whether to remove variables if all values are NA.
#'
#' @param max_width_obj,max_width_chunk,max_width_file *Maximum object width*
#'
#'   `scalar<integer>` // *default:* `NULL` (`optional`)
#'
#'   Maximum width for names of objects (in R/Python environment),
#'   chunks (#| label: ) and optional files. Note, will always replace variable
#'   labels with variable names, to avoid very long file names.
#'   Note for filenames: Due to OneDrive having a max path of about
#'   400 characters, this can quickly be exceeded with a long path base path,
#'   long file names if using labels as part of structure, and hashing with
#'   Quarto's `cache: true` feature. Thus consider restricting max_width_file
#'   to lower than what you optimally would have wished for.
#'
#' @param sep_obj,sep_chunk,sep_file *Separator string*
#'
#'   `scalar<character>` // *default:* `"_"` (`optional`)
#'
#'   Separator to use between grouping variables. Defaults to underscore for
#'   object names and hyphen for chunk labels and file names.
#'
#' @param max_width_folder_name *Maximum clean folder name length*
#'
#'   `scalar<integer>` // *default:* `NULL` (`optional`)
#'
#'   Whereas `max_width_file` truncates the file name, this argument truncates
#'   the folder name. It will not impact the report or chapter names in website,
#'   only the folders.
#'
#' @param variable_group_dep *Name for the variable_group_dep column*
#'
#'   `scalar<string>` // *default:* `".variable_group_dep"`
#'
#'   This column is used to group variables that are part of the same bivariate analysis.
#'
#' @param variable_group_prefix *Set a prefix to more easily find it in your labels*
#'
#'   `scalar<string>` // *default:* `NULL`
#'
#'   By default, the .variable_group column is just integers. If you wish to
#'   use this as part of your object/label/filename numbering scheme, a number
#'   by itself will not be very informative. Hence you could set a prefix such
#'   as "Group" to distinguish this column from other columns in the chapter_structure.
#'
#' @param progress *Whether to display progress message*
#'
#'    `scalar<logical>` // *default:* `TRUE`
#'
#'    Mostly useful when hide_bi_entry_if_sig_above < 1
#'
#' @param log_file *Path to log file*
#'
#'   `scalar<string>` // *default:* `"_log.txt"` (`optional`)
#'
#'   Path to log file. Set to NULL to disable logging.
#'
#' @param n_range_glue_template_1,n_range_glue_template_2
#'
#'   `scalar<string>` // *default:* `"{n}" and "[{n[1]}, {n[2]}]` (`optional`)
#'
#'   Glue templates for the n_range columns to be created.
#'
#' @return Grouped tibble.
#' @export
#'
#' @examples
#' ref_df <- refine_chapter_overview(chapter_overview = ex_survey_ch_overview)
#' \donttest{
#' ref_df2 <- refine_chapter_overview(chapter_overview = ex_survey_ch_overview,
#'                      data = ex_survey, hide_bi_entry_if_sig_above=.05)
#' }
refine_chapter_overview <-
  function(chapter_overview = NULL,
           data = NULL,
           chunk_templates = NULL,

           # Splitting the variables labels and names
           label_separator = " - ",
           name_separator = NULL,

           # What sections to display (and their structure)
           single_y_bivariates_if_indep_cats_above = 3,
           single_y_bivariates_if_deps_above = 20,
           always_show_bi_for_indep = NULL,
           hide_bi_entry_if_sig_above = 1,
           hide_chunk_if_n_below = 10,
           hide_variable_if_all_na = TRUE,
           organize_by = c("chapter",
                           ".variable_label_prefix_dep",
                           ".variable_name_indep",
                           ".template_name"),
           arrange_section_by = c(chapter = FALSE,
                                  .variable_name_dep = FALSE,
                                  .variable_name_indep = FALSE,
                                  .template_name = FALSE),
           na_first_in_section = TRUE,

           # Path limits
           max_width_obj = 128,
           max_width_chunk = 128,
           max_width_file = 64,
           max_width_folder_name = 12,
           sep_obj = "_",
           sep_chunk = "-",
           sep_file = "-",

           ...,
           progress = TRUE,
           variable_group_dep = ".variable_group_dep",
           variable_group_prefix = NULL,
           n_range_glue_template_1 = "{n}",
           n_range_glue_template_2 = "[{n[1]}-{n[2]}]",
           log_file = NULL) {

    args <- utils::modifyList(as.list(environment()),
                              rlang::list2(...)
    )

    args <- validate_refine_chapter_overview_args(args)

    # Things changed during validate_refine_chapter_overview_args should be set anew here:
    out <- args$chapter_overview
    chunk_templates <- args$chunk_templates

    if(is.null(data)) arrange_section_by <- NULL


    if(progress) cli::cli_progress_message(msg = "Refining chapter_overview into a chapter_structure ...\n")


    out <- add_core_info_to_chapter_structure(chapter_structure = out)

    data_present <- !is.null(data) && is.data.frame(data)
    if(data_present) {

      out <- add_parsed_vars_to_chapter_structure(
        chapter_structure = out,
        data = data)

      out <- remove_from_chapter_structure_if_all_na(
        chapter_structure = out,
        data = data,
        hide_variable_if_all_na = hide_variable_if_all_na
      )

      # check_duplicates_in_chapter_overview(out)

      present_variable_names <-
        stringi::stri_remove_empty_na(unique(out$.variable_name))

      if(length(present_variable_names)>0) {
        out <-
          dplyr::left_join(x=out,
                           y=look_for_extended(data = data,
                                               cols = present_variable_names,
                                               label_separator = label_separator,
                                               name_separator = name_separator),
                           by = dplyr::join_by(".variable_position", ".variable_name"))

        # if(!is.factor(out$.variable_name_dep)) browser()

        out <-
          trim_columns(out, cols = c(".variable_label_prefix", ".variable_label_prefix"))
        out <-
          validate_labels(out)

        out <-
          add_indep_to_chapter_structure(out)
        # if(!is.factor(out$.variable_name_dep)) browser()


        out <-
          remove_from_chapter_structure_if_non_significant(
            chapter_structure = out,
            data = data,
            hide_bi_entry_if_sig_above = hide_bi_entry_if_sig_above,
            always_show_bi_for_indep = always_show_bi_for_indep,
            progress = progress)
        # if(!is.factor(out$.variable_name_dep)) browser()


        out <-
          add_chunk_templates_to_chapter_structure(
            chapter_structure = out,
            chunk_templates = chunk_templates)
        out <- remove_from_chapter_structure_if_no_type_match(out)
        # if(!is.factor(out$.variable_name_dep)) browser()


        out <-
          dplyr::distinct(out, dplyr::pick(tidyselect::everything()), .keep_all = TRUE)
        # if(!is.factor(out$.variable_name_dep)) browser()


        validate_chapter_structure_has_not_chapter_with_all_vars(out, data = data)


        log_unused_variables(chapter_structure = out,
                             data = data,
                             log_file = log_file)
        # if(!is.factor(out$.variable_name_dep)) browser()


        out <-
          set_chapter_structure_cols_as_factor_with_na(
            chapter_structure = out,
            data = data,
            chunk_template_names = chunk_templates$name)
        # if(!is.factor(out$.variable_name_dep)) browser()

        out <-
          add_group_id_to_chapter_structure(out,
                                            grouping_vars = organize_by[organize_by %in% colnames(out)],
                                            variable_group_prefix = NULL)

        # browser()

        out <-
          split_chapter_structure_groups_if_single_y_bivariates(
            chapter_structure = out,
            data = data,
            single_y_bivariates_if_indep_cats_above = single_y_bivariates_if_indep_cats_above,
            single_y_bivariates_if_deps_above = single_y_bivariates_if_deps_above,
            variable_group_dep = variable_group_dep,
            organize_by = organize_by)


      }

      # browser()



      out <- dplyr::group_by(out, dplyr::pick(tidyselect::all_of(organize_by[organize_by %in% colnames(out)])))
      out <- arrange2(data = out, arrange_vars = arrange_section_by, na_first = na_first_in_section)
      # if(!is.factor(out$.variable_name_dep)) browser()

      if(data_present) {

        out <-
          add_n_to_chapter_structure(
            chapter_structure = out,
            data = data,
            variable_name = ".n")

        out <-
          remove_from_chapter_structure_if_n_below(
            chapter_structure = out,
            n_variable_name = ".n",
            hide_chunk_if_n_below = hide_chunk_if_n_below)

        out <-
          add_n_range_to_chapter_structure(
            chapter_structure = out,
            data = data,
            glue_template_1 = n_range_glue_template_1,
            glue_template_2 = n_range_glue_template_2,
            variable_name = ".n_range")
        if(!is.factor(out$.variable_name_dep)) browser()

        out <-
          add_n_cats_to_chapter_structure(
            chapter_structure = out,
            data = data,
            target_variable = ".variable_name_dep",
            variable_name_n_cats = ".n_cats_dep",
            variable_name_max_cat_char = ".max_chars_dep",
            drop_na = TRUE)

        out <-
          add_n_cats_to_chapter_structure(
            chapter_structure = out,
            data = data,
            target_variable = ".variable_name_indep",
            variable_name_n_cats = ".n_cats_indep",
            variable_name_max_cat_char = ".max_chars_indep",
            drop_na = TRUE)

      }
      if(!is.factor(out$.variable_name_dep)) browser()



      out <-
        add_n_vars_to_chapter_structure(
          chapter_structure = out,
          target_variable = ".variable_name_dep",
          variable_name = ".n_dep")

      out <-
        add_n_vars_to_chapter_structure(
          chapter_structure = out,
          target_variable = ".variable_name_indep",
          variable_name = ".n_indep")



      out <-
        add_obj_name_to_chapter_structure(
          chapter_structure = out,
          variable_name = ".obj_name",
          sep = sep_obj,
          max_width = max_width_obj,
          make_unique = TRUE,
          to_lower = TRUE)

      out <-
        add_obj_name_to_chapter_structure(
          chapter_structure = out,
          variable_name = ".chunk_name",
          sep = sep_chunk,
          max_width = max_width_chunk,
          make_unique = TRUE,
          to_lower = TRUE)

      out <-
        add_obj_name_to_chapter_structure(
          chapter_structure = out,
          variable_name = ".file_name",
          sep = sep_file,
          max_width = max_width_file,
          make_unique = TRUE,
          to_lower = TRUE)
    }


    out <-
      add_chapter_foldername_to_chapter_structure(
        chapter_structure = out, #Current
        max_width_folder_name = max_width_folder_name)



    out
  }
