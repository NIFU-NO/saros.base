testthat::test_that("check_chapter_structure_for_duplicates handles uniques", {
  testthat::expect_no_warning(
    saros.base::ex_survey |>
      dplyr::select(b_1:b_2) |>
      labelled::set_variable_labels(b_1 = "Hello - you", b_2 = "Hello - you too") |>
      saros.base::refine_chapter_overview(
        chapter_overview = data.frame(chapter = "C1", dep = "b_1:b_2"),
        data = _,
        label_separator = " - ",
        chunk_templates = saros.base::get_chunk_template_defaults()
      )
  )
})

testthat::test_that("check_chapter_structure_for_duplicates handles duplicates", {
  testthat::expect_warning(
    saros.base::ex_survey |>
      dplyr::select(b_1:b_2, a_1:a_2) |>
      labelled::set_variable_labels(
        b_1 = "Hello - you", b_2 = "Hello - you",
        a_1 = "Hello - you too", a_2 = "Hello - you too"
      ) |>
      saros.base::refine_chapter_overview(
        chapter_overview = data.frame(chapter = "C1", dep = "b_1:b_2, a_1:a_2"),
        data = _,
        label_separator = " - ",
        chunk_templates = saros.base::get_chunk_template_defaults()
      ),
    regexp = "Duplicate rows were found for specified"
  )
})
