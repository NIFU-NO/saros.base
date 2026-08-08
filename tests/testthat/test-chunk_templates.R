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

# `chunk_template_variants()` comes from helper-chunk_templates.R, shared with
# test-qmd_snapshots.R.

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

################################################################################
# Regression tests for GH #246.
#
# Variant 1's univariate `int_table_html` and variant 5's univariate
# `int_plot_html` each ended with a bare `:::` but never opened a div. Both
# read as a bivariate sibling copied with the opening fence dropped -- the
# caption line survived, only the opener was missing -- so the closing fence
# reached generated .qmd unmatched.
#
# The scan lives here rather than with the snapshots because a snapshot only
# sees the templates a given fixture happens to instantiate, and neither of
# these two is reachable without a numeric `dep`. The store is scanned whole.
#
# `fence_balance()` and the two patterns come from helper-fences.R, shared with
# the emitted-.qmd assertion in test-qmd_snapshots.R.

testthat::test_that("the fence detector distinguishes opening from closing fences", {
  # Guards the guard, as the escape detector above does.
  balanced <- fence_balance(c("::: {#fig-x}", "body", ":::"))
  testthat::expect_equal(balanced$opens, 1)
  testthat::expect_equal(balanced$closes, 1)
  testthat::expect_equal(balanced$min_depth, 0)

  # A bare word class opens a div too, and four colons are still a fence.
  testthat::expect_equal(fence_balance(":::: panel-tabset")$opens, 1)

  # Trailing whitespace is what draft_report() actually emits on both fences.
  testthat::expect_equal(fence_balance("::: ")$closes, 1)
  testthat::expect_equal(fence_balance("::: {#tbl-x} ")$opens, 1)

  # The reported defect: a close with no open.
  reported <- fence_balance(c("```{r}", "x", "```", "", ":::"))
  testthat::expect_equal(reported$opens, 0)
  testthat::expect_equal(reported$closes, 1)
  testthat::expect_lt(reported$min_depth, 0)

  # The dangerous direction: an open with no close.
  testthat::expect_equal(fence_balance(c("::: {#fig-x}", "body"))$final_depth, 1)

  # Balanced counts in the wrong order must still be caught.
  inverted <- fence_balance(c(":::", "body", "::: {#fig-x}"))
  testthat::expect_equal(inverted$opens, inverted$closes)
  testthat::expect_lt(inverted$min_depth, 0)

  # A `:::` inside an R string literal is not a fence: variants 2 and 4 build
  # child documents from quoted vectors of markdown lines.
  testthat::expect_equal(fence_balance("      '::: {{#fig-x}}',")$opens, 0)
})

testthat::test_that("every chunk template has balanced div fences", {
  variants <- chunk_template_variants()
  testthat::expect_gt(length(variants), 0)

  for (variant in variants) {
    templates <- saros.base::get_chunk_template_defaults(variant)

    for (i in seq_len(nrow(templates))) {
      balance <- fence_balance(templates$.template[i])
      label <- paste0(
        "variant ", variant, ", template '", templates$.template_name[i],
        "', indep = ",
        ifelse(
          is.na(templates$.template_variable_type_indep[i]),
          "NA", templates$.template_variable_type_indep[i]
        )
      )

      testthat::expect_equal(balance$opens, balance$closes, info = label)
      # Counts alone would accept a close that precedes its open.
      testthat::expect_true(balance$min_depth >= 0, info = label)
    }
  }
})
