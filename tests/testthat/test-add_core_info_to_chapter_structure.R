testthat::test_that("add_core_info_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(dep = c("var1", "var2"), indep = c("var3", "var4"))
  result <- saros.base:::add_core_info_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.variable_role, c("dep", "indep", "dep", "indep"))
  # testthat::expect_equal(result$.variable_selection, c("var1", "var3", "var2", "var4"))
})

testthat::test_that("add_core_info_to_chapter_structure handles missing indep variables", {
  chapter_structure <- data.frame(dep = c("var1", "var2"), indep = c(NA, "var4"))
  result <- saros.base:::add_core_info_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.variable_role, c("dep", "dep", "indep"))
  testthat::expect_equal(result$.variable_selection, c("var1", "var2", "var4"))
})

testthat::test_that("add_core_info_to_chapter_structure handles empty strings in indep variables", {
  chapter_structure <- data.frame(dep = c("var1", "var2"), indep = c("", "var4"))
  result <- saros.base:::add_core_info_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.variable_role, c("dep", "dep", "indep"))
  testthat::expect_equal(result$.variable_selection, c("var1", "var2", "var4"))
})

testthat::test_that("add_core_info_to_chapter_structure handles multiple variable selections", {
  chapter_structure <- data.frame(dep = c("var1, var5", "var2"), indep = c("var3", "var4"))
  result <- saros.base:::add_core_info_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.variable_role, c("dep", "dep", "indep", "dep", "indep"))
  testthat::expect_equal(result$.variable_selection, c("var1", "var5", "var3", "var2", "var4"))
})

testthat::test_that("add_core_info_to_chapter_structure handles matches regex", {
  chapter_structure <- data.frame(dep = c("matches(var1)", "var2"), indep = c("var3*", "var4"))
  result <- saros.base:::add_core_info_to_chapter_structure(chapter_structure)
  testthat::expect_equal(result$.variable_selection, c("matches(var1)", "matches('var3*')", "var2", "var4"))
})
