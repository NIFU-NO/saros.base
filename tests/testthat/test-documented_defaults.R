# Regression test for GH #251.
#
# Every `@param` block in this package follows a house convention whose second
# line states the argument's default, e.g.
#
#   `scalar<logical>` // *default:* `TRUE` (`optional`)
#
# That line is the only thing most users read before calling a function, and it
# had drifted away from the signature for 24 arguments across 6 functions --
# three of them saying a feature was off when it was on. The same class of
# defect had already been fixed twice by hand (#232, #245) before anything
# checked it.
#
# This sweeps every documented argument and compares the stated default against
# `formals()`.

# A node's Rd tag ("\\code", "TEXT", ...), or "" for plain text.
rd_tag <- function(x) {
  tag <- attr(x, "Rd_tag")
  if (is.null(tag)) "" else tag
}

# The text of an Rd node, as `?topic` displays it. This is deliberately not the
# raw `.Rd` bytes: inside `\code{}` a hand-escaped `\{` stays a backslash and a
# brace all the way through Rd2txt and Rd2HTML, so reading the node -- rather
# than unescaping the file -- is what compares the value the reader is actually
# shown. #251 included four defaults that were wrong in exactly that way.
rd_text <- function(x) paste(as.character(unlist(x)), collapse = "")

squash <- function(x) trimws(gsub("\\s+", " ", x))

# Compare as R code rather than as strings, so that incidental differences --
# whitespace, and whether a vector name is quoted -- do not count. `c("a" = 1)`
# and `c(a = 1)` are the same default; deparse() emits the latter.
canonicalise <- function(x) {
  parsed <- tryCatch(str2lang(x), error = function(e) NULL)
  if (is.null(parsed)) return(squash(x))
  squash(paste(deparse(parsed), collapse = " "))
}

# The value stated after `*default:*` in one `\item{}{}` description, or NULL
# when the block states none. The value must follow the marker immediately,
# with only whitespace between: `*default:* see Usage` deliberately states no
# machine-checkable value and is left alone.
stated_default <- function(desc) {
  tags <- vapply(desc, rd_tag, character(1))
  marker <- which(
    tags == "\\emph" &
      vapply(desc, function(node) identical(trimws(rd_text(node)), "default:"), NA)
  )
  if (!length(marker)) return(NULL)

  i <- marker[1] + 1L
  while (i <= length(desc) && tags[i] == "TEXT" && !nzchar(trimws(rd_text(desc[[i]])))) {
    i <- i + 1L
  }
  if (i > length(desc) || !tags[i] %in% c("\\code", "\\verb")) return(NULL)
  rd_text(desc[[i]])
}

# The `\arguments` documentation, as a list of parsed Rd objects. Read from the
# source `man/` when it is there, and from the installed help otherwise, so
# this runs under `R CMD check` -- where the tests execute against an installed
# package with no `man/` directory -- rather than skipping there, which is
# where CI would have run it.
rd_topics <- function(pkg_root) {
  man_dir <- file.path(pkg_root, "man")
  rd_files <- list.files(man_dir, pattern = "[.]Rd$", full.names = TRUE)
  if (length(rd_files)) {
    return(lapply(sort(rd_files), tools::parse_Rd))
  }
  db <- tryCatch(tools::Rd_db("saros.base"), error = function(e) list())
  unname(db[order(names(db))])
}

# Argument names some function hands to rlang::arg_match()/match.arg().
# Discovered by deparsing the package's own function bodies rather than listed
# here, so a new choice-style argument is covered without touching this test,
# and so this works against an installed package as well as against sources.
arg_match_arguments <- function(ns) {
  pattern <- "(?:rlang::)?(?:arg_match|match\\.arg)\\(\\s*([A-Za-z._][A-Za-z0-9._]*)"
  found <- character()
  for (nm in ls(ns, all.names = TRUE)) {
    obj <- tryCatch(get(nm, envir = ns), error = function(e) NULL)
    if (!is.function(obj) || is.primitive(obj)) next
    src <- tryCatch(deparse(body(obj)), error = function(e) character())
    for (hit in unlist(regmatches(src, gregexpr(pattern, src)))) {
      found <- c(found, regmatches(hit, regexec(pattern, hit))[[1]][2])
    }
  }
  unique(found)
}

# Arguments that reach arg_match() under a different name, so the scan above
# cannot see them. `draft_report()` and `gen_qmd_chapters()` pass `qmd_engine`
# down to `gen_qmd_structure(engine =)`, which is where arg_match() runs.
# Written as name -> target so the exemption is withdrawn automatically if the
# target ever stops using arg_match(), rather than silently outliving it.
forwarded_to_arg_match <- c(qmd_engine = "engine")

# Is this default the `c("first", "second", ...)` menu that arg_match() picks
# from? Checked syntactically: evaluating a default would run things like
# tempdir() or system.file().
is_choice_menu <- function(default) {
  is.call(default) &&
    identical(default[[1]], quote(c)) &&
    length(default) >= 3L &&
    is.null(names(default)) &&
    all(vapply(as.list(default)[-1], is.character, NA))
}

testthat::test_that("every documented default matches the function's actual default", {
  testthat::skip_on_cran()

  ns <- asNamespace("saros.base")
  topics_rd <- rd_topics(testthat::test_path("..", ".."))
  testthat::skip_if(
    length(topics_rd) == 0,
    "no documentation available, neither in man/ nor installed"
  )

  choice_arguments <- arg_match_arguments(ns)
  # An argument may take the first-element exemption only if it is genuinely
  # consumed by arg_match(), directly or via the parameter it forwards to.
  exemptable <- union(
    choice_arguments,
    names(forwarded_to_arg_match)[forwarded_to_arg_match %in% choice_arguments]
  )

  offenders <- character()
  checked <- 0L
  for (rd in topics_rd) {
    tags <- vapply(rd, rd_tag, character(1))

    topics <- trimws(unique(vapply(rd[tags %in% c("\\name", "\\alias")], rd_text, character(1))))
    functions <- Filter(
      function(nm) exists(nm, envir = ns, inherits = FALSE) && is.function(get(nm, envir = ns)),
      topics
    )
    if (!length(functions)) next

    for (block in rd[tags == "\\arguments"]) {
      for (item in block[vapply(block, rd_tag, character(1)) == "\\item"]) {
        documented <- stated_default(item[[2]])
        if (is.null(documented)) next
        documented <- canonicalise(documented)

        # One `@param` tag may name several arguments, in which case its single
        # stated default has to be true of every one of them.
        for (arg in trimws(strsplit(rd_text(item[[1]]), ",")[[1]])) {
          for (fn_name in functions) {
            formal_args <- formals(get(fn_name, envir = ns))
            if (!arg %in% names(formal_args)) next
            checked <- checked + 1L

            # deparse() of the empty symbol is ""; unlike assigning it to a
            # variable, this does not trip R's missing-argument check.
            actual <- squash(paste(deparse(formal_args[[arg]]), collapse = " "))
            if (!nzchar(actual)) {
              offenders <- c(offenders, sprintf(
                "%s(%s): documented `%s` but the argument is required (no default)",
                fn_name, arg, documented
              ))
              next
            }
            if (identical(documented, canonicalise(actual))) next

            # The arg_match() convention: the formal carries the whole menu of
            # permitted values, but only its first element is ever the default,
            # so documenting that first element is both correct and the more
            # useful thing to state.
            if (arg %in% exemptable &&
              is_choice_menu(formal_args[[arg]]) &&
              identical(documented, canonicalise(deparse(formal_args[[arg]][[2]])))) {
              next
            }

            offenders <- c(offenders, sprintf(
              "%s(%s): documented `%s` but the default is `%s`",
              fn_name, arg, documented, canonicalise(actual)
            ))
          }
        }
      }
    }
  }

  testthat::expect_equal(offenders, character(0))

  # Without this the test would pass vacuously the moment the parse stops
  # finding anything -- a roxygen2 release that renders `*default:*`
  # differently, or a rename of the house convention, would silently disarm it
  # rather than fail. 73 argument/function pairs are matched at the time of
  # writing; the floor is set well below that so ordinary additions and
  # removals do not trip it.
  testthat::expect_gt(checked, 50L)
})

testthat::test_that("the arg_match() exemption is live and narrow", {
  # Guards the test above from two silent failure modes: the arg_match() scan
  # finding nothing (which would withdraw every exemption), and the exemption
  # widening to arguments that merely happen to default to a character vector
  # -- `ignore_heading_for_group` and `organize_by` are such arguments, and
  # documenting either as just its first element must stay an error.
  testthat::skip_on_cran()

  found <- arg_match_arguments(asNamespace("saros.base"))
  testthat::expect_true("engine" %in% found)
  testthat::expect_false("ignore_heading_for_group" %in% found)
  testthat::expect_false("organize_by" %in% found)

  testthat::expect_true(is_choice_menu(formals(saros.base::draft_report)$qmd_engine))
  testthat::expect_false(is_choice_menu(formals(saros.base::refine_chapter_overview)$arrange_section_by))
  testthat::expect_false(is_choice_menu(formals(saros.base::draft_report)$path))
})
