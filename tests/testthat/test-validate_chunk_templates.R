# Regression tests for GH #210.
#
# A project injects auxiliary text around each chunk by wrapping every
# `.template` with a pair of `insert_text()` calls. That wrap is easy to apply
# twice -- once in the generation script, once again in a mutation helper --
# and nothing downstream notices, so every inserted passage is emitted twice in
# the generated qmd.
#
# The wrapping itself lives outside saros.base (`insert_text()` and
# `apply_template_mutations()` are project/saros-side; neither name appears in
# this package). saros.base only ever sees the already-doubled string arriving
# in the `.template` column, so the guard here is a lint on user-supplied data:
# it warns and returns the templates unchanged.
#
# The discriminator is *identical repetition*, not a call count. See the
# "legitimate" test below, which carries three `before=TRUE` calls and must stay
# silent -- a count-based predicate fails it.

# The wrap, copied verbatim from the issue text.
wrap_with_insert_text <- function(df) {
  df$.template <- paste(
    '\n`{{r}} insert_text(aux_txt, chunk="{.chunk_name}", before=TRUE)`',
    df$.template,
    '`{{r}} insert_text(aux_txt, chunk="{.chunk_name}", before=FALSE)`\n\n',
    sep = "\n"
  )
  df
}

# Column names follow the real schema, as built by .onLoad() and returned by
# get_chunk_template_defaults(). (Note that the `core_columns` list inside
# validate_chunk_templates() names a `.variable_type_dep` that no default
# template has -- but that check is dead code, see the comment on the PR.)
one_template <- function(.template_name, .template) {
  data.frame(
    .template_name = .template_name,
    .template_variable_type_dep = "fct;ord",
    .template_variable_type_indep = NA_character_,
    .template = .template,
    stringsAsFactors = FALSE
  )
}

# Collect every warning message an expression emits, without letting any of
# them escape. refine_chapter_overview() emits several unrelated ones.
warnings_from <- function(expr) {
  messages <- character()
  withCallingHandlers(
    suppressMessages(expr),
    warning = function(w) {
      messages <<- c(messages, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  messages
}

# Fires on the doubled shape ---------------------------------------------------

testthat::test_that("a doubly-wrapped .template warns", {
  doubled <- wrap_with_insert_text(
    wrap_with_insert_text(saros.base::get_chunk_template_defaults(1))
  )

  testthat::expect_warning(
    saros.base:::validate_chunk_templates(doubled),
    regexp = "insert_text"
  )
})

testthat::test_that("the warning names the offending template", {
  one <- one_template(
    "cat_plot_html",
    paste(
      '`{{r}} insert_text(aux_txt, chunk="{.chunk_name}", before=TRUE)`',
      '`{{r}} insert_text(aux_txt, chunk="{.chunk_name}", before=TRUE)`',
      "body",
      sep = "\n"
    )
  )

  messages <- warnings_from(saros.base:::validate_chunk_templates(one))
  testthat::expect_true(any(grepl("cat_plot_html", messages, fixed = TRUE)))
})

testthat::test_that("duplicates differing only in whitespace are caught", {
  # The two wraps need not be byte-identical: a hand-written wrap and a
  # generated one commonly differ in spacing around `=` and `,`.
  spaced <- one_template(
    "cat_plot_html",
    paste(
      '`{{r}} insert_text(aux_txt, chunk="{.chunk_name}", before=TRUE)`',
      '`{{r}} insert_text( aux_txt , chunk = "{.chunk_name}" , before = TRUE )`',
      "body",
      sep = "\n"
    )
  )

  testthat::expect_warning(
    saros.base:::validate_chunk_templates(spaced),
    regexp = "insert_text"
  )
})

testthat::test_that("the doubled shape still warns on the real generation path", {
  # The guard has to fire where a project actually meets it, not only when the
  # internal validator is called directly.
  doubled <- wrap_with_insert_text(
    wrap_with_insert_text(saros.base::get_chunk_template_defaults(1))
  )

  messages <- warnings_from(saros.base::refine_chapter_overview(
    chapter_overview = data.frame(
      chapter = "Bakgrunn", dep = "x1_sex", indep = ""
    ),
    data = saros.base::ex_survey,
    chunk_templates = doubled,
    progress = FALSE
  ))

  testthat::expect_true(any(grepl("insert_text", messages, fixed = TRUE)))
})

# Stays silent -----------------------------------------------------------------

testthat::test_that("a singly-wrapped .template is silent", {
  single <- wrap_with_insert_text(saros.base::get_chunk_template_defaults(1))

  testthat::expect_silent(saros.base:::validate_chunk_templates(single))
})

testthat::test_that("several distinct insert_text() calls are silent", {
  # A template may legitimately address several insertion points. These five
  # calls include *three* with `before=TRUE`, so any predicate that counts
  # `before=TRUE` occurrences -- the obvious reading of the issue -- misfires
  # here. What distinguishes re-wrapping is that one call is reproduced
  # verbatim, which none of these are.
  legitimate <- one_template(
    "cat_plot_html",
    paste(
      '`{{r}} insert_text(aux_txt, chunk="intro", before=TRUE)`',
      '`{{r}} insert_text(aux_txt, chunk="intro", before=FALSE)`',
      '`{{r}} insert_text(aux_txt, chunk="method", before=TRUE)`',
      '`{{r}} insert_text(aux_txt, chunk="method", before=FALSE)`',
      '`{{r}} insert_text(other_txt, chunk="{.chunk_name}", before=TRUE)`',
      "body",
      sep = "\n"
    )
  )

  testthat::expect_silent(saros.base:::validate_chunk_templates(legitimate))
})

testthat::test_that("every default variant is silent", {
  # The package's own templates must never trip its own lint.
  variants <- grep(
    "^default_chunk_templates_",
    names(saros.base:::.saros.env),
    value = TRUE
  )
  testthat::expect_gte(length(variants), 5)

  for (variant in variants) {
    number <- as.integer(sub("^default_chunk_templates_", "", variant))
    testthat::expect_silent(
      saros.base:::validate_chunk_templates(
        saros.base::get_chunk_template_defaults(number)
      )
    )
  }
})

testthat::test_that("templates without any insert_text() call are silent", {
  plain <- one_template("cat_plot_html", "body only, no insertion at all")

  testthat::expect_silent(saros.base:::validate_chunk_templates(plain))
})

# Robustness -------------------------------------------------------------------

testthat::test_that("an NA .template does not error", {
  with_na <- one_template("cat_plot_html", NA_character_)

  testthat::expect_silent(saros.base:::validate_chunk_templates(with_na))
})

testthat::test_that("the templates are returned unchanged", {
  # This is a lint, not a repair: a false positive must not alter a build.
  doubled <- wrap_with_insert_text(
    wrap_with_insert_text(saros.base::get_chunk_template_defaults(1))
  )

  returned <- suppressWarnings(saros.base:::validate_chunk_templates(doubled))
  testthat::expect_identical(returned, doubled)
})

# Required core columns (GH #242) -----------------------------------------------

# `core_columns` was checked with `for (col in core_columns) if (!col %in%
# core_columns)`, comparing the list to itself, so the condition was FALSE on
# every iteration and `chunk_templates` was never inspected at all.
#
# The obvious repair -- `!col %in% names(chunk_templates)` -- would have made
# the package reject its own defaults, because the set named
# `.variable_type_dep`, which is a *chapter_structure* column (see
# `?refine_chapter_overview` and `validate_chapter_structure()`) and has never
# existed in `chunk_templates`. It is dropped rather than renamed.
#
# Every one of the four columns below already fails somewhere downstream when
# absent; what was missing is a failure that names `chunk_templates`. Two of
# them are actively misleading: a missing `.template` passes
# `refine_chapter_overview()` and is reported much later against
# `chapter_structure`, and the two type columns surface as
# `Must select at least one item` from a tidyselect call the caller never made.

required_core_columns <- c(
  ".template_name", ".template",
  ".template_variable_type_dep", ".template_variable_type_indep"
)

testthat::test_that("a chunk_templates missing a required column is rejected", {
  full <- one_template("cat_plot_html", "body")
  testthat::expect_true(all(required_core_columns %in% names(full)))

  for (col in required_core_columns) {
    without <- full[, setdiff(names(full), col), drop = FALSE]
    cnd <- testthat::expect_error(
      saros.base:::validate_chunk_templates(without),
      class = "rlang_error"
    )
    # Naming the argument the caller actually got wrong is the whole point of
    # the fix; every pre-existing failure named something else.
    testthat::expect_match(conditionMessage(cnd), "chunk_templates", fixed = TRUE)
    testthat::expect_match(conditionMessage(cnd), col, fixed = TRUE)
  }
})

testthat::test_that("every missing required column is named in one message", {
  # Dropped in the order `core_columns` lists them, so an implementation that
  # aborted on the *first* missing column would report `.template_name` and
  # stop. Asserting the later one appears too is what distinguishes one
  # message from four sequential aborts. Neither name is a substring of the
  # other, unlike `.template` and `.template_variable_type_indep`.
  full <- one_template("cat_plot_html", "body")
  without_two <- full[
    , setdiff(names(full), c(".template_name", ".template_variable_type_dep")),
    drop = FALSE
  ]

  cnd <- testthat::expect_error(
    saros.base:::validate_chunk_templates(without_two),
    class = "rlang_error"
  )
  testthat::expect_match(conditionMessage(cnd), ".template_name", fixed = TRUE)
  testthat::expect_match(
    conditionMessage(cnd), ".template_variable_type_dep",
    fixed = TRUE
  )
})

testthat::test_that("every default variant satisfies the required columns", {
  # The half of #242 that would have caught the bug. This cannot fail against
  # the unfixed code -- nothing rejected anything then -- so it guards the
  # *repair* rather than the defect: it is what fails if the required set ever
  # names a column the package's own templates do not carry, which is exactly
  # what `.variable_type_dep` did.
  variants <- grep(
    "^default_chunk_templates_",
    names(saros.base:::.saros.env),
    value = TRUE
  )
  testthat::expect_gte(length(variants), 5)

  for (variant in variants) {
    number <- as.integer(sub("^default_chunk_templates_", "", variant))
    testthat::expect_no_error(
      saros.base:::validate_chunk_templates(
        saros.base::get_chunk_template_defaults(number)
      )
    )
  }
})

testthat::test_that("a chunk_templates without .template no longer blames chapter_structure", {
  # The worst of the four. Missing `.template` passed validation, passed
  # `refine_chapter_overview()` entirely, and only surfaced inside
  # `draft_report()` as "`chapter_structure` is missing `.template`" -- naming
  # an object the caller may never have touched, in a different function, one
  # call later.
  ct <- data.frame(
    .template_name = "t",
    .template_variable_type_dep = "fct;ord",
    .template_variable_type_indep = NA_character_,
    stringsAsFactors = FALSE
  )

  cnd <- testthat::expect_error(
    suppressMessages(suppressWarnings(
      saros.base::refine_chapter_overview(
        chapter_overview = data.frame(chapter = "Ch", dep = "a_1", indep = ""),
        data = saros.base::ex_survey,
        chunk_templates = ct,
        progress = FALSE
      )
    )),
    class = "rlang_error"
  )
  testthat::expect_match(conditionMessage(cnd), "chunk_templates", fixed = TRUE)
  testthat::expect_no_match(conditionMessage(cnd), "chapter_structure", fixed = TRUE)
})
