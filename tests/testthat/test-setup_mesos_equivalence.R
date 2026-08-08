# Regression tests for GH #188.
#
# setup_mesos() and setup_mesos_structure() produced different trees for the
# same intent. Most of that was the path and overwrite behaviour fixed in #212;
# what remained was the display name of the mesos variable.
#
# setup_mesos_structure() builds its internal data frame with
# handle_named_list(), which sets attr(df[[1]], "label") <- var_name, so a
# label is always present. setup_mesos() takes the caller's data frame as-is,
# and a plain data.frame(Laerested = ...) has no label -- so mesos_var_pretty
# came back NA and was written into the site as `.na.character`.

# Content of every file under `root`, keyed by path relative to it.
tree_snapshot <- function(root) {
  files <- fs::dir_ls(root, recurse = TRUE, type = "file")
  relative <- as.character(fs::path_rel(files, root))
  contents <- vapply(
    files,
    function(file) paste(readLines(file, warn = FALSE), collapse = "\n"),
    character(1),
    USE.NAMES = FALSE
  )
  ordering <- order(relative)
  stats::setNames(contents[ordering], relative[ordering])
}

build_with_setup_mesos <- function(envir = parent.frame()) {
  path <- withr::local_tempdir(.local_envir = envir)
  writeLines("REAL CHAPTER CONTENT", fs::path(path, "_1_chapter.qmd"))
  withr::with_dir(path, {
    suppressMessages(saros.base::setup_mesos(
      main_directory = character(),
      files_to_process = "_1_chapter.qmd",
      mesos_df = list(Laerested = data.frame(Laerested = c("HINN", "UiO"))),
      read_syntax_pattern = NULL,
      read_syntax_replacement = NULL
    ))
  })
  path
}

build_with_setup_mesos_structure <- function(envir = parent.frame()) {
  path <- withr::local_tempdir(.local_envir = envir)
  writeLines("REAL CHAPTER CONTENT", fs::path(path, "_1_chapter.qmd"))
  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = path,
    files_to_process = fs::path(path, "_1_chapter.qmd"),
    mesos_groups = list(Laerested = c("HINN", "UiO"))
  ))
  path
}

################################################################################
testthat::test_that("no generated file contains a serialised NA", {
  # `.na.character` is what yaml::as.yaml() emits for NA_character_; it appeared
  # as the literal title of <mesos_var>/index.qmd.
  for (root in list(build_with_setup_mesos(), build_with_setup_mesos_structure())) {
    for (file in fs::dir_ls(root, recurse = TRUE, type = "file")) {
      contents <- paste(readLines(file, warn = FALSE), collapse = "\n")
      testthat::expect_false(
        grepl(".na.character", contents, fixed = TRUE),
        info = as.character(fs::path_rel(file, root))
      )
    }
  }
})

testthat::test_that("the mesos_var index page is titled with the variable name", {
  root <- build_with_setup_mesos()

  index <- yaml::read_yaml(fs::path(root, "Laerested", "index.qmd"))
  testthat::expect_equal(index$title, "Laerested")
})

################################################################################
testthat::test_that("both entry points produce the same files and includes", {
  by_setup_mesos <- tree_snapshot(build_with_setup_mesos())
  by_structure <- tree_snapshot(build_with_setup_mesos_structure())

  testthat::expect_equal(names(by_setup_mesos), names(by_structure))

  # Chapter stubs and the authored source must match exactly.
  qmd <- grep("[.]qmd$", names(by_setup_mesos), value = TRUE)
  testthat::expect_gt(length(qmd), 0)
  for (file in qmd) {
    testthat::expect_equal(by_setup_mesos[[file]], by_structure[[file]], info = file)
  }
})

testthat::test_that("the only metadata difference is the optional directory in the subtitle", {
  # Documented behaviour of subtitle_separator: the subtitle concatenates the
  # main_directory folder name with the mesos variable and group. With
  # main_directory = character() there is no folder name to include, so this
  # difference follows from the arguments rather than from a defect.
  by_setup_mesos <- tree_snapshot(build_with_setup_mesos())
  by_structure <- tree_snapshot(build_with_setup_mesos_structure())

  differing <- Filter(
    function(file) !identical(by_setup_mesos[[file]], by_structure[[file]]),
    intersect(names(by_setup_mesos), names(by_structure))
  )

  testthat::expect_setequal(
    differing,
    c("Laerested/HINN/_metadata.yml", "Laerested/UiO/_metadata.yml")
  )

  for (file in differing) {
    without_dir <- yaml::yaml.load(by_setup_mesos[[file]])
    with_dir <- yaml::yaml.load(by_structure[[file]])

    testthat::expect_equal(without_dir$params, with_dir$params, info = file)
    testthat::expect_equal(without_dir$title, with_dir$title, info = file)
    # Same subtitle, save for the leading directory component.
    testthat::expect_true(
      endsWith(with_dir$subtitle, without_dir$subtitle),
      info = paste(file, "|", with_dir$subtitle, "vs", without_dir$subtitle)
    )
  }
})

################################################################################
# Regression tests for GH #254.
#
# handle_legacy_format() row-subsets the legacy `mesos_groups` data frame with
# `[.data.frame`, which subsets each column with `[` and so drops every
# attribute but names/dim/dimnames. A `label` on the group column did not
# survive. extract_mesos_metadata() reads that label through
# get_raw_labels(col_pos = 1) and falls back to the column name (#188), so the
# same labelled input produced a human-readable mesos_var_pretty through
# setup_mesos() and the bare column name through setup_mesos_structure().
#
# Not a regression from #248: the clean_group_data() call this replaced began
# with as.character(), which drops the label just as thoroughly. The label has
# never survived this path.
#
# Labels are in scope here. The two sibling handlers in the same file both set
# one explicitly -- handle_named_list() assigns the variable name, and
# handle_data_frame() carries the source label through with a fallback to the
# column name. handle_legacy_format() was the only one of the three that did
# not. No fallback is added here: extract_mesos_metadata() already has one.

labelled_legacy_entry <- function() {
  df <- data.frame(Laerested = c("HINN", "UiO"), abbr = c("HI", "UO"))
  attr(df$Laerested, "label") <- "Higher education institution"
  df
}

testthat::test_that("the legacy path keeps the group column's label", {
  converted <- saros.base:::handle_legacy_format(list(labelled_legacy_entry()))

  testthat::expect_equal(
    attr(converted[[1]][[1]], "label"),
    "Higher education institution"
  )
})

testthat::test_that("a labelled legacy column gives the same mesos_var_pretty as mesos_df", {
  entry <- labelled_legacy_entry()

  by_setup_mesos <- saros.base:::extract_mesos_metadata(entry)
  by_structure <- saros.base:::extract_mesos_metadata(
    saros.base:::handle_legacy_format(list(entry))[[1]]
  )

  testthat::expect_equal(
    by_structure$mesos_var_pretty,
    by_setup_mesos$mesos_var_pretty
  )
  testthat::expect_equal(by_structure$mesos_var_pretty, "Higher education institution")
})

testthat::test_that("the label survives a row that the legacy filter drops", {
  # The filter is the mechanism that lost it, so a frame that actually loses a
  # row is the case that matters.
  df <- data.frame(Laerested = c("HINN", NA, "UiO"), abbr = c("HI", "XX", "UO"))
  attr(df$Laerested, "label") <- "Higher education institution"

  converted <- saros.base:::handle_legacy_format(list(df))[[1]]

  testthat::expect_equal(nrow(converted), 2)
  testthat::expect_equal(
    attr(converted[[1]], "label"),
    "Higher education institution"
  )
})

testthat::test_that("setup_mesos_structure titles the index page with the label", {
  path <- withr::local_tempdir()
  writeLines("REAL CHAPTER CONTENT", fs::path(path, "_1_chapter.qmd"))

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = path,
    files_to_process = fs::path(path, "_1_chapter.qmd"),
    mesos_groups = list(labelled_legacy_entry())
  ))

  index <- yaml::read_yaml(fs::path(path, "Laerested", "index.qmd"))
  testthat::expect_equal(index$title, "Higher education institution")

  metadata <- yaml::read_yaml(fs::path(path, "Laerested", "_metadata.yml"))
  testthat::expect_equal(metadata$params$mesos_var_pretty, "Higher education institution")
})
