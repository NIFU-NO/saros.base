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
