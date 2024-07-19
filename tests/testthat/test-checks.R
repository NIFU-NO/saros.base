testthat::test_that("check_bool", {
  test_arg <- "d"
  testthat::expect_error(
    object = saros.base:::check_bool(test_arg),
    regexp = "`test_arg` must be a logical of length 1, not a string"
  )
  test_arg <- TRUE
  testthat::expect_no_error(
    object = saros.base:::check_bool(test_arg))
})

testthat::test_that("check_integerish", {


  test_arg <- "d"
  testthat::expect_error(
    object = saros.base:::check_integerish(test_arg),
    regexp = "`test_arg` must be an integer of length 1, not a string"
  )


  test_arg <- -2
  testthat::expect_error(
    object = saros.base:::check_integerish(test_arg, min = 0),
    regexp = "`test_arg` must be a positive integer of length 1, not a number")

  test_arg <- 2L
  testthat::expect_no_error(
    object = saros.base:::check_integerish(test_arg))

  test_arg <- 2.0
  testthat::expect_no_error(
    object = saros.base:::check_integerish(test_arg))


  test_arg <- 10
  testthat::expect_no_error(
    object = saros.base:::check_integerish(test_arg, min = 0))


  test_arg <- 10
  testthat::expect_error(
    object = saros.base:::check_integerish(test_arg, min = 0, max = 8),
    regexp = "`test_arg` must be a positive integer of length 1 \\(max=8\\), not a number")
})


testthat::test_that("check_double", {
  test_arg <- "d"
  testthat::expect_error(
    object = saros.base:::check_double(test_arg),
    regexp = "`test_arg` must be a numeric of length 1, not a string"
  )

  test_arg <- -2.5
  testthat::expect_error(
    object = saros.base:::check_double(test_arg, min = 0),
    regexp = "`test_arg` must be a positive numeric of length 1 \\(min=0\\), not a number"
  )

  test_arg <- 2.5
  testthat::expect_no_error(
    object = saros.base:::check_double(test_arg)
  )
})

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

testthat::test_that("check_list", {
  test_arg <- "d"
  testthat::expect_error(
    object = saros.base:::check_list(test_arg, null.ok = FALSE),
    regexp = "`test_arg` must be a list, not a string"
  )

  test_arg <- list(a = 1, b = 2)
  testthat::expect_no_error(
    object = saros.base:::check_list(test_arg)
  )

  test_arg <- NULL
  testthat::expect_error(
    object = saros.base:::check_list(test_arg, null.ok = FALSE),
    regexp = "`test_arg` must be a list, not NULL"
  )
  testthat::expect_no_error(
    object = saros.base:::check_list(test_arg, null.ok = TRUE))



  test_arg <- list(a = 1, b = 2)
  testthat::expect_no_error(
    object = saros.base:::check_list(test_arg, n = 2, null.ok = TRUE))
  testthat::expect_error(
    object = saros.base:::check_list(test_arg, n = 1, null.ok = TRUE),
    regexp = "must be a list of length 1, not")

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





testthat::test_that("check_multiple_dep_and_one_indep", {

  data <- data.frame(a = 1:5, b = 6:10, c = 11:15, d = 16:20, e = 21:25)

  # Test 1: One column for 'dep' and one column for 'indep', expect no error
  testthat::expect_no_error(
    object = saros.base:::check_multiple_dep_and_one_indep(data, a, b)
  )

  # Test 2: Two columns for 'dep' and one column for 'indep', expect an error
  testthat::expect_error(
    object = saros.base:::check_multiple_dep_and_one_indep(data, c(a, b), c),
    regexp = "Multiple columns for `dep` and `indep` are not allowed.*You provided dep = \\^c\\(a, b\\)"
  )

})

