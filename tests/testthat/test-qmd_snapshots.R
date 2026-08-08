# Snapshots of the .qmd text draft_report() actually writes.
#
# The generated files are this package's deliverable, and until now nothing
# asserted anything about their content -- test-draft_report.R checks file
# counts and file *sizes* (`expect_lt(file.size(f), 3600)`). That is why this
# class of bug kept reaching users:
#
#   #207  two first-level headings in every chapter file
#   #208, #184  no `title` in the YAML front matter
#   #216  unnormalised whitespace in section headings
#
# Each is a defect in emitted text that a byte-level snapshot catches for free
# and a size assertion cannot see at all. Each was confirmed by re-introducing
# it and watching the relevant test below fail.
#
# #214 (a stray `ewpage` above every tabset) is NOT guarded here, despite being
# the same family of bug. Its guard is test-chunk_templates.R, which scans the
# template store itself. That is the stronger place for it: a snapshot only
# sees the templates a given example report happens to instantiate, so whether
# it catches the bug depends on whether the fixture has an `indep`. The
# source-level scan covers every template in every variant unconditionally.
# Verified: re-introducing #214 fails test-chunk_templates.R and leaves these
# snapshots green.
#
# These are only safe because #213 made the output deterministic -- anchors
# used to carry two RNG-drawn digits. test-anchor_determinism.R pins that
# property separately; if it ever regresses, these snapshots go flaky and that
# test says why.
#
# When a snapshot changes, read the diff before accepting it: it is the exact
# text your users will render.

# Helpers ---------------------------------------------------------------------

draft_into <- function(overview, envir = parent.frame(),
                       label_separator = " - ", chunk_templates = NULL,
                       organize_by = NULL, ...) {
  path <- withr::local_tempdir(.local_envir = envir)
  refine_args <- list(
    chapter_overview = overview,
    data = saros.base::ex_survey,
    label_separator = label_separator,
    chunk_templates = chunk_templates,
    progress = FALSE
  )
  if (!is.null(organize_by)) refine_args$organize_by <- organize_by
  chapter_structure <- suppressMessages(suppressWarnings(
    do.call(saros.base::refine_chapter_overview, refine_args)
  ))
  suppressMessages(saros.base::draft_report(
    data = saros.base::ex_survey,
    chapter_structure = chapter_structure,
    path = path,
    ...
  ))
  path
}

# Relative paths only -- an absolute tempdir would change on every run.
relative_files <- function(path, glob = "*") {
  sort(fs::path_rel(fs::dir_ls(path, recurse = TRUE, type = "file", glob = glob), start = path))
}

print_file <- function(path, file) {
  cat("== ", file, " ==\n", sep = "")
  writeLines(readLines(fs::path(path, file), warn = FALSE))
  cat("\n")
}

# YAML front matter, headings and float ids: the structural skeleton, without
# the chunk bodies. Compact enough to review on a richer report.
skeleton <- function(path, file) {
  lines <- readLines(fs::path(path, file), warn = FALSE)
  cat("== ", file, " ==\n", sep = "")

  # An opening fence with no closing one is a regression this file exists to
  # catch -- process_yaml() takes an `add_fences` argument, so it is reachable.
  # Report it in the snapshot rather than dying: which(...)[2] is NA there, and
  # seq_len(NA) errors with "argument must be coercible to non-negative
  # integer", which says nothing about the file that caused it.
  fences <- which(lines == "---")
  yaml_end <- 0L
  if (length(lines) && lines[1] == "---") {
    if (length(fences) >= 2) {
      yaml_end <- fences[2]
    } else {
      cat("<<< unterminated YAML front matter >>>\n")
    }
  }

  keep <- c(
    seq_len(yaml_end),
    grep("^#{1,6} |^::: \\{#|^:::: \\{\\.panel-tabset", lines)
  )
  writeLines(lines[sort(unique(keep))])
  cat("\n")
}

# A battery of two items plus a bivariate, and a single item in its own
# chapter -- enough to exercise prefix headings, indep headings and the
# chapter heading itself.
two_chapter_overview <- data.frame(
  chapter = c("Trivsel", "Trivsel", "Bakgrunn"),
  dep = c("a_1, a_2", "b_1", "x1_sex"),
  indep = c("x1_sex", "", "")
)

# The smallest thing that still produces a whole chapter.
one_chapter_overview <- data.frame(
  chapter = "Bakgrunn",
  dep = "x1_sex",
  indep = ""
)

# Numeric dependents, which neither fixture above touches -- every column they
# name is a factor. The templates keyed on `int;dbl` are unreachable without
# this, and both templates GH #246 fixed are in that group: variant 1 routes a
# univariate numeric to `int_table_html`, variant 5 to `int_plot_html`.
#
# The categorical chapter is not decoration: variant 3 declares no `int;dbl`
# template at all, so a numeric-only overview reduces to an empty
# chapter_structure there and draft_report() aborts on the missing core
# columns rather than producing a report to inspect.
mixed_chapter_overview <- data.frame(
  chapter = c("Num", "Bakgrunn"),
  dep = c("c_1, c_2", "x1_sex"),
  indep = c("", "")
)

# Tests -----------------------------------------------------------------------

testthat::test_that("the set of generated files is stable", {
  path <- draft_into(two_chapter_overview, title = "Eksempelrapport",
                     report_filename = "report")
  testthat::expect_snapshot(cat(relative_files(path), sep = "\n"))
})

testthat::test_that("index.qmd and report.qmd carry the report title", {
  # Guards #208 and #184: process_yaml() only assigned `title` when an explicit
  # yaml_file was supplied, so both files were written without one.
  path <- draft_into(two_chapter_overview, title = "Eksempelrapport",
                     report_filename = "report")
  testthat::expect_snapshot({
    print_file(path, "index.qmd")
    print_file(path, "report.qmd")
  })
})

testthat::test_that("a whole chapter file is stable", {
  # Full text, deliberately: this is the one place chunk bodies are pinned for
  # the default templates, so a stray character inside one shows up here.
  path <- draft_into(one_chapter_overview, title = "Eksempelrapport")
  testthat::expect_snapshot(print_file(path, "1_Bakgrunn.qmd"))
})

testthat::test_that("chapter structure -- headings, anchors and float ids", {
  # Guards #207 (one `#` heading per file, not two), #213 (anchors are a hash
  # of the heading's position, not RNG digits) and the heading text itself.
  path <- draft_into(two_chapter_overview, title = "Eksempelrapport")
  testthat::expect_snapshot({
    skeleton(path, "1_Trivsel.qmd")
    skeleton(path, "2_Bakgrunn.qmd")
  })
})

testthat::test_that("variant 2 (tabset) output is stable -- univariate", {
  # A general regression net for the tabset templates, not a guard for #214;
  # see the note at the top of this file.
  path <- draft_into(
    one_chapter_overview,
    title = "Eksempelrapport",
    chunk_templates = saros.base::get_chunk_template_defaults(2)
  )
  testthat::expect_snapshot(print_file(path, "1_Bakgrunn.qmd"))
})

testthat::test_that("variant 2 (tabset) output is stable -- bivariate", {
  # The univariate fixture above never instantiates the templates that declare
  # a `.template_variable_type_indep`, which is most of variant 2. Skeleton
  # form, since the point here is coverage of more templates rather than their
  # chunk bodies.
  path <- draft_into(
    two_chapter_overview,
    title = "Eksempelrapport",
    chunk_templates = saros.base::get_chunk_template_defaults(2)
  )
  testthat::expect_snapshot({
    skeleton(path, "1_Trivsel.qmd")
    skeleton(path, "2_Bakgrunn.qmd")
  })

  # Cheap backstop across every generated file. The primary guard for this
  # corruption is test-chunk_templates.R, which checks the templates directly.
  content <- unlist(lapply(
    fs::dir_ls(path, type = "file", glob = "*.qmd"),
    readLines, warn = FALSE
  ), use.names = FALSE)
  testthat::expect_false(any(grepl("ewpage", content, fixed = TRUE)))
  testthat::expect_false(any(grepl("newpage", content, fixed = TRUE)))
})

testthat::test_that("headings are whitespace-normalised with a bare separator", {
  # Guards #216: `.variable_label_suffix` was never passed to trim_columns(),
  # so suffixes kept leading/trailing spaces and internal runs of them. These
  # become section headings, where leading whitespace is significant in
  # Markdown.
  #
  # Two conditions are both required, and getting either wrong makes this test
  # pass against the broken code:
  #
  # 1. The separator must carry no spaces of its own. Labels in ex_survey read
  #    "Do you consent to the following? - Agreement #1", so splitting on "-"
  #    rather than " - " leaves a trailing space on the prefix and a leading one
  #    on the suffix. With ":" nothing splits at all and the suffix is empty.
  #
  # 2. `organize_by` must include `.variable_label_suffix_dep`, or the suffix
  #    never becomes a heading and the bug has nowhere to show. The default
  #    groups on the *prefix*, which was passed to trim_columns() twice -- so
  #    the prefix was always normalised, both before and after the fix.
  path <- draft_into(
    two_chapter_overview,
    label_separator = "-",
    organize_by = c(
      ".chapter_number", ".variable_label_prefix_dep",
      ".variable_label_suffix_dep", ".variable_name_indep", ".template_name"
    )
  )

  headings <- unlist(lapply(
    fs::dir_ls(path, type = "file", glob = "*.qmd"),
    function(file) grep("^#{1,6} ", readLines(file, warn = FALSE), value = TRUE)
  ), use.names = FALSE)

  testthat::expect_snapshot(cat(headings, sep = "\n"))

  # Stated as a property too, so the intent survives a careless snapshot accept.
  testthat::expect_false(any(grepl("^#{1,6}  ", headings)))
  testthat::expect_false(any(grepl("[ \t]$", headings)))
})

testthat::test_that("the numeric chapter is stable -- variants 1 and 5", {
  # Pins the two template bodies #246 fixed. Every other fixture in this file
  # names factor columns only, so before this the `int;dbl` templates were the
  # one group of default templates whose emitted text no snapshot covered --
  # which is why a missing opening fence survived in two of them.
  #
  # Paired with the property assertion below, per the note at the top of this
  # file: the snapshot shows what changed, the property says what must hold.
  default_variant <- draft_into(mixed_chapter_overview, title = "Eksempelrapport")
  variant_5 <- draft_into(
    mixed_chapter_overview,
    title = "Eksempelrapport",
    chunk_templates = saros.base::get_chunk_template_defaults(5)
  )

  testthat::expect_snapshot({
    cat("---- variant 1 (default) ----\n")
    print_file(default_variant, "1_Num.qmd")
    cat("---- variant 5 ----\n")
    print_file(variant_5, "1_Num.qmd")
  })
})

testthat::test_that("emitted .qmd has balanced div fences", {
  # Guards #246 at the output layer. test-chunk_templates.R scans the template
  # store, which is the stronger guard; this one pins the property on the text
  # users actually render, because that is where the stray `:::` surfaced.
  #
  # Stated as a property rather than left to the snapshot above: a snapshot
  # diff can be accepted carelessly and this cannot.
  #
  # Every variant is exercised, not just the two that were broken -- the
  # property belongs to emitted .qmd generally.
  for (variant in chunk_template_variants()) {
    path <- draft_into(
      mixed_chapter_overview,
      title = "Eksempelrapport",
      chunk_templates = saros.base::get_chunk_template_defaults(variant)
    )

    files <- fs::dir_ls(path, recurse = TRUE, type = "file", glob = "*.qmd")
    testthat::expect_gt(length(files), 0)

    for (file in files) {
      balance <- fence_balance(readLines(file, warn = FALSE))
      label <- paste0(
        "variant ", variant, ", ", fs::path_rel(file, start = path)
      )

      testthat::expect_equal(balance$opens, balance$closes, info = label)
      # A close before its open, and an unclosed div at end of file, are
      # distinct failures that equal counts would both accept.
      testthat::expect_true(balance$min_depth >= 0, info = label)
      testthat::expect_equal(balance$final_depth, 0, info = label)
    }
  }
})

testthat::test_that("the numeric fixture reaches the templates #246 fixed", {
  # Anti-vacuity guard for the test above. Both fixed templates are keyed on a
  # numeric `dep`, so if `mixed_chapter_overview` ever stopped routing to them
  # -- a renamed column in ex_survey, a changed default `organize_by` -- the
  # fence assertions would still pass while covering nothing.
  #
  # Variant 1's univariate int template is a table and carries `#tbl-`;
  # variant 5's is a plot and carries `#fig-`. Asserting the prefix, not just
  # the presence of a fence, pins which template was instantiated.
  expected_prefix <- c("1" = "#tbl-", "5" = "#fig-")

  for (variant in names(expected_prefix)) {
    path <- draft_into(
      mixed_chapter_overview,
      title = "Eksempelrapport",
      chunk_templates = saros.base::get_chunk_template_defaults(as.integer(variant))
    )
    chapter <- readLines(fs::path(path, "1_Num.qmd"), warn = FALSE)

    testthat::expect_true(
      any(grepl(paste0("^::: \\{", expected_prefix[[variant]]), chapter)),
      info = paste("variant", variant)
    )
    # The girafe call that variant 1's int_table_html used to make on a data
    # frame aborted the render outright; the table template must not emit one.
    if (variant == "1") {
      testthat::expect_false(any(grepl("girafe", chapter, fixed = TRUE)))
    }
  }
})

testthat::test_that("skeleton() reports unterminated YAML instead of erroring", {
  # Guards the helper itself. Before this, an opening fence with no closing one
  # made which(lines == "---")[2] NA and seq_len(NA) abort with "argument must
  # be coercible to non-negative integer" -- an error that names neither the
  # file nor the problem, in the one place a YAML regression would show up.
  dir <- withr::local_tempdir()

  writeLines(c("---", "title: x", "# Heading"), fs::path(dir, "unterminated.qmd"))
  output <- utils::capture.output(skeleton(dir, "unterminated.qmd"))
  testthat::expect_true(any(grepl("unterminated YAML front matter", output)))
  testthat::expect_true(any(grepl("^# Heading$", output)))

  # A well-formed file is unaffected: front matter through the closing fence,
  # then the headings.
  writeLines(
    c("---", "title: x", "---", "# Heading", "body text"),
    fs::path(dir, "wellformed.qmd")
  )
  output <- utils::capture.output(skeleton(dir, "wellformed.qmd"))
  testthat::expect_false(any(grepl("unterminated", output)))
  testthat::expect_true(any(grepl("^title: x$", output)))
  testthat::expect_false(any(grepl("^body text$", output)))
})
