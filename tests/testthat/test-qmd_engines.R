# The two traversal engines behind `draft_report(qmd_engine = )` must produce
# byte-identical output (GH #19).
#
# The recursion is the reference implementation; the loop walks the same tree
# with an explicit stack. If these ever disagree, the loop is wrong -- the
# snapshots in test-qmd_snapshots.R pin the recursion's output, so they are the
# arbiter of what "correct" means.
#
# Two semantics are easy to get wrong when converting, and both are checked
# indirectly by every case below:
#
#   1. `for (value in <factor>)` hands the body a *character*. The loop engine
#      indexes with [[ ]], which yields a one-element factor instead, so
#      level_values() coerces. Without that, every downstream comparison of
#      `value` shifts.
#   2. The recursion returns character() as soon as `level > ncol(grouped_data)`,
#      before it reaches its length-1 assertion. The loop carries that on its
#      frame as `beyond` and unwinds without asserting.
#
# What each node emits on its own is pinned separately, in
# test-qmd_empty_section.R -- these engines agreeing says nothing about whether
# they agree on the right thing.

draft_with <- function(overview, engine, envir = parent.frame(), ...) {
  path <- withr::local_tempdir(.local_envir = envir)
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = overview,
      data = saros.base::ex_survey,
      label_separator = " - ",
      progress = FALSE
    )
  ))
  # engine = NULL omits the argument entirely, exercising the default.
  call_args <- list(
    data = saros.base::ex_survey,
    chapter_structure = chapter_structure,
    path = path,
    ...
  )
  if (!is.null(engine)) call_args$qmd_engine <- engine
  suppressMessages(do.call(saros.base::draft_report, call_args))
  path
}

# Contents of every generated .qmd, keyed by relative path, so a difference in
# *which* files were written shows up as well as a difference in their text.
qmd_contents <- function(path) {
  files <- sort(fs::path_rel(
    fs::dir_ls(path, recurse = TRUE, type = "file", glob = "*.qmd"),
    start = path
  ))
  stats::setNames(
    lapply(files, function(f) readLines(fs::path(path, f), warn = FALSE)),
    files
  )
}

expect_engines_agree <- function(overview, ...) {
  recursion <- qmd_contents(draft_with(overview, "recursion", ...))
  loop <- qmd_contents(draft_with(overview, "loop", ...))
  testthat::expect_identical(names(loop), names(recursion))
  testthat::expect_identical(loop, recursion)
}

################################################################################

testthat::test_that("engines agree on a single univariate chapter", {
  expect_engines_agree(data.frame(chapter = "Bakgrunn", dep = "x1_sex", indep = ""))
})

testthat::test_that("engines agree on a battery with a bivariate", {
  expect_engines_agree(data.frame(
    chapter = c("Trivsel", "Trivsel", "Bakgrunn"),
    dep = c("a_1, a_2", "b_1", "x1_sex"),
    indep = c("x1_sex", "", "")
  ))
})

testthat::test_that("engines agree on the bundled example report", {
  # The widest fixture available: every chapter, every template the defaults
  # reach, and the deepest grouping the example produces.
  path_recursion <- withr::local_tempdir()
  path_loop <- withr::local_tempdir()
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = saros.base::ex_survey_ch_overview,
      data = saros.base::ex_survey,
      progress = FALSE
    )
  ))
  for (engine_path in list(
    list(engine = "recursion", path = path_recursion),
    list(engine = "loop", path = path_loop)
  )) {
    suppressMessages(saros.base::draft_report(
      data = saros.base::ex_survey,
      chapter_structure = chapter_structure,
      path = engine_path$path,
      qmd_engine = engine_path$engine
    ))
  }
  testthat::expect_identical(qmd_contents(path_loop), qmd_contents(path_recursion))
})

testthat::test_that("engines agree on a deeper grouping", {
  # Adds .variable_label_suffix_dep, so the tree gains a level and the loop's
  # stack has to unwind more than once between siblings.
  path_recursion <- withr::local_tempdir()
  path_loop <- withr::local_tempdir()
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(
        chapter = c("Trivsel", "Trivsel"),
        dep = c("a_1, a_2", "b_1"),
        indep = c("x1_sex", "")
      ),
      data = saros.base::ex_survey,
      label_separator = " - ",
      progress = FALSE,
      organize_by = c(
        ".chapter_number", ".variable_label_prefix_dep",
        ".variable_label_suffix_dep", ".variable_name_indep", ".template_name"
      )
    )
  ))
  for (engine_path in list(
    list(engine = "recursion", path = path_recursion),
    list(engine = "loop", path = path_loop)
  )) {
    suppressMessages(saros.base::draft_report(
      data = saros.base::ex_survey,
      chapter_structure = chapter_structure,
      path = engine_path$path,
      qmd_engine = engine_path$engine
    ))
  }
  testthat::expect_identical(qmd_contents(path_loop), qmd_contents(path_recursion))
})

testthat::test_that("engines agree under non-default chunk templates", {
  path_recursion <- withr::local_tempdir()
  path_loop <- withr::local_tempdir()
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(
        chapter = c("Trivsel", "Bakgrunn"),
        dep = c("a_1, a_2", "x1_sex"),
        indep = c("x1_sex", "")
      ),
      data = saros.base::ex_survey,
      label_separator = " - ",
      progress = FALSE,
      chunk_templates = saros.base::get_chunk_template_defaults(2)
    )
  ))
  for (engine_path in list(
    list(engine = "recursion", path = path_recursion),
    list(engine = "loop", path = path_loop)
  )) {
    suppressMessages(saros.base::draft_report(
      data = saros.base::ex_survey,
      chapter_structure = chapter_structure,
      path = engine_path$path,
      qmd_engine = engine_path$engine
    ))
  }
  testthat::expect_identical(qmd_contents(path_loop), qmd_contents(path_recursion))
})

################################################################################

testthat::test_that("qmd_engine rejects an unknown engine", {
  testthat::expect_error(
    suppressMessages(draft_with(
      data.frame(chapter = "Bakgrunn", dep = "x1_sex", indep = ""),
      engine = "iterative"
    )),
    class = "rlang_error"
  )
})

testthat::test_that("omitting qmd_engine gives the recursion engine", {
  # Asserted behaviourally rather than by reading the default out of formals():
  # what matters is that an unchanged call still runs the reference engine.
  overview <- data.frame(
    chapter = c("Trivsel", "Bakgrunn"),
    dep = c("a_1, a_2", "x1_sex"),
    indep = c("x1_sex", "")
  )
  default <- qmd_contents(draft_with(overview, engine = NULL))
  recursion <- qmd_contents(draft_with(overview, "recursion"))
  testthat::expect_identical(default, recursion)
})
