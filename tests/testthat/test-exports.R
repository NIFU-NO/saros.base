# Regression test for GH #219.
#
# delete_freeze() was documented with @export and had a generated
# man/delete_freeze.Rd, but NAMESPACE was never regenerated, so
# saros.base::delete_freeze() errored with "not an exported object". The
# roxygen block and the .Rd were both correct; only NAMESPACE had drifted.

# Names of functions carrying a roxygen @export tag in R/.
roxygen_exported_names <- function(r_dir) {
  names <- character()

  for (file in list.files(r_dir, pattern = "[.][Rr]$", full.names = TRUE)) {
    src <- readLines(file, warn = FALSE)
    is_roxygen <- grepl("^\\s*#'", src)

    for (i in which(grepl("^\\s*#'\\s*@export\\s*$", src))) {
      # Walk forward past the rest of the roxygen block and any blank lines,
      # then take the name from the first assignment encountered.
      j <- i + 1
      while (j <= length(src) && (is_roxygen[j] || !nzchar(trimws(src[j])))) {
        j <- j + 1
      }
      if (j > length(src)) next

      match <- regmatches(src[j], regexec("^\\s*([A-Za-z._][A-Za-z0-9._]*)\\s*<-", src[j]))[[1]]
      if (length(match) == 2) names <- c(names, match[2])
    }
  }

  unique(names)
}

test_that("every function tagged @export is actually exported", {
  skip_on_cran()

  # An *installed* package also has an R/ directory, but it holds saros.base.rdb
  # rather than sources -- so presence of the directory is not enough.
  r_dir <- test_path("..", "..", "R")
  skip_if(
    length(list.files(r_dir, pattern = "[.][Rr]$")) == 0,
    "no R/ sources available (running against an installed package)"
  )

  tagged <- roxygen_exported_names(r_dir)
  expect_gt(length(tagged), 0)

  missing <- setdiff(tagged, getNamespaceExports("saros.base"))
  expect_equal(missing, character(0))
})

test_that("delete_freeze() is reachable as saros.base::delete_freeze", {
  expect_true("delete_freeze" %in% getNamespaceExports("saros.base"))
  expect_true(is.function(saros.base::delete_freeze))
})

test_that("every pkgdown reference topic resolves to a documented object", {
  # _pkgdown.yml listed delete_freeze while NAMESPACE did not. pkgdown indexes
  # .Rd topics rather than exports, so it stayed green -- this checks the
  # stricter property that the topic is both documented and exported.
  skip_on_cran()

  pkgdown_yml <- test_path("..", "..", "_pkgdown.yml")
  man_dir <- test_path("..", "..", "man")
  skip_if_not(file.exists(pkgdown_yml) && dir.exists(man_dir), "source tree not available")

  config <- yaml::read_yaml(pkgdown_yml)
  listed <- unlist(lapply(config$reference, function(section) section$contents))
  # Ignore selector expressions such as starts_with("ex_survey") or matches(...);
  # these are resolved by pkgdown, and may legitimately cover datasets.
  listed <- listed[!grepl("[(]", listed)]
  expect_gt(length(listed), 0)

  documented <- sub("[.]Rd$", "", list.files(man_dir, pattern = "[.]Rd$"))
  expect_equal(setdiff(listed, documented), character(0))

  # The stricter half: a topic named literally in _pkgdown.yml should be
  # reachable by users. This is what pkgdown itself does not check -- it
  # indexes .Rd topics, so an unexported function stays green there.
  expect_equal(setdiff(listed, getNamespaceExports("saros.base")), character(0))
})
