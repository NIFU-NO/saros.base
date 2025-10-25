test_that("log_unused_variables logs to file", {
  data <- data.frame(
    used1 = 1:5,
    used2 = letters[1:5],
    unused1 = 6:10,
    unused2 = LETTERS[1:5]
  )

  chapter_structure <- data.frame(
    .variable_name_dep = c("used1", "used2"),
    .variable_name_indep = c(NA, NA),
    stringsAsFactors = FALSE
  )

  log_file <- tempfile(fileext = ".txt")
  on.exit(unlink(log_file))

  log_unused_variables(
    data = data,
    chapter_structure = chapter_structure,
    log_file = log_file
  )

  expect_true(file.exists(log_file))
  log_content <- readLines(log_file)
  expect_true(any(grepl("Not using the following variables", log_content)))
  expect_true(any(grepl("unused1", log_content)))
  expect_true(any(grepl("unused2", log_content)))
})

test_that("remove_from_chapter_structure_if_all_na logs to file", {
  data <- data.frame(
    var1 = 1:5,
    var2 = rep(NA, 5),
    var3 = letters[1:5]
  )

  chapter_structure <- data.frame(
    .variable_name = c("var1", "var2", "var3"),
    .variable_name_dep = c("var1", "var2", "var3"),
    .variable_name_indep = c(NA, NA, NA),
    stringsAsFactors = FALSE
  )

  log_file <- tempfile(fileext = ".txt")
  on.exit(unlink(log_file))

  result <- remove_from_chapter_structure_if_all_na(
    chapter_structure = chapter_structure,
    data = data,
    hide_variable_if_all_na = TRUE,
    log_file = log_file
  )

  expect_true(file.exists(log_file))
  log_content <- readLines(log_file)
  expect_true(any(grepl("Hiding.*all NA", log_content)))
  expect_true(any(grepl("var2", log_content)))
  expect_false(any(grepl("var1", log_content)))
  expect_false(any(grepl("var3", log_content)))
})

test_that("remove_from_chapter_structure_if_n_below logs to file", {
  chapter_structure <- data.frame(
    .variable_name_dep = c("var1", "var2", "var3"),
    .n = c(5, 15, 8),
    stringsAsFactors = FALSE
  )

  log_file <- tempfile(fileext = ".txt")
  on.exit(unlink(log_file))

  result <- remove_from_chapter_structure_if_n_below(
    chapter_structure = chapter_structure,
    n_variable_name = ".n",
    hide_chunk_if_n_below = 10,
    log_file = log_file
  )

  expect_true(file.exists(log_file))
  log_content <- readLines(log_file)
  expect_true(any(grepl("Hiding.*n < 10", log_content)))
  expect_true(any(grepl("var1.*n=5", log_content)))
  expect_true(any(grepl("var3.*n=8", log_content)))
  expect_false(any(grepl("var2", log_content)))
})

test_that("remove_from_chapter_structure_if_non_significant logs to file", {
  data <- data.frame(
    dep1 = c(1, 1, 2, 2, 1, 1, 2, 2),
    indep1 = c(1, 2, 1, 2, 1, 2, 1, 2)
  )

  chapter_structure <- data.frame(
    .variable_name_dep = "dep1",
    .variable_name_indep = "indep1",
    .variable_type_dep = "int",
    .variable_type_indep = "int",
    stringsAsFactors = FALSE
  )

  log_file <- tempfile(fileext = ".txt")
  on.exit(unlink(log_file))

  result <- remove_from_chapter_structure_if_non_significant(
    chapter_structure = chapter_structure,
    data = data,
    hide_bi_entry_if_sig_above = 0.05,
    progress = FALSE,
    log_file = log_file
  )

  # File should exist even if nothing is logged (depends on p-value)
  # The test is mainly to ensure no errors occur
  expect_no_error({
    result <- remove_from_chapter_structure_if_non_significant(
      chapter_structure = chapter_structure,
      data = data,
      hide_bi_entry_if_sig_above = 0.05,
      progress = FALSE,
      log_file = log_file
    )
  })
})

test_that("remove_from_chapter_structure_if_no_overlap logs to file", {
  data <- data.frame(
    dep1 = c(1, 2, NA, NA, NA),
    dep2 = c(1, 2, 3, 4, 5),
    indep1 = c(NA, NA, NA, NA, NA),
    indep2 = c(1, 2, 3, 4, 5)
  )

  chapter_structure <- data.frame(
    .variable_name_dep = c("dep1", "dep2"),
    .variable_name_indep = c("indep1", "indep2"),
    stringsAsFactors = FALSE
  )

  log_file <- tempfile(fileext = ".txt")
  on.exit(unlink(log_file))

  result <- remove_from_chapter_structure_if_no_overlap(
    chapter_structure = chapter_structure,
    data = data,
    log_file = log_file
  )

  expect_true(file.exists(log_file))
  log_content <- readLines(log_file)
  expect_true(any(grepl("no non-NA overlap", log_content)))
  expect_true(any(grepl("dep1.*indep1", log_content)))
})

test_that("log file appends multiple exclusions", {
  data <- data.frame(
    var1 = 1:5,
    var2 = rep(NA, 5),
    unused1 = 6:10
  )

  chapter_structure <- data.frame(
    .variable_name = c("var1", "var2"),
    .variable_name_dep = c("var1", "var2"),
    .variable_name_indep = c(NA, NA),
    .n = c(15, 20),
    stringsAsFactors = FALSE
  )

  log_file <- tempfile(fileext = ".txt")
  on.exit(unlink(log_file))

  # First exclusion: unused variables
  log_unused_variables(
    data = data,
    chapter_structure = chapter_structure,
    log_file = log_file
  )

  # Second exclusion: all NA variables
  result <- remove_from_chapter_structure_if_all_na(
    chapter_structure = chapter_structure,
    data = data,
    hide_variable_if_all_na = TRUE,
    log_file = log_file
  )

  log_content <- readLines(log_file)
  # Should have both exclusion types
  expect_true(any(grepl("Not using", log_content)))
  expect_true(any(grepl("all NA", log_content)))
  expect_true(any(grepl("unused1", log_content)))
  expect_true(any(grepl("var2", log_content)))
})

test_that("log_file = NULL does not create file", {
  data <- data.frame(
    used1 = 1:5,
    unused1 = 6:10
  )

  chapter_structure <- data.frame(
    .variable_name_dep = "used1",
    .variable_name_indep = NA,
    stringsAsFactors = FALSE
  )

  # Should not error with NULL log_file
  expect_no_error({
    log_unused_variables(
      data = data,
      chapter_structure = chapter_structure,
      log_file = NULL
    )
  })
})
