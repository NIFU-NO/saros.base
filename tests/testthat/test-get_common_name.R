testthat::test_that("get_common_name works with common characters", {
  x <- c("apple", "apricot", "apartment")
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, "ap")
})

testthat::test_that("get_common_name works with no common characters", {
  x <- c("dog", "cat", "mouse")
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, x)
})

testthat::test_that("get_common_name handles single string input", {
  x <- "banana"
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, "banana")
})

testthat::test_that("get_common_name handles empty string input", {
  x <- ""
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, "")
})


testthat::test_that("get_common_name handles NA values in input", {
  x <- c("pear", NA, "peach")
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, x)
})


testthat::test_that("get_common_name handles values with double letters", {
  x <- c("kitten", "kitten_and_puppies", "kites")
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, "kite")
})

testthat::test_that("get_common_name works with case differences", {
  x <- c("Grape", "Grapefruit", "Graph")
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, "Grap")
})

testthat::test_that("get_common_name handles special characters", {
  x <- c("hello-world", "hello-worlds", "hello-worldly")
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, "helo-wrd")
})

testthat::test_that("get_common_name handles strings with spaces", {
  x <- c("new york", "new year", "new")
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, "new")
})

testthat::test_that("get_common_name handles numeric characters", {
  x <- c("12345", "123", "12")
  result <- saros.base:::get_common_name(x)
  testthat::expect_equal(result, "12")
})
