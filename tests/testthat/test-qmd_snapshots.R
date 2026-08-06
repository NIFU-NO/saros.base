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
  yaml_end <- if (length(lines) && lines[1] == "---") which(lines == "---")[2] else 0L
  keep <- c(
    seq_len(yaml_end),
    grep("^#{1,6} |^::: \\{#|^:::: \\{\\.panel-tabset", lines)
  )
  cat("== ", file, " ==\n", sep = "")
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
  # Full text, deliberately: this is the one place chunk bodies are pinned, so
  # a stray character inside a template shows up here (#214).
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
