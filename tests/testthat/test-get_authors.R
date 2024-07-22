testthat::test_that("unique_authors handles single author strings", {
  result <- saros.base:::unique_authors(c("Author A", "Author B", "Author C"))
  testthat::expect_equal(result, c("Author A", "Author B", "Author C"))
})

testthat::test_that("unique_authors handles multiple author strings", {
  result <- saros.base:::unique_authors(c("Author A; Author B", "Author B; Author C"))
  testthat::expect_equal(result, c("Author A", "Author B", "Author C"))
})

testthat::test_that("unique_authors removes duplicates", {
  result <- saros.base:::unique_authors(c("Author A", "Author A; Author B", "Author B"))
  testthat::expect_equal(result, c("Author A", "Author B"))
})

testthat::test_that("unique_authors handles empty input", {
  result <- saros.base:::unique_authors(NULL)
  testthat::expect_equal(result, character(0))
})

testthat::test_that("unique_authors handles empty input", {
  result <- saros.base:::unique_authors(character(0))
  testthat::expect_equal(result, character(0))
})

testthat::test_that("unique_authors handles NA values", {
  result <- saros.base:::unique_authors(c("Author A; Author B", NA, "Author C"))
  testthat::expect_equal(result, c("Author A", "Author B", "Author C"))
})

testthat::test_that("get_authors handles single author column", {
  data <- data.frame(author = c("Author A", "Author B", "Author C"))
  result <- saros.base:::get_authors(data)
  testthat::expect_equal(result, c("Author A", "Author B", "Author C"))
})

testthat::test_that("get_authors handles multiple authors in a single cell", {
  data <- data.frame(author = c("Author A; Author B", "Author B; Author C"))
  result <- saros.base:::get_authors(data)
  testthat::expect_equal(result, c("Author A", "Author B", "Author C"))
})

testthat::test_that("get_authors removes duplicate authors", {
  data <- data.frame(author = c("Author A", "Author A; Author B", "Author B"))
  result <- saros.base:::get_authors(data)
  testthat::expect_equal(result, c("Author A", "Author B"))
})

testthat::test_that("get_authors handles empty author column", {
  data <- data.frame(author = character(0))
  result <- saros.base:::get_authors(data)
  testthat::expect_equal(result, '')
})

testthat::test_that("get_authors handles NA values in author column", {
  data <- data.frame(author = c("Author A; Author B", NA, "Author C"))
  result <- saros.base:::get_authors(data)
  testthat::expect_equal(result, c("Author A", "Author B", "Author C"))
})

testthat::test_that("get_authors returns error for non-character and non-factor columns", {
  data <- data.frame(author = c(1, 2, 3))
  testthat::expect_error(saros.base:::get_authors(data), regexp = "must be factor or character")
})

testthat::test_that("get_authors handles missing author column gracefully", {
  data <- data.frame(title = c("Title A", "Title B"))
  result <- saros.base:::get_authors(data)
  testthat::expect_equal(result, '')
})

testthat::test_that("get_authors handles specified author column", {
  data <- data.frame(authors = c("Author A; Author B", "Author C"))
  result <- saros.base:::get_authors(data, col = "authors")
  testthat::expect_equal(result, c("Author A", "Author B", "Author C"))
})

