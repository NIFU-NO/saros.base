testthat::test_that("draft_report", {

  tmpdir <- file.path(tempdir(), "test-draft_report")

  saros.base::ex_survey_ch_overview |>
    saros.base::refine_chapter_overview(data = saros.base::ex_survey,
                                        label_separator = " - ") |>
    saros.base::draft_report(
      chapter_structure = _,
      data = saros.base::ex_survey,
      path = tmpdir)

  output_files <-
    list.files(pattern = "\\.qmd$", path = tmpdir,
               full.names = TRUE, recursive = FALSE, ignore.case = TRUE)
  output_files <-
    gsub(x=output_files, pattern = "\\", replacement = "/", fixed=TRUE)
  testthat::expect_equal(
    object = length(output_files),
    expected = nrow(saros.base::ex_survey_ch_overview)+2)
  testthat::expect_lt(file.size(output_files[1]), 3600)
  testthat::expect_gt(file.size(output_files[4]), 3350)

  if(FALSE && !is.null(quarto::quarto_path()) && nchar(quarto::quarto_path())>1) {
    testthat::expect_no_error(
      withr::with_dir(new = tmpdir,
                      code = quarto::quarto_render(input = output_files[3])))
  }


  ##############################

    tmpdir <- file.path(tempdir(), "test-draft_report2")
    saros.base::ex_survey_ch_overview |>
      saros.base::refine_chapter_overview(data = saros.base::ex_survey,
                                          label_separator = " - ") |>
      saros.base::draft_report(
        chapter_structure = _,
        data = saros.base::ex_survey,
        mesos_var = "f_uni",
        combined_report = TRUE,
        path = tmpdir)

    output_files <-
      list.files(pattern = "\\.qmd", path = tmpdir,
                 full.names = TRUE, recursive = TRUE, ignore.case = TRUE)
    testthat::expect_equal(
      object = length(output_files),
      expected = (nrow(saros.base::ex_survey_ch_overview)+2) * dplyr::n_distinct(saros.base::ex_survey$f_uni))


})
