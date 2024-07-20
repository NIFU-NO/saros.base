testthat::test_that("eval_cols works with typical input", {
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  x <- c("var1", "var2")
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L))
  testthat::expect_equal(result[[2]], c(var2 = 2L))
})

testthat::test_that("eval_cols handles missing columns", {
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  x <- c("var1", "var3")
  testthat::expect_error(saros.base:::eval_cols(x, data), regexp = "Column .* doesn't exist in data")
})

testthat::test_that("eval_cols handles NA in input", {
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  x <- c("var1", NA)
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L))
  testthat::expect_true(is.na(result[[2]]))
})

testthat::test_that("eval_cols handles empty strings in input", {
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  x <- c("var1", "")
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L))
  testthat::expect_true(is.na(result[[2]]))
})

testthat::test_that("eval_cols handles non-character input", {
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  x <- c("var1", 123)
  testthat::expect_error(saros.base:::eval_cols(x, data), regexp = "Column `123` doesn't exist in data")
})

testthat::test_that("eval_cols handles single column input", {
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  x <- "var1"
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L))
})

testthat::test_that("eval_cols handles multiple columns input", {
  data <- data.frame(var1 = 1:3, var2 = 4:6, var3 = 7:9)
  x <- c("var1", "var2", "var3")
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L))
  testthat::expect_equal(result[[2]], c(var2 = 2L))
  testthat::expect_equal(result[[3]], c(var3 = 3L))
})

testthat::test_that("eval_cols handles tidyselect all_of syntax", {
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  x <- c("tidyselect::all_of(c('var1', 'var2'))")
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L, var2 = 2L))
})

testthat::test_that("eval_cols handles tidyselect starts_with syntax", {
  data <- data.frame(var1 = 1:3, var2 = 4:6, var3 = 7:9)
  x <- c("tidyselect::starts_with('var')")
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L, var2 = 2L, var3 = 3L))
})

testthat::test_that("eval_cols handles tidyselect matches syntax", {
  data <- data.frame(var1 = 1:3, var2 = 4:6, var3 = 7:9)
  x <- c("tidyselect::matches('var[12]')")
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L, var2 = 2L))
})

testthat::test_that("eval_cols handles tidyselect everything syntax", {
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  x <- c("tidyselect::everything()")
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L, var2 = 2L))
})

testthat::test_that("eval_cols handles tidyselect where syntax", {
  data <- data.frame(var1 = 1:3, var2 = 4:6, var3 = 7:9)
  x <- c("tidyselect::where(is.numeric)")
  result <- saros.base:::eval_cols(x, data)
  testthat::expect_equal(result[[1]], c(var1 = 1L, var2 = 2L, var3 = 3L))
})
