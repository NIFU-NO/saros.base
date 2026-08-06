# Regression tests for GH #214.
#
# The templates carried the element '#\newpage' (a single literal backslash).
# Templates are written verbatim into the generated .qmd, so when R later parsed
# that single-quoted string, `\n` was consumed as a newline escape and the
# remainder survived as visible body text -- a stray `ewpage` above every
# tabset, on every page.
#
# Note that a literal backslash in a template is not wrong by itself: the same
# templates legitimately emit `cat(sep = '\n')`, where the generated code is
# meant to re-parse `\n` into a newline. That is precisely why this bug was easy
# to introduce and invisible on inspection. What distinguishes the defect is an
# escape sequence with *more word characters glued to it* -- `\newpage` is
# `\n` + "ewpage", so the author plainly meant a literal `\newpage` directive.

# Variants available from the package's internal template store.
chunk_template_variants <- function() {
  names <- grep("^default_chunk_templates_", names(saros.base:::.saros.env), value = TRUE)
  as.integer(sub("^default_chunk_templates_", "", names))
}

# A literal backslash, an escape letter, then further alphanumerics.
unintended_escape_pattern <- "\\\\[[:alpha:]][[:alnum:]]"

################################################################################
testthat::test_that("the escape detector recognises the reported defect", {
  # Guards the guard: '#\newpage' must trip it, `sep = '\n'` must not.
  testthat::expect_true(grepl(unintended_escape_pattern, "'#\\newpage',"))
  testthat::expect_false(grepl(unintended_escape_pattern, "cat(sep = '\\n')"))
  testthat::expect_false(grepl(unintended_escape_pattern, "opts.label=\\'fig\\'"))
})

testthat::test_that("no chunk template contains an unintended backslash escape", {
  variants <- chunk_template_variants()
  testthat::expect_gt(length(variants), 0)

  for (variant in variants) {
    templates <- saros.base::get_chunk_template_defaults(variant)

    for (i in seq_len(nrow(templates))) {
      offenders <- regmatches(
        templates$.template[i],
        gregexpr(unintended_escape_pattern, templates$.template[i])
      )[[1]]

      testthat::expect_equal(
        offenders,
        character(0),
        info = paste0(
          "variant ", variant, ", template '", templates$.template_name[i], "'"
        )
      )
    }
  }
})

testthat::test_that("no chunk template still contains newpage", {
  # Narrow guard for the exact reported symptom, across every variant --
  # variants 2 and 4 were both affected.
  for (variant in chunk_template_variants()) {
    templates <- saros.base::get_chunk_template_defaults(variant)
    testthat::expect_false(
      any(grepl("newpage", templates$.template, fixed = TRUE)),
      info = paste("variant", variant)
    )
  }
})
