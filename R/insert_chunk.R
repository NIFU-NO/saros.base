#' Mass Create Elements of A Certain Type
#'
#' @inheritParams draft_report
#' @inheritParams gen_qmd_chapters
#'
#' @param chapter_structure_section *Overview of chapter section*
#'
#'   `obj:<data.frame>|obj:<tbl_df>` // Required
#'
#'   Data frame (or tibble, possibly grouped). Must contain column 'dep'
#'   with similar items. See `draft_report()`.
#'
#' @param grouping_structure *Vector of groups*
#'
#'  `vector<character>` // *default:* `NULL` (`Optional`)
#'
#'  Internal usage.
#'
#' @return Named list of elements, where each element can UNFINISHED.
#' @importFrom rlang !!!
#' @keywords internal
#'

insert_chunk <-
  function(chapter_structure_section,
           .y, # chapter_structure_grouping as data.frame?
           grouping_structure,
           template_variable_name = ".template",
           ...
  ) {

    dots <- #update_dots(dots =
                          rlang::list2(...)#,
                        #allow_unique_overrides = FALSE)

    #####
    # Early returns
    # chapter and element_name is NA
    if(all(!is.na(chapter_structure_section$chapter)) &&
       all(is.na(as.character(chapter_structure_section$.template_name)))) return()

    if(all(is.na(as.character(chapter_structure_section$.variable_name_dep)))) return()





    # Re-group chapter_structure_section
    grouping_structure <- grouping_structure[!grouping_structure %in% "chapter"]

    chapter_structure_section <-
      dplyr::group_by(chapter_structure_section,
                      dplyr::pick(tidyselect::all_of(unname(grouping_structure))))
    chapter_structure_section <- droplevels(chapter_structure_section)


    section_key <- chapter_structure_section
    section_key <- dplyr::ungroup(section_key)
    section_key <- dplyr::distinct(section_key, dplyr::pick(tidyselect::all_of(grouping_structure)))
    section_key <- dplyr::arrange(section_key, dplyr::pick(tidyselect::all_of(grouping_structure)))
    section_key <- dplyr::group_by(section_key, dplyr::pick(tidyselect::all_of(grouping_structure)))
    if(nrow(section_key)>1) cli::cli_warn("Something weird going on in grouping.")

    ## Collapsing the chapter_structure_section and inserting it into the template
    out <-
    chapter_structure_section |>
      lapply(FUN = function(col) {
        col <- as.character(col)
        uniques <- unique(col)
        uniques <- uniques[!is.na(uniques)]
        cli::ansi_collapse(uniques, sep=",", sep2 = ",", last = ",", trunc = 30, width = Inf)
        }) |>
      unlist()
    glue::glue_data(out, out[[template_variable_name]])

  }
