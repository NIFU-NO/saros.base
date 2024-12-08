testthat::test_that("add_n_cats_to_chapter_structure works with different category sets", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2"))
  data <- data.frame(var1 = factor(c("a", "b", "c")), var2 = factor(c("d", "e", "f")))
  result <- saros.base:::add_n_cats_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n_cats_dep" %in% colnames(result))
  testthat::expect_true(".max_chars_cats_dep" %in% colnames(result))
  testthat::expect_equal(result$.n_cats_dep, c(6, 6))
  testthat::expect_equal(result$.max_chars_cats_dep, c(1, 1))
})

testthat::test_that("add_n_cats_to_chapter_structure works with overlapping category sets", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2"))
  data <- data.frame(var1 = factor(c("a", "b", "c")), var2 = factor(c("b", "c", "d")))
  result <- saros.base:::add_n_cats_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n_cats_dep" %in% colnames(result))
  testthat::expect_true(".max_chars_cats_dep" %in% colnames(result))
  testthat::expect_equal(result$.n_cats_dep, c(4, 4))
  testthat::expect_equal(result$.max_chars_cats_dep, c(1, 1))
})


testthat::test_that("add_n_cats_to_chapter_structure handles drop_na = FALSE", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2"))
  data <- data.frame(var1 = factor(c("a", "b", NA)), var2 = factor(c("x", NA, "z")))
  result <- saros.base:::add_n_cats_to_chapter_structure(chapter_structure, data, drop_na = FALSE)
  testthat::expect_true(".n_cats_dep" %in% colnames(result))
  testthat::expect_true(".max_chars_cats_dep" %in% colnames(result))
  testthat::expect_equal(result$.n_cats_dep, c(4, 4))
  testthat::expect_equal(result$.max_chars_cats_dep, c(1, 1))
})

testthat::test_that("add_n_cats_to_chapter_structure handles custom target_variable and variable_name_n_cats", {
  chapter_structure <- data.frame(custom_dep = c("var1", "var2"))
  data <- data.frame(var1 = factor(c("a", "b", "c")), var2 = factor(c("a", "b", "c")))
  result <- saros.base:::add_n_cats_to_chapter_structure(chapter_structure, data, target_variable = "custom_dep", variable_name_n_cats = "custom_n_cats", variable_name_max_cat_char = "custom_max_chars")
  testthat::expect_true("custom_n_cats" %in% colnames(result))
  testthat::expect_true("custom_max_chars" %in% colnames(result))
  testthat::expect_equal(result$custom_n_cats, c(3, 3))
  testthat::expect_equal(result$custom_max_chars, c(1, 1))
})

testthat::test_that("add_n_cats_to_chapter_structure throws error for missing target_variable", {
  chapter_structure <- data.frame(.variable_name_other = c("var1", "var2"))
  data <- data.frame(var1 = factor(c("a", "b", "c")), var2 = factor(c("x", "y", "z")))
  testthat::expect_error(saros.base:::add_n_cats_to_chapter_structure(chapter_structure, data),
    regexp = "`target_variable` .* not found in"
  )
})
