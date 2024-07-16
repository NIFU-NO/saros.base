#' Automatically Draft a Quarto Report
#'
#' @description
#' The `draft_report()` function takes a raw dataset (`data`-argument) and the
#' output from the `refine_chapter_overview()`-function as the
#' `chapter_structure`-argument and outputs a set of pre-populated qmd-files in the
#' specified `path`-folder. You can edit, render, and
#' ultimately publish these as usual with Quarto features in RStudio. See also
#' `{saros.post}`-package for post-processing tools.
#'
#' @details
#' Note that saros treats data as they are stored: numeric,
#' integer, factor, ordinal, character, and datetime. Currently, only
#' factor/ordinal and character are implemented.
#'
#' @inheritParams refine_chapter_overview
#' @param chapter_structure *What goes into each chapter and sub-chapter*
#'
#'   `obj:<data.frame>|obj:<tbl_df>` // Required
#'
#'   Data frame (or tibble, possibly grouped). One row per chapter. Should
#'   contain the columns 'chapter' and 'dep', Optionally 'indep' (independent
#'   variables) and other informative columns as needed.
#'
#' @param ... *Dynamic dots*
#'
#'   <[`dynamic-dots`](https://rlang.r-lib.org/reference/dyn-dots.html)>
#'
#'   Arguments forwarded to the corresponding functions that create the elements.
#'
#' @param title *Title of report*
#'
#'   `scalar<character>` // *default:* `NULL` (`optional`)
#'
#'   Added automatically to YAML-header of index.qmd and report.qmd-files.
#'
#' @param authors *Authors of entire report*
#'
#'   `vector<character>` // *default:* `NULL` (`optional`)
#'
#'   If NULL, infers from chapter_structure$authors, and collates for entire report.
#'   If multiple authors per chapter, separate with semicolon. Ensure consistency.
#'
#' @param index_yaml_file,report_yaml_file *Path to YAML-file to insert into index.qmd and 0_report.qmd respectively*
#'
#'   `scalar<character>` // *default:* `NULL` (`optional`)
#'
#'   Path to file used to insert header YAML, in index and report files.
#'
#' @param chapter_yaml_file *Path to YAML-file to insert into each chapter qmd-file*
#'
#'   `scalar<character>` // *default:* `NULL` (`optional`)
#'
#'   Path to file used to insert header YAML, in each chapter.
#'
#' @param index_filename *Index filename*
#'
#'   `scalar<character>` // *default:* `"index.qmd"` (`optional`)
#'
#'   The name of the main index Quarto file used as landing
#'   page for each report. Will link to a PDF (report.qmd) which collects all chapters.
#'
#' @param report_filename *Report filename*
#'
#'   `scalar<character>` // *default:* `"0_report.qmd"` (`optional`)
#'
#'   The name of the main report QMD-file used when compiling a complete report
#'   collecting all chapters in its folder (except itself).
#'   If provided, will be linked to in the index.
#'   If NULL, will generate a filename based on the report title, prefixed with "0_".
#'   To turn off, set `pdf=FALSE`.
#'
#'
#' @param chapter_qmd_start_section_filepath,chapter_qmd_end_section_filepath,index_qmd_start_section_filepath,index_qmd_end_section_filepath,report_qmd_start_section_filepath,report_qmd_end_section_filepath, *Path to qmd-bit for start/end of each qmd*
#'
#'   `scalar<character>` // *default:* `NULL` (`optional`)
#'
#'   Path to qmd-snippet placed before/after body of all chapter/index/report qmd-files.
#'
#' @param path *Output path*
#'
#'   `scalar<character>` // *default:* `NULL` (`optional`)
#'
#'   Path to save all output.
#'
#' @param require_common_categories *Check common categories*
#'
#'   `scalar<logical>` // *default:* `NULL` (`optional`)
#'
#'   Whether to check if all items share common categories.
#'
#'
#' @param replace_heading_for_group *Replacing heading for group*
#'
#'  `named vector<character>` // *default:* `c(".variable_label_suffix_dep" = ".variable_name_dep")`
#'
#'  Occasionally, one needs to replace the heading with another piece of information
#'  in the refined chapter_structure. For instance, one may want to organize output
#'  by variable_name_indep, but to display the variable_label_indep instead. Use
#'  the name for the replacement and the value for the original.
#'
#' @param ignore_heading_for_group *Ignore heading for group*
#'
#'  `vector<character>` // *default:* `NULL` (`optional`)
#'
#'  Type of refined chapter_structure data for which to suppress the heading
#'  in the report output. Typically variable_name_dep, variable_name_indep, etc.
#'
#'
#' @param attach_chapter_dataset *Toggle inclusion of chapter-specific datasets in qmd-files*
#'
#'   `scalar<logical>` // *default:* `FALSE`
#'
#'   Whether to save in each chapter folder an 'Rds'-file with the
#'   chapter-specific dataset, and load it at the top of each QMD-file.
#'
#' @param combined_report *Create a combined report?*
#'
#'   `scalar<logical>` // *default:* `FALSE` (`optional`)
#'
#'   Whether to create a qmd file that merges all chapters into
#'   a combined report.
#'
#' @param max_path_warning_threshold *Maximum number of characters in paths warning*
#'
#'   `scalar<integer>` // *default:* `260` (`optional`)
#'
#'   Microsoft has set an absolute limit of 260 characters for its Sharepoint/OneDrive
#'   file paths. This will mean that files with cache (hash suffixes are added) will
#'   quickly breach this limit. When set, a warning will be returned if files are found
#'   to be longer than this threshold. Also note that spaces count as three characters
#'   due to its URL-conversion: %20. To avoid test, set to Inf
#'
#' @param log_file *Path to log file*
#'
#'   `scalar<string>` // *default:* `"_log.txt"` (`optional`)
#'
#'   Path to log file. Set to NULL to disable logging.
#'
#' @param tabular_format *Serialized format*
#'
#'   `scalar<string>` // *default:* `"delim"`
#'
#'   Format for pretty tabular data, meant for end-user to peruse and will be
#'   linked to in reports (the graph data, etc). One of `"delim"` (tab-separated delim-files)
#'   `"xlsx"` requires `writexl`-package), `"csv"` or `"csv2"` (requires `readr`-package.
#'   `"dta"` or `"sav"` requires `haven`-package. Currently must be specified,
#'   in the future this will become an optional argument.
#'
#' @param serialized_format *Serialized format*
#'
#'   `scalar<string>` // *default:* `"rds"`
#'
#'   Format for serialized data when storing chapter dataset.
#'   One of `"rds"` (default), `"qs"` or `"fst"`.
#'   The latter two requires the respective packages to be installed.
#'   `"qs"` is usually the fastest and most space efficient, but sets package
#'   dependencies on the report project.
#'
#' @importFrom rlang !!!
#'
#' @return The `path`-argument.
#' @export
#'
#' @examples
#' \donttest{
#' ex_survey_ch_structure <-
#'   refine_chapter_overview(
#'           chapter_overview = ex_survey_ch_overview,
#'           data = ex_survey)
#' index_filepath <-
#'  draft_report(
#'     chapter_structure = ex_survey_ch_structure,
#'     data = ex_survey,
#'     path = tempdir())
#' }
draft_report <-
  function(data,
           chapter_structure,
           ...,
           path,
           title = "Report",
           authors = NULL,
           mesos_var = NULL,

           chapter_yaml_file = NULL,
           chapter_qmd_start_section_filepath = NULL,
           chapter_qmd_end_section_filepath = NULL,

           index_filename = "index",
           index_yaml_file = NULL,
           index_qmd_start_section_filepath = NULL,
           index_qmd_end_section_filepath = NULL,

           report_filename = "0_report",
           report_yaml_file = NULL,
           report_qmd_start_section_filepath = NULL,
           report_qmd_end_section_filepath = NULL,

           ignore_heading_for_group = c(".template_name", # Do not move
                                        ".variable_type_dep",
                                        ".variable_type_indep",
                                        "chapter"),
           replace_heading_for_group = c(".variable_label_suffix_dep" = ".variable_name_dep",
                                         ".variable_label_suffix_indep" = ".variable_name_indep"),

           require_common_categories = TRUE, # Not in use, should be merged with chunk_templates?

           # Formats and attachments
           combined_report = TRUE,
           attach_chapter_dataset = TRUE,
           auxiliary_variables = NULL,
           serialized_format = c("rds", "qs"), # For attach_chapter_dataset
           tabular_format = c("delim", "xlsx", "csv", "csv2", "tsv", "sav", "dta"),


           max_path_warning_threshold = 260,  # Tidy up argument name: max_width_path_warning. Keep here

           # Debugging
           log_file = NULL


  ) {

    args <- utils::modifyList(as.list(environment()),
                              rlang::list2(...)
                              )
    timestamp <- proc.time()


    args <- validate_draft_report_args(params = args)


    data <- ungroup_data(data)




    all_authors <- get_authors(data = chapter_structure, col="author")

    if(!is_string(args$mesos_var)) {

      uniques <- NA_character_

    } else {
      # Mesos reports
      uniques <- pull_uniques(data[[args$mesos_var]])
    }

    report_foldername_clean <- filename_sanitizer(uniques, max_chars = args$max_clean_folder_name)

    index_filepath <-
      lapply(X =
               cli::cli_progress_along(uniques, # Not working well
                                       format = "Generating mesos report for... {uniques[cli::pb_current]}",
                                       clear = FALSE,
                                       auto_terminate = FALSE),
             FUN = function(.x) {


               if(is.na(uniques[.x])) { # Macro

                 mesos_group <- NULL


               } else {  # Mesos

                 mesos_group <- uniques[.x]
                 path <- file.path(path, report_foldername_clean[.x])
                 args$title <- stringi::stri_c(args$title,
                                          uniques[.x],
                                          ignore_null=TRUE)


               }


               chapter_filepaths <-
                 rlang::exec(
                   gen_qmd_chapters,
                   chapter_structure = chapter_structure,
                   data = data,
                   mesos_group = mesos_group,
                   path = path,
                   !!!args[!names(args) %in% .saros.env$ignore_args])




               if(isTRUE(args$combined_report)) {

                 report_filepath <-
                     gen_qmd_file(
                       path = path,
                       filename = args$report_filename,
                       yaml_file = args$report_yaml_file,
                       qmd_start_section_filepath = args$report_qmd_start_section_filepath,
                       qmd_end_section_filepath = args$report_qmd_end_section_filepath,
                       title = args$title,
                       authors = all_authors,
                       output_formats = NULL,
                       output_filename = NULL,
                       call = rlang::caller_env())
               }

               index_filepath <-
                   gen_qmd_file(
                   path = path,
                   filename = args$index_filename,
                   yaml_file = args$index_yaml_file,
                   qmd_start_section_filepath = args$index_qmd_start_section_filepath,
                   qmd_end_section_filepath = args$index_qmd_end_section_filepath,
                   title = args$title,
                   authors = all_authors,
                   output_formats = if(!is.null(args$report_yaml_file)) find_yaml_formats(args$report_yaml_file),
                   output_filename = args$report_filename,
                   call = rlang::caller_env())

               index_filepath

             })

    index_filepath <- as.character(unlist(index_filepath))

    validate_path_lengths_on_win(path = path,
                                 max_path_warning_threshold = max_path_warning_threshold)


    cat(proc.time()-timestamp)
    cat("\n")
    if(is_string(args$log_file)) {
      cat("Run time: ", proc.time()-timestamp, file=args$log_file)
    }
    stringi::stri_replace_all_regex(index_filepath, pattern="\\\\+", replacement="/")
  }
