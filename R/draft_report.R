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
#'   Added automatically to the YAML-header of the index.qmd and report.qmd-files.
#'   If `NULL`, no `title` field is written to those files.
#'
#'   Each chapter qmd-file instead receives its own value of the
#'   `chapter`-column as its YAML title, so chapters are titled correctly
#'   regardless of this argument.
#'
#' @param authors *Authors of entire report*
#'
#'   `vector<character>` // *default:* `NULL` (`optional`)
#'
#'   If NULL, infers from `chapter_structure[[authors_col]]`, and collates for entire report.
#'   If multiple authors per chapter, separate with semicolon. Ensure consistency.
#'
#' @param authors_col *Column name for author*
#'
#'   `scalar<character>` // *default:* `"author"` (`optional`)
#'
#'   Only used if it exists. Multiple authors are separated by semicolon (and optionally with a subsequent space).
#'
#' @param index_yaml_file,report_yaml_file *Path to YAML-file to insert into index.qmd and report.qmd respectively*
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
#'   `scalar<character>` // *default:* `"index"` (`optional`)
#'
#'   The name of the main index Quarto file used as landing
#'   page for each report. Will link to a PDF (report.qmd) which collects all chapters.
#'
#' @param report_filename *Report filename*
#'
#'   `scalar<character>` // *default:* `"report"` (`optional`)
#'
#'   The name of the main report QMD-file used when compiling a complete report
#'   collecting all chapters in its folder (except itself).
#'   If provided, will be linked to in the index.
#'   If NULL, will generate a filename based on the report title, prefixed with "0_".
#'   To turn off, set `pdf=FALSE`.
#'
#'
#' @param report_includes_files *Whether report.qmd includes \{\{< include 'chapter.qmd' >\}\}*
#'
#'   `scalar<logical>` // *default:* `FALSE`
#'
#'   Useful to have in mesos reports. However, bear in mind that including other qmd files with conflicting YAML-headers might be risky.
#'
#'
#' @param report_includes_prefix *String before each file in report.qmd*
#'
#'   `scalar<string>` // *default:* `'{{< include "'`
#'
#'   The prefix placed before each of the chapters being included in the
#'   report.qmd file if `report_includes_files = TRUE`. Shown single-quoted
#'   because the value itself ends in the double quote that opens the included
#'   filename, which `report_includes_suffix` then closes with `'" >}}'`.
#'
#' @param report_includes_suffix *String after each file in report.qmd*
#'
#'   `scalar<string>` // *default:* `'" >}}'`
#'
#'   The suffix placed after each of the chapters being included in the
#'   report.qmd file if `report_includes_files = TRUE`. It opens with the
#'   double quote that closes the filename opened by
#'   `report_includes_prefix`, whose default is `'{{< include "'`.
#'
#' @param chapter_qmd_start_section_filepath,chapter_qmd_end_section_filepath,index_qmd_start_section_filepath,index_qmd_end_section_filepath,report_qmd_start_section_filepath,report_qmd_end_section_filepath *Path to qmd-bit for start/end of each qmd*
#'
#'   `scalar<character>` // *default:* `NULL` (`optional`)
#'
#'   Path to qmd-snippet placed before/after body of all chapter/index/report qmd-files.
#'
#'   **The contents are processed as a [glue::glue()] template**, with the
#'   chapter's own metadata available as `{.chapter}`, `{.variable_name_dep}`
#'   and so on. Braces that are meant to survive into the generated file must
#'   therefore be doubled: an R chunk has to open with ```` ```{{r}} ````, not
#'   ```` ```{r} ````, or the run aborts with `object 'r' not found`.
#'
#'   Note that a start section is no longer needed merely to make a chapter
#'   render. The default `chunk_templates` are namespace-qualified, and every
#'   generated chapter opens with a setup chunk attaching `saros` and `gt`, so
#'   a chapter renders as generated. A snippet is still the place for anything
#'   project-specific, including further `library()` calls if your own
#'   `chunk_templates` reach for other packages.
#'
#' @param path *Output path*
#'
#'   `scalar<character>` // *default:* `tempdir()` (`optional`)
#'
#'   Path to save all output. Defaults to a temporary directory.
#'
#' @param require_common_categories *Check common categories*
#'
#'   `scalar<logical>` // *default:* `TRUE` (`optional`)
#'
#'   Whether to check if all items share common categories. On by default: a
#'   section whose factor `dep` columns have no response category in common
#'   aborts the run, before any file is written. Set to `FALSE` to skip.
#'
#'
#' @param replace_heading_for_group *Replacing heading for group*
#'
#'  `named vector<character>` // *default:* `c("chapter" = ".chapter_number", ".variable_label_suffix_dep" = ".variable_name_dep", ".variable_label_suffix_indep" = ".variable_name_indep")`
#'
#'  Occasionally, one needs to replace the heading with another piece of information
#'  in the refined chapter_structure. For instance, one may want to organize output
#'  by variable_name_indep, but to display the variable_label_indep instead. Use
#'  the name for the replacement and the value for the original.
#'
#' @param ignore_heading_for_group *Ignore heading for group*
#'
#'  `vector<character>` // *default:* see Usage (`optional`)
#'
#'  Grouping columns of the refined chapter_structure for which to suppress the
#'  heading in the report output. Typically variable_name_dep,
#'  variable_name_indep, etc. Names must match the columns actually grouped on,
#'  i.e. the `organize_by`-argument of [refine_chapter_overview()]; an entry
#'  that is not a grouping column simply has no effect.
#'
#'  `.chapter_number` is suppressed by default because the chapter heading is
#'  written directly by the chapter file, so leaving it enabled produces two
#'  first-level headings. Remove it from this argument to get the chapter
#'  heading from the grouping machinery instead, which gives it a `{#sec-}`
#'  anchor and makes `prefix_heading_for_group`/`suffix_heading_for_group`
#'  apply to it.
#'
#'
#' @param prefix_heading_for_group,suffix_heading_for_group *Prefix and suffix headings*
#'
#'  `vector<named character>` // *default:* `NULL` (`optional`)
#'
#'  Names are heading_groups, values are the prefixes and suffixes. These are
#'  placed on their own lines, above and below the heading; to change the
#'  heading text itself use `glue_heading_for_group`. Note
#'  that prefixes should end with a `\n` as headings must begin on a new line.
#'
#'
#' @param glue_heading_for_group *Glue templates for heading text*
#'
#'  `vector<named character>` // *default:* `NULL` (`optional`)
#'
#'  Rewrites the text of the headings at one level of the grouping tree.
#'  Names are grouping columns, following the same rule as
#'  `ignore_heading_for_group`: they must match the columns actually grouped
#'  on, i.e. the `organize_by`-argument of [refine_chapter_overview()], and an
#'  entry that is not a grouping column simply has no effect. Note that this is
#'  the grouped column, not the one `replace_heading_for_group` may have chosen
#'  to supply the label -- with the defaults, `.variable_name_indep` rather
#'  than `.variable_label_suffix_indep`.
#'
#'  Values are [glue::glue()] templates in which `{heading}` is the heading
#'  text that would otherwise have been written. Because each grouping column
#'  occupies a fixed level, this targets a heading level:
#'  `c(.variable_name_indep = "By {tolower(heading)}")` turns
#'
#'  ```
#'  ## Self-efficacy
#'  ### Gender
#'  ```
#'
#'  into
#'
#'  ```
#'  ## Self-efficacy
#'  ### By gender
#'  ```
#'
#'  which reads correctly for someone who sees the sub-heading and the figure
#'  without the parent heading above them. Arbitrary R runs inside the braces,
#'  so `{sub("^(.)", "\\L\\1", heading, perl = TRUE)}` lowercases only the
#'  first letter, and a template needs no placeholder at all if a fixed
#'  heading is wanted.
#'
#'  The `{#sec-}` anchor is derived from the group's value rather than from the
#'  heading text, so changing a template moves no cross-reference and
#'  invalidates no Quarto `freeze` cache. A group listed in
#'  `ignore_heading_for_group` emits no heading and so is unaffected.
#'
#'
#' @param write_qmd *Toggle whether to make qmd-files*
#'
#'   `scalar<logical>` // *default:* `TRUE`
#'
#'   Sometimes it is useful to only create chapter_dataset files if these have been updated,
#'   without having to overwrite the qmd files.
#'
#' @param attach_chapter_dataset *Toggle inclusion of chapter-specific datasets in qmd-files*
#'
#'   `scalar<logical>` // *default:* `TRUE`
#'
#'   Whether to save in each chapter folder an 'Rds'-file with the
#'   chapter-specific dataset, and load it at the top of each QMD-file.
#'
#' @param auxiliary_variables *Auxiliary variables to be included in datasets*
#'
#'   `vector<character>` // *default:* `NULL` (`optional`)
#'
#'   Column names in `data` that should always be included in datasets for
#'   chapter qmd-files, if `attach_chapter_dataset=TRUE`. Not publicly available.
#'
#' @param combined_report *Create a combined report?*
#'
#'   `scalar<logical>` // *default:* `TRUE` (`optional`)
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
#'   `scalar<string>` // *default:* `NULL` (`optional`)
#'
#'   Path to a log file, which is appended to rather than overwritten. `NULL`,
#'   the default, disables logging entirely; nothing is written and no file is
#'   created.
#'
#'   When a path is given, the columns of `data` that this report does not use
#'   are recorded. `auxiliary_variables` counts as used, since those columns are
#'   deliberately carried into the chapter datasets — which is why this entry is
#'   worth having in addition to the one [refine_chapter_overview()] writes:
#'   that function has no `auxiliary_variables` argument, so its own list
#'   reports auxiliary columns as unused.
#'
#'   Nothing is written, and the file is therefore not created, when every
#'   column of `data` is used. An absent log file means there was nothing to
#'   report rather than that logging failed.
#'
#'   The same path may be passed to both functions; entries accumulate.
#'
#' @param qmd_engine *Traversal engine for the grouping tree*
#'
#'   `scalar<string>` // *default:* `"recursion"`
#'
#'   Which implementation walks the grouping tree when assembling each chapter.
#'   Both produce byte-identical output; this exists so the newer one can be
#'   adopted, benchmarked and backed out of independently.
#'
#'   - `"recursion"`: the original implementation. One R function call per
#'     node, so a deep `organize_by` is bounded by the expression nesting limit
#'     (`options("expressions")`) and by C stack size.
#'   - `"loop"`: the same traversal driven by an explicit stack, so depth is
#'     bounded by heap instead.
#'
#'   Equivalence is asserted in `tests/testthat/test-qmd_engines.R`, which
#'   compares the two engines' output byte-for-byte across several report
#'   shapes.
#'
#' @param serialized_format *Serialized format*
#'
#'   `scalar<string>` // *default:* `"rds"`
#'
#'   Format for serialized data when storing chapter dataset.
#'   Currently only `"rds"` is supported.
#'
#' @param data_filename_prefix *String attached to beginning of data-file and data-object*
#'
#'   `scalar<string>` // *default:* `"data_"`
#'
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
#'     chapter_overview = ex_survey_ch_overview,
#'     data = ex_survey
#'   )
#' index_filepath <-
#'   draft_report(
#'     chapter_structure = ex_survey_ch_structure,
#'     data = ex_survey,
#'     path = tempdir()
#'   )
#'
#' # Recording which columns of `data` went unused. Write the log to a
#' # tempfile(), not to a bare filename -- a relative path would land in the
#' # user's working directory.
#' log_file <- tempfile(fileext = ".txt")
#' index_filepath_logged <-
#'   draft_report(
#'     chapter_structure = ex_survey_ch_structure,
#'     data = ex_survey,
#'     path = tempdir(),
#'     auxiliary_variables = "resp_status",
#'     log_file = log_file
#'   )
#' cat(readLines(log_file), sep = "\n")
#' }
draft_report <-
  function(data,
           chapter_structure,
           ...,
           path = tempdir(),
           title = NULL,
           authors = NULL,
           authors_col = "author",
           chapter_yaml_file = NULL,
           chapter_qmd_start_section_filepath = NULL,
           chapter_qmd_end_section_filepath = NULL,
           index_filename = "index",
           index_yaml_file = NULL,
           index_qmd_start_section_filepath = NULL,
           index_qmd_end_section_filepath = NULL,
           report_filename = "report",
           report_yaml_file = NULL,
           report_qmd_start_section_filepath = NULL,
           report_qmd_end_section_filepath = NULL,
           report_includes_files = FALSE,
           ignore_heading_for_group = c(
             ".template_name",
             ".variable_type_dep",
             ".variable_type_indep",
             ".variable_group_dep",
             ".chapter_number",
             "chapter"
           ),
           replace_heading_for_group = c(
             "chapter" = ".chapter_number",
             ".variable_label_suffix_dep" = ".variable_name_dep",
             ".variable_label_suffix_indep" = ".variable_name_indep"
           ),
           prefix_heading_for_group = NULL,
           suffix_heading_for_group = NULL,
           glue_heading_for_group = NULL,
           require_common_categories = TRUE, # Not in use, should be merged with chunk_templates?
           # Formats and attachments
           combined_report = TRUE,
           write_qmd = TRUE,
           attach_chapter_dataset = TRUE,
           auxiliary_variables = NULL,
           serialized_format = "rds", # For attach_chapter_dataset
           max_path_warning_threshold = 260, # Tidy up argument name: max_width_path_warning. Keep here
           data_filename_prefix = "data_",
           report_includes_prefix = '{{< include "',
           report_includes_suffix = '" >}}',
           qmd_engine = c("recursion", "loop"),
           log_file = NULL) {
    args <- utils::modifyList(
      as.list(environment()),
      rlang::list2(...)
    )


    args <- validate_draft_report_args(params = args)


    # `combined_report` defaults to TRUE and `report_includes_files` to FALSE,
    # so the shipped combination writes a `report.qmd` and leaves it with no
    # chapters in it (GH #119). Quarto renders that file without complaint,
    # into a document whose entire body is the title, which is why it reads as
    # "the report setup does not work" rather than as an error.
    #
    # Reported rather than corrected: flipping either default would change the
    # generated output of every existing caller. Raised before anything is
    # written, so it arrives with the run rather than after it.
    #
    # `cli_inform()` rather than `cli_warn()` deliberately. This fires on the
    # *default* pairing, so a warning would fire on essentially every call --
    # 55 times across this package's own suite -- which is the shape that
    # trains people to ignore warnings. A message is also what draft_report()
    # already uses to report a defaulted argument ("`chunk_templates` is NULL.
    # Using global defaults."), so this arrives in the console the same way.
    if (isTRUE(args$combined_report) && !isTRUE(args$report_includes_files)) {
      cli::cli_inform(c(
        "!" = "{.arg combined_report} is {.code TRUE} but {.arg report_includes_files} is {.code FALSE}, so {.file {paste0(args$report_filename, '.qmd')}} will contain no chapters.",
        i = "Set {.code report_includes_files = TRUE} to include them, or {.code combined_report = FALSE} to stop writing the file."
      ))
    }


    data <- ungroup_data(data)


    # Checked before anything is written, so a mismatch does not leave a
    # half-generated report behind.
    #
    # `current_env()` is this frame, so cli_abort() reports the failure against
    # the user's own `draft_report(...)` call. `caller_env()` here would name
    # whatever called draft_report() instead, which is one frame too far out.
    if (isTRUE(args$require_common_categories)) {
      check_common_categories_in_sections(
        chapter_structure = chapter_structure,
        data = data,
        call = rlang::current_env()
      )
    }


    all_authors <- get_authors(data = chapter_structure, col = args$authors_col)


    chapter_filepaths <-
      gen_qmd_chapters(
        chapter_structure = chapter_structure,
        data = data,
        path = args$path,
        ignore_heading_for_group = args$ignore_heading_for_group,
        replace_heading_for_group = args$replace_heading_for_group,
        prefix_heading_for_group = args$prefix_heading_for_group,
        suffix_heading_for_group = args$suffix_heading_for_group,
        glue_heading_for_group = args$glue_heading_for_group,
        chapter_yaml_file = args$chapter_yaml_file,
        chapter_qmd_start_section_filepath = args$chapter_qmd_start_section_filepath,
        chapter_qmd_end_section_filepath = args$chapter_qmd_end_section_filepath,
        write_qmd = args$write_qmd,
        attach_chapter_dataset = args$attach_chapter_dataset,
        auxiliary_variables = args$auxiliary_variables,
        serialized_format = args$serialized_format,
        qmd_engine = args$qmd_engine
      )

    processed_files <- chapter_filepaths



    if (isTRUE(args$combined_report)) {
      report_filepath <-
        gen_qmd_file(
          path = args$path,
          filename = args$report_filename,
          yaml_file = args$report_yaml_file,
          qmd_start_section_filepath = args$report_qmd_start_section_filepath,
          qmd_end_section_filepath = args$report_qmd_end_section_filepath,
          chapter_structure = args$chapter_structure,
          include_files = if (isTRUE(args$report_includes_files)) sort(basename(chapter_filepaths)),
          title = args$title,
          authors = all_authors,
          output_formats = NULL,
          output_filename = NULL,
          includes_prefix = report_includes_prefix,
          includes_suffix = report_includes_suffix,
          call = rlang::caller_env()
        )
      processed_files <- c(processed_files, report_filepath)
    }

    index_filepath <-
      gen_qmd_file(
        path = args$path,
        filename = args$index_filename,
        yaml_file = args$index_yaml_file,
        qmd_start_section_filepath = args$index_qmd_start_section_filepath,
        qmd_end_section_filepath = args$index_qmd_end_section_filepath,
        chapter_structure = args$chapter_structure,
        title = args$title,
        authors = all_authors,
        output_formats = if (!is.null(args$report_yaml_file)) find_yaml_formats(args$report_yaml_file),
        output_filename = stringi::stri_replace_first_regex(str = args$report_filename, pattern = "^_", replacement = ""),
        call = rlang::caller_env()
      )
    processed_files <- c(processed_files, index_filepath)


    validate_path_lengths_on_win(
      path = args$path,
      max_path_warning_threshold = max_path_warning_threshold
    )


    # Written last, so the log describes a run that actually completed rather
    # than one that aborted partway through. (This is where the argument's
    # original run-time entry lived before c73000f dropped the timing and left
    # `log_file` wired to nothing.)
    #
    # `draft_report()` does not call `refine_chapter_overview()` -- it receives
    # an already-refined `chapter_structure` -- so none of the removal helpers
    # that take a `log_file` are on this path, and there is nothing to thread
    # through. `log_unused_variables()` is the one existing logger whose inputs
    # this function has, and it is the only caller able to supply
    # `auxiliary_variables`: `refine_chapter_overview()` has no such argument,
    # so its own call reports auxiliary columns as unused even though they are
    # deliberately carried into the chapter datasets.
    #
    # Guarded on the path rather than called unconditionally, because
    # `log_unused_variables()` also informs via cli irrespective of `log_file`.
    # Calling it always would add a message to every existing `draft_report()`
    # call; with the default (`log_file = NULL`) behaviour is unchanged.
    if (is_string(args$log_file)) {
      log_unused_variables(
        data = data,
        chapter_structure = chapter_structure,
        auxiliary_variables = args$auxiliary_variables,
        log_file = args$log_file
      )
    }


    stringi::stri_replace_all_regex(processed_files, pattern = "\\\\+", replacement = "/")
  }
