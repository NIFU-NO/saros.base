testthat::test_that("add_chapter_foldername_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(chapter = c("Cha", "Chi", "Cho"))
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.chapter_number, c(1, 2, 3))
  testthat::expect_true(all(nchar(result$.chapter_foldername) <= 64))
})

testthat::test_that("add_chapter_foldername_to_chapter_structure handles null chapter", {
  chapter_structure <- data.frame(chapter = NULL)
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure)
  testthat::expect_equal(nrow(result), 0)
  testthat::expect_equal(colnames(result), character())
})

testthat::test_that("add_chapter_foldername_to_chapter_structure handles character chapters (rare)", {
  chapter_structure <- data.frame(chapter = c("A", "B", "C"))
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.chapter_number, as.integer(c(1, 2, 3)))
  testthat::expect_true(all(nchar(result$.chapter_foldername) <= 64))
})

testthat::test_that("add_chapter_foldername_to_chapter_structure handles max_clean_folder_name", {
  chapter_structure <- data.frame(chapter = c("This is a long chapter", "This is an even longer chapter", "This is by far the longest chapter"))
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure, max_clean_folder_name = 10)
  testthat::expect_equal(result$.chapter_foldername, c("1_This_is_a_", "2_This_is_an", "3_This_is_by"))
  testthat::expect_true(all(nchar(result$.chapter_foldername) <= 2+10))
})

testthat::test_that("add_chapter_foldername_to_chapter_structure creates unique folder names", {
  chapter_structure <- data.frame(chapter = c("This is a long chapter", "This is a very long chapter", "This is by far the longest chapter"))
  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure, max_clean_folder_name = 10)
  testthat::expect_equal(result$.chapter_foldername, c("1_This_is_a_", "2_This_is_a_", "3_This_is_by"))
  testthat::expect_true(all(nchar(result$.chapter_foldername) <= 2+10))

})
