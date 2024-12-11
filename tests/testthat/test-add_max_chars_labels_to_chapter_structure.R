testthat::test_that("add_max_chars_labels_to_chapter_structure", {
    testthat::expect_equal(
        data.frame(
            chapter = "1",
            .variable_label_suffix_dep = c(NA, "Hello dear!")
        ) |>
            dplyr::group_by(chapter) |>
            saros.base:::add_max_chars_labels_to_chapter_structure(),
        tibble::tibble(chapter = "1", .variable_label_suffix_dep = c(NA, "Hello dear!"), .max_chars_labels_dep = c(11, 11)) |>
            dplyr::group_by(chapter)
    )
})
