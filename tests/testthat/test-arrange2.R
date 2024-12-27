testthat::test_that("arrange2 works with typical input", {
  data <- data.frame(var1 = c(3, 1, 2), var2 = c(4, 6, 5))
  arrange_vars <- c("var1", "var2")
  result <- saros.base:::arrange2(data, arrange_vars)
  testthat::expect_equal(result$var1, c(1, 2, 3))
  testthat::expect_equal(result$var2, c(6, 5, 4))
})

testthat::test_that("arrange2 works with descending order", {
  data <- data.frame(var1 = c(3, 1, 2), var2 = c(4, 6, 5))
  arrange_vars <- c(var1 = TRUE, var2 = FALSE)
  result <- saros.base:::arrange2(data, arrange_vars)
  testthat::expect_equal(result$var1, c(3, 2, 1))
  testthat::expect_equal(result$var2, c(4, 5, 6))
})

testthat::test_that("arrange2 works with factors", {
  data <- data.frame(var1 = factor(c("b", "a", "c")), var2 = c(4, 6, 5))
  arrange_vars <- c("var1", "var2")
  result <- saros.base:::arrange2(data, arrange_vars)
  testthat::expect_equal(as.character(result$var1), c("a", "b", "c"))
  testthat::expect_equal(result$var2, c(6, 4, 5))
})

testthat::test_that("arrange2 works with factors and descending order", {
  data <- data.frame(var1 = factor(c("b", "a", "c")), var2 = c(4, 6, 5))
  arrange_vars <- c(var1 = TRUE, var2 = FALSE)
  result <- saros.base:::arrange2(data, arrange_vars)
  testthat::expect_equal(as.character(result$var1), c("c", "b", "a"))
  testthat::expect_equal(result$var2, c(5, 4, 6))
})

testthat::test_that("arrange2 handles na_first argument", {
  data <- data.frame(var1 = forcats::fct_na_value_to_level(factor(c(3, NA, 2)), NA), var2 = c(4, 6, 5))
  arrange_vars <- c("var1")
  result <- saros.base:::arrange2(data, arrange_vars, na_first = TRUE)
  testthat::expect_true(is.na(as.character(result$var1[1])))
  testthat::expect_true(!is.na(result$var1[1]))
  testthat::expect_equal(levels(droplevels(result$var1[-1])), c("2", "3"))
})

testthat::test_that("arrange2 handles missing columns", {
  data <- data.frame(var1 = c(3, 1, 2), var2 = c(4, 6, 5))
  arrange_vars <- c("var1", "var3")
  testthat::expect_error(saros.base:::arrange2(data, arrange_vars), regexp = "`arrange_vars` not found in `data`: var3")
})

testthat::test_that("arrange2 handles NULL arrange_vars", {
  data <- tibble::tibble(var1 = c(3, 1, 2), var2 = c(4, 6, 5))
  result <- saros.base:::arrange2(data, arrange_vars = "var2")
  testthat::expect_equal(result, tibble::tibble(var1 = c(3, 2, 1), var2 = c(4, 5, 6)))
})

testthat::test_that("arrange2 handles character input for arrange_vars", {
  data <- data.frame(var1 = c(3, 1, 2), var2 = c(4, 6, 5))
  arrange_vars <- c("var1", "var2")
  result <- saros.base:::arrange2(data, arrange_vars)
  testthat::expect_equal(result$var1, c(1, 2, 3))
  testthat::expect_equal(result$var2, c(6, 5, 4))
})

testthat::test_that("arrange2 handles numeric columns", {
  data <- data.frame(var1 = c(3.1, 1.5, 2.8), var2 = c(4.3, 6.2, 5.1))
  arrange_vars <- c("var1", "var2")
  result <- saros.base:::arrange2(data, arrange_vars)
  testthat::expect_equal(result$var1, c(1.5, 2.8, 3.1))
  testthat::expect_equal(result$var2, c(6.2, 5.1, 4.3))
})

testthat::test_that("arrange2 handles logical columns", {
  data <- data.frame(var1 = c(TRUE, FALSE, TRUE), var2 = c(4, 6, 5))
  arrange_vars <- c("var1", "var2")
  result <- saros.base:::arrange2(data, arrange_vars)
  testthat::expect_equal(result$var1, c(FALSE, TRUE, TRUE))
  testthat::expect_equal(result$var2, c(6, 4, 5))
})

testthat::test_that("arrange2 handles NA values in factors with na_first", {
  data <- data.frame(var1 = factor(c("b", NA, "c")), var2 = c(4, 6, 5))
  arrange_vars <- c("var1")
  result <- saros.base:::arrange2(data, arrange_vars, na_first = TRUE)
  testthat::expect_true(is.na(result$var1[1]))
  testthat::expect_equal(as.character(result$var1[-1]), c("b", "c"))
})
