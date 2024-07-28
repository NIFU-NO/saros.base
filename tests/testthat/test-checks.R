
testthat::test_that("check_string", {
  test_arg <- 5
  testthat::expect_error(
    object = saros.base:::check_string(test_arg),
    regexp = "`test_arg` must be a character vector of length 1, not a number"
  )

  test_arg <- "test"
  testthat::expect_no_error(
    object = saros.base:::check_string(test_arg)
  )

  test_arg <- NULL
  testthat::expect_no_error(
    object = saros.base:::check_string(test_arg, null.ok = TRUE)
  )

  test_arg <- NULL
  testthat::expect_error(
    object = saros.base:::check_string(test_arg, null.ok = FALSE),
    regexp = "`test_arg` must be a character vector of length 1, not NULL"
  )
})


testthat::test_that("check_data_frame", {
  test_arg <- "not_a_data_frame"
  testthat::expect_error(
    object = saros.base:::check_data_frame(test_arg),
    regexp = "`test_arg` must be a data.frame, not a string"
  )

  test_arg <- data.frame(a = 1:3, b = 4:6)
  testthat::expect_no_error(
    object = saros.base:::check_data_frame(test_arg)
  )


  test_arg <- list(a = 1:3, b = 4:6)
  testthat::expect_error(
    object = saros.base:::check_data_frame(test_arg),
    regexp = "`test_arg` must be a data.frame, not a list"
  )

  test_arg <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2)
  testthat::expect_error(
    object = saros.base:::check_data_frame(test_arg),
    regexp = "`test_arg` must be a data.frame, not a double matrix"
  )
})




