# Stable, content-derived suffix disambiguating headings whose sanitized base
# collides.
#
# The base of an anchor is the sanitized group *value*, which is not unique on
# its own: the same value routinely appears under different parents within one
# chapter (e.g. an indep variable used in several sections), so some suffix is
# required. This used to be two RNG-drawn digits, which made `draft_report()`
# non-reproducible and defeated Quarto's `freeze` cache -- every chapter
# re-rendered after every regeneration (GH #213).
#
# The path of group values from the outermost level down to this one uniquely
# identifies a heading's position in the tree, so hashing it is both stable
# across runs and a stronger disambiguator than 2 digits (which collided 1% of
# the time for any given pair).
anchor_suffix <- function(grouping_structure, level) {
  path <- utils::head(
    c(
      rbind(
        as.character(grouping_structure), # the grouping columns
        as.character(names(grouping_structure)) # the value chosen at each level
      )
    ),
    n = 2L * level
  )
  substr(rlang::hash(paste(path, collapse = "\r")), 1L, 6L)
}

insert_section_heading_line <- function(grouped_data,
                                        level,
                                        chapter_structure,
                                        value,
                                        grouping_structure = character(),
                                        ignore_heading_for_group = NULL,
                                        replace_heading_for_group = NULL,
                                        prefix_heading_for_group = NULL,
                                        suffix_heading_for_group = NULL,
                                        glue_heading_for_group = NULL) {

  current_group <- names(grouped_data)[level]


  if(current_group %in% ignore_heading_for_group) return(character())

  if (is.character(replace_heading_for_group) && current_group %in% unname(replace_heading_for_group)) {
    renamed_group <- names(replace_heading_for_group)[replace_heading_for_group == current_group]
  } else renamed_group <- current_group

  heading <-
    unique(chapter_structure[chapter_structure[[current_group]] %in% value, renamed_group][[1]])

  # The only route into the heading *text*. `prefix_heading_for_group` and
  # `suffix_heading_for_group` below wrap the heading in whole lines, so they
  # cannot turn "Gender" into "By gender" under a "Self-efficacy" parent.
  #
  # Keyed on `current_group` -- the column actually grouped on -- like its four
  # siblings, not on `renamed_group`. Under the default
  # `replace_heading_for_group` those differ: `.variable_name_indep` is the
  # group, `.variable_label_suffix_indep` merely supplies the label.
  #
  # Placed after the label has been chosen, so `{heading}` is what the reader
  # would otherwise have seen, and before the anchor is appended, so `{#sec-}`
  # stays derived from `value` alone -- editing a template must not move a
  # cross-reference or invalidate Quarto's freeze cache (GH #213).
  if (current_group %in% names(glue_heading_for_group)) {
    heading <-
      tryCatch(
        as.character(glue::glue_data(
          list(heading = heading),
          glue_heading_for_group[[current_group]]
        )),
        error = function(cnd) glue_err(cnd = cnd, arg_name = "glue_heading_for_group")
      )
  }

  prefix <- if(current_group %in% names(prefix_heading_for_group)) {
    prefix_heading_for_group[current_group]
  } else {
    ""
  }
  suffix <- if(current_group %in% names(suffix_heading_for_group)) {
    suffix_heading_for_group[current_group]
  } else {
    ""
  }

  heading_line <-
    stringi::stri_c(prefix, "\n",
                    strrep("#", level),
                    " ",
                    heading,
                    "{#sec-", filename_sanitizer(value, sep = "-"), "-",
                        anchor_suffix(grouping_structure, level), "}\n",
                    suffix,
                    ignore_null = TRUE) |>
    stringi::stri_remove_empty_na()
}
