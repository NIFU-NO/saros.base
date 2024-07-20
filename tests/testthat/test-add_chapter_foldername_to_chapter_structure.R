testthat::test_that("add_chapter_foldername_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(chapter = c("1", "2", "10"))
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.chapter_number, as.integer(c("1", "2", "10")))
  testthat::expect_true(all(nchar(result$.chapter_foldername) <= 64))
})

testthat::test_that("add_chapter_foldername_to_chapter_structure handles null chapter", {
  chapter_structure <- data.frame(chapter = NULL)
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure)
  testthat::expect_null(result$.chapter_number)
  testthat::expect_null(result$.chapter_foldername)
})

testthat::test_that("add_chapter_foldername_to_chapter_structure handles non-integer chapters", {
  chapter_structure <- data.frame(chapter = c("A", "B", "C"))
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.chapter_number, as.integer(c(NA, NA, NA)))
  testthat::expect_true(all(nchar(result$.chapter_foldername) <= 64))
})

testthat::test_that("add_chapter_foldername_to_chapter_structure handles max_clean_folder_name", {
  chapter_structure <- data.frame(chapter = c("1", "2", "3"))
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure, max_clean_folder_name = 10)
  testthat::expect_true(all(nchar(result$.chapter_foldername) <= 10))
})

testthat::test_that("add_chapter_foldername_to_chapter_structure creates unique folder names", {
  chapter_structure <- data.frame(chapter = c("1", "1", "2"))
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure)
  testthat::expect_true(length(unique(result$.chapter_foldername)) == length(result$.chapter_foldername))
})
