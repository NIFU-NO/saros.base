# Regression tests for GH #232.
#
# require_common_categories was documented, validated, and never read; the
# check_category_pairs() helper implementing it had tests but no caller.
#
# Only factor columns are compared. check_category_pairs() falls back to
# unique() for anything else, so including numeric or free-text variables would
# abort on values that merely happen not to coincide.

# Two items sharing a label prefix land in the same section, i.e. the same
# figure -- which is where sharing categories matters.
battery_data <- function(first_levels, second_levels, extra = NULL) {
  set.seed(1)
  n <- 60
  data <- data.frame(
    q_1 = factor(sample(first_levels, n, TRUE), levels = first_levels),
    q_2 = factor(sample(second_levels, n, TRUE), levels = second_levels),
    g = factor(sample(c("X", "Y"), n, TRUE))
  )
  attr(data$q_1, "label") <- "Battery - item one"
  attr(data$q_2, "label") <- "Battery - item two"
  attr(data$g, "label") <- "Group"
  if (!is.null(extra)) {
    data <- cbind(data, extra)
  }
  data
}

battery_structure <- function(data, deps = "q_1, q_2") {
  suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(chapter = "Ch", dep = deps, indep = "g"),
      data = data,
      progress = FALSE
    )
  ))
}

################################################################################
testthat::test_that("require_common_categories catches items with disjoint categories", {
  data <- battery_data(c("Yes", "No"), c("Agree", "Disagree"))
  structure <- battery_structure(data)

  testthat::expect_error(
    suppressMessages(saros.base::draft_report(
      data = data,
      chapter_structure = structure,
      path = withr::local_tempdir(),
      require_common_categories = TRUE
    )),
    regexp = "common categories"
  )
})

testthat::test_that("require_common_categories = FALSE skips the check", {
  data <- battery_data(c("Yes", "No"), c("Agree", "Disagree"))
  structure <- battery_structure(data)

  testthat::expect_no_error(
    suppressMessages(saros.base::draft_report(
      data = data,
      chapter_structure = structure,
      path = withr::local_tempdir(),
      require_common_categories = FALSE
    ))
  )
})

testthat::test_that("items sharing categories pass the check", {
  data <- battery_data(c("Yes", "No"), c("Yes", "No"))
  structure <- battery_structure(data)

  testthat::expect_no_error(
    suppressMessages(saros.base::draft_report(
      data = data,
      chapter_structure = structure,
      path = withr::local_tempdir(),
      require_common_categories = TRUE
    ))
  )
})

testthat::test_that("nothing is written when the check fails", {
  # The check runs before generation, so a mismatch must not leave a
  # half-generated report behind.
  data <- battery_data(c("Yes", "No"), c("Agree", "Disagree"))
  structure <- battery_structure(data)
  path <- withr::local_tempdir()

  testthat::expect_error(suppressMessages(saros.base::draft_report(
    data = data, chapter_structure = structure, path = path,
    require_common_categories = TRUE
  )))

  testthat::expect_length(fs::dir_ls(path, glob = "*.qmd"), 0)
})

################################################################################
testthat::test_that("the bundled example passes with the check enabled by default", {
  # Guards against the check being too aggressive for ordinary reports.
  structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = saros.base::ex_survey_ch_overview,
      data = saros.base::ex_survey,
      progress = FALSE
    )
  ))

  testthat::expect_no_error(
    suppressMessages(saros.base::draft_report(
      data = saros.base::ex_survey,
      chapter_structure = structure,
      path = withr::local_tempdir()
    ))
  )
})

testthat::test_that("numeric items with no shared values do not trip the check", {
  # unique() on two numeric columns can easily be disjoint; that is not a
  # category mismatch, and must not abort.
  set.seed(1)
  n <- 60
  data <- data.frame(
    m_1 = as.numeric(seq_len(n)),
    m_2 = as.numeric(seq_len(n)) + 0.5,
    g = factor(sample(c("X", "Y"), n, TRUE))
  )
  attr(data$m_1, "label") <- "Measures - first"
  attr(data$m_2, "label") <- "Measures - second"
  attr(data$g, "label") <- "Group"

  structure <- battery_structure(data, deps = "m_1, m_2")

  testthat::expect_no_error(
    suppressMessages(saros.base::draft_report(
      data = data,
      chapter_structure = structure,
      path = withr::local_tempdir(),
      require_common_categories = TRUE
    ))
  )
})
