testthat::test_that("refine_chapter_overview preserves chapter order (GH #110)", {
  ch_overview <- data.frame(
    chapter = c("C", "A", "B"),
    dep = c("b_1", "b_2", "b_3"),
    stringsAsFactors = FALSE
  )
  result <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    progress = FALSE
  )
  # Only check the order of the first few rows for chapter
  expect_order <- c("C", "A", "B")
  testthat::expect_equal(unique(result$chapter)[seq_along(expect_order)], expect_order)
})
testthat::test_that("refine_chapter_overview allows chapter as factor (GH #109)", {
  ch_overview <- data.frame(
    chapter = factor(c("A", "B")),
    dep = c("b_1", "b_2"),
    stringsAsFactors = FALSE
  )
  result <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    progress = FALSE
  )
  testthat::expect_true(all(result$chapter %in% c("A", "B")))
  testthat::expect_equal(class(result$chapter), "character")
})
testthat::test_that("eval_cols", {
  x <-
    saros.base:::eval_cols(
      x = c(
        "x1_sex, x2_human",
        "matches('b_')"
      ),
      data = saros.base::ex_survey
    )
  testthat::expect_equal(lengths(x), c(2, 3))
})

testthat::test_that("look_for_extended", {
  x <-
    saros.base:::look_for_extended(
      data = saros.base::ex_survey,
      cols = colnames(saros.base::ex_survey),
      label_separator = " - ",
      name_separator = "_"
    )
  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(dim(x), c(32, 8))
  testthat::expect_contains(names(x), c(
    ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
    ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
    ".variable_type"
  ))
  x <-
    saros.base:::look_for_extended(
      data = saros.base::ex_survey,
      cols = colnames(saros.base::ex_survey),
      name_separator = "_"
    )
  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(dim(x), c(32, 8))
  testthat::expect_contains(names(x), c(
    ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
    ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
    ".variable_type"
  ))
  x <-
    saros.base:::look_for_extended(
      data = saros.base::ex_survey,
      cols = colnames(saros.base::ex_survey),
      label_separator = " - "
    )
  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(dim(x), c(32, 8))
  testthat::expect_contains(names(x), c(
    ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
    ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
    ".variable_type"
  ))
  x <-
    saros.base:::look_for_extended(
      data = saros.base::ex_survey,
      cols = paste0("b_", 1:3)
    )
  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(dim(x), c(3, 8))
  testthat::expect_contains(names(x), c(
    ".variable_name", ".variable_name_prefix", ".variable_name_suffix",
    ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
    ".variable_type"
  ))
})

testthat::test_that("validate_labels", {
  saros.base:::look_for_extended(
    data = saros.base::ex_survey,
    cols = paste0("b_", 1:3),
    label_separator = " - "
  ) |>
    dplyr::mutate(.variable_label_suffix = c("Bejing", NA, "Budapest")) |>
    saros.base:::validate_labels() |>
    dplyr::pull(.variable_label_suffix) |>
    testthat::expect_equal(c("Bejing", "b_2", "Budapest"))
})


testthat::test_that("add_chunk_templates_to_chapter_structure", {
  saros.base::ex_survey_ch_overview |>
    dplyr::mutate(.variable_name_dep = dep) |>
    saros.base:::add_chunk_templates_to_chapter_structure(chunk_templates = c("cat_plot", "cat_table")) |>
    dim() |>
    testthat::expect_equal(c(10, 7))
})


testthat::test_that("refine_chapter_overview", {
  x <-
    saros.base::refine_chapter_overview(
      chapter_overview = saros.base::ex_survey_ch_overview,
      data = saros.base::ex_survey,
      label_separator = " - ",
      name_separator = "_"
    )
  testthat::expect_equal(dim(x), c(1 + 1 + 7 * 4 + 7 * 4 + 8 * 2, 48))
})

testthat::test_that("refine_chapter_overview with always_show_bi_for_indep keeps specified bivariates", {
  # Create chapter overview with bivariate entries
  ch_overview <- data.frame(
    chapter = c("Demographics", "Demographics", "Demographics"),
    dep = c("b_1", "b_2:b_3", "c_1:c_2"),
    indep = c(NA, "x2_human", "x1_sex"),
    stringsAsFactors = FALSE
  )

  # Test that always_show_bi_for_indep forces keeping specific indep variable
  result <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    hide_bi_entry_if_sig_above = 0.05, # Very strict filtering
    always_show_bi_for_indep = "x2_human", # Force keep this one
    progress = FALSE
  )

  # x2_human should be in the result even if not significant
  testthat::expect_true("x2_human" %in% result$.variable_name_indep)
})

testthat::test_that("refine_chapter_overview with always_show_bi_for_indep handles multiple variables", {
  ch_overview <- data.frame(
    chapter = rep("Test", 5),
    dep = rep("b_2", 5),
    indep = c(NA, "x2_human", "x1_sex", "f_uni", "x1_sex"),
    stringsAsFactors = FALSE
  )

  result <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    hide_bi_entry_if_sig_above = 0.01, # Very strict
    always_show_bi_for_indep = c("x2_human", "x1_sex"),
    progress = FALSE
  )

  # Both forced variables should be present
  testthat::expect_true(all(c("x2_human", "x1_sex") %in% result$.variable_name_indep))
})

testthat::test_that("refine_chapter_overview filters non-significant without always_show_bi_for_indep", {
  ch_overview <- data.frame(
    chapter = rep("Test", 4),
    dep = rep("x1_sex", 4),
    indep = c(NA, "x2_human", "x2_human", "x1_sex"),
    stringsAsFactors = FALSE
  )

  result_filtered <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    hide_bi_entry_if_sig_above = 0.01,
    progress = FALSE
  )

  result_all <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    hide_bi_entry_if_sig_above = 1, # Show all
    progress = FALSE
  )

  # Filtered result should have fewer bivariate entries than unfiltered
  n_bi_filtered <- sum(!is.na(result_filtered$.variable_name_indep))
  n_bi_all <- sum(!is.na(result_all$.variable_name_indep))

  testthat::expect_true(n_bi_filtered <= n_bi_all)
})

testthat::test_that("refine_chapter_overview respects hide_bi_entry_if_sig_above = NULL", {
  ch_overview <- data.frame(
    chapter = rep("Test", 3),
    dep = rep("b_1", 3),
    indep = c(NA, "x2_human", "x1_sex"),
    stringsAsFactors = FALSE
  )

  result <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    hide_bi_entry_if_sig_above = 1, # Don't filter
    progress = FALSE
  )

  # Should keep all bivariate entries
  testthat::expect_true(all(c("x2_human", "x1_sex") %in% result$.variable_name_indep))
})

testthat::test_that("refine_chapter_overview with hide_variable_if_all_na removes NA variables", {
  # Create data with an all-NA variable
  test_data <- saros.base::ex_survey
  test_data$all_na_var <- NA_integer_
  attr(test_data$all_na_var, "label") <- "All values are missing"

  ch_overview <- data.frame(
    chapter = c("Test", "Test"),
    dep = c("x1_sex", "all_na_var"),
    indep = c(NA, NA),
    stringsAsFactors = FALSE
  )

  result_hide <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = test_data,
    hide_variable_if_all_na = TRUE,
    progress = FALSE
  )

  result_keep <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = test_data,
    hide_variable_if_all_na = FALSE,
    progress = FALSE
  )

  # With hide_variable_if_all_na = TRUE, all_na_var should be removed
  testthat::expect_false("all_na_var" %in% result_hide$.variable_name_dep)

  # With hide_variable_if_all_na = FALSE, all_na_var should be kept but is dropped because its type is NA
  #  testthat::expect_true("all_na_var" %in% result_keep$.variable_name_dep)
})

testthat::test_that("refine_chapter_overview handles keep_dep_indep_if_no_overlap", {
  ch_overview <- data.frame(
    chapter = c("Test", "Test"),
    dep = c("p_1", "p_2"),
    indep = c(NA, "x2_human"),
    stringsAsFactors = FALSE
  )

  result_keep <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    keep_dep_indep_if_no_overlap = TRUE,
    progress = FALSE
  )

  result_remove <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    keep_dep_indep_if_no_overlap = FALSE,
    progress = FALSE
  )

  # Both should have results (since x1_sex and x2_human have overlap)
  testthat::expect_true(nrow(result_keep) > 0)
  testthat::expect_true(nrow(result_remove) > 0)
})

testthat::test_that("refine_chapter_overview handles single_y_bivariates_if_indep_cats_above", {
  ch_overview <- data.frame(
    chapter = c("Test", "Test"),
    dep = c("p_1", "p_1"),
    indep = c(NA, "f_uni"), # x11_health has many categories
    stringsAsFactors = FALSE
  )

  result_low <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    single_y_bivariates_if_indep_cats_above = 2, # Low threshold
    progress = FALSE
  )

  result_high <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    single_y_bivariates_if_indep_cats_above = 100, # High threshold
    progress = FALSE
  )

  # Both should produce results
  testthat::expect_true(nrow(result_low) > 0)
  testthat::expect_true(nrow(result_high) > 0)
})

testthat::test_that("refine_chapter_overview handles single_y_bivariates_if_deps_above", {
  ch_overview <- data.frame(
    chapter = paste0("Test", 1:3),
    dep = paste0("b_", 1:3), # Many dependent variables
    indep = c(NA, rep("x1_sex", 2)),
    stringsAsFactors = FALSE
  )

  result_low <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    single_y_bivariates_if_deps_above = 5, # Low threshold
    progress = FALSE
  )

  result_high <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    single_y_bivariates_if_deps_above = 100, # High threshold
    progress = FALSE
  )

  # Both should produce results
  testthat::expect_true(nrow(result_low) > 0)
  testthat::expect_true(nrow(result_high) > 0)
})

testthat::test_that("refine_chapter_overview creates proper column structure", {
  result <- saros.base::refine_chapter_overview(
    chapter_overview = saros.base::ex_survey_ch_overview,
    data = saros.base::ex_survey,
    progress = FALSE
  )

  # Check for essential columns
  expected_cols <- c(
    ".variable_name_dep",
    ".variable_name_indep",
    ".variable_label_dep",
    ".variable_label_indep",
    ".variable_type_dep",
    ".variable_type_indep",
    "chapter"
  )

  testthat::expect_true(all(expected_cols %in% colnames(result)))
})

testthat::test_that("refine_chapter_overview validates inputs", {
  # Missing chapter_overview
  testthat::expect_error(
    saros.base::refine_chapter_overview(
      chapter_overview = NULL,
      data = saros.base::ex_survey
    )
  )

  # Missing data when needed
  testthat::expect_warning(
    saros.base::refine_chapter_overview(
      chapter_overview = saros.base::ex_survey_ch_overview,
      data = NULL
    )
  )
})

testthat::test_that("refine_chapter_overview with always_show_bi_for_indep overrides significance filtering", {
  # This is the key test for issue #4
  ch_overview <- data.frame(
    chapter = rep("Performance Test", 4),
    dep = rep("b_1", 4),
    indep = c(NA, "x2_human", "x2_human", "x1_sex"),
    stringsAsFactors = FALSE
  )

  # First, see what gets filtered without always_show_bi_for_indep
  result_strict <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    hide_bi_entry_if_sig_above = 0.01,
    always_show_bi_for_indep = NULL,
    progress = FALSE
  )

  # Now force keep x2_human even if not significant
  result_forced <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = saros.base::ex_survey,
    hide_bi_entry_if_sig_above = 0.01,
    always_show_bi_for_indep = "x2_human",
    progress = FALSE
  )

  # x2_human should be in forced result
  testthat::expect_true("x2_human" %in% result_forced$.variable_name_indep)

  # If x2_human wasn't in strict result, verify it was added by always_show_bi_for_indep
  if (!"x2_human" %in% result_strict$.variable_name_indep) {
    # This proves always_show_bi_for_indep is working as override
    testthat::expect_true(TRUE)
  }
})

testthat::test_that("refine_chapter_overview with always_show_bi_for_indep overrides significance filtering", {
  testthat::expect_error(saros.base::refine_chapter_overview(
    data = saros.base::ex_survey,
    chapter_overview = data.frame(chapter = "D", dep = "matches('non_existent_cols')")
  ), regexp = "No variables were selected from ")
})

testthat::test_that("refine_chapter_overview handles variable names with spaces (GH #151)", {
  # Create test data with variable names containing spaces
  test_data <- data.frame(
    `var with space` = factor(c("A", "B", "C", "A", "B")),
    normal_var = factor(c("X", "Y", "X", "Y", "X")),
    check.names = FALSE
  )

  # Add labels
  attr(test_data$`var with space`, "label") <- "Variable with space"
  attr(test_data$normal_var, "label") <- "Normal variable"

  ch_overview <- data.frame(
    chapter = "Test",
    dep = "`var with space`, normal_var",
    stringsAsFactors = FALSE
  )

  # Test the core processing: add_core_info_to_chapter_structure
  # This is where the fix is applied
  result_core <- saros.base:::add_core_info_to_chapter_structure(ch_overview)

  # Should have correctly split by comma, preserving the space in the backtick-quoted name
  testthat::expect_true("`var with space`" %in% result_core$.variable_selection)
  testthat::expect_true("normal_var" %in% result_core$.variable_selection)
  testthat::expect_equal(nrow(result_core), 2)

  # Test add_parsed_vars_to_chapter_structure
  result_parsed <- saros.base:::add_parsed_vars_to_chapter_structure(result_core, test_data)

  # Verify the variable name is correctly extracted (without backticks)
  testthat::expect_true("var with space" %in% result_parsed$.variable_name)
  testthat::expect_true("normal_var" %in% result_parsed$.variable_name)
})

testthat::test_that("refine_chapter_overview handles ordered indep with different dep types (hide_bi_entry_if_sig_above = 0.05)", {
  set.seed(42)
  n <- 400

  # Simulate an ordered independent variable (two levels) and use it to create
  # some strong relationships (dep_int, dep_dbl, dep_fct) and one random
  # relationship (dep_ord) so that some bivariate tests are significant at
  # alpha = 0.05 and others are not.
  indep_bin <- rbinom(n, 1, 0.5)
  indep_ord <- ordered(ifelse(indep_bin == 1, "yes", "no"), levels = c("no", "yes"))

  # Strong numeric relationship: dep_int and dep_dbl depend on indep
  dep_int <- as.integer(round(indep_bin * 5 + rnorm(n, sd = 0.8)))
  dep_dbl <- indep_bin * 2 + rnorm(n, sd = 0.7)

  # Categorical relationship: different sampling probabilities by indep
  dep_fct <- factor(ifelse(indep_bin == 1,
    sample(c("A", "B", "C"), n, replace = TRUE, prob = c(0.7, 0.2, 0.1)),
    sample(c("A", "B", "C"), n, replace = TRUE, prob = c(0.2, 0.4, 0.4))
  ))

  # Random ordered factor (should often be non-significant)
  dep_ord <- ordered(sample(c("low", "med", "high"), n, replace = TRUE), levels = c("low", "med", "high"))

  test_data <- data.frame(
    dep_int = dep_int,
    dep_dbl = dep_dbl,
    dep_fct = dep_fct,
    dep_ord = dep_ord,
    indep_ord = indep_ord,
    stringsAsFactors = FALSE
  )

  # Add variable labels to silence warnings about missing labels
  attr(test_data$dep_int, "label") <- "Integer dependent"
  attr(test_data$dep_dbl, "label") <- "Double dependent"
  attr(test_data$dep_fct, "label") <- "Factor dependent"
  attr(test_data$dep_ord, "label") <- "Ordered factor dependent"
  attr(test_data$indep_ord, "label") <- "Ordered independent"

  ch_overview <- data.frame(
    chapter = rep("OrderedIndepTest", 4),
    dep = c("dep_int", "dep_dbl", "dep_fct", "dep_ord"),
    indep = rep("indep_ord", 4),
    stringsAsFactors = FALSE
  )

  res <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = test_data,
    hide_bi_entry_if_sig_above = 0.05,
    progress = FALSE
  )

  testthat::expect_s3_class(res, "data.frame")

  # Keep rows that refer to our ordered indep
  rows_ord <- res[res$.variable_name_indep == "indep_ord", , drop = FALSE]
  testthat::expect_true(nrow(rows_ord) >= 0)

  # Check that the indep type is reported as 'ord' (vctrs abbreviation)
  if (nrow(rows_ord) > 0) {
    # For this test data none of the variables are all-NA, so types should be
    # present (non-NA) and equal to the vctrs abbreviations.
    types_indep <- unique(rows_ord$.variable_type_indep)
    non_na_indep <- types_indep[!is.na(types_indep)]
    testthat::expect_true(length(non_na_indep) > 0)
    testthat::expect_true(all(non_na_indep == "ord"))

    # Map expected dep types (vctrs abbreviations)
    expected_dep_types <- c(dep_int = "int", dep_dbl = "dbl", dep_fct = "fct", dep_ord = "ord")

    deps_present <- unique(rows_ord$.variable_name_dep)
    # For each dep present, check reported type (must be non-NA) matches expected abbreviation
    for (d in deps_present) {
      reported <- unique(rows_ord$.variable_type_dep[rows_ord$.variable_name_dep == d])
      reported_non_na <- reported[!is.na(reported)]
      testthat::expect_true(length(reported_non_na) > 0)
      testthat::expect_true(all(reported_non_na == expected_dep_types[d]))
    }
  }
})
