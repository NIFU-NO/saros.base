testthat::test_that("remove_from_chapter_overview_if_no_type_match", {
  df1 <-
  data.frame(a=1:3,
             .variable_type_dep=c("fct", "fct", NA),
             .variable_type_indep=c("fct", "fct", NA),
             .template_variable_type_dep=c("fct;ord;int", "int;num", "int;num"),
             .template_variable_type_indep=c("fct;ord;int", "int;num", "int;num"))
  df1 <- dplyr::group_by(df1, .data[["a"]])
  df2 <-
    df1 |>
    saros.base:::remove_from_chapter_structure_if_no_type_match()
  testthat::expect_equal(ncol(df2), expected = ncol(df1)+4)
  testthat::expect_equal(nrow(df2), expected = 2)
  testthat::expect_equal(dplyr::group_vars(df2), expected = "a")

})
