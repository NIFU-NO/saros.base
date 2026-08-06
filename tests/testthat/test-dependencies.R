# Helpers -------------------------------------------------------------------

# Parsed dependency field from the package DESCRIPTION, without version
# constraints. Returns character(0) if the field is absent.
description_deps <- function(field) {
  desc_path <- test_path("..", "..", "DESCRIPTION")
  skip_if_not(file.exists(desc_path), "source tree not available (installed package)")

  desc <- read.dcf(desc_path)
  if (!field %in% colnames(desc) || is.na(desc[, field])) {
    return(character())
  }
  trimws(gsub("\\(.*?\\)", "", strsplit(desc[, field], ",")[[1]]))
}

# Tests ---------------------------------------------------------------------

test_that("tibble is declared in Imports, because .onLoad() uses it", {
  # Guards GH #215: `.onLoad()` builds the default chunk templates with
  # `tibble::add_row()`. A package whose `.onLoad()` errors cannot be attached
  # at all, so this dependency must be hard, not suggested.
  skip_on_cran()
  expect_true("tibble" %in% description_deps("Imports"))
})

test_that("Suggests-only packages are used conditionally in R/", {
  # R-exts: "Packages in Suggests should be used conditionally." A file is
  # compliant if it calls rlang::check_installed() before reaching for one.
  skip_on_cran()

  r_dir <- test_path("..", "..", "R")
  skip_if_not(dir.exists(r_dir), "source tree not available (installed package)")

  suggests_only <- setdiff(description_deps("Suggests"), description_deps("Imports"))
  skip_if(length(suggests_only) == 0, "no Suggests-only packages declared")

  offenders <- character()
  for (file in list.files(r_dir, pattern = "[.][Rr]$", full.names = TRUE)) {
    src <- readLines(file, warn = FALSE)
    src <- src[!grepl("^\\s*#", src)] # roxygen and ordinary comments
    src <- gsub("\\{\\.[a-z_]+ [^}]*\\}", "", src) # cli inline markup, e.g. {.fun pkg::f}

    used <- unique(unlist(regmatches(
      src,
      gregexpr("[A-Za-z][A-Za-z0-9._]*(?=::)", src, perl = TRUE)
    )))
    unguarded <- intersect(used, suggests_only)

    if (length(unguarded) > 0 && !any(grepl("check_installed", src, fixed = TRUE))) {
      offenders <- c(
        offenders,
        paste0(basename(file), ": ", paste(unguarded, collapse = ", "))
      )
    }
  }

  expect_equal(offenders, character(0))
})
