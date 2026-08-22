# The chunk that establishes `parameters` in every generated chapter (GH #270).
#
# `parameters` is what variants 4 and 5 read `save` from -- four sites each,
# counted; variants 2 and 3 read only Quarto's `params`, so this is not a
# mesos-only concern. Until now it came only from an organization's
# `general_formatting.R`, sourced into the qmd by a start section the caller
# had to supply, so a chapter generated with no start section referenced a
# symbol nothing assigned.
#
# That did not stop variant 5 rendering: `save = parameters$save` is a promise
# R never forced, so it behaved as "do not save". The visible effect of fixing
# it is that `save` now carries a real value. Variant 4 still does not render
# standalone, before or after, and not because of `parameters` -- it dies in
# `saros::makeme()` on `mesos_var`/`mesos_group`, which come from Quarto's
# `params`.
#
# The chunk is emitted separately from the `library()` one rather than folded
# into it, because `chapter_setup_packages = NULL` is the documented escape
# hatch for a project needing neither `saros` nor `gt`, and suppressing the
# packages must not silently take `parameters` with it.
#
# The guard matters in both directions. `if (!exists("parameters", ...))` keeps
# this a floor rather than an override: a project whose `general_formatting.R`
# assigns `parameters` first -- in `report.qmd`, before the chapter includes --
# keeps its own value untouched, and one that sources it afterwards overwrites
# this unconditionally, as it always did.

parameters_chunk <- function(...) saros.base:::chapter_parameters_chunk(...)

# The R code inside the emitted chunk, with the fence and the knitr options
# stripped, so it can be run rather than merely matched against.
chunk_body <- function(chunk) {
  lines <- strsplit(chunk, "\n", fixed = TRUE)[[1]]
  paste(lines[!grepl("^```", lines) & !grepl("^#\\|", lines)], collapse = "\n")
}

# Run the emitted chunk in `dir` and hand back the environment it built.
run_chunk_in <- function(dir, preset = NULL) {
  env <- new.env(parent = globalenv())
  if (!is.null(preset)) assign("parameters", preset, envir = env)
  withr::with_dir(dir, eval(parse(text = chunk_body(parameters_chunk("1_Ch1"))), envir = env))
  env
}

project_dir <- function(params = NULL) {
  dir <- withr::local_tempdir(.local_envir = parent.frame())
  cat("project:\n  type: website\n", file = fs::path(dir, "_quarto.yml"))
  if (!is.null(params)) {
    yaml::write_yaml(list(params = params), file = fs::path(dir, "_metadata.yml"))
  }
  dir
}

draft_with <- function(path, ...) {
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(chapter = "Ch1", dep = "a_1", indep = ""),
      data = saros.base::ex_survey, label_separator = " - ", progress = FALSE
    )
  ))
  suppressMessages(saros.base::draft_report(
    data = saros.base::ex_survey, chapter_structure = chapter_structure,
    path = path, ...
  ))
  readLines(fs::path(path, "1_Ch1.qmd"), warn = FALSE)
}

################################################################################

testthat::test_that("the chunk reads the metadata chain and hides itself", {
  out <- parameters_chunk("1_Ch1")
  testthat::expect_match(out, "aggregate_metadata_yml", fixed = TRUE)
  testthat::expect_match(out, "#| include: false", fixed = TRUE)
  # A label distinct from the packages chunk's: knitr aborts on duplicates.
  testthat::expect_match(out, "Parameters for 1_Ch1", fixed = TRUE)
})

testthat::test_that("the chunk's code parses", {
  testthat::expect_no_error(parse(text = chunk_body(parameters_chunk("1_Ch1"))))
})

testthat::test_that("save falls back to TRUE when the chain sets nothing", {
  env <- run_chunk_in(project_dir())
  testthat::expect_true(env$parameters$save)
})

testthat::test_that("a save set in _metadata.yml survives, rather than being overwritten", {
  # This is finding 1 of #270, fixed on the package's side of the line. The
  # external file assigns `parameters$save <- TRUE` unconditionally *after*
  # aggregating, so `save` is the one key its own inheritance chain cannot
  # carry. Here the chain wins and the default is only a floor.
  env <- run_chunk_in(project_dir(params = list(save = FALSE)))
  testthat::expect_false(env$parameters$save)
})

testthat::test_that("other keys from the chain reach parameters", {
  env <- run_chunk_in(project_dir(params = list(mesos_group = "Oslo skole")))
  testthat::expect_identical(env$parameters$mesos_group, "Oslo skole")
})

testthat::test_that("a parameters established earlier is left alone", {
  # The floor, not an override: a project sourcing its general_formatting.R in
  # report.qmd before the chapter includes must keep its own object.
  env <- run_chunk_in(project_dir(params = list(save = FALSE)),
    preset = list(save = "untouched")
  )
  testthat::expect_identical(env$parameters$save, "untouched")
})

testthat::test_that("no _metadata.yml anywhere still yields a usable parameters", {
  # `aggregate_metadata_yml()` returns list(), so `[["params"]]` is NULL and
  # the floor has to build the object from nothing rather than erroring.
  dir <- withr::local_tempdir()
  env <- run_chunk_in(dir)
  testthat::expect_true(env$parameters$save)
})

################################################################################

testthat::test_that("draft_report() emits the parameters chunk by default", {
  path <- withr::local_tempdir()
  chapter <- draft_with(path)
  testthat::expect_true(any(grepl("aggregate_metadata_yml", chapter, fixed = TRUE)))
})

testthat::test_that("draft_report(chapter_setup_parameters=FALSE) emits none", {
  path <- withr::local_tempdir()
  chapter <- draft_with(path, chapter_setup_parameters = FALSE)
  testthat::expect_false(any(grepl("aggregate_metadata_yml", chapter, fixed = TRUE)))
  testthat::expect_false(any(grepl("Parameters for", chapter, fixed = TRUE)))
  # The rest of the chapter is unaffected.
  testthat::expect_true(any(grepl("library(saros)", chapter, fixed = TRUE)))
})

testthat::test_that("suppressing the packages chunk does not suppress parameters", {
  # The reason these are two chunks rather than one.
  path <- withr::local_tempdir()
  chapter <- draft_with(path, chapter_setup_packages = NULL)
  testthat::expect_false(any(grepl("library(", chapter, fixed = TRUE)))
  testthat::expect_true(any(grepl("aggregate_metadata_yml", chapter, fixed = TRUE)))
})

testthat::test_that("an invalid chapter_setup_parameters is rejected", {
  path <- withr::local_tempdir()
  testthat::expect_warning(
    draft_with(path, chapter_setup_parameters = "yes"),
    regexp = "chapter_setup_parameters"
  )
})

testthat::test_that("parameters is assigned before any template reads it", {
  # The end-to-end property the per-template allowlist in
  # test-generated_code_parses.R cannot express: that check asks whether a
  # template assigns what it subscripts, and no template assigns `parameters`
  # -- the chapter does, above them all. Variant 5 is the fixture because its
  # templates read `parameters$save` and it needs no mesos `params`.
  path <- withr::local_tempdir()
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(chapter = "Ch1", dep = "a_1, a_2", indep = "x1_sex"),
      data = saros.base::ex_survey, label_separator = " - ", progress = FALSE,
      chunk_templates = saros.base::get_chunk_template_defaults(5)
    )
  ))
  suppressMessages(suppressWarnings(saros.base::draft_report(
    data = saros.base::ex_survey, chapter_structure = chapter_structure, path = path
  )))
  chapter <- readLines(fs::path(path, "1_Ch1.qmd"), warn = FALSE)

  assigned <- grep("parameters <-", chapter, fixed = TRUE)
  used <- grep("parameters$", chapter, fixed = TRUE)
  used <- setdiff(used, assigned)

  # Positive control: variant 5 must actually read `parameters$`, or the
  # ordering assertion below is satisfied by an empty set.
  testthat::expect_gt(length(used), 0)
  testthat::expect_length(assigned, 1)
  testthat::expect_lt(assigned, min(used))
})
