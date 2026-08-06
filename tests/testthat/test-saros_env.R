# Regression tests for GH #218.
#
# `.saros.env <- NULL` at package level meant exists(".saros.env") inside
# .onLoad() always resolved TRUE, so the new.env() branch never ran. The first
# `$<-` then coerced NULL to a list, and every subsequent assignment copied the
# whole (large) list instead of mutating an environment in place.

testthat::test_that(".saros.env is an environment, not a list", {
  testthat::expect_true(is.environment(saros.base:::.saros.env))
})

testthat::test_that(".saros.env has reference semantics", {
  # The practical consequence of the bug: a setter called from another
  # function would have modified a copy, silently failing to persist.
  env <- saros.base:::.saros.env
  key <- "..test_reference_semantics.."
  withr::defer(if (exists(key, envir = env)) rm(list = key, envir = env))

  setter <- function(target) target[[key]] <- "written"
  setter(env)

  testthat::expect_identical(env[[key]], "written")
})

testthat::test_that(".onLoad() populated every expected entry", {
  env <- saros.base:::.saros.env

  testthat::expect_true(is.character(env$core_chapter_structure_cols))
  testthat::expect_gt(length(env$core_chapter_structure_cols), 0)
  testthat::expect_true(is.character(env$peripheral_chapter_structure_cols))
  testthat::expect_true(is.character(env$core_chapter_structure_pattern))
  testthat::expect_true(is.character(env$ignore_args))
})

testthat::test_that("chunk template variants are reachable via names()", {
  # names() behaves differently on environments than on lists; this is the
  # lookup get_chunk_template_defaults() relies on.
  variants <- grep(
    "^default_chunk_templates_",
    names(saros.base:::.saros.env),
    value = TRUE
  )
  testthat::expect_gte(length(variants), 5)

  for (variant in variants) {
    number <- as.integer(sub("^default_chunk_templates_", "", variant))
    templates <- saros.base::get_chunk_template_defaults(number)
    testthat::expect_s3_class(templates, "data.frame")
    testthat::expect_gt(nrow(templates), 0)
    testthat::expect_true(all(
      c(".template_name", ".template") %in% names(templates)
    ))
  }
})

testthat::test_that("get_chunk_template_defaults() rejects an unknown variant", {
  testthat::expect_error(
    saros.base::get_chunk_template_defaults(99),
    regexp = "invalid"
  )
})
