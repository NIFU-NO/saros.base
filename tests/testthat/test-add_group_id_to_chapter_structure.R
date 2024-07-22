testthat::test_that("add_group_id_to_chapter_structure works with single grouping variable", {
  data <- data.frame(var1 = c("A", "A", "B"), var2 = c(1, 2, 3))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = "var1")
  testthat::expect_equal(result$.variable_group_id, c(1, 1, 2))
})

testthat::test_that("add_group_id_to_chapter_structure works with multiple grouping variables", {
  data <- data.frame(var1 = c("A", "A", "B"), var2 = c(1, 1, 2))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = c("var1", "var2"))
  testthat::expect_equal(result$.variable_group_id, c(1, 1, 2))
})

testthat::test_that("add_group_id_to_chapter_structure works with no grouping variables", {
  data <- data.frame(var1 = c("A", "A", "B"), var2 = c(1, 2, 3))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = NULL)
  testthat::expect_equal(result, data)
})

testthat::test_that("add_group_id_to_chapter_structure works with variable_group_prefix", {
  data <- data.frame(var1 = c("A", "A", "B"), var2 = c(1, 2, 3))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = "var1", variable_group_prefix = "group_")
  testthat::expect_equal(result$.variable_group_id, c("group_1", "group_1", "group_2"))
})

testthat::test_that("add_group_id_to_chapter_structure works with single grouping variable and prefix", {
  data <- data.frame(var1 = c("A", "A", "B"), var2 = c(1, 2, 3))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = "var1", variable_group_prefix = "group_")
  testthat::expect_equal(result$.variable_group_id, c("group_1", "group_1", "group_2"))
})

testthat::test_that("add_group_id_to_chapter_structure works with multiple grouping variables and prefix", {
  data <- data.frame(var1 = c("A", "A", "B"), var2 = c(1, 1, 2))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = c("var1", "var2"), variable_group_prefix = "group_")
  testthat::expect_equal(result$.variable_group_id, c("group_1", "group_1", "group_2"))
})

testthat::test_that("add_group_id_to_chapter_structure handles empty data frame", {
  data <- data.frame(var1 = character(0), var2 = numeric(0))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = "var1")
  testthat::expect_equal(nrow(result), 0)
})

testthat::test_that("add_group_id_to_chapter_structure handles NA values in grouping variables", {
  data <- data.frame(var1 = c("A", NA, "B"), var2 = c(1, 2, 3))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = "var1")
  testthat::expect_equal(result$.variable_group_id, c(1, 2, 3))
})

testthat::test_that("add_group_id_to_chapter_structure handles NA values with prefix", {
  data <- data.frame(var1 = c("A", NA, "B"), var2 = c(1, 2, 3))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = "var1", variable_group_prefix = "group_")
  testthat::expect_equal(result$.variable_group_id, c("group_1", "group_2", "group_3"))
})

testthat::test_that("add_group_id_to_chapter_structure custom variable name", {
  data <- data.frame(var1 = c("A", "A", "B"), var2 = c(1, 2, 3))
  result <- saros.base:::add_group_id_to_chapter_structure(data, grouping_vars = "var1", variable_group_id = ".custom_group_id")
  testthat::expect_equal(result$.custom_group_id, c(1, 1, 2))
})
