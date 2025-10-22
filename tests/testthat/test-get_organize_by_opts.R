testthat::test_that("get_organize_by_opts returns character vector", {
  result <- get_organize_by_opts()
  
  # Should return a character vector
  testthat::expect_type(result, "character")
  
  # Should have at least some expected core column names
  # Based on the package structure, these are core chapter structure columns
  expected_cols <- c(
    ".variable_type_dep",
    ".variable_name_dep",
    ".variable_label_dep"
  )
  
  # At least some of these should be present
  testthat::expect_true(any(expected_cols %in% result))
  
  # Should not be empty
  testthat::expect_true(length(result) > 0)
  
  # Should not have NA values
  testthat::expect_false(any(is.na(result)))
  
  # Each element should be a non-empty string
  testthat::expect_true(all(nchar(result) > 0))
})

testthat::test_that("get_organize_by_opts is consistent across calls", {
  result1 <- get_organize_by_opts()
  result2 <- get_organize_by_opts()
  
  # Should return the same result each time
  testthat::expect_identical(result1, result2)
})
