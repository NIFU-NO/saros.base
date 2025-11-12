# Tests for arrange2 and arrange_expr_producer

testthat::test_that("arrange2 sorts ascending by default", {
  data <- data.frame(var1 = c(3, 1, 2), var2 = c(4, 6, 5))
  result <- saros.base:::arrange2(data, c("var1", "var2"))
  testthat::expect_equal(result$var1, c(1, 2, 3))
  testthat::expect_equal(result$var2, c(6, 5, 4))
})

testthat::test_that("arrange2 handles descending order", {
  data <- data.frame(var1 = c(3, 1, 2), var2 = c(4, 6, 5))
  result <- saros.base:::arrange2(data, c(var1 = TRUE, var2 = FALSE))
  testthat::expect_equal(result$var1, c(3, 2, 1))
  testthat::expect_equal(result$var2, c(4, 5, 6))
})

testthat::test_that("arrange2 handles factors correctly", {
  data <- data.frame(var1 = factor(c("b", "a", "c")), var2 = c(4, 6, 5))
  result <- saros.base:::arrange2(data, c("var1"))
  testthat::expect_equal(as.character(result$var1), c("a", "b", "c"))
})

testthat::test_that("arrange2 handles NA values with na_first", {
  data <- data.frame(var1 = factor(c("b", NA, "c")), var2 = c(4, 6, 5))
  result <- saros.base:::arrange2(data, c("var1"), na_first = TRUE)
  testthat::expect_true(is.na(result$var1[1]))
  testthat::expect_equal(as.character(result$var1[-1]), c("b", "c"))
})

testthat::test_that("arrange2 errors on missing columns", {
  data <- data.frame(var1 = c(3, 1, 2))
  testthat::expect_error(
    saros.base:::arrange2(data, c("var1", "var3")),
    regexp = "`arrange_vars` not found"
  )
})

testthat::test_that("arrange_expr_producer correctly names expressions", {
  data <- data.frame(col1 = 1:3, col2 = 4:6)
  arrange_vars <- c(col1 = FALSE, col2 = TRUE)
  result <- saros.base:::arrange_expr_producer(data, arrange_vars, na_first = TRUE)
  # Names should be column names, not the logical values
  testthat::expect_equal(names(result), c("col1", "col2"))
})

# Tests for arrange integration with refine_chapter_overview

testthat::test_that("refine_chapter_overview sorts by position not label", {
  # Variables with intentionally reversed label/position order
  test_data <- data.frame(
    var_e = factor(rep(c("a", "b", "c"), length.out = 11)), # Pos 1, label "Z"
    var_d = factor(rep(c("a", "b", "c"), length.out = 11)), # Pos 2, label "Y"
    var_c = factor(rep(c("a", "b", "c"), length.out = 11)), # Pos 3, label "X"
    var_b = factor(rep(c("a", "b", "c"), length.out = 11)), # Pos 4, label "W"
    var_a = factor(rep(c("a", "b", "c"), length.out = 11)) # Pos 5, label "V"
  )
  attr(test_data$var_e, "label") <- "Z Question"
  attr(test_data$var_d, "label") <- "Y Question"
  attr(test_data$var_c, "label") <- "X Question"
  attr(test_data$var_b, "label") <- "W Question"
  attr(test_data$var_a, "label") <- "V Question"

  result <- saros.base::refine_chapter_overview(
    chapter_overview = data.frame(chapter = "Test", dep = "tidyselect::everything()"),
    data = test_data,
    hide_chunk_if_n_below = 5,
    progress = FALSE
  )

  result_uni <- result[is.na(result$.variable_name_indep), ]
  testthat::expect_equal(
    as.character(unique(result_uni$.variable_name_dep)),
    c("var_e", "var_d", "var_c", "var_b", "var_a")
  )
  testthat::expect_equal(unique(result_uni$.variable_position_dep), 1:5)
})

testthat::test_that("refine_chapter_overview sorts within chapters", {
  test_data <- data.frame(
    beta_3 = factor(rep(c("a", "b", "c"), length.out = 11)),
    beta_2 = factor(rep(c("a", "b", "c"), length.out = 11)),
    alpha_2 = factor(rep(c("a", "b", "c"), length.out = 11)),
    alpha_1 = factor(rep(c("a", "b", "c"), length.out = 11))
  )
  attr(test_data$beta_3, "label") <- "Z Beta"
  attr(test_data$beta_2, "label") <- "Y Beta"
  attr(test_data$alpha_2, "label") <- "Y Alpha"
  attr(test_data$alpha_1, "label") <- "X Alpha"

  ch_overview <- data.frame(
    chapter = c("Beta", "Beta", "Alpha", "Alpha"),
    dep = c("beta_3", "beta_2", "alpha_2", "alpha_1")
  )

  result <- saros.base::refine_chapter_overview(
    chapter_overview = ch_overview,
    data = test_data,
    hide_chunk_if_n_below = 5,
    progress = FALSE
  )

  result_uni <- result[is.na(result$.variable_name_indep), ]
  beta <- result_uni[result_uni$chapter == "Beta", ]
  alpha <- result_uni[result_uni$chapter == "Alpha", ]

  testthat::expect_equal(as.character(unique(beta$.variable_name_dep)), c("beta_3", "beta_2"))
  testthat::expect_equal(as.character(unique(alpha$.variable_name_dep)), c("alpha_2", "alpha_1"))
})

testthat::test_that("refine_chapter_overview sorts bivariates by dep position", {
  test_data <- data.frame(
    dep_c = factor(rep(c("a", "b", "c"), length.out = 11)), # Pos 1, label "Z"
    dep_b = factor(rep(c("a", "b", "c"), length.out = 11)), # Pos 2, label "Y"
    dep_a = factor(rep(c("a", "b", "c"), length.out = 11)), # Pos 3, label "X"
    indep_x = factor(rep(c("a", "b", "c"), length.out = 11))
  )
  attr(test_data$dep_c, "label") <- "Z Dep"
  attr(test_data$dep_b, "label") <- "Y Dep"
  attr(test_data$dep_a, "label") <- "X Dep"
  attr(test_data$indep_x, "label") <- "Group"

  result <- saros.base::refine_chapter_overview(
    chapter_overview = data.frame(
      chapter = "Test",
      dep = "starts_with('dep_')",
      indep = "indep_x"
    ),
    data = test_data,
    hide_chunk_if_n_below = 5,
    progress = FALSE
  )

  result_bi <- result[!is.na(result$.variable_name_indep), ]
  testthat::expect_equal(
    as.character(unique(result_bi$.variable_name_dep)),
    c("dep_c", "dep_b", "dep_a")
  )
})
