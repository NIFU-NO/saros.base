
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
