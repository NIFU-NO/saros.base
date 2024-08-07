testthat::test_that("eval_cols", {
  x <-
    saros.base:::eval_cols(x = c("x1_sex, x2_human",
                            "matches('b_')"),
              data = saros.base::ex_survey)
  testthat::expect_equal(lengths(x), c(2, 3))
})

testthat::test_that("look_for_extended", {
  x <-
    saros.base:::look_for_extended(data = saros.base::ex_survey,
                              cols = colnames(saros.base::ex_survey),
                              label_separator = " - ",
                              name_separator = "_")
  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(dim(x), c(32, 8))
  testthat::expect_contains(names(x), c(".variable_name", ".variable_name_prefix", ".variable_name_suffix",
                                        ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
                                        ".variable_type"))
  x <-
    saros.base:::look_for_extended(data = saros.base::ex_survey,
                              cols = colnames(saros.base::ex_survey),
                              name_separator = "_")
  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(dim(x), c(32, 8))
  testthat::expect_contains(names(x), c(".variable_name", ".variable_name_prefix", ".variable_name_suffix",
                                        ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
                                        ".variable_type"))
  x <-
    saros.base:::look_for_extended(data = saros.base::ex_survey,
                              cols = colnames(saros.base::ex_survey),
                              label_separator = " - ")
  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(dim(x), c(32, 8))
  testthat::expect_contains(names(x), c(".variable_name", ".variable_name_prefix", ".variable_name_suffix",
                                        ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
                                        ".variable_type"))
  x <-
    saros.base:::look_for_extended(data = saros.base::ex_survey,
                              cols = paste0("b_", 1:3))
  testthat::expect_s3_class(x, "data.frame")
  testthat::expect_equal(dim(x), c(3, 8))
  testthat::expect_contains(names(x), c(".variable_name", ".variable_name_prefix", ".variable_name_suffix",
                                        ".variable_label", ".variable_label_prefix", ".variable_label_suffix",
                                        ".variable_type"))

})

testthat::test_that("validate_labels", {
    saros.base:::look_for_extended(data = saros.base::ex_survey,
                              cols = paste0("b_", 1:3),
                              label_separator = " - ") |>
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
    saros.base:::refine_chapter_overview(
      chapter_overview = saros.base::ex_survey_ch_overview,
      data = saros.base::ex_survey,
      label_separator = " - ",
      name_separator = "_")
  testthat::expect_equal(dim(x), c(1+1+7*4+7*4+8*2, 46))
})
