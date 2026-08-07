# A deepest-level section that matches no rows must contribute nothing (GH #239).
#
# `new_out` used to be threaded through the sibling loop and reassigned only
# when a section was non-empty, so an empty section kept whatever the previous
# sibling produced and emitted it under its own heading -- silently, and looking
# entirely plausible in the rendered report.
#
# The integration path cannot currently produce an empty section: `grouped_data`
# is distinct() over the grouping columns of `chapter_structure`, so every
# traversal path corresponds to at least one real row and the filter in
# prepare_chapter_structure_section() finds it. That protection is an invariant
# held elsewhere, not a local guarantee -- a change to how `grouped_data` is
# derived, to NA handling in that filter, or a grouping column whose values do
# not round-trip through as.character() would turn a should-be-empty section
# into a wrong-chunk section, with no error and no warning. So the empty section
# is constructed here directly, by handing the engines a `grouped_data` with one
# path that `chapter_structure` has no row for.

grouping_vars <- c("chapter", ".template_name")

# Minimal metadata: one section per chapter, each with its own template whose
# body is a literal marker. glue leaves a brace-free template alone, so a chunk
# that surfaces in the wrong section names the sibling it leaked from.
chapter_structure_fixture <-
  dplyr::grouped_df(
    tibble::tibble(
      chapter = c("Ch1", "Ch2"),
      .template_name = c("tmpl_a", "tmpl_b"),
      .variable_name_dep = c("x1", "x2"),
      .template = c("CHUNK-FROM-TMPL-A", "CHUNK-FROM-TMPL-B")
    ),
    vars = grouping_vars
  )

# What gen_qmd_structure() derives today: exactly one path per real section.
grouped_data_real <-
  dplyr::distinct(
    chapter_structure_fixture,
    dplyr::pick(tidyselect::all_of(grouping_vars))
  )

# The same tree plus (Ch1, tmpl_b), which matches no row of the metadata. It
# follows tmpl_a as a sibling under Ch1, so CHUNK-FROM-TMPL-A is the stale value
# it would inherit. Both "Ch1" and "tmpl_b" occur in `chapter_structure`, just
# never together, so the heading still resolves: the section is empty, the value
# is not unknown.
grouped_data_phantom <-
  dplyr::grouped_df(
    tibble::tibble(
      chapter = c("Ch1", "Ch1", "Ch2"),
      .template_name = c("tmpl_a", "tmpl_b", "tmpl_b")
    ),
    vars = grouping_vars
  )

gen_structure <- function(engine, grouped_data) {
  engine_fn <- switch(engine,
    recursion = saros.base:::gen_group_structure_recursion,
    loop = saros.base:::gen_group_structure_loop
  )
  engine_fn(
    grouped_data = grouped_data,
    grouping_structure = grouping_vars,
    chapter_structure = chapter_structure_fixture,
    ignore_heading_for_group = NULL,
    replace_heading_for_group = NULL,
    prefix_heading_for_group = NULL,
    suffix_heading_for_group = NULL
  )
}

n_occurrences <- function(x, pattern) {
  lengths(regmatches(x, gregexpr(pattern, x, fixed = TRUE)))
}

################################################################################

testthat::test_that("the fixture emits one chunk per non-empty section", {
  # Guards everything below: if the markers never made it into the output, an
  # assertion that one of them appears once would be trivially satisfiable.
  for (engine in c("recursion", "loop")) {
    out <- gen_structure(engine, grouped_data_real)
    testthat::expect_identical(n_occurrences(out, "CHUNK-FROM-TMPL-A"), 1L, info = engine)
    testthat::expect_identical(n_occurrences(out, "CHUNK-FROM-TMPL-B"), 1L, info = engine)
    testthat::expect_match(out, "## tmpl_a{#sec-tmpl-a-", fixed = TRUE)
  }
})

testthat::test_that("an empty section does not emit the previous sibling's chunk", {
  for (engine in c("recursion", "loop")) {
    out <- gen_structure(engine, grouped_data_phantom)
    testthat::expect_identical(
      n_occurrences(out, "CHUNK-FROM-TMPL-A"), 1L,
      info = paste0(engine, ": tmpl_a's chunk must appear only under tmpl_a")
    )
    testthat::expect_identical(
      n_occurrences(out, "CHUNK-FROM-TMPL-B"), 1L,
      info = paste0(engine, ": tmpl_b's chunk must appear only under Ch2")
    )
  }
})

testthat::test_that("an empty section emits nothing at all, not even its heading", {
  # attach_new_output_to_output() drops the heading of a deepest-level section
  # with no chunk, so a traversal that visits an extra empty path must produce
  # byte-identical output to one that does not.
  for (engine in c("recursion", "loop")) {
    testthat::expect_identical(
      gen_structure(engine, grouped_data_phantom),
      gen_structure(engine, grouped_data_real),
      info = engine
    )
  }
})

testthat::test_that("the engines agree on a tree containing an empty section", {
  testthat::expect_identical(
    gen_structure("loop", grouped_data_phantom),
    gen_structure("recursion", grouped_data_phantom)
  )
})

################################################################################
# The same property one level down, at the node that owns it.
################################################################################

testthat::test_that("gen_qmd_node leaves `output` untouched for a path with no rows", {
  # `output` carries what the siblings so far have produced. A deepest-level
  # path matching no rows must add neither a heading nor a chunk to it.
  node <- saros.base:::gen_qmd_node(
    value = "tmpl_b",
    grouped_data = grouped_data_phantom,
    level = 2L,
    grouping_structure = stats::setNames(grouping_vars, c("Ch1", NA)),
    chapter_structure = chapter_structure_fixture,
    output = "CHUNK-FROM-TMPL-A",
    ignore_heading_for_group = NULL,
    replace_heading_for_group = NULL,
    prefix_heading_for_group = NULL,
    suffix_heading_for_group = NULL
  )
  testthat::expect_identical(node$output, "CHUNK-FROM-TMPL-A")
})

testthat::test_that("gen_qmd_node still emits heading and chunk for a path with rows", {
  # The counterpart, so the assertion above cannot be met by a node that emits
  # nothing whatever the path.
  node <- saros.base:::gen_qmd_node(
    value = "tmpl_a",
    grouped_data = grouped_data_phantom,
    level = 2L,
    grouping_structure = stats::setNames(grouping_vars, c("Ch1", NA)),
    chapter_structure = chapter_structure_fixture,
    output = "EARLIER OUTPUT",
    ignore_heading_for_group = NULL,
    replace_heading_for_group = NULL,
    prefix_heading_for_group = NULL,
    suffix_heading_for_group = NULL
  )
  testthat::expect_match(node$output, "^EARLIER OUTPUT")
  testthat::expect_match(node$output, "## tmpl_a{#sec-tmpl-a-", fixed = TRUE)
  testthat::expect_match(node$output, "CHUNK-FROM-TMPL-A", fixed = TRUE)
})
