testthat::test_that("replace_label_groups_with_name_groups works with typical input", {
  chapter_structure <- dplyr::group_by(
    data.frame(
      .variable_label_prefix_dep = c("label1", "label2"),
      .variable_label_prefix_indep = c("label3", "label4"),
      .variable_name_dep = c("var1", "var2"),
      .variable_name_indep = c("var3", "var4")
    ),
    .variable_label_prefix_dep, .variable_label_prefix_indep
  )
  result <- saros.base:::replace_label_groups_with_name_groups(chapter_structure)
  testthat::expect_true(".variable_name_dep" %in% dplyr::group_vars(result))
  testthat::expect_true(".variable_name_indep" %in% dplyr::group_vars(result))
  testthat::expect_false(".variable_label_prefix_dep" %in% dplyr::group_vars(result))
  testthat::expect_false(".variable_label_prefix_indep" %in% dplyr::group_vars(result))
})

testthat::test_that("replace_label_groups_with_name_groups handles missing grouping_structure", {
  chapter_structure <- data.frame(
    .variable_label_prefix_dep = c("label1", "label2"),
    .variable_label_prefix_indep = c("label3", "label4"),
    .variable_name_dep = c("var1", "var2"),
    .variable_name_indep = c("var3", "var4")
  )
  testthat::expect_warning(
    result <-
      saros.base:::replace_label_groups_with_name_groups(chapter_structure),
    regexp = "should be grouped by a subset of columns"
  )
})

testthat::test_that("replace_label_groups_with_name_groups handles unique grouping_structure", {
  chapter_structure <- dplyr::group_by(
    data.frame(
      .variable_label_prefix_dep = c("label1", "label1", "label2"),
      .variable_label_prefix_indep = c("label3", "label3", "label4"),
      .variable_name_dep = c("var1", "var2", "var3"),
      .variable_name_indep = c("var4", "var5", "var6")
    ),
    .variable_label_prefix_dep, .variable_label_prefix_indep
  )
  result <- saros.base:::replace_label_groups_with_name_groups(chapter_structure)
  testthat::expect_true(".variable_name_dep" %in% dplyr::group_vars(result))
  testthat::expect_true(".variable_name_indep" %in% dplyr::group_vars(result))
  testthat::expect_equal(dplyr::n_groups(result), 3)
})

testthat::test_that("replace_label_groups_with_name_groups keeps other columns unchanged", {
  chapter_structure <- dplyr::group_by(
    data.frame(
      .variable_label_prefix_dep = c("label1", "label2"),
      .variable_label_prefix_indep = c("label3", "label4"),
      other_col = c(1, 2),
      .variable_name_dep = c("var1", "var2"),
      .variable_name_indep = c("var3", "var4")
    ),
    .variable_label_prefix_dep, .variable_label_prefix_indep
  )
  result <- saros.base:::replace_label_groups_with_name_groups(chapter_structure)
  testthat::expect_true(".variable_name_dep" %in% dplyr::group_vars(result))
  testthat::expect_true(".variable_name_indep" %in% dplyr::group_vars(result))
  testthat::expect_equal(result$other_col, c(1, 2))
})
