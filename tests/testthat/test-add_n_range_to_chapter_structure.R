testthat::test_that("add_n_range_to_chapter_structure works with typical input", {
  chapter_structure <- tibble::tibble(.variable_name_dep = c("var1", "var2"))
  data <- data.frame(var1 = c(1, 2, NA, 4), var2 = c(NA, NA, 3, 4))
  result <- saros.base:::add_n_range_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n_range" %in% colnames(result))
  testthat::expect_equal(result$.n_range, c("[2-3]", "[2-3]"))
})

testthat::test_that("add_n_range_to_chapter_structure handles missing data", {
  chapter_structure <- tibble::tibble(.variable_name_dep = c("var1", "var2"))
  data <- data.frame(var1 = c(NA, NA, NA), var2 = c(NA, NA, NA))
  result <- saros.base:::add_n_range_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n_range" %in% colnames(result))
  testthat::expect_equal(result$.n_range, c("0", "0"))
})

testthat::test_that("add_n_range_to_chapter_structure handles single non-NA value", {
  chapter_structure <- tibble::tibble(.variable_name_dep = c("var1"))
  data <- data.frame(var1 = c(NA, 2, NA))
  result <- saros.base:::add_n_range_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n_range" %in% colnames(result))
  testthat::expect_equal(result$.n_range, c("1"))
})

testthat::test_that("add_n_range_to_chapter_structure uses custom glue templates", {
  chapter_structure <- tibble::tibble(.variable_name_dep = c("var1"))
  data <- data.frame(var1 = c(1, 2, NA, 4))
  result <- saros.base:::add_n_range_to_chapter_structure(chapter_structure, data, glue_template_1 = "N={n}", glue_template_2 = "N[{n[1]}-{n[2]}]")
  testthat::expect_true(".n_range" %in% colnames(result))
  testthat::expect_equal(result$.n_range, c("N=3"))
})

testthat::test_that("add_n_range_to_chapter_structure handles NA values in chapter_structure", {
  chapter_structure <- tibble::tibble(.variable_name_dep = c("var1", NA))
  data <- data.frame(var1 = c(1, 2, NA, 4))
  result <- saros.base:::add_n_range_to_chapter_structure(chapter_structure, data)
  testthat::expect_true(".n_range" %in% colnames(result))
  testthat::expect_equal(result$.n_range, c("3", "3"))
})

