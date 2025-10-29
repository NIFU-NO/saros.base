test_that("sanitize_chr_vec handles basic input", {
  input <- c(
    "<b>Bold</b>",
    "  Extra spaces   ",
    "First question - Selected Choice - Option B",
    "&Agrave;",
    "&Eacute;",
    "&Ouml;",
    "Question - Subquestion",
    "Another - Example - Test",
    "Label {random tag}"
  )
  result <- saros.base::sanitize_chr_vec(input,
    replace_ascii_with_utf = TRUE,
    sep = " - ",
    multi_sep_replacement = ": "
  )
  testthat::expect_equal(
    result,
    c(
      "Bold",
      "Extra spaces",
      "First question - Option B",
      "À",
      "É",
      "Ö",
      "Question - Subquestion",
      "Another - Example: Test",
      "Label (random tag)"
    )
  )
})
