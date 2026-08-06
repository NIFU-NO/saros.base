# Regression tests for GH #216.
#
# refine_chapter_overview() called trim_columns() with ".variable_label_prefix"
# twice and never passed ".variable_label_suffix", so label suffixes kept their
# leading/trailing whitespace and internal runs of spaces. Those suffixes become
# section headings, where leading whitespace is significant in Markdown.

################################################################################
testthat::test_that("trim_columns() normalises every column it is given", {
  data <- data.frame(
    a = c("  padded  ", "double  space"),
    b = c(" also padded ", "x"),
    stringsAsFactors = FALSE
  )
  out <- saros.base:::trim_columns(data, cols = c("a", "b"))

  testthat::expect_equal(out$a, c("padded", "double space"))
  testthat::expect_equal(out$b, c("also padded", "x"))
})

testthat::test_that("trim_columns() ignores absent and non-character columns", {
  data <- data.frame(a = c(" x "), n = 1L, stringsAsFactors = FALSE)
  out <- saros.base:::trim_columns(data, cols = c("a", "n", ".does_not_exist"))

  testthat::expect_equal(out$a, "x")
  testthat::expect_equal(out$n, 1L)
})

testthat::test_that("trim_columns() default names each prefix and suffix once", {
  # The default previously listed ".variable_label_prefix_dep" twice and
  # omitted ".variable_label_suffix_dep".
  default_cols <- eval(formals(saros.base:::trim_columns)$cols)

  testthat::expect_equal(anyDuplicated(default_cols), 0L)
  testthat::expect_setequal(
    default_cols,
    c(
      ".variable_label_prefix_dep", ".variable_label_suffix_dep",
      ".variable_label_prefix_indep", ".variable_label_suffix_indep"
    )
  )
})

################################################################################
testthat::test_that("label prefixes and suffixes are both whitespace-normalised", {
  # A separator without surrounding spaces is what exposes the bug: the default
  # " - " already consumes the padding, so nothing is left to trim.
  set.seed(1)
  n <- 100
  data <- data.frame(
    q1 = factor(sample(c("Ja", "Nei"), n, TRUE), levels = c("Ja", "Nei")),
    q2 = factor(sample(c("Ja", "Nei"), n, TRUE), levels = c("Ja", "Nei")),
    g = factor(sample(c("X", "Y"), n, TRUE))
  )
  attr(data$q1, "label") <- "Main  question:  first item"
  attr(data$q2, "label") <- "Main  question:  second item"
  attr(data$g, "label") <- "Group"

  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(chapter = "Ch", dep = "q1, q2", indep = "g"),
      data = data,
      label_separator = ":",
      progress = FALSE
    )
  ))

  untidy <- "^\\s|\\s$|  " # leading, trailing, or repeated whitespace
  testthat::expect_false(any(grepl(untidy, chapter_structure$.variable_label_prefix_dep)))
  testthat::expect_false(any(grepl(untidy, chapter_structure$.variable_label_suffix_dep)))

  # And the content itself survives, collapsed rather than stripped.
  testthat::expect_setequal(
    unique(chapter_structure$.variable_label_suffix_dep),
    c("first item", "second item")
  )
})
