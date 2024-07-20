testthat::test_that("add_group_id_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(group1 = c("A", "A", "B"), group2 = c(1, 2, 1))
  result <- saros.base:::add_group_id_to_chapter_structure(chapter_structure, grouping_vars = c("group1", "group2"))
  testthat::expect_true(".variable_group_id" %in% names(result))
  testthat::expect_equal(result$.variable_group_id, c(1, 2, 3))
})

testthat::test_that("add_group_id_to_chapter_structure handles empty grouping_vars", {
  chapter_structure <- data.frame(group1 = c("A", "A", "B"), group2 = c(1, 2, 1))
  result <- saros.base:::add_group_id_to_chapter_structure(chapter_structure, grouping_vars = NULL)
  testthat::expect_false(".variable_group_id" %in% names(result))
})

testthat::test_that("add_group_id_to_chapter_structure works with different variable_group_id name", {
  chapter_structure <- data.frame(group1 = c("A", "A", "B"), group2 = c(1, 2, 1))
  result <- saros.base:::add_group_id_to_chapter_structure(chapter_structure, grouping_vars = c("group1", "group2"), variable_group_id = "custom_group_id")
  testthat::expect_true("custom_group_id" %in% names(result))
  testthat::expect_equal(result$custom_group_id, c(1, 2, 3))
})

testthat::test_that("add_group_id_to_chapter_structure works with a single grouping_var", {
  chapter_structure <- data.frame(group1 = c("A", "A", "B"), group2 = c(1, 2, 1))
  result <- saros.base:::add_group_id_to_chapter_structure(chapter_structure, grouping_vars = "group1")
  testthat::expect_true(".variable_group_id" %in% names(result))
  testthat::expect_equal(result$.variable_group_id, c(1, 1, 2))
})

testthat::test_that("add_group_id_to_chapter_structure works with no grouping_vars", {
  chapter_structure <- data.frame(group1 = c("A", "A", "B"), group2 = c(1, 2, 1))
  result <- saros.base:::add_group_id_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result, chapter_structure)
})
