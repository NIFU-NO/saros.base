# Regression tests for GH #253.
#
# extract_mesos_metadata() filtered two parallel vectors for NA independently:
#
#     mesos_groups_pretty <- mesos_groups_pretty[!is.na(mesos_groups_pretty)]
#     mesos_groups_abbr   <- mesos_groups_abbr[!is.na(mesos_groups_abbr)]
#
# Nothing held them in step. An NA in one column but not the other shifted
# every later element of that vector relative to the other, so a group was
# paired with the abbreviation belonging to a different group --
# data.frame(Skole = c("Skole A", "Skole B"), abbr = c(NA, "B")) handed back
# two group names and the single abbreviation "B", pairing "Skole A" with
# "Skole B"'s abbreviation. validate_mesos_groups_abbr() (GH #244) did not
# object: "B" is neither empty nor duplicated.
#
# This is GH #248's bug at the second entry point. #252 closed the
# setup_mesos_structure() route by normalising NA to "" in
# handle_legacy_format(); this closes the setup_mesos() route the same way.
#
# End to end the misalignment did not stay silent, but it never reached a guard
# in this package either: the shortened abbreviation vector was recycled into a
# data.frame() beside a full-length one and the run died in base R with
# `arguments imply differing number of rows: 1, 2`. Which mesos variable, which
# group, and that an abbreviation was what was missing were all absent from
# that message.
#
# The all-NA abbreviation column went the other way. It did not mean "generate
# abbreviations" -- a length-zero vector made create_includes_content_path_df()
# skip the group-folder level entirely, and create_metadata_yml() then aborted
# on its length guard, *after* <mesos_var>/_metadata.yml, index.qmd and the
# stub had been written. The message named `mesos_groups_pretty` and
# `mesos_groups_abbr`, two internal variables the caller never supplied. The
# legacy entry point had already handled that same input cleanly since #252, so
# the two routes disagreed. Both now abort by naming the groups, and neither
# writes anything.
#
# One mask, derived from the group names, now indexes both vectors, so they are
# aligned by construction rather than by coincidence.

local_alignment_project <- function(envir = parent.frame()) {
  path <- withr::local_tempdir(.local_envir = envir)
  writeLines("REAL CHAPTER CONTENT", fs::path(path, "_1_chapter.qmd"))
  path
}

files_below <- function(root) {
  as.character(fs::path_rel(fs::dir_ls(root, recurse = TRUE, all = TRUE), root))
}

################################################################################
# Alignment as a property: a group keeps its own abbreviation, or none is used.

testthat::test_that("extract_mesos_metadata keeps group names and abbreviations the same length", {
  # The property that was violated. Whenever an abbreviation column is
  # supplied, the two vectors describe the same groups, so they must agree in
  # length -- otherwise create_metadata_yml() pairs them off by position and
  # the pairing is meaningless.
  result <- saros.base:::extract_mesos_metadata(
    data.frame(Skole = c("Skole A", NA, "Skole B"), abbr = c("A", "X", "B"))
  )

  testthat::expect_length(
    result$mesos_groups_abbr,
    length(result$mesos_groups_pretty)
  )
})

testthat::test_that("a dropped group name takes its own abbreviation with it", {
  # The NA row's abbreviation "X" must go with it. Filtering the columns
  # separately kept "X" and shifted it onto "Skole B".
  result <- saros.base:::extract_mesos_metadata(
    data.frame(Skole = c("Skole A", NA, "Skole B"), abbr = c("A", "X", "B"))
  )

  testthat::expect_equal(result$mesos_groups_pretty, c("Skole A", "Skole B"))
  testthat::expect_equal(result$mesos_groups_abbr, c("A", "B"))
})

testthat::test_that("extract_mesos_metadata does not pair a group with its neighbour's abbreviation", {
  # The issue's own reproduction. Before the fix this returned two group names
  # and the single abbreviation "B", silently giving "Skole A" the folder that
  # belongs to "Skole B".
  err <- testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      data.frame(Skole = c("Skole A", "Skole B"), abbr = c(NA, "B"))
    )
  )

  # Reported as the emptiness fault it is, against the group that has it.
  testthat::expect_match(conditionMessage(err), "non-empty\\s+abbreviation")
  testthat::expect_match(conditionMessage(err), "Skole A")
})

testthat::test_that("an NA abbreviation is rejected wherever it sits in the column", {
  # Not just the first row: the shift is invisible from either end.
  err <- testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      data.frame(Skole = c("Skole A", "Skole B"), abbr = c("A", NA))
    )
  )

  testthat::expect_match(conditionMessage(err), "Skole B")
})

################################################################################
# The all-NA abbreviation column.

testthat::test_that("an all-NA abbreviation column aborts instead of writing a partial tree", {
  err <- testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      data.frame(region = c("North Region", "South Region"), abbr = c(NA, NA))
    )
  )

  testthat::expect_match(conditionMessage(err), "non-empty\\s+abbreviation")
})

testthat::test_that("an all-NA abbreviation column names every group missing one", {
  err <- testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      data.frame(region = c("North Region", "South Region"), abbr = c(NA, NA))
    )
  )

  testthat::expect_match(conditionMessage(err), "North Region")
  testthat::expect_match(conditionMessage(err), "South Region")
})

testthat::test_that("setup_mesos writes nothing when every abbreviation is missing", {
  # The half-written tree. Pre-fix this left <mesos_var>/, its _metadata.yml,
  # its index.qmd and the chapter stub on disk before create_metadata_yml()
  # reached its length guard, so the run failed with a directory already
  # standing that a retry would have to overwrite.
  main <- local_alignment_project()

  testthat::expect_error(
    suppressMessages(saros.base::setup_mesos(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_df = list(data.frame(
        region = c("North Region", "South Region"),
        abbr = c(NA, NA)
      )),
      read_syntax_pattern = NULL,
      read_syntax_replacement = NULL
    ))
  )

  testthat::expect_equal(files_below(main), "_1_chapter.qmd")
})

testthat::test_that("setup_mesos reports a partly missing abbreviation column in its own terms", {
  # Pre-fix this reached base R rather than any guard in this package: the
  # shortened abbreviation vector was recycled into a data.frame() alongside a
  # full-length one, and the run died with `arguments imply differing number of
  # rows: 1, 2`, which names nothing the caller supplied.
  main <- local_alignment_project()

  err <- testthat::expect_error(
    suppressMessages(saros.base::setup_mesos(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_df = list(data.frame(
        Skole = c("Skole A", "Skole B"),
        abbr = c(NA, "B")
      )),
      read_syntax_pattern = NULL,
      read_syntax_replacement = NULL
    ))
  )

  testthat::expect_match(conditionMessage(err), "Skole A")
  testthat::expect_no_match(conditionMessage(err), "differing\\s+number\\s+of\\s+rows")
})

testthat::test_that("setup_mesos no longer aborts with an internal length message", {
  # `mesos_groups_pretty must be of same length as mesos_groups_abbr` names two
  # internal variables the caller never supplied. That guard in
  # create_metadata_yml() is now unreachable from this path.
  main <- local_alignment_project()

  err <- testthat::expect_error(
    suppressMessages(saros.base::setup_mesos(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_df = list(data.frame(
        region = c("North Region", "South Region"),
        abbr = c(NA, NA)
      )),
      read_syntax_pattern = NULL,
      read_syntax_replacement = NULL
    ))
  )

  testthat::expect_no_match(conditionMessage(err), "same\\s+length")
})

################################################################################
# Both entry points, one answer.

testthat::test_that("both entry points reject a missing abbreviation the same way", {
  # The divergence #253 leaves open: the legacy route has reported this
  # correctly since #252, while setup_mesos() half-wrote a tree and died on an
  # internal guard.
  entry <- data.frame(Skole = c("Skole A", "Skole B"), abbr = c(NA, "B"))

  direct <- testthat::expect_error(
    saros.base:::extract_mesos_metadata(entry)
  )
  legacy <- testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      saros.base:::handle_legacy_format(list(entry))[[1]]
    )
  )

  testthat::expect_equal(conditionMessage(direct), conditionMessage(legacy))
})

################################################################################
# Blast radius: what must keep working.

testthat::test_that("a fully supplied abbreviation column is still accepted", {
  result <- saros.base:::extract_mesos_metadata(
    data.frame(region = c("North", "South", "East"), abbr = c("N", "S", "E"))
  )

  testthat::expect_equal(result$mesos_groups_pretty, c("North", "South", "East"))
  testthat::expect_equal(result$mesos_groups_abbr, c("N", "S", "E"))
})

testthat::test_that("abbreviations are still generated when no column is supplied", {
  # An absent column means "generate them". Only an absent *column* does; an
  # all-NA one is a fault, per #253.
  result <- saros.base:::extract_mesos_metadata(
    data.frame(region = c("North Region", "South Region"))
  )

  testthat::expect_length(result$mesos_groups_abbr, 2)
  testthat::expect_true(all(nzchar(result$mesos_groups_abbr)))
})

testthat::test_that("an NA group name is still dropped silently when no abbreviations are supplied", {
  # `?setup_mesos` documents that NA is silently ignored in `mesos_df`.
  result <- saros.base:::extract_mesos_metadata(
    data.frame(region = c("North", NA, "South"))
  )

  testthat::expect_equal(result$mesos_groups_pretty, c("North", "South"))
  testthat::expect_length(result$mesos_groups_abbr, 2)
})
