# The `_metadata.yml` inheritance chain, read back by the package that writes
# it (GH #270).
#
# Until now `saros.base` emitted these files -- `setup_mesos.R:192` and `:342`
# -- while the only function able to read them, `aggregate_metadata_yml()`,
# lived in an organization's `general_formatting.R` outside any repository.
# Writer and reader could therefore disagree without anything catching it, and
# they did: see "an empty _metadata.yml contributes nothing" below.
#
# Two deliberate differences from the external original, both recorded in
# NEWS.md:
#
#   * The walk is bounded by the Quarto project root rather than by the first
#     ancestor lacking a `_metadata.yml`. The original broke at the first gap,
#     so a project-level `_metadata.yml` was unreachable whenever an
#     intermediate folder had none.
#   * It takes a `path` rather than calling `knitr::current_input()`. `knitr`
#     is in neither `Imports` nor `Suggests` here, and a function that only
#     works inside a knit cannot be tested at all.

# Write `contents` as `file` in `dir`, creating `dir`. `NULL` writes an empty
# file -- the shape `write_subfolder_metadata()` produces.
write_meta <- function(dir, contents = NULL, file = "_metadata.yml") {
  fs::dir_create(dir)
  if (is.null(contents)) {
    cat(file = fs::path(dir, file), append = TRUE)
  } else {
    yaml::write_yaml(contents, file = fs::path(dir, file))
  }
  invisible(dir)
}

mark_project_root <- function(dir, file = "_quarto.yml") {
  fs::dir_create(dir)
  cat("project:\n  type: website\n", file = fs::path(dir, file))
  invisible(dir)
}

################################################################################

testthat::test_that("a deeper folder overrides a shallower one", {
  root <- withr::local_tempdir()
  mark_project_root(root)
  write_meta(root, list(params = list(save = TRUE, wave = "2025")))
  write_meta(fs::path(root, "Skole"), list(params = list(wave = "2026")))

  out <- saros.base::aggregate_metadata_yml(fs::path(root, "Skole"))

  # The deeper value wins, and the shallower key it does not mention survives.
  testthat::expect_identical(out$params$wave, "2026")
  testthat::expect_true(out$params$save)
})

testthat::test_that("a _metadata.yml above the project root is not merged", {
  outer <- withr::local_tempdir()
  write_meta(outer, list(params = list(leaked = TRUE)))

  root <- fs::path(outer, "project")
  mark_project_root(root)
  write_meta(root, list(params = list(wave = "2026")))

  out <- saros.base::aggregate_metadata_yml(root)

  testthat::expect_identical(out$params$wave, "2026")
  testthat::expect_null(out$params$leaked)
})

testthat::test_that("the project root is found under either Quarto spelling", {
  # The spelling that matters: the one real saros project available while this
  # was written uses `_quarto.yaml`. A marker check matching only `_quarto.yml`
  # finds no root, falls back to the starting directory, and silently reduces
  # every chain to one folder -- which looks exactly like a project that
  # inherits nothing.
  for (spelling in c("_quarto.yml", "_quarto.yaml")) {
    outer <- withr::local_tempdir()
    write_meta(outer, list(params = list(leaked = TRUE)))

    root <- fs::path(outer, "project")
    mark_project_root(root, file = spelling)
    write_meta(root, list(params = list(wave = "2026")))
    write_meta(fs::path(root, "Skole"), list(params = list(group = "Oslo")))

    out <- saros.base::aggregate_metadata_yml(fs::path(root, "Skole"))

    testthat::expect_identical(out$params$wave, "2026", info = spelling)
    testthat::expect_identical(out$params$group, "Oslo", info = spelling)
    testthat::expect_null(out$params$leaked)
  }
})

testthat::test_that("a folder without _metadata.yml does not stop the walk", {
  # The behaviour change. The external original walked up only while
  # `_metadata.yml` existed and broke at the first gap, so `Rapport/` here
  # would hide the project-level file from every chapter beneath it.
  root <- withr::local_tempdir()
  mark_project_root(root)
  write_meta(root, list(params = list(wave = "2026")))
  fs::dir_create(fs::path(root, "Rapport")) # the gap: no _metadata.yml
  write_meta(fs::path(root, "Rapport", "Skole"), list(params = list(group = "Oslo")))

  out <- saros.base::aggregate_metadata_yml(fs::path(root, "Rapport", "Skole"))

  testthat::expect_identical(out$params$wave, "2026")
  testthat::expect_identical(out$params$group, "Oslo")
})

testthat::test_that("an empty _metadata.yml contributes nothing rather than aborting", {
  # The writer/reader disagreement #270 exists to end, reproduced against this
  # package's own output rather than a hand-built fixture.
  #
  # `write_subfolder_metadata()` writes a zero-byte `_metadata.yml` at every
  # intermediate level of `setup_mesos_structure(mesos_var_subfolder = )`.
  # `yaml::read_yaml()` returns NULL for those, and `utils::modifyList(x, NULL)`
  # errors with "is.list(val) is not TRUE" -- so the external reader aborted
  # partway up, before ever reaching the group's own file. The group's
  # `mesos_group` was therefore never merged either, which is the parameter the
  # mesos templates exist to use.
  root <- withr::local_tempdir()
  mark_project_root(root)

  fs::dir_create(fs::path(root, "Skole", "reports", "Q1", "oslo"))
  saros.base:::write_mesos_var_metadata(root, "Skole", "Skolen")
  saros.base:::write_subfolder_metadata(root, "Skole", c("reports", "Q1"))
  saros.base:::write_group_metadata(saros.base:::create_metadata_yml(
    main_directory = root,
    mesos_var = "Skole",
    mesos_var_pretty = "Skolen",
    mesos_var_subfolder = c("reports", "Q1"),
    mesos_groups_pretty = "Oslo skole",
    mesos_groups_abbr = "oslo"
  ))

  # Positive control on the fixture: the zero-byte files the bug turns on must
  # actually be there, or this test passes for the wrong reason.
  testthat::expect_identical(
    file.size(fs::path(root, "Skole", "reports", "_metadata.yml")), 0
  )

  out <- saros.base::aggregate_metadata_yml(
    fs::path(root, "Skole", "reports", "Q1", "oslo")
  )

  testthat::expect_identical(out$params$mesos_var, "Skole")
  testthat::expect_identical(out$params$mesos_var_pretty, "Skolen")
  testthat::expect_identical(out$params$mesos_group, "Oslo skole")
})

testthat::test_that("a _metadata.yaml is read alongside _metadata.yml", {
  root <- withr::local_tempdir()
  mark_project_root(root)
  write_meta(root, list(params = list(wave = "2026")), file = "_metadata.yaml")

  out <- saros.base::aggregate_metadata_yml(root)

  testthat::expect_identical(out$params$wave, "2026")
})

testthat::test_that("_metadata.yaml wins over _metadata.yml in the same folder", {
  # Not a recommendation, just a pinned order: one folder holding both is a
  # mistake, and an arbitrary-but-documented winner beats a silently
  # filesystem-order-dependent one.
  root <- withr::local_tempdir()
  mark_project_root(root)
  write_meta(root, list(params = list(wave = "yml")), file = "_metadata.yml")
  write_meta(root, list(params = list(wave = "yaml")), file = "_metadata.yaml")

  out <- saros.base::aggregate_metadata_yml(root)

  testthat::expect_identical(out$params$wave, "yaml")
})

testthat::test_that("with no Quarto project root, only the starting folder is read", {
  outer <- withr::local_tempdir()
  write_meta(outer, list(params = list(leaked = TRUE)))
  write_meta(fs::path(outer, "Skole"), list(params = list(group = "Oslo")))

  out <- saros.base::aggregate_metadata_yml(fs::path(outer, "Skole"))

  testthat::expect_identical(out$params$group, "Oslo")
  testthat::expect_null(out$params$leaked)
})

testthat::test_that("no metadata files anywhere gives an empty list", {
  root <- withr::local_tempdir()
  mark_project_root(root)

  out <- saros.base::aggregate_metadata_yml(root)

  testthat::expect_identical(out, list())
  # And the shape the generated setup chunk relies on: `[["params"]]` on the
  # result must be NULL rather than an error, so `parameters$save <- TRUE`
  # still builds a usable list from nothing.
  testthat::expect_null(out[["params"]])
})

testthat::test_that("a directory that does not exist is an error, not a silent empty chain", {
  root <- withr::local_tempdir()
  msg <- tryCatch(
    saros.base::aggregate_metadata_yml(fs::path(root, "no_such_folder")),
    error = function(e) conditionMessage(e)
  )
  # Whitespace is stripped before matching: `cli` wraps at the console width,
  # and a tempdir path is long enough to be broken across lines, which would
  # make a plain `expect_error(regexp = )` fail for reasons unrelated to the
  # behaviour being pinned.
  testthat::expect_match(gsub("[[:space:]]", "", msg), "no_such_folder")
})
