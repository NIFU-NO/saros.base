testthat::test_that("ungroup_data", {
  x <- saros.base::ex_survey |>
    dplyr::group_by(.data$f_uni)
  testthat::expect_false(inherits(saros.base:::ungroup_data(x), "grouped_df"))
  x <- saros.base::ex_survey |>
    srvyr::as_survey_design() |>
    srvyr::group_by(.data$f_uni)
  testthat::expect_false(inherits(saros.base:::ungroup_data(x), "grouped_svy"))
})
