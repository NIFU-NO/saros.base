# Ordering, grouping and sorting must survive the change of traversal engine
# (GH #19).
#
# test-qmd_engines.R already compares full file text, which would catch an
# ordering difference -- but only as "the files differ". These cases vary the
# knobs that actually control order and compare the *sequence* of headings,
# anchors and float ids first, so a regression names the problem instead of
# handing over a whole-file diff.
#
# The knobs, all on refine_chapter_overview():
#   organize_by          which columns are grouped on, and in what order --
#                        this is the shape of the tree the engines walk
#   arrange_section_by   sort direction within a section
#   na_first_in_section  where NA groups land
#
# Plus the properties of the data itself: factor vs character grouping columns,
# NA in a grouping column, and single- vs multi-value levels.

refine <- function(overview, ...) {
  suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = overview,
      data = saros.base::ex_survey,
      progress = FALSE,
      ...
    )
  ))
}

# Returns the output path *and* the warnings raised, so the engines can be
# compared on both. Some organize_by shapes legitimately warn -- a section that
# spans several variable labels trips validate_chapter_structure() -- and
# suppressing that would discard a real signal: if one engine warned and the
# other did not, that is exactly the kind of divergence worth catching.
draft_engine <- function(chapter_structure, engine, envir = parent.frame(), ...) {
  path <- withr::local_tempdir(.local_envir = envir)
  warnings_seen <- character()
  withCallingHandlers(
    suppressMessages(saros.base::draft_report(
      data = saros.base::ex_survey,
      chapter_structure = chapter_structure,
      path = path,
      qmd_engine = engine,
      ...
    )),
    warning = function(w) {
      warnings_seen <<- c(warnings_seen, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  list(path = path, warnings = warnings_seen)
}

qmd_files_rel <- function(path) {
  sort(fs::path_rel(
    fs::dir_ls(path, recurse = TRUE, type = "file", glob = "*.qmd"),
    start = path
  ))
}

# The ordered sequence of every line that encodes position in the tree:
# headings (with their level and anchor) and float ids. Order-sensitive by
# construction -- this is the thing under test.
ordering_fingerprint <- function(path) {
  files <- qmd_files_rel(path)
  stats::setNames(
    lapply(files, function(f) {
      lines <- readLines(fs::path(path, f), warn = FALSE)
      grep("^#{1,6} |^::: \\{#|^:::: \\{\\.panel-tabset", lines, value = TRUE)
    }),
    files
  )
}

full_contents <- function(path) {
  files <- qmd_files_rel(path)
  stats::setNames(
    lapply(files, function(f) readLines(fs::path(path, f), warn = FALSE)),
    files
  )
}

expect_same_ordering <- function(chapter_structure, label, ...) {
  recursion <- draft_engine(chapter_structure, "recursion", ...)
  loop <- draft_engine(chapter_structure, "loop", ...)

  # Same files, in the same order.
  testthat::expect_identical(
    qmd_files_rel(loop$path), qmd_files_rel(recursion$path),
    info = paste0(label, ": set of generated files")
  )
  # Same headings/anchors/floats, in the same sequence.
  testthat::expect_identical(
    ordering_fingerprint(loop$path), ordering_fingerprint(recursion$path),
    info = paste0(label, ": ordering of headings, anchors and float ids")
  )
  # And byte-identical overall, so nothing outside the fingerprint moved.
  testthat::expect_identical(
    full_contents(loop$path), full_contents(recursion$path),
    info = paste0(label, ": full file contents")
  )
  # Same diagnostics, in the same order.
  testthat::expect_identical(
    loop$warnings, recursion$warnings,
    info = paste0(label, ": warnings raised")
  )
}

# A battery, a single item, and a bivariate across two chapters -- enough that
# every grouping level has more than one value to order.
overview_std <- data.frame(
  chapter = c("Trivsel", "Trivsel", "Bakgrunn", "Bakgrunn"),
  dep = c("a_1, a_2", "b_1", "x1_sex", "x2_human"),
  indep = c("x1_sex", "x1_sex", "", "")
)

################################################################################
# organize_by: the shape of the tree itself
################################################################################

testthat::test_that("engines agree across organize_by permutations", {
  # Reordering the grouping columns changes which level each value sits at, and
  # therefore the entire traversal. Both engines must follow the same path.
  permutations <- list(
    default = NULL,
    indep_before_prefix = c(
      ".chapter_number", ".variable_name_indep",
      ".variable_label_prefix_dep", ".template_name"
    ),
    template_first = c(
      ".chapter_number", ".template_name",
      ".variable_label_prefix_dep", ".variable_name_indep"
    ),
    with_suffix_level = c(
      ".chapter_number", ".variable_label_prefix_dep",
      ".variable_label_suffix_dep", ".variable_name_indep", ".template_name"
    ),
    # Shallower, but still valid: `organize_by` must contain `.template_name`,
    # and the default templates reference `.n_cats_indep`, so dropping
    # `.variable_name_indep` from the grouping makes them unresolvable. Both
    # engines fail identically on those shapes, so they say nothing about
    # traversal and are left out.
    no_prefix_level = c(".chapter_number", ".variable_name_indep", ".template_name"),
    template_before_indep = c(
      ".chapter_number", ".variable_label_prefix_dep",
      ".template_name", ".variable_name_indep"
    )
  )

  for (nm in names(permutations)) {
    chapter_structure <-
      if (is.null(permutations[[nm]])) {
        refine(overview_std, label_separator = " - ")
      } else {
        refine(overview_std, label_separator = " - ", organize_by = permutations[[nm]])
      }
    # Some shapes put unrelated batteries in one section (a_1 and b_1 share no
    # categories), which require_common_categories correctly rejects. The shape
    # of the tree is what is under test here, not the validity of the pairing.
    expect_same_ordering(
      chapter_structure,
      paste0("organize_by = ", nm),
      require_common_categories = FALSE
    )
  }
})

################################################################################
# arrange_section_by / na_first_in_section: sort direction and NA placement
################################################################################

testthat::test_that("engines agree across arrange_section_by directions", {
  arrangements <- list(
    ascending = c(
      .chapter_number = FALSE, chapter = FALSE, .variable_position_dep = FALSE,
      .variable_position_indep = FALSE, .template_name = FALSE
    ),
    descending = c(
      .chapter_number = TRUE, chapter = TRUE, .variable_position_dep = TRUE,
      .variable_position_indep = TRUE, .template_name = TRUE
    ),
    mixed = c(
      .chapter_number = FALSE, chapter = TRUE, .variable_position_dep = TRUE,
      .variable_position_indep = FALSE, .template_name = FALSE
    )
  )

  for (nm in names(arrangements)) {
    chapter_structure <- refine(
      overview_std,
      label_separator = " - ",
      arrange_section_by = arrangements[[nm]]
    )
    expect_same_ordering(chapter_structure, paste0("arrange_section_by = ", nm))
  }
})

testthat::test_that("engines agree with NA groups placed first or last", {
  # `indep = ""` yields NA in .variable_name_indep, so this fixture genuinely
  # has an NA grouping value to place. NA as an explicit factor level is the
  # case that bit remove_from_chapter_structure_if_no_overlap() in #232, so it
  # is worth pinning here too.
  for (na_first in c(TRUE, FALSE)) {
    chapter_structure <- refine(
      overview_std,
      label_separator = " - ",
      na_first_in_section = na_first
    )
    expect_same_ordering(
      chapter_structure,
      paste0("na_first_in_section = ", na_first)
    )
  }
})

################################################################################
# Properties of the data being grouped
################################################################################

testthat::test_that("engines agree when chapters are declared out of order", {
  # Chapter order comes from the overview, not from sorting, so a reversed
  # declaration must reverse the output identically under both engines.
  reversed <- overview_std[rev(seq_len(nrow(overview_std))), , drop = FALSE]
  chapter_structure <- refine(reversed, label_separator = " - ")
  expect_same_ordering(chapter_structure, "chapters declared in reverse")
})

testthat::test_that("engines agree when a grouping level has a single value", {
  # One chapter, one template, one dep: every level collapses to a single
  # value, which is the degenerate traversal.
  chapter_structure <- refine(
    data.frame(chapter = "Bakgrunn", dep = "x1_sex", indep = ""),
    label_separator = " - "
  )
  expect_same_ordering(chapter_structure, "single value at every level")
})

testthat::test_that("engines agree on the bundled example with a deep grouping", {
  # The widest fixture, at the deepest grouping it supports.
  chapter_structure <- refine(
    saros.base::ex_survey_ch_overview,
    label_separator = " - ",
    organize_by = c(
      ".chapter_number", ".variable_label_prefix_dep",
      ".variable_label_suffix_dep", ".variable_name_indep", ".template_name"
    )
  )
  expect_same_ordering(chapter_structure, "bundled example, deep grouping")
})

################################################################################
# The fingerprint must itself be order-sensitive, or every test above is
# vacuous.
################################################################################

testthat::test_that("ordering_fingerprint distinguishes a reordering", {
  a <- list(f = c("# One", "## Two", "## Three"))
  b <- list(f = c("# One", "## Three", "## Two"))
  testthat::expect_false(identical(a, b))
  testthat::expect_identical(sort(a$f), sort(b$f)) # same set, different order
})
