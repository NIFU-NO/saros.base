test_that("detect_malformed_quarto_project finds missing index.qmd", {
  tmp <- tempfile()
  dir.create(tmp)
  dir.create(file.path(tmp, "sub1"))
  # No index.qmd in sub1
  result <- detect_malformed_quarto_project(tmp)
  expect_true(any(result$type == "missing_index.qmd"))
  unlink(tmp, recursive = TRUE)
})

test_that("detect_malformed_quarto_project finds qmd without title", {
  tmp <- tempfile()
  dir.create(tmp)
  qmd <- file.path(tmp, "file.qmd")
  writeLines(c("---", "author: test", "---", "content"), qmd)
  result <- detect_malformed_quarto_project(tmp)
  expect_true(any(result$type == "missing_title"))
  unlink(tmp, recursive = TRUE)
})

test_that("detect_malformed_quarto_project finds qmd without YAML", {
  tmp <- tempfile()
  dir.create(tmp)
  qmd <- file.path(tmp, "file.qmd")
  writeLines(c("content"), qmd)
  result <- detect_malformed_quarto_project(tmp)
  expect_true(any(result$type == "missing_title"))
  unlink(tmp, recursive = TRUE)
})

test_that("detect_malformed_quarto_project passes with no issues", {
  tmp <- tempfile()
  dir.create(tmp)
  dir.create(file.path(tmp, "sub1"))
  writeLines(c("---", "title: Test", "---", "content"), file.path(tmp, "index.qmd"))
  writeLines(c("---", "title: Test", "---", "content"), file.path(tmp, "sub1", "index.qmd"))
  writeLines(c("---", "title: Test", "---", "content"), file.path(tmp, "sub1", "chapter.qmd"))
  result <- detect_malformed_quarto_project(tmp)
  testthat::expect_equal(nrow(result), 0)
  unlink(tmp, recursive = TRUE)
})
