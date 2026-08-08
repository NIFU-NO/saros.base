# Regression tests for GH #244.
#
# Each mesos group abbreviation names one group folder. Two ways of getting an
# abbreviation that cannot do that, both silent and both destructive:
#
#   1. An empty abbreviation. filename_sanitizer() returned "" for a group name
#      in which every character was illegal ("***"), and fs::path() drops an
#      empty segment, so the group's _metadata.yml landed on
#      <mesos_var>/_metadata.yml -- the *mesos variable's* metadata file. It was
#      overwritten with one group's metadata, destroying params$mesos_var for
#      every sibling group, and that group's own folder was never created.
#      make.unique() disambiguated the second and later collisions ("_1", "_2"),
#      so the *first* such group was the one that got the empty name.
#   2. A duplicated abbreviation. make.unique() is applied to generated
#      abbreviations only, so two groups given the same explicit abbreviation
#      collapsed into one folder and the last one written won.
#
# In both cases setup_mesos_structure() still reported
# "Mesos structure created successfully".

# Build a main_directory holding one authored chapter source.
local_abbr_project <- function(envir = parent.frame()) {
  path <- withr::local_tempdir(.local_envir = envir)
  writeLines("REAL CHAPTER CONTENT", fs::path(path, "_1_chapter.qmd"))
  path
}

################################################################################
# The abbreviations, at the point where they are derived.

testthat::test_that("extract_mesos_metadata gives a group name that sanitizes away a usable abbreviation", {
  result <- saros.base:::extract_mesos_metadata(
    data.frame(Skole = c("***", "Skole A", "Skole B"))
  )

  testthat::expect_true(all(nzchar(result$mesos_groups_abbr)))
  testthat::expect_equal(anyDuplicated(result$mesos_groups_abbr), 0L)
  testthat::expect_length(result$mesos_groups_abbr, 3)
})

testthat::test_that("extract_mesos_metadata aborts on an empty explicit abbreviation", {
  # An explicit abbreviation column is passed through untouched, so "" reaches
  # the path construction whatever filename_sanitizer() does.
  testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      data.frame(region = c("North", "South"), abbr = c("", "S"))
    ),
    "non-empty\\s+abbreviation"
  )
})

testthat::test_that("extract_mesos_metadata names the groups with an empty abbreviation", {
  testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      data.frame(region = c("North", "South"), abbr = c("", "S"))
    ),
    "North"
  )
})

testthat::test_that("extract_mesos_metadata aborts on duplicated explicit abbreviations", {
  # make.unique() runs on generated abbreviations only, never on an explicit
  # column, so nothing separated these two folders.
  testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      data.frame(region = c("North", "South", "East"), abbr = c("N", "N", "E"))
    ),
    "must\\s+be\\s+unique"
  )
})

testthat::test_that("extract_mesos_metadata names the groups sharing an abbreviation", {
  err <- testthat::expect_error(
    saros.base:::extract_mesos_metadata(
      data.frame(region = c("North", "South", "East"), abbr = c("N", "N", "E"))
    )
  )
  testthat::expect_match(conditionMessage(err), "North")
  testthat::expect_match(conditionMessage(err), "South")
})

# Not a #244 guard -- this one passes before the fix too. It pins the blast
# radius of the new validation: distinct, non-empty abbreviations must still be
# accepted.
testthat::test_that("extract_mesos_metadata accepts distinct non-empty abbreviations", {
  testthat::expect_no_error(
    saros.base:::extract_mesos_metadata(
      data.frame(region = c("North", "South", "East"), abbr = c("N", "S", "E"))
    )
  )
})

################################################################################
# The mesos variable's own metadata file must survive.

testthat::test_that("a group whose name sanitizes away does not overwrite <mesos_var>/_metadata.yml", {
  main <- local_abbr_project()

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = fs::path(main, "_1_chapter.qmd"),
    mesos_groups = list(Skole = c("***", "Skole A", "Skole B"))
  ))

  metadata <- yaml::read_yaml(fs::path(main, "Skole", "_metadata.yml"))

  # This file belongs to the mesos variable, not to any group.
  testthat::expect_equal(metadata$params$mesos_var, "Skole")
  testthat::expect_equal(metadata$params$mesos_var_pretty, "Skole")
  testthat::expect_null(metadata$params$mesos_group)
})

testthat::test_that("a group whose name sanitizes away still gets a folder of its own", {
  main <- local_abbr_project()

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = fs::path(main, "_1_chapter.qmd"),
    mesos_groups = list(Skole = c("***", "Skole A", "Skole B"))
  ))

  group_dirs <- fs::dir_ls(fs::path(main, "Skole"), type = "directory")
  testthat::expect_length(group_dirs, 3)

  # Every group folder carries its own metadata, and the three of them describe
  # the three groups.
  groups <- vapply(
    group_dirs,
    function(dir) yaml::read_yaml(fs::path(dir, "_metadata.yml"))$params$mesos_group,
    character(1),
    USE.NAMES = FALSE
  )
  testthat::expect_setequal(groups, c("***", "Skole A", "Skole B"))
})

testthat::test_that("no group stub is written at the mesos_var level", {
  # The collapsed group segment also put the group's stub at
  # <mesos_var>/1_chapter.qmd. Only the underscore-prefixed intermediate stub
  # belongs there.
  main <- local_abbr_project()

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = fs::path(main, "_1_chapter.qmd"),
    mesos_groups = list(Skole = c("***", "Skole A"))
  ))

  testthat::expect_true(fs::file_exists(fs::path(main, "Skole", "_1_chapter.qmd")))
  testthat::expect_false(fs::file_exists(fs::path(main, "Skole", "1_chapter.qmd")))
})

################################################################################
# Aborting before anything is written.

testthat::test_that("setup_mesos_structure() aborts on duplicated explicit abbreviations without writing", {
  main <- local_abbr_project()

  testthat::expect_error(
    suppressMessages(saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(data.frame(
        Skole = c("Skole A", "Skole B"),
        abbr = c("SK", "SK")
      ))
    )),
    "must\\s+be\\s+unique"
  )

  # Nothing beyond the authored source.
  testthat::expect_equal(
    as.character(fs::path_rel(fs::dir_ls(main, recurse = TRUE, all = TRUE), main)),
    "_1_chapter.qmd"
  )
})

testthat::test_that("setup_mesos_structure() aborts on an empty explicit abbreviation without writing", {
  # This test was written deliberately unpinned as to *why* it aborted, and is
  # now pinned. When #247 added it, setup_mesos_structure() did not hand its
  # input straight to extract_mesos_metadata(): the legacy two-column path ran
  # both columns through clean_group_data(), which dropped "" from the
  # abbreviation column, and `[[<-.data.frame` recycled the shortened vector
  # back over two rows. The empty abbreviation never arrived -- "SK" was copied
  # onto the second group -- so the abort came from the *uniqueness* check for a
  # fault that was an *empty* abbreviation. The test asserted only the property
  # that mattered then (abort, nothing written) because asserting the message
  # would have pinned that wrong reason in place.
  #
  # #248 fixed the recycling, so the empty abbreviation now reaches
  # validate_mesos_groups_abbr() intact and is reported as what it is. The
  # abort-and-write-nothing assertion is unchanged; the message assertion is
  # new, and is the reason this test needed touching at all.
  main <- local_abbr_project()

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

  testthat::expect_equal(
    as.character(fs::path_rel(fs::dir_ls(main, recurse = TRUE, all = TRUE), main)),
    "_1_chapter.qmd"
  )
})

testthat::test_that("setup_mesos() aborts on an empty explicit abbreviation without writing", {
  working_dir <- withr::local_tempdir()
  writeLines("REAL CHAPTER CONTENT", fs::path(working_dir, "_1_chapter.qmd"))

  withr::with_dir(working_dir, {
    testthat::expect_error(
      suppressMessages(saros.base::setup_mesos(
        main_directory = character(),
        files_to_process = "_1_chapter.qmd",
        mesos_df = list(data.frame(
          Laerested = c("HINN", "UiO"),
          abbr = c("HINN", "")
        )),
        read_syntax_pattern = NULL,
        read_syntax_replacement = NULL
      )),
      "non-empty\\s+abbreviation"
    )
  })

  testthat::expect_equal(
    as.character(fs::path_rel(fs::dir_ls(working_dir, recurse = TRUE, all = TRUE), working_dir)),
    "_1_chapter.qmd"
  )
})

testthat::test_that("a bad abbreviation in one mesos variable leaves the others unwritten", {
  # Validation happens for every mesos variable before the writing loop starts,
  # so a fault in the second one does not leave the first half-written.
  main <- local_abbr_project()

  testthat::expect_error(
    suppressMessages(saros.base::setup_mesos_structure(
      main_directory = main,
      files_to_process = fs::path(main, "_1_chapter.qmd"),
      mesos_groups = list(
        data.frame(Fylke = c("Oslo", "Viken")),
        data.frame(Skole = c("Skole A", "Skole B"), abbr = c("SK", "SK"))
      )
    )),
    "must\\s+be\\s+unique"
  )

  testthat::expect_false(fs::dir_exists(fs::path(main, "Fylke")))
  testthat::expect_equal(
    as.character(fs::path_rel(fs::dir_ls(main, recurse = TRUE, all = TRUE), main)),
    "_1_chapter.qmd"
  )
})

################################################################################
testthat::test_that("a whole set of pathological group names produces one folder each", {
  # The end state the fix is for: every group addressable, and the mesos
  # variable's metadata intact.
  main <- local_abbr_project()
  groups <- c("Skole A", "***", "///", "!!!", "   ")

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = fs::path(main, "_1_chapter.qmd"),
    mesos_groups = list(Skole = groups)
  ))

  group_dirs <- fs::dir_ls(fs::path(main, "Skole"), type = "directory")
  testthat::expect_length(group_dirs, length(groups))

  described <- vapply(
    group_dirs,
    function(dir) yaml::read_yaml(fs::path(dir, "_metadata.yml"))$params$mesos_group,
    character(1),
    USE.NAMES = FALSE
  )
  testthat::expect_setequal(described, groups)

  metadata <- yaml::read_yaml(fs::path(main, "Skole", "_metadata.yml"))
  testthat::expect_equal(metadata$params$mesos_var, "Skole")
})
