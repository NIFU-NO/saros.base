test_that("read_main_password_file fails with informative error on missing file", {
  expect_error(
    read_main_password_file("nonexistent_file.txt"),
    "does not exist"
  )
})

test_that("read_main_password_file fails with informative error on empty file", {
  tmp <- tempfile()
  file.create(tmp)
  expect_error(
    read_main_password_file(tmp),
    "is empty"
  )
  unlink(tmp)
})

test_that("read_main_password_file fails with informative error on bad format", {
  tmp <- tempfile()
  writeLines(c("not:enough", "onlyonecolumn"), tmp)
  expect_error(
    read_main_password_file(tmp),
    "incorrectly formatted"
  )
  unlink(tmp)
})

test_that("read_main_password_file works with correct format", {
  tmp <- tempfile()
  writeLines(c("username:password"), tmp)
  df <- read_main_password_file(tmp)
  expect_true(is.data.frame(df))
  expect_equal(ncol(df), 2)
  unlink(tmp)
})
