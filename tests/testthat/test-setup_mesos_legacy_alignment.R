# Regression tests for GH #248.
#
# handle_legacy_format() cleaned the two columns of a legacy `mesos_groups` data
# frame independently and in place:
#
#     df[[1]] <- clean_group_data(df[[1]])
#     if (length(df) == 2) df[[2]] <- clean_group_data(df[[2]])
#
# clean_group_data() drops NA and "", so it can hand back a vector shorter than
# the column it replaces, and `[[<-.data.frame` then recycles that vector over
# the original number of rows. Two outcomes, both wrong:
#
#   1. The length divides evenly, and one group's value is silently copied onto
#      another. An empty abbreviation was never rejected -- it was replaced by
#      the previous group's abbreviation.
#   2. The length does not divide evenly, and the conversion dies with a raw
#      base R message naming `[[<-.data.frame`.
#
# The columns are now filtered as rows, so a group name and its abbreviation
# stay on the same row, and an empty abbreviation is left in place for
# validate_mesos_groups_abbr() (GH #244) to reject by name.

local_mesos_project <- function(envir = parent.frame()) {
  path <- withr::local_tempdir(.local_envir = envir)
  writeLines("REAL CHAPTER CONTENT", fs::path(path, "_1_chapter.qmd"))
  path
}

files_below <- function(root) {
  as.character(fs::path_rel(fs::dir_ls(root, recurse = TRUE, all = TRUE), root))
}

################################################################################
# The conversion itself.

testthat::test_that("an empty abbreviation is kept, not replaced by its neighbour's", {
  result <- saros.base:::convert_mesos_groups_to_df(
    list(data.frame(Skole = c("Skole A", "Skole B"), abbr = c("SK", "")))
  )

  testthat::expect_equal(as.character(result[[1]][[1]]), c("Skole A", "Skole B"))
  testthat::expect_equal(as.character(result[[1]][[2]]), c("SK", ""))
})

testthat::test_that("a shortened abbreviation column that does not divide evenly no longer errors", {
  testthat::expect_no_error(
    saros.base:::convert_mesos_groups_to_df(
      list(data.frame(Skole = c("A", "B", "C"), abbr = c("X", "Y", "")))
    )
  )
})

testthat::test_that("an uneven shortening leaves every abbreviation on its own group", {
  result <- saros.base:::convert_mesos_groups_to_df(
    list(data.frame(Skole = c("A", "B", "C"), abbr = c("X", "Y", "")))
  )

  testthat::expect_equal(as.character(result[[1]][[1]]), c("A", "B", "C"))
  testthat::expect_equal(as.character(result[[1]][[2]]), c("X", "Y", ""))
})

testthat::test_that("an empty group name takes its abbreviation with it", {
  # The row goes, not the value: dropping "" from the name column alone left
  # "Skole A" recycled onto the second row, which then owned abbreviation "B".
  result <- saros.base:::convert_mesos_groups_to_df(
    list(data.frame(Skole = c("Skole A", ""), abbr = c("A", "B")))
  )

  testthat::expect_equal(nrow(result[[1]]), 1L)
  testthat::expect_equal(as.character(result[[1]][[1]]), "Skole A")
  testthat::expect_equal(as.character(result[[1]][[2]]), "A")
})

testthat::test_that("an NA group name takes its abbreviation with it", {
  result <- saros.base:::convert_mesos_groups_to_df(
    list(data.frame(Skole = c("Skole A", NA, "Skole C"), abbr = c("A", "B", "C")))
  )

  testthat::expect_equal(as.character(result[[1]][[1]]), c("Skole A", "Skole C"))
  testthat::expect_equal(as.character(result[[1]][[2]]), c("A", "C"))
})

testthat::test_that("an NA abbreviation is carried through as an empty one", {
  # NA in the abbreviation column means "no abbreviation given", not "skip this
  # group", so the row stays and the missing value is normalised to "" for
  # validate_mesos_groups_abbr() to reject. Dropping it instead would shorten
  # the column and reintroduce the misalignment this fix removes.
  result <- saros.base:::convert_mesos_groups_to_df(
    list(data.frame(Skole = c("Skole A", "Skole B"), abbr = c("A", NA)))
  )

  testthat::expect_equal(as.character(result[[1]][[1]]), c("Skole A", "Skole B"))
  testthat::expect_equal(as.character(result[[1]][[2]]), c("A", ""))
})

testthat::test_that("a legacy frame with no usable group name is named in the abort", {
  # clean_group_data()'s "Group data must be a non-empty character vector."
  # was the only thing standing here, and it identified neither the argument
  # nor which of the data frames was empty.
  testthat::expect_error(
    saros.base:::convert_mesos_groups_to_df(
      list(
        data.frame(Fylke = c("Oslo", "Viken")),
        data.frame(Skole = c("", NA))
      )
    ),
    "Data frame 2"
  )
})

################################################################################
# End to end, through setup_mesos_structure().

testthat::test_that("a dropped group name does not reappear under its neighbour's abbreviation", {
  # The shape #248 called out as the one #244's guard cannot see. The fabricated
  # value lands in the *group name* column, so the abbreviations stay distinct
  # and non-empty and validate_mesos_groups_abbr() waves it through. Before the
  # fix this wrote Skole/A and Skole/B, both recording mesos_group "Skole A",
  # and reported "Mesos structure created successfully".
  main <- local_mesos_project()

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = fs::path(main, "_1_chapter.qmd"),
    mesos_groups = list(data.frame(Skole = c("Skole A", ""), abbr = c("A", "B")))
  ))

  group_dirs <- fs::dir_ls(fs::path(main, "Skole"), type = "directory")
  testthat::expect_equal(as.character(fs::path_file(group_dirs)), "A")

  described <- vapply(
    group_dirs,
    function(dir) yaml::read_yaml(fs::path(dir, "_metadata.yml"))$params$mesos_group,
    character(1),
    USE.NAMES = FALSE
  )
  testthat::expect_equal(described, "Skole A")
})

testthat::test_that("an empty explicit abbreviation aborts as empty rather than as a duplicate", {
  main <- local_mesos_project()

  testthat::expect_error(
    suppressMessages(saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(data.frame(
        Skole = c("Skole A", "Skole B"),
        abbr = c("SK", "")
      ))
    )),
    "non-empty\\s+abbreviation"
  )
})

testthat::test_that("the group missing an abbreviation is the one named", {
  main <- local_mesos_project()

  err <- testthat::expect_error(
    suppressMessages(saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(data.frame(
        Skole = c("Skole A", "Skole B"),
        abbr = c("SK", "")
      ))
    ))
  )

  testthat::expect_match(conditionMessage(err), "Skole B")
  testthat::expect_no_match(conditionMessage(err), "must\\s+be\\s+unique")
})

testthat::test_that("an unevenly shortened abbreviation column aborts by name without writing", {
  # Previously `Error in [[<-.data.frame(*tmp*, 2, value = c("X", "Y")):
  # replacement has 2 rows, data has 3` -- a base R message naming an internal
  # assignment, with no indication of which group or which argument was at
  # fault.
  main <- local_mesos_project()

  err <- testthat::expect_error(
    suppressMessages(saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(data.frame(
        Skole = c("Skole A", "Skole B", "Skole C"),
        abbr = c("X", "Y", "")
      ))
    )),
    "non-empty\\s+abbreviation"
  )

  testthat::expect_match(conditionMessage(err), "Skole C")
  testthat::expect_equal(files_below(main), "_1_chapter.qmd")
})

testthat::test_that("an NA explicit abbreviation aborts by name without writing", {
  main <- local_mesos_project()

  err <- testthat::expect_error(
    suppressMessages(saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(data.frame(
        Skole = c("Skole A", "Skole B"),
        abbr = c("SK", NA)
      ))
    )),
    "non-empty\\s+abbreviation"
  )

  testthat::expect_match(conditionMessage(err), "Skole B")
  testthat::expect_equal(files_below(main), "_1_chapter.qmd")
})

testthat::test_that("a legacy frame with a dropped row still builds the groups that remain", {
  main <- local_mesos_project()

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = fs::path(main, "_1_chapter.qmd"),
    mesos_groups = list(data.frame(
      Skole = c("Skole A", NA, "Skole C"),
      abbr = c("A", "B", "C")
    ))
  ))

  group_dirs <- fs::dir_ls(fs::path(main, "Skole"), type = "directory")
  testthat::expect_setequal(as.character(fs::path_file(group_dirs)), c("A", "C"))

  described <- vapply(
    group_dirs,
    function(dir) yaml::read_yaml(fs::path(dir, "_metadata.yml"))$params$mesos_group,
    character(1),
    USE.NAMES = FALSE
  )
  testthat::expect_setequal(described, c("Skole A", "Skole C"))
})

################################################################################
# Not #248 guards -- these pass before the fix too. They pin the blast radius:
# a legacy frame that needs no filtering must still come back untouched.

testthat::test_that("a legacy frame needing no filtering is returned unchanged", {
  legacy <- list(
    data.frame(region = c("North", "South")),
    data.frame(dept = c("Sales", "IT"))
  )

  testthat::expect_identical(saros.base:::convert_mesos_groups_to_df(legacy), legacy)
})

testthat::test_that("a two-column legacy frame needing no filtering keeps both columns", {
  legacy <- list(data.frame(Skole = c("Skole A", "Skole B"), abbr = c("A", "B")))

  testthat::expect_identical(saros.base:::convert_mesos_groups_to_df(legacy), legacy)
})

testthat::test_that("a group name of only whitespace is still a group", {
  # nzchar() is the test, not trimws(): "   " is a usable, if odd, group name
  # and test-setup_mesos_abbr.R pins that it gets a folder of its own.
  result <- saros.base:::convert_mesos_groups_to_df(
    list(data.frame(Skole = c("Skole A", "   "), abbr = c("A", "B")))
  )

  testthat::expect_equal(nrow(result[[1]]), 2L)
})
