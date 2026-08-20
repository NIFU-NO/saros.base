# The setup chunk every generated chapter opens with, and the argument that
# controls it (GH #119, and review of PR #263).
#
# The chunk exists so that a project supplying its own `chunk_templates` --
# written the way the defaults used to be, with unqualified `makeme(...)` and
# `gt(...)` -- still gets a chapter that renders. The default chunk templates
# no longer need it, being namespace-qualified.
#
# It is configurable rather than fixed because `saros` and `gt` are in neither
# `Imports` nor `Suggests` of this package. An unconditional `library(gt)`
# would make every chapter of a project whose own templates never touch `gt`
# fail outright if `gt` is not installed -- a wider blast radius than before,
# where only a chapter actually using a gt template failed.

setup_chunk <- function(...) saros.base:::chapter_setup_chunk(...)

draft_with_packages <- function(path, ...) {
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(chapter = "Ch1", dep = "a_1", indep = ""),
      data = saros.base::ex_survey,
      label_separator = " - ",
      progress = FALSE
    )
  ))
  # Deliberately not wrapped in suppressWarnings(): the validator warns on a
  # bad `chapter_setup_packages` and one test asserts on that warning.
  suppressMessages(saros.base::draft_report(
    data = saros.base::ex_survey,
    chapter_structure = chapter_structure,
    path = path,
    ...
  ))
  readLines(fs::path(path, "1_Ch1.qmd"), warn = FALSE)
}

################################################################################

testthat::test_that("the default attaches saros and gt", {
  out <- setup_chunk("1_Ch1")
  testthat::expect_match(out, "library(saros)", fixed = TRUE)
  testthat::expect_match(out, "library(gt)", fixed = TRUE)
  testthat::expect_match(out, "#| include: false", fixed = TRUE)
})

testthat::test_that("only the named packages are attached", {
  out <- setup_chunk("1_Ch1", packages = "saros")
  testthat::expect_match(out, "library(saros)", fixed = TRUE)
  testthat::expect_no_match(out, "library(gt)", fixed = TRUE)
})

testthat::test_that("no packages means no chunk at all", {
  # Not an empty chunk: an empty ```{r}``` block is still executed by knitr and
  # still renders an empty cell, so the absence has to be total.
  testthat::expect_null(setup_chunk("1_Ch1", packages = NULL))
  testthat::expect_null(setup_chunk("1_Ch1", packages = character()))
})

################################################################################

testthat::test_that("draft_report() attaches saros and gt by default", {
  path <- withr::local_tempdir()
  chapter <- draft_with_packages(path)
  testthat::expect_true(any(grepl("library(saros)", chapter, fixed = TRUE)))
  testthat::expect_true(any(grepl("library(gt)", chapter, fixed = TRUE)))
})

testthat::test_that("draft_report(chapter_setup_packages=) controls what is attached", {
  path <- withr::local_tempdir()
  chapter <- draft_with_packages(path, chapter_setup_packages = c("saros", "tibble"))
  testthat::expect_true(any(grepl("library(tibble)", chapter, fixed = TRUE)))
  testthat::expect_false(any(grepl("library(gt)", chapter, fixed = TRUE)))
})

testthat::test_that("draft_report(chapter_setup_packages=NULL) emits no setup chunk", {
  # The escape hatch for a project whose own chunk_templates need neither
  # package, and which therefore should not be forced to install them.
  path <- withr::local_tempdir()
  chapter <- draft_with_packages(path, chapter_setup_packages = NULL)
  testthat::expect_false(any(grepl("library(", chapter, fixed = TRUE)))
  testthat::expect_false(any(grepl("Setup for", chapter, fixed = TRUE)))
  # The chapter is still generated, and still imports its dataset.
  testthat::expect_true(any(grepl("readRDS", chapter, fixed = TRUE)))
})

testthat::test_that("an invalid chapter_setup_packages is rejected", {
  path <- withr::local_tempdir()
  testthat::expect_warning(
    draft_with_packages(path, chapter_setup_packages = 42),
    regexp = "chapter_setup_packages"
  )
})
