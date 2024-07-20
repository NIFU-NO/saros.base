replace_label_groups_with_name_groups <- function(chapter_structure) {
  grouping_structure <- dplyr::group_vars(chapter_structure)

  if(length(grouping_structure)==0) cli::cli_warn("{.arg chapter_structure} should be grouped by a subset of columns.")
  if (any(c(".variable_label_prefix_dep", ".variable_label_suffix_dep") %in% grouping_structure)) {
    grouping_structure[grouping_structure %in% c(".variable_label_prefix_dep", ".variable_label_suffix_dep")] <- ".variable_name_dep"
  }

  if (any(c(".variable_label_prefix_indep", ".variable_label_suffix_indep") %in% grouping_structure)) {
    grouping_structure[grouping_structure %in% c(".variable_label_prefix_indep", ".variable_label_suffix_indep")] <- ".variable_name_indep"
  }
  grouping_structure <- unique(grouping_structure)
  chapter_structure <- dplyr::group_by(chapter_structure, dplyr::pick(tidyselect::all_of(grouping_structure)))
  chapter_structure
}
