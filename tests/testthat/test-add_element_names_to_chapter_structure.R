testthat::test_that("add_chunk_templates_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2", NA_character_))
  chunk_templates <- data.frame(template = c("temp1", "temp2"))
  result <- saros.base:::add_chunk_templates_to_chapter_structure(chapter_structure, chunk_templates)
  testthat::expect_equal(nrow(result), 5)
  testthat::expect_equal(result$template, c(NA, "temp1", "temp2", "temp1", "temp2"))
})

testthat::test_that("add_chunk_templates_to_chapter_structure handles all NA .variable_name_dep", {
  chapter_structure <- data.frame(.variable_name_dep = c(NA, NA))
  chunk_templates <- data.frame(template = c("temp1", "temp2"))
  result <- saros.base:::add_chunk_templates_to_chapter_structure(chapter_structure, chunk_templates)
  testthat::expect_equal(nrow(result), 2)
  testthat::expect_equal(result$template, c(NA_character_, NA_character_))
})

testthat::test_that("add_chunk_templates_to_chapter_structure handles no NA .variable_name_dep", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2"))
  chunk_templates <- data.frame(template = c("temp1", "temp2"))
  result <- saros.base:::add_chunk_templates_to_chapter_structure(chapter_structure, chunk_templates)
  testthat::expect_equal(nrow(result), 4)
  testthat::expect_equal(result$template, c("temp1", "temp2", "temp1", "temp2"))
})

testthat::test_that("add_chunk_templates_to_chapter_structure handles empty chunk_templates", {
  chapter_structure <- data.frame(.variable_name_dep = c("var1", "var2", NA))
  chunk_templates <- data.frame(template = character(0))
  result <- saros.base:::add_chunk_templates_to_chapter_structure(chapter_structure, chunk_templates)
  testthat::expect_equal(nrow(result), 1)
  testthat::expect_equal(result$template, NA_character_)
})

testthat::test_that("add_chunk_templates_to_chapter_structure handles empty chapter_structure", {
  chapter_structure <- data.frame(.variable_name_dep = character(0))
  chunk_templates <- data.frame(template = c("temp1", "temp2"))
  result <- saros.base:::add_chunk_templates_to_chapter_structure(chapter_structure, chunk_templates)
  testthat::expect_equal(nrow(result), 0)
})
