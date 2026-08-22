# The `_metadata.yml` files written at intermediate `mesos_var_subfolder`
# levels (GH #272).
#
# `write_subfolder_metadata()` used to create these with
# `cat(file = f, append = TRUE)`, i.e. **zero bytes**. Quarto rejects a
# zero-byte `_metadata.yml` at project level -- "Directory metadata validation
# failed ... YAML value is missing" -- so **any** report using
# `setup_mesos_structure(mesos_var_subfolder = )` failed to render before a
# line of R ran. Nothing caught it because the only coverage asserted the files
# existed, never that Quarto would accept them.
#
# What Quarto actually accepts, measured rather than assumed:
#
#   no file at all       accepted
#   zero bytes           REJECTED
#   "{}"                 accepted
#   "[]"                 REJECTED   <- what yaml::write_yaml(list(), f) emits
#   a comment alone      REJECTED
#
# The `[]` row is why this writes a literal `{}` rather than going through
# `yaml::write_yaml()`: the obvious implementation still fails.

subfolder_metadata_paths <- function(root, mesos_var = "Skole") {
  fs::path(root, mesos_var, c("reports", fs::path("reports", "Q1")), "_metadata.yml")
}

write_subfolders <- function(root, mesos_var = "Skole", levels = c("reports", "Q1")) {
  fs::dir_create(fs::path(root, mesos_var, fs::path_join(levels)))
  saros.base:::write_subfolder_metadata(root, mesos_var, levels)
  invisible(root)
}

################################################################################

testthat::test_that("an intermediate _metadata.yml is a valid empty mapping, not an empty file", {
  root <- withr::local_tempdir()
  write_subfolders(root)

  for (f in subfolder_metadata_paths(root)) {
    testthat::expect_true(fs::file_exists(f))
    # The whole defect in one assertion: zero bytes is what Quarto refuses.
    testthat::expect_gt(file.size(f), 0)

    parsed <- yaml::yaml.load(paste(readLines(f, warn = FALSE), collapse = "\n"))
    # A mapping, so `utils::modifyList()` accepts it, and empty, so it
    # contributes nothing to the chain.
    testthat::expect_true(is.list(parsed))
    testthat::expect_length(parsed, 0)
  }
})

testthat::test_that("the file is not a YAML sequence", {
  # `yaml::write_yaml(list(), f)` emits `[]`, which parses as a list of length
  # zero and would satisfy the test above while still being rejected by Quarto.
  # The distinction is invisible to R and fatal to the render, so it is pinned
  # on the text.
  root <- withr::local_tempdir()
  write_subfolders(root)

  contents <- paste(readLines(subfolder_metadata_paths(root)[1], warn = FALSE), collapse = "\n")
  testthat::expect_match(contents, "{}", fixed = TRUE)
  testthat::expect_no_match(contents, "[]", fixed = TRUE)
})

testthat::test_that("existing content at an intermediate level is left alone", {
  # The old writer used `append = TRUE`, so it never clobbered a file a project
  # had filled in. That has to survive the fix.
  root <- withr::local_tempdir()
  fs::dir_create(fs::path(root, "Skole", "reports", "Q1"))
  kept <- fs::path(root, "Skole", "reports", "_metadata.yml")
  yaml::write_yaml(list(params = list(wave = "2026")), file = kept)

  saros.base:::write_subfolder_metadata(root, "Skole", c("reports", "Q1"))

  testthat::expect_identical(
    yaml::read_yaml(kept)$params$wave, "2026"
  )
})

testthat::test_that("a zero-byte file left by an earlier version is healed", {
  # Projects on disk are full of these already. Re-running setup_mesos() should
  # repair them rather than leave the project unrenderable.
  root <- withr::local_tempdir()
  fs::dir_create(fs::path(root, "Skole", "reports", "Q1"))
  stale <- fs::path(root, "Skole", "reports", "_metadata.yml")
  cat(file = stale)
  testthat::expect_identical(file.size(stale), 0)

  saros.base:::write_subfolder_metadata(root, "Skole", c("reports", "Q1"))

  testthat::expect_gt(file.size(stale), 0)
})

testthat::test_that("the placeholder contributes nothing to the inheritance chain", {
  root <- withr::local_tempdir()
  cat("project:\n  type: website\n", file = fs::path(root, "_quarto.yml"))
  write_subfolders(root)
  yaml::write_yaml(
    list(params = list(mesos_var = "Skole")),
    file = fs::path(root, "Skole", "_metadata.yml")
  )
  fs::dir_create(fs::path(root, "Skole", "reports", "Q1", "oslo"))
  yaml::write_yaml(
    list(params = list(mesos_group = "Oslo")),
    file = fs::path(root, "Skole", "reports", "Q1", "oslo", "_metadata.yml")
  )

  params <- saros.base::aggregate_metadata_yml(
    fs::path(root, "Skole", "reports", "Q1", "oslo")
  )[["params"]]

  testthat::expect_identical(params$mesos_var, "Skole")
  testthat::expect_identical(params$mesos_group, "Oslo")
})

################################################################################

testthat::test_that("Quarto renders a project carrying the intermediate files", {
  # The guard #272 asks for: a render, not a file-existence check. Every
  # previous test in this file would have passed against a writer that emitted
  # something Quarto refuses.
  #
  # Needs only Quarto -- not `saros` or `gt` -- because the failure is Quarto
  # rejecting the project's directory metadata before any R runs. That makes it
  # far cheaper than the render tests in test-generated_qmd_renders.R.
  testthat::skip_on_cran()
  testthat::skip_if_not_installed("quarto")
  quarto_bin <- tryCatch(quarto::quarto_path(), error = function(e) NULL)
  testthat::skip_if(is.null(quarto_bin) || !nzchar(quarto_bin), "Quarto CLI not found")

  root <- withr::local_tempdir()
  cat("project:\n  type: website\n", file = fs::path(root, "_quarto.yml"))
  cat("---\ntitle: index\n---\n", file = fs::path(root, "index.qmd"))
  write_subfolders(root)
  cat("---\ntitle: ch\n---\n\nText.\n",
    file = fs::path(root, "Skole", "reports", "Q1", "ch.qmd")
  )

  # Positive control on the fixture: the files this test exists to vet must
  # actually be present, or the render below proves nothing.
  testthat::expect_true(all(fs::file_exists(subfolder_metadata_paths(root))))

  testthat::expect_no_error(
    withr::with_dir(root, quarto::quarto_render(
      input = fs::path("Skole", "reports", "Q1", "ch.qmd"), quiet = TRUE
    ))
  )
})
