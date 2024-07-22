testthat::test_that("add_obj_name_to_chapter_structure works with typical input", {
  chapter_structure <- dplyr::group_by(data.frame(
    .variable_label_prefix_dep = c("label1", "label2"),
    .variable_label_prefix_indep = c("label3", "label4"),
    .variable_name_dep = c("var1", "var2"),
    .variable_name_indep = c("var3", "var4"),
    .variable_group_id = c(1, 1)
  ), .variable_label_prefix_dep, .variable_label_prefix_indep)

  result <- saros.base:::add_obj_name_to_chapter_structure(chapter_structure)

  testthat::expect_true(".obj_name" %in% colnames(result))
  testthat::expect_true(all(!is.na(result$.obj_name)))
})

testthat::test_that("add_obj_name_to_chapter_structure handles NA values", {
  chapter_structure <- dplyr::group_by(data.frame(
    .variable_label_prefix_dep = c("label1", NA),
    .variable_label_prefix_indep = c("label3", NA),
    .variable_name_dep = c("var1", NA),
    .variable_name_indep = c("var3", NA),
    .variable_group_id = c(1, 1)
  ), .variable_label_prefix_dep, .variable_label_prefix_indep)

  result <- saros.base:::add_obj_name_to_chapter_structure(chapter_structure)

  testthat::expect_true(".obj_name" %in% colnames(result))
  testthat::expect_equal(result$.obj_name, c("var1_var3", "var1_var3_1"))
})

testthat::test_that("add_obj_name_to_chapter_structure handles custom separator", {
  chapter_structure <- dplyr::group_by(data.frame(
    .variable_label_prefix_dep = c("label1", "label2"),
    .variable_label_prefix_indep = c("label3", "label4"),
    .variable_name_dep = c("var1", "var2"),
    .variable_name_indep = c("xvar3", "xvar4"),
    .variable_group_id = c(1, 1)
  ), .variable_label_prefix_dep, .variable_label_prefix_indep)

  result <- saros.base:::add_obj_name_to_chapter_structure(chapter_structure, sep = "-")

  testthat::expect_true(".obj_name" %in% colnames(result))
  testthat::expect_equal(result$.obj_name, c("var-xvar", "var-xvar-1"))
})

testthat::test_that("add_obj_name_to_chapter_structure handles max_width", {
  chapter_structure <- dplyr::group_by(data.frame(
    .variable_label_prefix_dep = c("verylonglabel1", "verylonglabel2"),
    .variable_label_prefix_indep = c("verylonglabel3", "verylonglabel4"),
    .variable_name_dep = c("var1", "var2"),
    .variable_name_indep = c("var3", "var4"),
    .variable_group_id = c(1, 1)
  ), .variable_label_prefix_dep, .variable_label_prefix_indep)

  result <- saros.base:::add_obj_name_to_chapter_structure(chapter_structure, max_width = 10)

  testthat::expect_true(".obj_name" %in% colnames(result))
  testthat::expect_true(all(nchar(result$.obj_name) <= 10))
})

testthat::test_that("add_obj_name_to_chapter_structure handles valid_obj", {
  chapter_structure <- dplyr::group_by(data.frame(
    .variable_label_prefix_dep = c("123label1", "123label2"),
    .variable_label_prefix_indep = c("label3", "label4"),
    .variable_name_dep = c("var1", "var2"),
    .variable_name_indep = c("var3", "var4"),
    .variable_group_id = c(1, 1)
  ), .variable_label_prefix_dep, .variable_label_prefix_indep)

  result <- saros.base:::add_obj_name_to_chapter_structure(chapter_structure, valid_obj = TRUE)

  testthat::expect_true(".obj_name" %in% colnames(result))
  testthat::expect_true(all(grepl("^[[:alpha:]]", result$.obj_name)))
})

testthat::test_that("add_obj_name_to_chapter_structure handles to_lower", {
  chapter_structure <- dplyr::group_by(data.frame(
    .variable_label_prefix_dep = c("LABEL1", "LABEL2"),
    .variable_label_prefix_indep = c("LABEL3", "LABEL4"),
    .variable_name_dep = c("VAR1", "VAR2"),
    .variable_name_indep = c("VAR3", "VAR4"),
    .variable_group_id = c(1, 1)
  ), .variable_label_prefix_dep, .variable_label_prefix_indep)

  result <- saros.base:::add_obj_name_to_chapter_structure(chapter_structure, to_lower = TRUE)

  testthat::expect_true(".obj_name" %in% colnames(result))
  testthat::expect_true(all(tolower(result$.obj_name) == result$.obj_name))
})

testthat::test_that("add_obj_name_to_chapter_structure handles make_unique", {
  chapter_structure <- dplyr::group_by(data.frame(
    .variable_label_prefix_dep = c("label1", "label1", "label2", "label2"),
    .variable_label_prefix_indep = c("label3", "label3", "label3", "label3"),
    .variable_name_dep = c("var1", "var2", "var3", "var4"),
    .variable_name_indep = c("xvar3", "xvar3", "xvar3", "xvar3"),
    .variable_group_id = c(1, 1, 2, 2)
  ), .variable_label_prefix_dep, .variable_label_prefix_indep)

  result <- saros.base:::add_obj_name_to_chapter_structure(chapter_structure, make_unique = TRUE)

  testthat::expect_true(".obj_name" %in% colnames(result))
  testthat::expect_true(any(duplicated(result$.obj_name) == FALSE))
})
