# Regression tests for GH #208 / #184.
#
# `process_yaml()` only assigned `title` on the branch where a `yaml_file` was
# supplied, so `draft_report(title = )` was a silent no-op; and
# `gen_qmd_chapters()` passed `title = NULL`, so chapter files carried no YAML
# title at all. Projects worked around both by regex-copying the first body
# heading into the header, which is what truncated titles at hyphens.

# Small fixture: two items sharing a main question, plus a grouping variable.
local_title_fixture <- function(chapter = "Chapter One") {
  set.seed(1)
  n <- 100
  d <- data.frame(
    a = factor(sample(c("Ja", "Nei"), n, TRUE), levels = c("Ja", "Nei")),
    b = factor(sample(c("Ja", "Nei"), n, TRUE), levels = c("Ja", "Nei")),
    g = factor(sample(c("X", "Y"), n, TRUE))
  )
  attr(d$a, "label") <- "Question A - first item"
  attr(d$b, "label") <- "Question A - second item"
  attr(d$g, "label") <- "Group"

  cs <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(chapter = chapter, dep = "a, b", indep = "g"),
      data = d,
      progress = FALSE
    )
  ))
  list(data = d, chapter_structure = cs)
}

################################################################################
testthat::test_that("process_yaml() includes the title when no yaml_file is given", {
  out <- saros.base:::process_yaml(yaml_file = NULL, title = "My Report Title")
  testthat::expect_match(out, "title: My Report Title", fixed = TRUE)
})

testthat::test_that("process_yaml() omits the title key entirely when title is NULL", {
  # Must not surface as `title: ~`, which is what a retained NULL would render as.
  out <- saros.base:::process_yaml(yaml_file = NULL, title = NULL)
  testthat::expect_false(grepl("title:", out, fixed = TRUE))
})

testthat::test_that("process_yaml() still sets the title when a yaml_file is given", {
  yaml_file <- withr::local_tempfile(fileext = ".yml")
  yaml::write_yaml(list(format = list(html = list(toc = TRUE))), yaml_file)

  out <- saros.base:::process_yaml(yaml_file = yaml_file, title = "From File")
  testthat::expect_match(out, "title: From File", fixed = TRUE)
})

################################################################################
testthat::test_that("draft_report() writes its title into index.qmd and report.qmd", {
  tmpdir <- withr::local_tempdir()
  fixture <- local_title_fixture()

  suppressMessages(saros.base::draft_report(
    chapter_structure = fixture$chapter_structure,
    data = fixture$data,
    path = tmpdir,
    title = "THE REPORT TITLE"
  ))

  for (file in c("index.qmd", "report.qmd")) {
    contents <- paste(readLines(file.path(tmpdir, file), warn = FALSE), collapse = "\n")
    testthat::expect_match(contents, "title: THE REPORT TITLE", fixed = TRUE)
  }
})

testthat::test_that("chapter qmd files get a YAML title, with hyphens preserved", {
  # "Etter- og videreutdanning" is the reported case: the hyphen must survive
  # into the YAML header, and the title must be present without post-processing.
  chapter <- "Etter- og videreutdanning"
  tmpdir <- withr::local_tempdir()
  fixture <- local_title_fixture(chapter = chapter)

  suppressMessages(saros.base::draft_report(
    chapter_structure = fixture$chapter_structure,
    data = fixture$data,
    path = tmpdir
  ))

  chapter_files <- setdiff(
    list.files(tmpdir, pattern = "\\.qmd$"),
    c("index.qmd", "report.qmd")
  )
  testthat::expect_length(chapter_files, 1)

  contents <- paste(
    readLines(file.path(tmpdir, chapter_files[1]), warn = FALSE),
    collapse = "\n"
  )
  testthat::expect_match(contents, paste0("title: ", chapter), fixed = TRUE)
})

################################################################################
testthat::test_that("mesos group _metadata.yml gets a title, as documented", {
  # ?setup_mesos states subtitle_separator "will add title and subtitle fields
  # to the _metadata.yml-files in the deepest child folders. The title is the
  # mesos_group." The title assignment was commented out.
  main <- withr::local_tempdir()
  writeLines("chapter", file.path(main, "_1_chapter.qmd"))

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = file.path(main, "_1_chapter.qmd"),
    mesos_groups = list(Laerested = c("HINN", "UiO"))
  ))

  for (group in c("HINN", "UiO")) {
    metadata <- yaml::read_yaml(file.path(main, "Laerested", group, "_metadata.yml"))
    testthat::expect_equal(metadata$title, group)
    testthat::expect_true(nzchar(metadata$subtitle))
  }
})

testthat::test_that("mesos _metadata.yml omits title when subtitle_separator is NULL", {
  main <- withr::local_tempdir()
  writeLines("chapter", file.path(main, "_1_chapter.qmd"))

  suppressMessages(saros.base::setup_mesos_structure(
    main_directory = main,
    files_to_process = file.path(main, "_1_chapter.qmd"),
    mesos_groups = list(Laerested = "HINN"),
    subtitle_separator = NULL
  ))

  metadata <- yaml::read_yaml(file.path(main, "Laerested", "HINN", "_metadata.yml"))
  testthat::expect_null(metadata$title)
  testthat::expect_null(metadata$subtitle)
})
