testthat::test_that("add_n_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2"), .variable_name_indep = c("var3", "var4"))
  data <- data.frame(var1 = c(1, 2, 3, 4), var2 = c(1, 2, 3, 4), var3 = c(1, 2, 3, 4), var4 = c(1, 2, 3, 4))
  result <- saros.base:::add_n_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n" %in% colnames(result))
  testthat::expect_equal(result$.n, c(4, 4))
})

testthat::test_that("add_n_to_chapter_structure handles missing values in data", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2"), .variable_name_indep = c("var3", "var4"))
  data <- data.frame(var1 = c(1, 2, NA, 4), var2 = c(NA, 2, 3, 4), var3 = c(1, 2, 3, 4), var4 = c(1, 2, 3, 4))
  result <- saros.base:::add_n_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n" %in% colnames(result))
  testthat::expect_equal(result$.n, c(3, 3))
})

testthat::test_that("add_n_to_chapter_structure handles custom variable_name", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2"), .variable_name_indep = c("var3", "var4"))
  data <- data.frame(var1 = c(1, 2, 3, 4), var2 = c(1, 2, 3, 4), var3 = c(1, 2, 3, 4), var4 = c(1, 2, 3, 4))
  result <- saros.base:::add_n_to_chapter_structure(chapter_structure, data, variable_name = "sample_size")
  testthat::expect_true("sample_size" %in% colnames(result))
  testthat::expect_equal(result$sample_size, c(4, 4))
})

testthat::test_that("add_n_to_chapter_structure handles NA in target_grouping_variables", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", NA), .variable_name_indep = c("var3", NA))
  data <- data.frame(var1 = c(1, 2, 3, 4), var3 = c(1, 2, 3, 4), var4 = c(1, 2, 3, 4))
  result <- saros.base:::add_n_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n" %in% colnames(result))
  testthat::expect_equal(result$.n, c(4, 0))
})

testthat::test_that("add_n_to_chapter_structure handles empty data", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2"), .variable_name_indep = c("var3", "var4"))
  data <- data.frame(var1 = integer(), var2 = integer(), var3 = integer(), var4 = integer())
  result <- saros.base:::add_n_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n" %in% colnames(result))
  testthat::expect_equal(result$.n, c(0, 0))
})
