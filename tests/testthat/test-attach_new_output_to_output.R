testthat::test_that("attach_new_output_to_output", {
  saros.base:::attach_new_output_to_output(
    output = character(),
    heading_line = "# New heading",
    new_out = "New output",
    level = 1,
    grouping_structure = letters[1:3]) |>
  testthat::expect_equal("# New heading\n\nNew output")

  saros.base:::attach_new_output_to_output(
    output = "",
    heading_line = "# New heading",
    new_out = "New output",
    level = 1,
    grouping_structure = letters[1:3]) |>
    testthat::expect_equal("# New heading\n\nNew output")

  saros.base:::attach_new_output_to_output(
    output = character(),
    heading_line = "# New heading",
    new_out = character(),
    level = 1,
    grouping_structure = letters[1:3]) |>
    testthat::expect_equal("# New heading")

  saros.base:::attach_new_output_to_output(
    output = character(),
    heading_line = "# New heading",
    new_out = character(),
    level = 3,
    grouping_structure = letters[1:3]) |>
    testthat::expect_equal(character())

  saros.base:::attach_new_output_to_output(
    output = character(),
    heading_line = character(),
    new_out = character(),
    level = 1,
    grouping_structure = letters[1:3]) |>
    testthat::expect_equal(character())

  saros.base:::attach_new_output_to_output(
    output = "Existing",
    heading_line = "## Subheading",
    new_out = "chunk",
    level = 1,
    grouping_structure = letters[1:3]) |>
    testthat::expect_equal("Existing\n\n## Subheading\n\nchunk")

})
