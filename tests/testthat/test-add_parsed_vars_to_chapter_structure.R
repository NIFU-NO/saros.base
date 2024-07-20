testthat::test_that("add_parsed_vars_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(.variable_selection = c("var1", "var2"))
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  result <- saros.base:::add_parsed_vars_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(!".cols" %in% colnames(result))
  testthat::expect_true(".variable_position" %in% colnames(result))
  testthat::expect_true(".variable_name" %in% colnames(result))
  testthat::expect_equal(result$.variable_name, c("var1", "var2"))
})

testthat::test_that("add_parsed_vars_to_chapter_structure handles NA in variable_selection", {
  chapter_structure <- data.frame(.variable_selection = c("var1", NA))
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  result <- saros.base:::add_parsed_vars_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(!".cols" %in% colnames(result))
  testthat::expect_true(".variable_position" %in% colnames(result))
  testthat::expect_true(".variable_name" %in% colnames(result))
  testthat::expect_equal(result$.variable_name, c("var1", NA))
})

testthat::test_that("add_parsed_vars_to_chapter_structure handles tidyselect syntax", {
  chapter_structure <- data.frame(.variable_selection = c("tidyselect::starts_with('var')"))
  data <- data.frame(var1 = 1:3, var2 = 4:6, var3 = 7:9)
  result <- saros.base:::add_parsed_vars_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(!".cols" %in% colnames(result))
  testthat::expect_true(".variable_position" %in% colnames(result))
  testthat::expect_true(".variable_name" %in% colnames(result))
  testthat::expect_equal(result$.variable_name, c("var1", "var2", "var3"))
})

testthat::test_that("add_parsed_vars_to_chapter_structure handles quotes in variable_selection", {
  chapter_structure <- data.frame(.variable_selection = c("'var1', 'var2'"))
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  result <- saros.base:::add_parsed_vars_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(!".cols" %in% colnames(result))
  testthat::expect_true(".variable_position" %in% colnames(result))
  testthat::expect_true(".variable_name" %in% colnames(result))
  testthat::expect_equal(result$.variable_name, c("var1", "var2"))
})

testthat::test_that("add_parsed_vars_to_chapter_structure handles commas in variable_selection", {
  chapter_structure <- data.frame(.variable_selection = c("var1,var2"))
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  result <- saros.base:::add_parsed_vars_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(!".cols" %in% colnames(result))
  testthat::expect_true(".variable_position" %in% colnames(result))
  testthat::expect_true(".variable_name" %in% colnames(result))
  testthat::expect_equal(result$.variable_name, c("var1", "var2"))
})

testthat::test_that("add_parsed_vars_to_chapter_structure handles empty variable_selection", {
  chapter_structure <- data.frame(.variable_selection = c(""))
  data <- data.frame(var1 = 1:3, var2 = 4:6)
  result <- saros.base:::add_parsed_vars_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(!".cols" %in% colnames(result))
  testthat::expect_true(".variable_position" %in% colnames(result))
  testthat::expect_true(".variable_name" %in% colnames(result))
  testthat::expect_equal(result$.variable_name, NA)
})
