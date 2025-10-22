testthat::test_that("remove_from_chapter_structure_if_non_significant handles basic filtering", {
  # Create test data with clear associations
  set.seed(123)
  test_data <- data.frame(
    gender = factor(sample(c("Male", "Female"), 100, replace = TRUE)),
    age_group = factor(sample(c("18-30", "31-50", "51+"), 100, replace = TRUE)),
    satisfaction = factor(sample(c("Low", "Medium", "High"), 100, replace = TRUE)),
    random_var = factor(sample(letters[1:5], 100, replace = TRUE))
  )
  
  # Create chapter structure with bivariate entries
  chapter_structure <- data.frame(
    .variable_name_dep = c("satisfaction", "satisfaction", "age_group"),
    .variable_name_indep = c("gender", "age_group", "gender"),
    .variable_type_dep = c("fct", "fct", "fct"),
    .variable_type_indep = c("fct", "fct", "fct"),
    .variable_label_dep = c("Satisfaction", "Satisfaction", "Age Group"),
    .variable_label_indep = c("Gender", "Age Group", "Gender"),
    stringsAsFactors = FALSE
  )
  
  # Test with hide_bi_entry_if_sig_above = NULL (should keep all)
  result_null <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = test_data,
    hide_bi_entry_if_sig_above = NULL,
    progress = FALSE
  )
  
  testthat::expect_equal(nrow(result_null), nrow(chapter_structure))
  testthat::expect_true(".bi_test" %in% colnames(result_null))
  testthat::expect_true(".p_value" %in% colnames(result_null))
  
  # Test with hide_bi_entry_if_sig_above = 1 (should keep all)
  result_one <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = test_data,
    hide_bi_entry_if_sig_above = 1,
    progress = FALSE
  )
  
  testthat::expect_equal(nrow(result_one), nrow(chapter_structure))
  
  # Test with hide_bi_entry_if_sig_above = 0.05 (should filter non-significant)
  result_filtered <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = test_data,
    hide_bi_entry_if_sig_above = 0.05,
    progress = FALSE
  )
  
  # Result should have .bi_test and .p_value columns
  testthat::expect_true(".bi_test" %in% colnames(result_filtered))
  testthat::expect_true(".p_value" %in% colnames(result_filtered))
  
  # Result should have fewer or equal rows than original
  testthat::expect_true(nrow(result_filtered) <= nrow(chapter_structure))
})

testthat::test_that("remove_from_chapter_structure_if_non_significant handles univariate entries", {
  test_data <- data.frame(
    var1 = factor(sample(c("A", "B", "C"), 50, replace = TRUE)),
    var2 = factor(sample(c("X", "Y"), 50, replace = TRUE))
  )
  
  # Mix of univariate and bivariate entries
  chapter_structure <- data.frame(
    .variable_name_dep = c("var1", "var1", "var2"),
    .variable_name_indep = c(NA, "var2", NA),
    .variable_type_dep = c("fct", "fct", "fct"),
    .variable_type_indep = c(NA, "fct", NA),
    .variable_label_dep = c("Variable 1", "Variable 1", "Variable 2"),
    .variable_label_indep = c(NA, "Variable 2", NA),
    stringsAsFactors = FALSE
  )
  
  result <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = test_data,
    hide_bi_entry_if_sig_above = 0.05,
    progress = FALSE
  )
  
  # Univariate entries (with NA indep) should always be kept
  univariate_results <- result[is.na(result$.variable_name_indep), ]
  testthat::expect_equal(nrow(univariate_results), 2)
  testthat::expect_true(all(is.na(univariate_results$.p_value)))
})

testthat::test_that("remove_from_chapter_structure_if_non_significant respects always_show_bi_for_indep", {
  set.seed(456)
  test_data <- data.frame(
    outcome = factor(sample(c("Yes", "No"), 100, replace = TRUE)),
    important_var = factor(sample(c("A", "B"), 100, replace = TRUE)),
    noise_var = factor(sample(letters[1:10], 100, replace = TRUE))
  )
  
  chapter_structure <- data.frame(
    .variable_name_dep = c("outcome", "outcome"),
    .variable_name_indep = c("important_var", "noise_var"),
    .variable_type_dep = c("fct", "fct"),
    .variable_type_indep = c("fct", "fct"),
    .variable_label_dep = c("Outcome", "Outcome"),
    .variable_label_indep = c("Important Variable", "Noise Variable"),
    stringsAsFactors = FALSE
  )
  
  # Force keeping important_var even if not significant
  result <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = test_data,
    hide_bi_entry_if_sig_above = 0.05,
    always_show_bi_for_indep = "important_var",
    progress = FALSE
  )
  
  # important_var should always be in result
  testthat::expect_true("important_var" %in% result$.variable_name_indep)
})

testthat::test_that("remove_from_chapter_structure_if_non_significant handles character variables", {
  test_data <- data.frame(
    char_var = c("text1", "text2", "text3", "text1", "text2"),
    factor_var = factor(c("A", "B", "A", "B", "A"))
  )
  
  # Character variables should be skipped from testing
  chapter_structure <- data.frame(
    .variable_name_dep = c("char_var", "factor_var"),
    .variable_name_indep = c("factor_var", "char_var"),
    .variable_type_dep = c("chr", "fct"),
    .variable_type_indep = c("fct", "chr"),
    .variable_label_dep = c("Character Variable", "Factor Variable"),
    .variable_label_indep = c("Factor Variable", "Character Variable"),
    stringsAsFactors = FALSE
  )
  
  result <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = test_data,
    hide_bi_entry_if_sig_above = 0.05,
    progress = FALSE
  )
  
  # Character variable entries should be removed (not tested)
  testthat::expect_true(nrow(result) <= nrow(chapter_structure))
})

testthat::test_that("remove_from_chapter_structure_if_non_significant handles same variable dep and indep", {
  test_data <- data.frame(
    var1 = factor(sample(c("A", "B", "C"), 50, replace = TRUE))
  )
  
  # Entry where dep and indep are the same (should be skipped)
  chapter_structure <- data.frame(
    .variable_name_dep = "var1",
    .variable_name_indep = "var1",
    .variable_type_dep = "fct",
    .variable_type_indep = "fct",
    .variable_label_dep = "Variable 1",
    .variable_label_indep = "Variable 1",
    stringsAsFactors = FALSE
  )
  
  result <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = test_data,
    hide_bi_entry_if_sig_above = 0.05,
    progress = FALSE
  )
  
  # Same variable comparison should be removed
  testthat::expect_equal(nrow(result), 0)
})

testthat::test_that("remove_from_chapter_structure_if_non_significant handles no variance", {
  # Data with no variance in one variable
  test_data <- data.frame(
    constant_var = factor(rep("A", 50)),
    varying_var = factor(sample(c("X", "Y", "Z"), 50, replace = TRUE))
  )
  
  chapter_structure <- data.frame(
    .variable_name_dep = "constant_var",
    .variable_name_indep = "varying_var",
    .variable_type_dep = "fct",
    .variable_type_indep = "fct",
    .variable_label_dep = "Constant",
    .variable_label_indep = "Varying",
    stringsAsFactors = FALSE
  )
  
  result <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = test_data,
    hide_bi_entry_if_sig_above = 0.05,
    progress = FALSE
  )
  
  # No variance means can't test, should be removed
  testthat::expect_equal(nrow(result), 0)
})

testthat::test_that("remove_from_chapter_structure_if_non_significant validates inputs", {
  df <- data.frame(x = 1:5, y = 1:5)
  
  # Invalid chapter_structure (not a data frame)
  testthat::expect_error(
    remove_from_chapter_structure_if_non_significant(
      chapter_structure = "not a data frame",
      data = df,
      progress = FALSE
    ),
    class = "rlang_error"
  )
  
  # Invalid data (not a data frame)
  chapter_structure <- data.frame(
    .variable_name_dep = "x",
    .variable_name_indep = "y"
  )
  
  testthat::expect_error(
    remove_from_chapter_structure_if_non_significant(
      chapter_structure = chapter_structure,
      data = "not a data frame",
      progress = FALSE
    ),
    class = "rlang_error"
  )
})
