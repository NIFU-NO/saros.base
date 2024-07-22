testthat::test_that("add_indep_to_chapter_structure works with typical input", {
  chapter_structure <- data.frame(.variable_role = c("dep", "indep", "dep"),
                                  .variable_name = c("var1", "var2", "var3"))
  result <- saros.base:::add_indep_to_chapter_structure(chapter_structure)
  testthat::expect_true(all(c(".variable_role_dep", ".variable_name_dep", ".variable_role_indep", ".variable_name_indep") %in% colnames(result)))
  testthat::expect_equal(nrow(result), 4)
})

testthat::test_that("add_indep_to_chapter_structure handles missing .variable_role", {
  chapter_structure <- data.frame(.variable_name = c("var1", "var2", "var3"))
  testthat::expect_warning(saros.base:::add_indep_to_chapter_structure(chapter_structure), regexp = "No column `.variable_role` found, no bivariates possible")
})

testthat::test_that("add_indep_to_chapter_structure handles all dep variables", {
  chapter_structure <- data.frame(.variable_role = c("dep", "dep", "dep", "indep"),
                                  .variable_name = c("var1", "var2", "var3", "var4"))
  result <- saros.base:::add_indep_to_chapter_structure(chapter_structure)
  testthat::expect_true(all(c(".variable_role_dep", ".variable_name_dep", ".variable_role_indep", ".variable_name_indep") %in% colnames(result)))
  testthat::expect_equal(nrow(result), 6)
})

## Not relevant, will never occur. But should result in a zero-length data frame
testthat::test_that("add_indep_to_chapter_structure handles all indep variables", {
  chapter_structure <- data.frame(.variable_role = c("indep", "indep", "indep"),
                                  .variable_name = c("var1", "var2", "var3"))
  result <- saros.base:::add_indep_to_chapter_structure(chapter_structure)
  testthat::expect_true(all(c(".variable_role_indep", ".variable_name_indep") %in% colnames(result)))
  testthat::expect_true(".variable_role_dep" %in% colnames(result))
  testthat::expect_equal(nrow(result), 0)
})

testthat::test_that("add_indep_to_chapter_structure handles NA", {
  chapter_structure <- data.frame(.variable_role = c("dep", NA, "indep"),
                                  .variable_name = c("var1", NA, "var3"))
  result <- saros.base:::add_indep_to_chapter_structure(chapter_structure)
  testthat::expect_true(all(c(".variable_role_dep", ".variable_name_dep", ".variable_role_indep", ".variable_name_indep") %in% colnames(result)))
  testthat::expect_equal(nrow(result), 3)
})

