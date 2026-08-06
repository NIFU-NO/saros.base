# Regression tests for GH #213 and #207.
#
# #213: insert_section_heading_line() appended two RNG-drawn digits to every
# {#sec-...} anchor, so draft_report() produced different .qmd files from
# identical inputs. Quarto's `freeze` cache keys on file content, so it missed
# on every chapter after every regeneration -- a one-line change in data prep
# forced a full re-render of the whole site.
#
# #207: each chapter file carried two first-level headings, because
# gen_qmd_chapters() emits `# {chapter}` directly *and* the .chapter_number
# grouping level emitted one too. The ignore_heading_for_group default listed
# "chapter", but the grouping column is .chapter_number, so the guard never
# fired.

# Draft the bundled example report into a fresh directory.
draft_example <- function(envir = parent.frame()) {
  path <- withr::local_tempdir(.local_envir = envir)
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = saros.base::ex_survey_ch_overview,
      data = saros.base::ex_survey,
      progress = FALSE
    )
  ))
  suppressMessages(saros.base::draft_report(
    data = saros.base::ex_survey,
    chapter_structure = chapter_structure,
    path = path
  ))
  path
}

qmd_files <- function(path) sort(basename(fs::dir_ls(path, type = "file", glob = "*.qmd")))

all_anchors <- function(path) {
  files <- fs::dir_ls(path, type = "file", glob = "*.qmd")
  stats::setNames(
    lapply(files, function(file) {
      lines <- readLines(file, warn = FALSE)
      unlist(regmatches(lines, gregexpr("\\{#sec-[^}]+\\}", lines)))
    }),
    basename(files)
  )
}

################################################################################
testthat::test_that("draft_report() is reproducible across differing RNG state", {
  # The two runs deliberately leave the RNG in different states. Before the fix
  # this alone changed every anchor in every chapter.
  set.seed(1)
  invisible(stats::runif(7))
  first <- draft_example()

  set.seed(99)
  invisible(stats::runif(23))
  second <- draft_example()

  testthat::expect_equal(qmd_files(first), qmd_files(second))

  for (file in qmd_files(first)) {
    testthat::expect_equal(
      readLines(fs::path(first, file), warn = FALSE),
      readLines(fs::path(second, file), warn = FALSE),
      info = file
    )
  }
})

testthat::test_that("draft_report() draws no random numbers", {
  # Stronger than comparing output: nothing in the pipeline should touch the
  # session RNG at all, so a caller's stream is left undisturbed.
  set.seed(42)
  before <- .Random.seed

  invisible(draft_example())

  testthat::expect_identical(.Random.seed, before)
})

################################################################################
testthat::test_that("anchors are unique within and across chapter files", {
  # The sanitized base is not unique on its own -- in the bundled example
  # "x1_sex" and "x3_nationality" each appear twice within a single chapter --
  # so the suffix has real disambiguation work to do.
  anchors <- all_anchors(draft_example())
  flat <- unlist(anchors, use.names = FALSE)

  testthat::expect_gt(length(flat), 0)
  testthat::expect_equal(anyDuplicated(flat), 0L)

  for (file in names(anchors)) {
    testthat::expect_equal(anyDuplicated(anchors[[file]]), 0L, info = file)
  }
})

testthat::test_that("repeated group values still get distinct anchors", {
  anchors <- unlist(all_anchors(draft_example()), use.names = FALSE)

  for (base in c("x1-sex", "x3-nationality")) {
    matching <- grep(base, anchors, value = TRUE, fixed = TRUE)
    testthat::expect_gt(length(matching), 1)
    testthat::expect_equal(anyDuplicated(matching), 0L, info = base)
  }
})

testthat::test_that("anchor_suffix() is stable and path-sensitive", {
  grouping <- stats::setNames(
    c(".chapter_number", ".variable_label_prefix_dep", ".variable_name_indep"),
    c("1", "Some question", "x1_sex")
  )

  # Same input, same answer.
  testthat::expect_identical(
    saros.base:::anchor_suffix(grouping, level = 3),
    saros.base:::anchor_suffix(grouping, level = 3)
  )

  # Depth is part of the identity ...
  testthat::expect_false(identical(
    saros.base:::anchor_suffix(grouping, level = 2),
    saros.base:::anchor_suffix(grouping, level = 3)
  ))

  # ... and so is the path taken to get there: the same value under a different
  # parent must not collide, which is the case a hash of the value alone breaks.
  sibling <- grouping
  names(sibling)[2] <- "A different question"
  testthat::expect_false(identical(
    saros.base:::anchor_suffix(grouping, level = 3),
    saros.base:::anchor_suffix(sibling, level = 3)
  ))

  testthat::expect_match(saros.base:::anchor_suffix(grouping, level = 3), "^[0-9a-f]{6}$")
})

################################################################################
testthat::test_that("each chapter file has exactly one first-level heading", {
  path <- draft_example()
  chapter_files <- setdiff(qmd_files(path), c("index.qmd", "report.qmd"))
  testthat::expect_gt(length(chapter_files), 0)

  for (file in chapter_files) {
    lines <- readLines(fs::path(path, file), warn = FALSE)
    headings <- grep("^# ", lines, value = TRUE)
    testthat::expect_length(headings, 1)
    # And it is the plain chapter title, not a second anchored copy.
    testthat::expect_false(grepl("\\{#sec-", headings[1]), info = file)
  }
})

testthat::test_that("ignore_heading_for_group default covers the chapter grouping column", {
  # The default listed "chapter" while organize_by groups on .chapter_number,
  # so the guard silently never fired.
  ignored <- eval(formals(saros.base::draft_report)$ignore_heading_for_group)
  organized <- eval(formals(saros.base::refine_chapter_overview)$organize_by)

  testthat::expect_true(".chapter_number" %in% ignored)
  testthat::expect_true(".chapter_number" %in% organized)
})
