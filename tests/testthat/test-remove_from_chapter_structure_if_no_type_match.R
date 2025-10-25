testthat::test_that("remove_from_chapter_overview_if_no_type_match", {
  df1 <-
    data.frame(
      a = 1:3,
      .variable_type_dep = c("fct", "fct", NA),
      .variable_type_indep = c("fct", "fct", NA),
      .template_variable_type_dep = c("fct;ord;int", "int;num", "int;num"),
      .template_variable_type_indep = c("fct;ord;int", "int;num", "int;num")
    )
  df1 <- dplyr::group_by(df1, .data[["a"]])
  df2 <-
    df1 |>
    saros.base:::remove_from_chapter_structure_if_no_type_match()
  testthat::expect_equal(ncol(df2), expected = ncol(df1) + 4)
  testthat::expect_equal(nrow(df2), expected = 2)
  testthat::expect_equal(dplyr::group_vars(df2), expected = "a")
})

testthat::test_that("remove_from_chapter_structure_if_no_type_match logs to file", {
  df1 <-
    data.frame(
      .variable_name_dep = c("var1", "var2", "var3"),
      .variable_name_indep = c("indep1", "indep2", NA),
      .variable_type_dep = c("fct", "chr", "int"),
      .variable_type_indep = c("fct", "int", NA),
      .template_variable_type_dep = c("fct;ord;int", "int;num", "int;num"),
      .template_variable_type_indep = c("fct;ord;int", "int;num", "int;num")
    )

  log_file <- tempfile(fileext = ".txt")
  on.exit(unlink(log_file))

  result <- saros.base:::remove_from_chapter_structure_if_no_type_match(
    chapter_structure = df1,
    log_file = log_file
  )

  # Should have removed var2 due to type mismatch (chr vs int/num)
  testthat::expect_true(file.exists(log_file))
  log_content <- readLines(log_file)
  testthat::expect_true(any(grepl("no type match", log_content)))
  testthat::expect_true(any(grepl("var2", log_content)))
  testthat::expect_true(any(grepl("chr", log_content)))
})
