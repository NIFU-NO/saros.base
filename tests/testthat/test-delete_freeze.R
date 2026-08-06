# Regression tests for GH #220.
#
# max() over an empty _freeze entry warned "no non-missing arguments to max;
# returning -Inf". The deletion itself was correct -- an empty cache entry is
# stale -- only the warning was wrong, and delete_freeze() is typically called
# over a whole project, so it was noisy.
#
# `:::` is used deliberately: delete_freeze() is not exported on main (see
# GH #219, fixed separately), and this keeps the branch mergeable in any order.

# Minimal Quarto-ish project: a chapter and its freeze entry.
local_freeze_project <- function(envir = parent.frame()) {
  path <- withr::local_tempdir(.local_envir = envir)
  fs::dir_create(fs::path(path, "_freeze", "ch1"))
  writeLines("chapter", fs::path(path, "ch1.qmd"))
  path
}

################################################################################
testthat::test_that("an empty freeze entry is deleted without warning", {
  path <- local_freeze_project()

  testthat::expect_no_warning(deleted <- saros.base:::delete_freeze(path = path))
  testthat::expect_length(deleted, 1)
  testthat::expect_false(fs::dir_exists(fs::path(path, "_freeze", "ch1")))
})

testthat::test_that("a freeze entry newer than its qmd is kept", {
  path <- local_freeze_project()
  writeLines("cached", fs::path(path, "_freeze", "ch1", "html.json"))
  # Ensure the cache is unambiguously newer than the source.
  fs::file_touch(fs::path(path, "_freeze", "ch1", "html.json"),
    modification_time = Sys.time() + 60
  )

  testthat::expect_no_warning(deleted <- saros.base:::delete_freeze(path = path))
  testthat::expect_length(deleted, 0)
  testthat::expect_true(fs::dir_exists(fs::path(path, "_freeze", "ch1")))
})

testthat::test_that("a freeze entry older than its qmd is deleted", {
  path <- local_freeze_project()
  cached <- fs::path(path, "_freeze", "ch1", "html.json")
  writeLines("cached", cached)
  fs::file_touch(cached, modification_time = Sys.time() - 3600)

  deleted <- saros.base:::delete_freeze(path = path)
  testthat::expect_length(deleted, 1)
  testthat::expect_false(fs::dir_exists(fs::path(path, "_freeze", "ch1")))
})

testthat::test_that("qmd discovery ignores files cached inside _freeze", {
  path <- local_freeze_project()
  # Quarto writes copies of sources under _freeze; these are not sources.
  fs::dir_create(fs::path(path, "_freeze", "ch1", "nested"))
  writeLines("cached copy", fs::path(path, "_freeze", "ch1", "nested", "ch1.qmd"))

  # If that cached copy were treated as a source, its derived freeze entry
  # would be _freeze/_freeze/ch1/nested/ch1 -- empty, therefore judged stale,
  # therefore deleted. Create it, so the test can tell the difference rather
  # than passing merely because the derived path happens not to exist.
  decoy <- fs::path(path, "_freeze", "_freeze", "ch1", "nested", "ch1")
  fs::dir_create(decoy)

  testthat::expect_no_warning(deleted <- saros.base:::delete_freeze(path = path))

  testthat::expect_true(fs::dir_exists(decoy))
  testthat::expect_false(decoy %in% deleted)
})

testthat::test_that("a missing _freeze directory is reported, not an error", {
  path <- withr::local_tempdir()
  writeLines("chapter", fs::path(path, "ch1.qmd"))

  testthat::expect_message(
    deleted <- saros.base:::delete_freeze(path = path),
    regexp = "No"
  )
  testthat::expect_length(deleted, 0)
})
