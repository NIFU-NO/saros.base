# Does the .qmd that draft_report() writes actually render? (GH #119)
#
# Nothing in this package had ever answered that. The only `quarto_render()`
# call in the suite, in test-draft_report.R, was guarded by `if (FALSE && ...)`
# from the very first commit (72d9487, July 2024) -- so the entire render path
# was untested for the whole life of the package, and #119 ("report.qmd setup
# seems unstable/not working") was filed four months into that gap.
#
# What the gap hid: the five default chunk template variants call `saros` and
# `gt` functions unqualified -- makeme(), make_link(), n_range(), girafe(),
# ggsaver, fig_height_h_barchart(), get_fig_title_suffix_from_ggplot(), gt() --
# and nothing attached either package. Not the generated qmd, not saros.base,
# not the project templates in inst/. The first failure was in a *chunk header*
# (`fig.height=fig_height_h_barchart(...)`), which knitr evaluates before the
# chunk body, so a chapter died before running a line of its own code.
#
# These tests are necessarily heavy: they shell out to Quarto, which executes R
# that calls saros and gt. All three are optional here, so every guard below is
# required -- and they mean the file contributes nothing on CRAN, which is the
# point rather than a defect.

skip_unless_renderable <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not_installed("quarto")
  testthat::skip_if_not_installed("saros")
  testthat::skip_if_not_installed("gt")
  path <- tryCatch(quarto::quarto_path(), error = function(e) NULL)
  testthat::skip_if(is.null(path) || !nzchar(path), "Quarto CLI not found")
}

# One chapter, one bivariate battery: enough to reach a plot template, the
# `fig.height=` chunk header and a `make_link()`/`ggsaver` call, without paying
# for the whole example report on every run.
draft_minimal <- function(path, ...) {
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(
        chapter = "Ch1", dep = "a_1, a_2", indep = "x1_sex"
      ),
      data = saros.base::ex_survey,
      label_separator = " - ",
      progress = FALSE
    )
  ))
  suppressMessages(suppressWarnings(saros.base::draft_report(
    data = saros.base::ex_survey,
    chapter_structure = chapter_structure,
    path = path,
    ...
  )))
  path
}

################################################################################

testthat::test_that("a generated chapter renders with no setup section supplied", {
  # The whole point of #119. `chapter_qmd_start_section_filepath` is NOT passed:
  # a caller who supplies nothing must still get a chapter that renders, which
  # is what qualifying the template calls and emitting the library() preamble
  # buy. Before that, this died with
  # `could not find function "fig_height_h_barchart"`.
  skip_unless_renderable()

  path <- withr::local_tempdir()
  draft_minimal(path)
  chapter <- fs::path(path, "1_Ch1.qmd")
  testthat::expect_true(fs::file_exists(chapter))

  testthat::expect_no_error(
    withr::with_dir(path, quarto::quarto_render(
      input = "1_Ch1.qmd", quiet = TRUE
    ))
  )
  testthat::expect_true(fs::file_exists(fs::path(path, "1_Ch1.html")))
})

testthat::test_that("the rendered chapter contains the section heading and a figure", {
  # A positive control. `quarto_render()` succeeding proves the file parsed;
  # it does not prove any chunk produced output, and a chapter whose templates
  # silently emitted nothing would pass the test above.
  skip_unless_renderable()

  path <- withr::local_tempdir()
  draft_minimal(path)
  withr::with_dir(path, quarto::quarto_render(input = "1_Ch1.qmd", quiet = TRUE))

  html <- paste(readLines(fs::path(path, "1_Ch1.html"), warn = FALSE), collapse = "\n")
  testthat::expect_match(html, "Ch1", fixed = TRUE)
  # Every plot template ends in a figure div carrying the chunk anchor.
  testthat::expect_match(html, "fig-", fixed = TRUE)
})

testthat::test_that("report.qmd gains the chapter includes when asked for them", {
  # Not a render test -- no Quarto needed -- but it belongs with the others:
  # it is the other half of what "the report.qmd setup does not work" turned
  # out to mean. See the warning test in test-draft_report.R for the default.
  path <- withr::local_tempdir()
  draft_minimal(path, report_includes_files = TRUE)

  report <- readLines(fs::path(path, "report.qmd"), warn = FALSE)
  testthat::expect_true(any(grepl("{{< include", report, fixed = TRUE)))
  testthat::expect_true(any(grepl("1_Ch1.qmd", report, fixed = TRUE)))
})
