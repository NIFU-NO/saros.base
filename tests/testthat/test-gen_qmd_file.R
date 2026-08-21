
################################################################################
testthat::test_that("gen_qmd_file works for creating index", {
  # Test 1: Basic test with title, authors, etc
  result <- saros.base:::gen_qmd_file(
    path = tempdir(),
    filename = "report",
    title = "This is a report-file",
    authors = c("Mark Twain", "Stephen King"))

  testthat::expect_true(file.exists(file.path(tempdir(), "report.qmd")))

  result <- saros.base:::gen_qmd_file(
    path = tempdir(),
    filename = "index",
    title = "This is an index-file",
    authors = c("Mark Twain", "Stephen King"),
    output_formats = c("typst", "docx", "epub"),
    output_filename = "report")

  testthat::expect_true(file.exists(file.path(tempdir(), "index.qmd")))
})

# `format` must be validated like every other string argument (#268 review).
#
# gen_qmd_file() checks path, filename, yaml_file, both section filepaths,
# title, authors, output_formats and output_filename with check_string(), and
# `format` was the one string argument added without a check. It flows straight
# into process_yaml() and from there into the YAML front matter, so a
# non-character produces a malformed document rather than an error, or an error
# far from its cause.

testthat::test_that("gen_qmd_file() validates format like its other string arguments", {
  path <- withr::local_tempdir()

  testthat::expect_error(
    saros.base:::gen_qmd_file(path = path, filename = "report", format = 42),
    regexp = "format"
  )
  testthat::expect_error(
    saros.base:::gen_qmd_file(path = path, filename = "report", format = NULL),
    regexp = "format"
  )
  testthat::expect_error(
    saros.base:::gen_qmd_file(
      path = path, filename = "report", format = c("html", "pdf")
    ),
    regexp = "format"
  )
})

testthat::test_that("gen_qmd_file() accepts a single format string", {
  path <- withr::local_tempdir()
  testthat::expect_no_error(
    saros.base:::gen_qmd_file(path = path, filename = "report", format = "pdf")
  )
  written <- readLines(fs::path(path, "report.qmd"), warn = FALSE)
  testthat::expect_true(any(grepl("^format: pdf$", written)))
})
