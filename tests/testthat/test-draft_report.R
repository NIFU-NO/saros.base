testthat::test_that("draft_report", {
  tmpdir <- file.path(tempdir(), "test-draft_report")

  saros.base::ex_survey_ch_overview |>
    saros.base::refine_chapter_overview(
      data = saros.base::ex_survey,
      label_separator = " - "
    ) |>
    saros.base::draft_report(
      chapter_structure = _,
      data = saros.base::ex_survey,
      path = tmpdir,
      report_filename = "report"
    )

  output_files <-
    list.files(
      pattern = "\\.qmd$", path = tmpdir,
      full.names = TRUE, recursive = FALSE, ignore.case = TRUE
    )
  output_files <-
    gsub(x = output_files, pattern = "\\", replacement = "/", fixed = TRUE)
  testthat::expect_equal(
    object = length(output_files),
    expected = nrow(saros.base::ex_survey_ch_overview) + 2
  )
  testthat::expect_lt(file.size(output_files[1]), 3600)
  testthat::expect_gt(file.size(output_files[3]), 3350)

  # The `if (FALSE && ...)` render check that stood here from the first commit
  # (72d9487) has moved to test-generated_qmd_renders.R, where it actually
  # runs. Dead from July 2024, it meant nothing had ever rendered a generated
  # qmd -- which is how #119 stayed unreproduced for so long.


  ##############################

  tmpdir <- file.path(tempdir(), "test-draft_report2")
  saros.base::ex_survey_ch_overview |>
    saros.base::refine_chapter_overview(
      data = saros.base::ex_survey,
      label_separator = " - "
    ) |>
    saros.base::draft_report(
      chapter_structure = _,
      data = saros.base::ex_survey,
      combined_report = TRUE,
      report_filename = "report",
      path = tmpdir
    )

  output_files <-
    list.files(
      pattern = "\\.qmd", path = tmpdir,
      full.names = TRUE, recursive = TRUE, ignore.case = TRUE
    )
  testthat::expect_equal(
    object = length(output_files),
    expected = (nrow(saros.base::ex_survey_ch_overview) + 2)
  )
})

# The combined report that contains nothing (GH #119) ---------------------------

# `combined_report` defaults to TRUE and `report_includes_files` to FALSE, so
# out of the box `draft_report()` always writes a `report.qmd` and always
# leaves it with no chapters in it. It is not a render failure -- Quarto
# renders it happily, into an HTML document whose entire body is the title --
# which is exactly why it went unnoticed.
#
# Reported as a message, not a warning: the pairing that triggers it is the
# default one, so a warning would fire on essentially every call -- 55 times
# across this suite. The default itself is deliberately NOT changed: that
# would alter generated output for every existing caller. The silence is what
# is fixed.

draft_for_message <- function(path, ...) {
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(chapter = "Ch1", dep = "a_1", indep = ""),
      data = saros.base::ex_survey,
      label_separator = " - ",
      progress = FALSE
    )
  ))
  saros.base::draft_report(
    data = saros.base::ex_survey,
    chapter_structure = chapter_structure,
    path = path,
    ...
  )
}

testthat::test_that("a combined report with no includes reports that it will be empty", {
  path <- withr::local_tempdir()
  testthat::expect_message(
    draft_for_message(path),
    regexp = "report_includes_files"
  )
})

testthat::test_that("the empty combined report is still written, unchanged", {
  # The message must not become a refusal: the file is still produced, and
  # still produced empty. Pins that this change altered no output.
  path <- withr::local_tempdir()
  suppressMessages(draft_for_message(path))

  report <- readLines(fs::path(path, "report.qmd"), warn = FALSE)
  testthat::expect_true(fs::file_exists(fs::path(path, "report.qmd")))
  testthat::expect_false(any(grepl("{{< include", report, fixed = TRUE)))
})

testthat::test_that("nothing reported when the combined report will have content", {
  path <- withr::local_tempdir()
  testthat::expect_no_message(draft_for_message(path, report_includes_files = TRUE))
})

testthat::test_that("nothing reported when no combined report is requested", {
  # Nothing is empty if nothing is written, so the pairing that triggers the
  # message is specifically TRUE/FALSE and not `report_includes_files` alone.
  path <- withr::local_tempdir()
  testthat::expect_no_message(draft_for_message(path, combined_report = FALSE))
})

testthat::test_that("the message does not invent a filename when report_filename is NULL", {
  # `report_filename = NULL` is documented and validated as acceptable, and
  # gen_qmd_file() names the file from the title in that case. Pasting a
  # suffix onto it yields `".qmd"` -- a plausible-looking filename that is not
  # the one written -- so the message must describe the file instead.
  #
  # The call aborts further downstream on this input for reasons that predate
  # this message and are filed separately; the message is emitted before that,
  # so both are caught here.
  path <- withr::local_tempdir()
  msgs <- character()
  tryCatch(
    withCallingHandlers(
      draft_for_message(path, title = "My Report", report_filename = NULL),
      message = function(m) {
        msgs <<- c(msgs, conditionMessage(m))
        invokeRestart("muffleMessage")
      }
    ),
    error = function(e) NULL
  )

  hit <- grep("contain no chapters", msgs, value = TRUE)
  testthat::expect_length(hit, 1L)
  testthat::expect_no_match(hit, ".qmd", fixed = TRUE)
  testthat::expect_match(hit, "the combined report file", fixed = TRUE)
})
