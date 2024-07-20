testthat::test_that("add_n_vars_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2", "var3", "var1", "var2"))
  result <- saros.base:::add_n_vars_to_chapter_structure(chapter_structure)
  testthat::expect_true(".n_dep" %in% colnames(result))
  testthat::expect_equal(result$.n_dep, rep(3, 5))
})

testthat::test_that("add_n_vars_to_chapter_structure handles custom target_variable", {
  chapter_structure <- data.frame(custom_dep = c("var1", "var2", "var3", "var1", "var2"))
  result <- saros.base:::add_n_vars_to_chapter_structure(chapter_structure, target_variable = "custom_dep")
  testthat::expect_true(".n_dep" %in% colnames(result))
  testthat::expect_equal(result$.n_dep, rep(3, 5))
})

testthat::test_that("add_n_vars_to_chapter_structure handles custom variable_name", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2", "var3", "var1", "var2"))
  result <- saros.base:::add_n_vars_to_chapter_structure(chapter_structure, variable_name = "num_deps")
  testthat::expect_true("num_deps" %in% colnames(result))
  testthat::expect_equal(result$num_deps, rep(3, 5))
})

testthat::test_that("add_n_vars_to_chapter_structure handles NA values in target_variable", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", NA, "var3", "var1", "var2"))
  result <- saros.base:::add_n_vars_to_chapter_structure(chapter_structure)
  testthat::expect_true(".n_dep" %in% colnames(result))
  testthat::expect_equal(result$.n_dep, rep(3, 5))
})

testthat::test_that("add_n_vars_to_chapter_structure handles grouped input", {
  chapter_structure <- dplyr::group_by(data.frame(group = c("A", "A", "B", "B"), .variable_name_dep = c("var1", "var2", "var1", "var2")), .data$group)
  result <- saros.base:::add_n_vars_to_chapter_structure(chapter_structure)
  testthat::expect_true(".n_dep" %in% colnames(result))
  testthat::expect_equal(result$.n_dep, c(2, 2, 2, 2))
  testthat::expect_true("group" %in% dplyr::group_vars(result))
})
