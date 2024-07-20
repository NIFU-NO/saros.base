testthat::test_that("filename_sanitizer works with typical input", {
  x <- c("Too long a name", "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, c("Too_long_a_name", "with_invalid_"))
})

testthat::test_that("filename_sanitizer handles max_chars", {
  x <- c("Too long a name", "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x, max_chars = 10)
  testthat::expect_equal(result, c("Too_long_a", "with_inval"))
})

testthat::test_that("filename_sanitizer handles accept_hyphen", {
  x <- c("Too-long-a-name", "with-invalid-*^/&#")
  result <- saros.base:::filename_sanitizer(x, accept_hyphen = TRUE)
  testthat::expect_equal(result, c("Too-long-a-name", "with-invalid-_"))
})

testthat::test_that("filename_sanitizer handles valid_obj", {
  x <- c("123Too long a name", "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x, valid_obj = TRUE)
  testthat::expect_equal(result, c("Too_long_a_name", "with_invalid_"))
})

testthat::test_that("filename_sanitizer handles to_lower", {
  x <- c("Too long a name", "WITH INVALID *^/&#")
  result <- saros.base:::filename_sanitizer(x, to_lower = TRUE)
  testthat::expect_equal(result, c("too_long_a_name", "with_invalid_"))
})

testthat::test_that("filename_sanitizer handles make_unique", {
  x <- c("Too long a name", "Too long a name")
  result <- saros.base:::filename_sanitizer(x, make_unique = TRUE)
  testthat::expect_equal(result, c("Too_long_a_name", "Too_long_a_name_1"))
})

testthat::test_that("filename_sanitizer handles custom sep", {
  x <- c("Too long a name", "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x, sep = "-")
  testthat::expect_equal(result, c("Too-long-a-name", "with-invalid-"))
})

testthat::test_that("filename_sanitizer handles empty input", {
  x <- character(0)
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, character(0))
})

testthat::test_that("filename_sanitizer handles NA values in input", {
  x <- c("Too long a name", NA, "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, c("Too_long_a_name", NA, "with_invalid_"))
})

testthat::test_that("filename_sanitizer handles special characters", {
  x <- c("hello-world", "goodbye-world")
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, c("hello_world", "goodbye_world"))
})

testthat::test_that("filename_sanitizer handles numeric characters", {
  x <- c("12345", "67890")
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, c("12345", "67890"))
})

testthat::test_that("filename_sanitizer handles different character lengths", {
  x <- c("short", "a very very very long name")
  result <- saros.base:::filename_sanitizer(x, max_chars = 10)
  testthat::expect_equal(result, c("short", "a_very_ver"))
})

testthat::test_that("filename_sanitizer handles truncation", {
  x <- c("too_long_a_name", "another_long_name")
  result <- saros.base:::filename_sanitizer(x, max_chars = 8)
  testthat::expect_equal(result, c("too_long", "another_"))
})
