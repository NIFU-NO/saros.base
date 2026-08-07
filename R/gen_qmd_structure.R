# Two traversal engines over the grouping tree, producing byte-identical output.
#
# `recursion` is the original implementation. `loop` walks the same tree with an
# explicit stack, so depth is bounded by heap rather than by R's expression
# nesting limit (GH #19).
#
# The per-node work lives in gen_qmd_node() and the two combining steps in
# combine_child_output()/assert_node_output(), so the engines differ ONLY in how
# they traverse. Anything else would let them drift apart silently.

# Everything one (level, value) pair does. Shared by both engines.
#
# Returns the updated `output` and `new_out` plus the filtered `sub_df` and the
# `grouping_structure` to hand to the next level down.
gen_qmd_node <- function(value,
                         grouped_data,
                         level,
                         grouping_structure,
                         chapter_structure,
                         output,
                         new_out,
                         ignore_heading_for_group,
                         replace_heading_for_group,
                         prefix_heading_for_group,
                         suffix_heading_for_group) {
  # Keep only the part of the metadata that belongs below this value.
  sub_df <-
    vctrs::vec_slice(
      grouped_data,
      as.character(grouped_data[[colnames(grouped_data)[level]]]) %in% value
    ) |>
    droplevels()

  # The *names* of `grouping_structure` are a side channel carrying the path of
  # chosen values down to this level, which avoids threading it through as an
  # extra argument. That path is also what makes the anchor suffix stable and
  # unique (GH #213).
  names(grouping_structure)[level] <- value

  # If innermost/deepest level, insert chunk.
  if (level == length(grouping_structure)) {
    chapter_structure_section <-
      prepare_chapter_structure_section(
        chapter_structure = chapter_structure,
        grouping_structure = grouping_structure
      )

    if (nrow(chapter_structure_section) >= 1) {
      new_out <-
        insert_chunk(
          chapter_structure_section = chapter_structure_section,
          grouping_structure = unname(grouping_structure)
        )
    }
  }
  # NB: when the section is empty, `new_out` deliberately keeps whatever the
  # previous sibling produced. That is what the recursive implementation has
  # always done -- `new_out` is declared outside its for loop -- so it is
  # preserved here rather than quietly corrected.

  heading_line <-
    insert_section_heading_line(
      grouped_data = grouped_data,
      level = level,
      chapter_structure = chapter_structure,
      value = value,
      grouping_structure = grouping_structure,
      ignore_heading_for_group = ignore_heading_for_group,
      replace_heading_for_group = replace_heading_for_group,
      prefix_heading_for_group = prefix_heading_for_group,
      suffix_heading_for_group = suffix_heading_for_group
    )

  output <-
    attach_new_output_to_output(
      output = output,
      heading_line = heading_line,
      new_out = new_out,
      level = level,
      grouping_structure = grouping_structure
    )

  list(
    output = output,
    new_out = new_out,
    grouping_structure = grouping_structure,
    sub_df = sub_df
  )
}

# Fold a completed child's return value into its parent's accumulator. Blank
# line between each section, before the next heading.
combine_child_output <- function(output, added) {
  added <- stringi::stri_remove_empty_na(added)
  output <- stringi::stri_c(output, added, sep = "\n\n", ignore_null = TRUE)
  if (length(output) > 0) output else ""
}

assert_node_output <- function(output) {
  if (length(output) != 1 || is.na(output)) {
    cli::cli_abort(c(
      "x" = "Internal error in {.fn gen_qmd_structure}",
      "!" = "{.val output} is {output}",
      i = "Please create a bug report at {.url https://github.com/NIFU-NO/saros.base/issues}."
    ))
  }
  output
}

# The values one level iterates over.
#
# `for (value in <factor>)` hands the body a character, not a factor element,
# so the loop engine -- which indexes with [[ ]] -- has to coerce or it would
# pass a one-element factor where the recursion passes a string. Non-factor
# columns are left alone, since `for` yields their elements unchanged.
level_values <- function(grouped_data, level) {
  values <- unique(grouped_data[[level]])
  if (is.factor(values)) as.character(values) else values
}

gen_group_structure_recursion <-
  function(grouped_data,
           grouping_structure,
           chapter_structure,
           ignore_heading_for_group,
           replace_heading_for_group,
           prefix_heading_for_group,
           suffix_heading_for_group) {
    walk <- function(grouped_data, level, grouping_structure) {
      output <- character()
      new_out <- character()

      if (level > ncol(grouped_data)) {
        return(output)
      }

      for (value in level_values(grouped_data, level)) {
        node <-
          gen_qmd_node(
            value = value,
            grouped_data = grouped_data,
            level = level,
            grouping_structure = grouping_structure,
            chapter_structure = chapter_structure,
            output = output,
            new_out = new_out,
            ignore_heading_for_group = ignore_heading_for_group,
            replace_heading_for_group = replace_heading_for_group,
            prefix_heading_for_group = prefix_heading_for_group,
            suffix_heading_for_group = suffix_heading_for_group
          )
        output <- node$output
        new_out <- node$new_out

        added <- walk(node$sub_df, level + 1, node$grouping_structure)
        output <- combine_child_output(output, added)
      }

      assert_node_output(output)
    }

    walk(grouped_data, 1, grouping_structure)
  }

gen_group_structure_loop <-
  function(grouped_data,
           grouping_structure,
           chapter_structure,
           ignore_heading_for_group,
           replace_heading_for_group,
           prefix_heading_for_group,
           suffix_heading_for_group) {
    # One list element per activation the recursion would have had.
    new_frame <- function(grouped_data, level, grouping_structure) {
      beyond <- level > ncol(grouped_data)
      list(
        grouped_data = grouped_data,
        level = level,
        grouping_structure = grouping_structure,
        values = if (beyond) character() else level_values(grouped_data, level),
        idx = 1L,
        output = character(),
        new_out = character(),
        beyond = beyond
      )
    }

    stack <- list(new_frame(grouped_data, 1, grouping_structure))
    # Carries a finished child's return value back to the parent, arriving
    # exactly where `added <- walk(...)` receives it in the recursion.
    pending <- NULL
    have_pending <- FALSE

    repeat {
      depth <- length(stack)
      frame <- stack[[depth]]

      # The recursion's early return: character(), and crucially *before* the
      # length-1 assertion, which it therefore never reaches.
      if (frame$beyond) {
        stack[[depth]] <- NULL
        pending <- character()
        have_pending <- TRUE
        if (length(stack) == 0L) {
          return(pending)
        }
        next
      }

      if (have_pending) {
        frame$output <- combine_child_output(frame$output, pending)
        have_pending <- FALSE
        frame$idx <- frame$idx + 1L
      }

      # End of this level's loop.
      if (frame$idx > length(frame$values)) {
        output <- assert_node_output(frame$output)
        stack[[depth]] <- NULL
        pending <- output
        have_pending <- TRUE
        if (length(stack) == 0L) {
          return(pending)
        }
        next
      }

      node <-
        gen_qmd_node(
          value = frame$values[[frame$idx]],
          grouped_data = frame$grouped_data,
          level = frame$level,
          grouping_structure = frame$grouping_structure,
          chapter_structure = chapter_structure,
          output = frame$output,
          new_out = frame$new_out,
          ignore_heading_for_group = ignore_heading_for_group,
          replace_heading_for_group = replace_heading_for_group,
          prefix_heading_for_group = prefix_heading_for_group,
          suffix_heading_for_group = suffix_heading_for_group
        )
      frame$output <- node$output
      frame$new_out <- node$new_out

      stack[[depth]] <- frame
      stack[[depth + 1L]] <- new_frame(node$sub_df, frame$level + 1, node$grouping_structure)
    }
  }

#' @keywords internal
gen_qmd_structure <-
  function(chapter_structure,
           ignore_heading_for_group = NULL,
           replace_heading_for_group = NULL,
           prefix_heading_for_group = NULL,
           suffix_heading_for_group = NULL,
           engine = c("recursion", "loop")) {
    engine <- rlang::arg_match(engine)

    grouping_structure <- dplyr::group_vars(chapter_structure)

    grouped_data <-
      chapter_structure |>
      dplyr::grouped_df(vars = grouping_structure) |>
      dplyr::distinct(dplyr::pick(tidyselect::all_of(grouping_structure)))

    engine_fn <-
      switch(engine,
        recursion = gen_group_structure_recursion,
        loop = gen_group_structure_loop
      )

    engine_fn(
      grouped_data = grouped_data,
      grouping_structure = grouping_structure,
      chapter_structure = chapter_structure,
      ignore_heading_for_group = ignore_heading_for_group,
      replace_heading_for_group = replace_heading_for_group,
      prefix_heading_for_group = prefix_heading_for_group,
      suffix_heading_for_group = suffix_heading_for_group
    )
  }
