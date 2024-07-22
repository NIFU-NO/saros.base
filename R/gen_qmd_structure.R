#' @keywords internal
gen_qmd_structure <-
  function(chapter_structure,
           ...,
           call = rlang::caller_env()) {


    dots <- update_dots(dots = rlang::list2(...),
                        allow_unique_overrides = FALSE)




    gen_group_structure <- function(grouped_data,
                                     level = 1,
                                     grouping_structure) {
      output <- ""

      if (level > ncol(grouped_data)) {
        return(output)
      }


      for(value in unique(grouped_data[[level]])) {

        heading_line <- insert_section_heading_line(
          grouped_data = grouped_data,
          level = level,
          chapter_structure = chapter_structure,
          value = value)

        # Add heading line if not a .template_name or chapter
        if(!names(grouped_data)[level] %in% c(dots$ignore_heading_for_group, ".variable_group_dep") &&
           level < ncol(grouped_data)) {

          output <-
            stringi::stri_c(output,
                            heading_line,
                            sep="\n",
                            ignore_null=TRUE)
        }

        # Keep only relevant part of meta data


        sub_df <- vctrs::vec_slice(grouped_data,
                                   is.na(as.character(grouped_data[[colnames(grouped_data)[level]]])) |
                                     as.character(grouped_data[[colnames(grouped_data)[level]]]) == value)

        sub_df <- droplevels(sub_df)


        # Setting a specific sub-chapter (e.g. a label_prefix) as the column name. WHY?
        names(grouping_structure)[level] <- value

        # If innermost/deepest level, start producing contents
        if(level == length(grouping_structure)) {

          # Create new metadata with bare minimum needed, and reapply grouping
          chapter_structure_section <- chapter_structure

          if(all(is.na(chapter_structure_section$chapter)) && nrow(chapter_structure_section)>1) browser()

          for(i in seq_along(grouping_structure)) {
            variable <- as.character(chapter_structure_section[[grouping_structure[[i]]]])
            lgl_filter <-
              (!is.na(names(grouping_structure)[i]) & !is.na(variable) & variable == names(grouping_structure)[i]) |
              (is.na(names(grouping_structure)[i]) & is.na(variable))

            chapter_structure_section <-
              vctrs::vec_slice(chapter_structure_section, lgl_filter)
          }
          if(all(is.na(chapter_structure_section$.variable_name_dep)) &&
             nrow(chapter_structure_section) > 1) browser()

          chapter_structure_section <- droplevels(chapter_structure_section)

          if(nrow(chapter_structure_section) >= 1) {


            chapter_structure_section <-
              dplyr::group_by(chapter_structure_section,
                              dplyr::pick(tidyselect::all_of(unname(grouping_structure))))
            chapter_structure_section <- droplevels(chapter_structure_section)


            new_out <-
              chapter_structure_section |>
              dplyr::group_map(.keep = TRUE,
                               .f = ~insert_chunk(
                                 chapter_structure_section = .x,
                                 .y=.y,
                                 grouping_structure = unname(grouping_structure),
                                 dots = dots
                               ))

            output <- attach_new_output_to_output(new_out = new_out,
                                                  output = output,
                                                  level = level,
                                                  grouped_data = grouped_data,
                                                  heading_line = heading_line)

          }
        }


        added <- # Recursive call
          gen_group_structure(grouped_data = sub_df,
                               level = level + 1,
                               grouping_structure = grouping_structure)
        added <- stringi::stri_remove_empty_na(added)
        output <-
          stringi::stri_c(output,
                          added,
                          sep="\n\n", ignore_null=TRUE) # Space between each section (before new heading)
      }

      if(length(output)>1 || (length(output)==1 && is.na(output))) browser()

      return(output)
    }

    grouping_structure <- dplyr::group_vars(chapter_structure)
    non_grouping_vars <- colnames(chapter_structure)[!colnames(chapter_structure) %in% grouping_structure]

    grouped_data <- chapter_structure
    grouped_data <-dplyr::group_by(grouped_data, dplyr::pick(tidyselect::all_of(grouping_structure)))
    grouped_data <- dplyr::distinct(grouped_data, dplyr::pick(tidyselect::all_of(grouping_structure)))

    out <-
      gen_group_structure(grouped_data = grouped_data,
                           grouping_structure = grouping_structure)
    out
  }
