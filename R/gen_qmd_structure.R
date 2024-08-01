#' @keywords internal
gen_qmd_structure <-
  function(chapter_structure,
           ignore_heading_for_group = NULL,
           replace_heading_for_group = NULL,
           prefix_heading_for_group = NULL,
           suffix_heading_for_group = NULL) {



    gen_group_structure <- function(grouped_data,
                                     level = 1,
                                     grouping_structure) {
      output <- character()
      new_out <- character()

      if (level > ncol(grouped_data)) return(output)


      for(value in unique(grouped_data[[level]])) {
# if(!is.na(value) && value == "x1_sex") browser()


        # Keep only relevant part of meta data which will be forwarded into a deeper level
        sub_df <-
          vctrs::vec_slice(grouped_data,
                           is.na(as.character(grouped_data[[colnames(grouped_data)[level]]])) |
                             as.character(grouped_data[[colnames(grouped_data)[level]]]) == value) |>
          droplevels()


        # Setting a specific sub-chapter (e.g. a label_prefix) as the column name to be able to forward filtering information to deeper recursion calls without additional complex arguments
        names(grouping_structure)[level] <- value

        # If innermost/deepest level, insert chunk
        if(level == length(grouping_structure)) {

          # Create new metadata with bare minimum needed, and reapply grouping
          chapter_structure_section <-
            prepare_chapter_structure_section(chapter_structure = chapter_structure,
                                              grouping_structure = grouping_structure)

          if(nrow(chapter_structure_section) >= 1) {

            new_out <- # Might be character() (initialized) or string (character vector?)
              insert_chunk(chapter_structure_section = chapter_structure_section,
                           grouping_structure = unname(grouping_structure)
                          )
          }
        }

        heading_line <- # Might be character() (if ignorable or value is NA). String always produced (even if no new output)
          insert_section_heading_line(
            grouped_data = grouped_data,
            level = level,
            chapter_structure = chapter_structure,
            value = value,
            ignore_heading_for_group = ignore_heading_for_group,
            replace_heading_for_group = replace_heading_for_group,
            prefix_heading_for_group = prefix_heading_for_group,
            suffix_heading_for_group = suffix_heading_for_group)


        output <- attach_new_output_to_output( # Might be character() or a string
          output = output,
          heading_line = heading_line,
          new_out = new_out,
          level = level,
          grouping_structure = grouping_structure)

        added <- # Recursive call
          gen_group_structure(grouped_data = sub_df,
                               level = level + 1,
                               grouping_structure = grouping_structure) |>
          stringi::stri_remove_empty_na()

        output <-
          stringi::stri_c(output,
                          added,
                          sep="\n\n", ignore_null=TRUE) # Space between each section (before new heading)
        output <-
          if(length(output)>0) output else ""
      }
      if(length(output)>1) browser()

      if(length(output) != 1 || is.na(output)) {
        cli::cli_abort(c("x"="Internal error in {.fn gen_qmd_structure}",
                         "!" = "{.val output} is {output}",
                       i="Please create a bug report at {.url https://github.com/NIFU-NO/saros.base/issues}."))
      }

      return(output)
    }

    grouping_structure <- dplyr::group_vars(chapter_structure)

    grouped_data <-
      chapter_structure |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(grouping_structure))) |>
      dplyr::distinct(dplyr::pick(tidyselect::all_of(grouping_structure)))

    out <-
      gen_group_structure(grouped_data = grouped_data,
                           grouping_structure = grouping_structure)
    out
  }
