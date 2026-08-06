# Regression tests for GH #212.
#
# Three defects in the mesos stub generation, all silent -- Quarto does not
# error on an unresolvable {{< include >}}, so affected group pages rendered as
# empty documents with correct titles and _metadata.yml:
#
#   1. create_include_content() scaled the hop with the level
#      (rep("../", path_lvl)), so every level above the innermost skipped a
#      directory and eventually pointed outside main_directory.
#   2. A stub was emitted at main_directory itself, overwriting the authored
#      _*.qmd sources with an include pointing outside main_directory. No
#      warning, no backup, and re-running after restoring them destroyed them
#      again.
#   3. write_subfolder_metadata() vectorised over the subfolder components
#      instead of nesting them, so a multi-component mesos_var_subfolder
#      addressed a non-existent sibling directory and errored mid-write.

# Build a main_directory holding one authored chapter source.
local_mesos_project <- function(envir = parent.frame()) {
  path <- withr::local_tempdir(.local_envir = envir)
  writeLines("REAL CHAPTER CONTENT", fs::path(path, "_1_chapter.qmd"))
  path
}

# Follow the {{< include >}} chain from `start` and return the content of the
# file it terminates at, or NA if it breaks or escapes main_directory.
resolve_include_chain <- function(main, start) {
  current <- start
  for (hop in seq_len(20L)) {
    if (startsWith(current, "..")) {
      return(NA_character_) # escaped main_directory
    }
    file <- fs::path(main, current)
    if (!fs::file_exists(file)) {
      return(NA_character_) # broken link
    }

    text <- paste(readLines(file, warn = FALSE), collapse = "\n")
    target <- regmatches(text, regexpr('(?<=include ")[^"]+', text, perl = TRUE))
    if (length(target) == 0) {
      return(text) # terminus: a real file, not a stub
    }

    current <- as.character(fs::path_rel(
      fs::path_norm(fs::path(main, dirname(current), target)),
      main
    ))
  }
  NA_character_ # cycle
}

################################################################################
testthat::test_that("the authored chapter source is not overwritten", {
  main <- local_mesos_project()

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = fs::path(main, "_1_chapter.qmd"),
    mesos_groups = list(Laerested = c("HINN", "UiO"))
  ))

  testthat::expect_equal(
    paste(readLines(fs::path(main, "_1_chapter.qmd"), warn = FALSE), collapse = "\n"),
    "REAL CHAPTER CONTENT"
  )
})

testthat::test_that("the source survives repeated runs", {
  # The original bug destroyed the source on the first call and again on every
  # subsequent one, so restoring from version control was not enough.
  main <- local_mesos_project()

  for (run in 1:3) {
    suppressMessages(saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(Laerested = "HINN")
    ))
  }

  testthat::expect_equal(
    paste(readLines(fs::path(main, "_1_chapter.qmd"), warn = FALSE), collapse = "\n"),
    "REAL CHAPTER CONTENT"
  )
})

################################################################################
testthat::test_that("include chains resolve to the source at every depth", {
  # Each configuration adds a directory level between the group folder and
  # main_directory; all must walk every level and terminate at the source.
  configurations <- list(
    list(label = "no subfolder", subfolder = character()),
    list(label = "one subfolder", subfolder = "Rapport"),
    list(label = "nested subfolder", subfolder = "Rapport/Del1")
  )

  for (config in configurations) {
    main <- withr::local_tempdir()
    writeLines("REAL CHAPTER CONTENT", fs::path(main, "_1_chapter.qmd"))

    suppressMessages(saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(Laerested = c("HINN", "UiO")),
      mesos_var_subfolder = config$subfolder
    ))

    group_pages <- fs::dir_ls(main, recurse = TRUE, type = "file", glob = "*1_chapter.qmd")
    group_pages <- group_pages[grepl("(HINN|UiO)", group_pages)]
    testthat::expect_length(group_pages, 2)

    for (page in group_pages) {
      testthat::expect_equal(
        resolve_include_chain(main, as.character(fs::path_rel(page, main))),
        "REAL CHAPTER CONTENT",
        info = paste0(config$label, ": ", fs::path_rel(page, main))
      )
    }
  }
})

testthat::test_that("no stub include escapes main_directory", {
  main <- local_mesos_project()

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = fs::path(main, "_1_chapter.qmd"),
    mesos_groups = list(Laerested = "HINN"),
    mesos_var_subfolder = "Rapport"
  ))

  for (file in fs::dir_ls(main, recurse = TRUE, type = "file", glob = "*.qmd")) {
    text <- paste(readLines(file, warn = FALSE), collapse = "\n")
    target <- regmatches(text, regexpr('(?<=include ")[^"]+', text, perl = TRUE))
    if (length(target) == 0) next

    resolved <- fs::path_norm(fs::path(dirname(file), target))
    testthat::expect_true(
      startsWith(as.character(resolved), as.character(fs::path_real(main))),
      info = paste0(fs::path_rel(file, main), " -> ", target)
    )
  }
})

################################################################################
testthat::test_that("a multi-component mesos_var_subfolder nests rather than erroring", {
  main <- local_mesos_project()

  testthat::expect_no_error(suppressMessages(
    saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(Laerested = "HINN"),
      mesos_var_subfolder = "Rapport/Del1"
    )
  ))

  # Nested, one _metadata.yml per level ...
  testthat::expect_true(fs::file_exists(fs::path(main, "Laerested", "Rapport", "_metadata.yml")))
  testthat::expect_true(fs::file_exists(fs::path(main, "Laerested", "Rapport", "Del1", "_metadata.yml")))
  # ... and never as a sibling of the first component.
  testthat::expect_false(fs::dir_exists(fs::path(main, "Laerested", "Del1")))

  # Group folders sit below the full nested path.
  testthat::expect_true(fs::dir_exists(fs::path(main, "Laerested", "Rapport", "Del1", "HINN")))
})
