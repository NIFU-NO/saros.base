# Regression test for GH #217.
#
# create_text_collapse() read `formals(draft_report)$translations`, but
# draft_report() has no `translations` argument. eval(NULL)$last_sep is NULL, so
# cli::ansi_collapse() silently dropped the final separator -- c("a","b","c")
# collapsed to "a, bc" instead of erroring. The function has been removed; this
# test stops the pattern from coming back anywhere else.

test_that("every formals(fn)$name reference in R/ names a real argument", {
  skip_on_cran()

  r_dir <- test_path("..", "..", "R")
  # An *installed* package also has an R/ directory, but it holds saros.base.rdb
  # rather than sources -- so presence of the directory is not enough, and
  # scanning it would otherwise pass vacuously.
  skip_if(
    length(list.files(r_dir, pattern = "[.][Rr]$")) == 0,
    "no R/ sources available (running against an installed package)"
  )

  pattern <- "formals\\(\\s*([A-Za-z._][A-Za-z0-9._]*)\\s*\\)\\$([A-Za-z._][A-Za-z0-9._]*)"

  offenders <- character()
  for (file in list.files(r_dir, pattern = "[.][Rr]$", full.names = TRUE)) {
    src <- readLines(file, warn = FALSE)
    src <- src[!grepl("^\\s*#", src)]

    matches <- regmatches(src, gregexpr(pattern, src))
    for (reference in unlist(matches)) {
      parts <- regmatches(reference, regexec(pattern, reference))[[1]]
      fn_name <- parts[2]
      arg_name <- parts[3]

      fn <- tryCatch(
        get(fn_name, envir = asNamespace("saros.base")),
        error = function(e) NULL
      )
      if (is.null(fn) || !is.function(fn)) {
        offenders <- c(offenders, paste0(basename(file), ": ", fn_name, "() not found"))
        next
      }
      if (!arg_name %in% names(formals(fn))) {
        offenders <- c(
          offenders,
          paste0(basename(file), ": ", fn_name, "() has no argument '", arg_name, "'")
        )
      }
    }
  }

  expect_equal(offenders, character(0))
})

test_that("create_text_collapse() is gone", {
  expect_false(exists("create_text_collapse", envir = asNamespace("saros.base"), inherits = FALSE))
})
