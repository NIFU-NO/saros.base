# Every R chunk a generated chapter contains must be syntactically valid, for
# every default chunk template variant (GH #266).
#
# This is the cheap half of the guard #263 was missing. #263 added real Quarto
# render tests, but rendering is slow enough that its fixture reaches only
# variant 1's plot templates -- so four `cat_table_html` rows in variants 2 and
# 4 were still emitting `I(paste0(c(nrange, link), collapse=', '` with the
# closing parenthesis missing, and nothing noticed. Parsing needs no Quarto,
# no `saros`, no `gt`, and covers all five variants in seconds.
#
# The awkward part, and the reason the defect survived: in variants 2 and 4 the
# broken line is a *string* inside `knitr::knit_child(text = c(...))`. The
# parent chunk therefore parses perfectly well -- the syntax error only exists
# once knitr assembles the child document at render time. A guard that stopped
# at the parent chunk would report all-clear. So the child text is extracted
# from the parsed call and parsed in its own right.

# Lines of every ```{r ...} block in a qmd, one character vector per chunk.
r_chunks <- function(lines) {
  opens <- grep("^```\\{r", lines)
  closes <- grep("^```\\s*$", lines)
  out <- list()
  for (o in opens) {
    close <- closes[closes > o]
    if (length(close) == 0L) next
    if (close[1] - o > 1L) out[[length(out) + 1L]] <- lines[(o + 1L):(close[1] - 1L)]
  }
  out
}

# The `text=` argument of any knit_child() call in an expression.
#
# Read off the parse tree rather than evaluated. The argument is a literal
# `c("...", "...")` in every default template, so the string constants can be
# taken directly from the call -- which keeps this from running any code at
# all, rather than relying on a restricted environment to make evaluation safe.
knit_child_texts <- function(expr, found = list()) {
  if (is.call(expr)) {
    fn <- expr[[1]]
    name <- if (is.name(fn)) as.character(fn) else if (is.call(fn) &&
      identical(as.character(fn[[1]]), "::")) as.character(fn[[3]]) else ""
    if (identical(name, "knit_child") && !is.null(expr$text)) {
      arg <- expr$text
      literals <- if (is.character(arg)) {
        arg
      } else if (is.call(arg) && identical(as.character(arg[[1]]), "c")) {
        parts <- as.list(arg)[-1]
        keep <- vapply(parts, is.character, logical(1))
        unlist(parts[keep], use.names = FALSE)
      } else {
        NULL
      }
      if (length(literals) > 0L) found[[length(found) + 1L]] <- literals
    }
    for (i in seq_along(expr)) {
      if (i == 1L) next
      found <- knit_child_texts(expr[[i]], found)
    }
  }
  found
}

# Every piece of R a chapter will ask R to parse: its own chunks, plus the
# chunks inside any child document it assembles.
parse_failures <- function(qmd_lines) {
  failures <- character()
  for (chunk in r_chunks(qmd_lines)) {
    code <- paste(chunk, collapse = "\n")
    parsed <- tryCatch(parse(text = code), error = function(e) e)
    if (inherits(parsed, "error")) {
      failures <- c(failures, paste0("chunk: ", conditionMessage(parsed)))
      next
    }
    for (expr in as.list(parsed)) {
      for (child in knit_child_texts(expr)) {
        for (child_chunk in r_chunks(child)) {
          child_code <- paste(child_chunk, collapse = "\n")
          err <- tryCatch(
            {
              parse(text = child_code)
              NULL
            },
            error = function(e) e
          )
          if (!is.null(err)) {
            failures <- c(failures, paste0("knit_child: ", conditionMessage(err)))
          }
        }
      }
    }
  }
  failures
}

draft_variant <- function(path, variant) {
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(
        chapter = c("Ch1", "Ch2"),
        dep = c("a_1, a_2", "b_1"),
        indep = c("x1_sex", "")
      ),
      data = saros.base::ex_survey,
      label_separator = " - ",
      progress = FALSE,
      chunk_templates = saros.base::get_chunk_template_defaults(variant)
    )
  ))
  suppressMessages(suppressWarnings(saros.base::draft_report(
    data = saros.base::ex_survey,
    chapter_structure = chapter_structure,
    path = path
  )))
  unlist(lapply(
    sort(fs::dir_ls(path, glob = "*.qmd")),
    readLines,
    warn = FALSE
  ))
}

default_variants <- function() {
  as.integer(sub(
    "^default_chunk_templates_", "",
    grep("^default_chunk_templates_", names(saros.base:::.saros.env), value = TRUE)
  ))
}

################################################################################

# Chunks that come from a chunk template, as opposed to the setup and dataset
# import chunks `draft_report()` emits for every chapter regardless.
template_chunks <- function(lines) {
  chunks <- r_chunks(lines)
  boilerplate <- vapply(chunks, function(ch) {
    any(grepl("#| label: 'Setup for ", ch, fixed = TRUE)) ||
      any(grepl("#| label: 'Import data for ", ch, fixed = TRUE))
  }, logical(1))
  chunks[!boilerplate]
}

testthat::test_that("the parse guard sees the template chunks, not just boilerplate", {
  # Anti-vacuity control: without it, every assertion below would pass on an
  # empty set.
  #
  # It counts *template* chunks specifically. An earlier version asserted
  # `length(r_chunks(lines)) > 3`, which this two-chapter fixture cleared on
  # boilerplate alone -- `draft_report()` emits a setup chunk and an import
  # chunk per chapter unconditionally, so four exist before any template
  # contributes anything. The control would have passed with zero template
  # chunks extracted, which is precisely the degradation it exists to catch.
  path <- withr::local_tempdir()
  lines <- draft_variant(path, 1)

  testthat::expect_gt(length(template_chunks(lines)), 3L)
  # And the boilerplate really is being excluded rather than the filter being
  # a no-op, which would put us straight back to counting the wrong thing.
  testthat::expect_lt(length(template_chunks(lines)), length(r_chunks(lines)))
})

testthat::test_that("the parse guard descends into knit_child text", {
  # The other half of the control: variants 2 and 4 hide their table code
  # inside a child document, and the guard is worthless there unless it looks.
  path <- withr::local_tempdir()
  lines <- draft_variant(path, 2)
  children <- unlist(lapply(
    unlist(lapply(r_chunks(lines), function(ch) {
      as.list(parse(text = paste(ch, collapse = "\n")))
    }), recursive = FALSE),
    function(e) knit_child_texts(e)
  ), recursive = FALSE)
  # More than one: this fixture yields several child texts, so `> 0` would pass
  # on a single surviving one while extraction had silently degraded.
  testthat::expect_gt(length(children), 3L)
})

testthat::test_that("every R chunk of every default variant parses", {
  for (variant in default_variants()) {
    path <- withr::local_tempdir()
    failures <- parse_failures(draft_variant(path, variant))
    testthat::expect_identical(
      failures, character(),
      info = paste("default_chunk_templates_", variant, sep = "")
    )
  }
})

testthat::test_that("no template uses a link variable it never assigns", {
  # The other half of #266, and the half parsing cannot reach: variant 3's two
  # `cat_table_html` rows computed `table` and `nrange`, then referenced `link`
  # in `paste0(c(nrange, link), ...)` without ever assigning it. Syntactically
  # perfect; `object 'link' not found` at render.
  #
  # Checked statically rather than by rendering because variants 2, 3 and 4 are
  # the mesos variants -- 15 to 19 `params$mesos_var` references each -- so they
  # cannot render standalone without a mesos fixture, and variant 3 is exactly
  # where this defect lived. A render test would not have covered it.
  offenders <- character()
  for (variant in default_variants()) {
    templates <- saros.base::get_chunk_template_defaults(variant)
    for (i in seq_len(nrow(templates))) {
      tpl <- as.character(templates$.template[i])
      if (is.na(tpl)) next
      for (var in c("link", "link_plot")) {
        used <- grepl(paste0("(?<![A-Za-z0-9._])", var, "(?![A-Za-z0-9._])"),
          tpl,
          perl = TRUE
        )
        assigned <- grepl(paste0("(?<![A-Za-z0-9._])", var, "\\s*<-"),
          tpl,
          perl = TRUE
        )
        if (used && !assigned) {
          offenders <- c(offenders, sprintf(
            "variant %d row %d (%s): uses `%s` unassigned",
            variant, i, templates$.template_name[i], var
          ))
        }
      }
    }
  }
  testthat::expect_identical(offenders, character())
})

# Two further classes of unrunnable generated code (GH #269).
#
# Both were found by review of #267, whose guards did not reach them: the parse
# check only proves syntax, and the used-but-never-assigned check was hard-coded
# to `link`/`link_plot`.

# Symbols used as *values* in an expression. Argument names are excluded for
# free: in `f(data = x)` the string "data" is a name of the call, not an
# element of it, so only `x` is collected. The function position is skipped
# when it is a plain name, so `data.frame(...)` does not count as using `data`.
value_symbols <- function(expr, found = character()) {
  if (is.name(expr)) {
    return(c(found, as.character(expr)))
  }
  if (is.call(expr)) {
    head <- expr[[1]]
    op <- if (is.name(head)) as.character(head) else ""
    # `a$data` and `a@data` are field accesses: the right side is a label, not
    # a symbol lookup. Walking it would report `link <- make_link(data =
    # plot$data)` as a use of a bare `data`, which it is not.
    if (op %in% c("$", "@")) {
      return(value_symbols(expr[[2]], found))
    }
    # `pkg::name` likewise: `name` is resolved inside the namespace.
    if (op %in% c("::", ":::")) {
      return(found)
    }
    parts <- as.list(expr)
    if (is.name(head)) parts <- parts[-1]
    for (p in parts) found <- value_symbols(p, found)
  }
  found
}

################################################################################

testthat::test_that("no template uses a bare `data`", {
  # A generated chapter binds `data_<chapter>` and never binds `data`, so a
  # bare `data` resolves to `utils::data` -- the function -- and the chunk dies
  # with "`x` must be a vector, not a function". Nine sites had it: seven
  # spelled `makeme(data = data, ...)` in variant 4, two `data |> makeme(...)`
  # in variant 5.
  offenders <- character()
  for (variant in default_variants()) {
    path <- withr::local_tempdir()
    lines <- draft_variant(path, variant)
    for (chunk in r_chunks(lines)) {
      code <- tryCatch(parse(text = paste(chunk, collapse = "\n")),
        error = function(e) NULL
      )
      if (is.null(code)) next
      for (expr in as.list(code)) {
        if ("data" %in% value_symbols(expr)) {
          offenders <- c(offenders, sprintf(
            "variant %d: %s", variant,
            trimws(substr(paste(deparse(expr), collapse = " "), 1, 70))
          ))
        }
      }
    }
  }
  testthat::expect_identical(unique(offenders), character())
})

testthat::test_that("no template subscripts a variable it never assigns", {
  # The variable-agnostic form of the `link`/`link_plot` check added in #267.
  # That one was scoped to two literal names, which is why it did not see
  # variant 4's `chr_table` assigning `tbl` and then reading `tbls[[.x]]`.
  #
  # `parameters` and `params` are allowlisted because they are legitimately
  # supplied from outside the template: `params` by Quarto from the qmd's YAML,
  # and `parameters` by an external formatting file sourced into every
  # generated qmd, which aggregates the `_metadata.yml` inheritance chain. See
  # #270 -- if `parameters` ever becomes package-supplied, this entry goes.
  #
  # `data_` names are allowlisted because the chapter's dataset is assigned by
  # the import chunk `draft_report()` emits, not by any template.
  supplied_externally <- c("parameters", "params")

  offenders <- character()
  for (variant in default_variants()) {
    templates <- saros.base::get_chunk_template_defaults(variant)
    for (i in seq_len(nrow(templates))) {
      tpl <- as.character(templates$.template[i])
      if (is.na(tpl)) next
      # The lookbehind excludes `pkg::name$...`, where the object belongs to a
      # namespace rather than to the template -- `knitr::opts_template$set()`
      # is the case in point.
      subscripted <- unique(unlist(regmatches(
        tpl,
        gregexpr(
          "(?<!:)(?<![A-Za-z0-9._])[A-Za-z._][A-Za-z0-9._]*(?=\\[\\[|\\$)",
          tpl,
          perl = TRUE
        )
      )))
      for (var in subscripted) {
        if (var %in% supplied_externally) next
        if (grepl("^data_", var)) next
        assigned <- grepl(
          paste0("(?<![A-Za-z0-9._])", var, "\\s*<-"), tpl,
          perl = TRUE
        )
        if (!assigned) {
          offenders <- c(offenders, sprintf(
            "variant %d row %d (%s): subscripts `%s` without assigning it",
            variant, i, templates$.template_name[i], var
          ))
        }
      }
    }
  }
  testthat::expect_identical(offenders, character())
})

testthat::test_that("the allowlist is doing work, not hiding an empty check", {
  # Anti-vacuity: `parameters` must actually be present in the templates, or
  # the allowlist above is inert and the check's coverage is untested.
  found <- FALSE
  for (variant in default_variants()) {
    templates <- saros.base::get_chunk_template_defaults(variant)
    tpl <- paste(stats::na.omit(as.character(templates$.template)), collapse = "\n")
    if (grepl("parameters$", tpl, fixed = TRUE)) found <- TRUE
  }
  testthat::expect_true(found)
})
