testthat::test_that("check_category_pairs validates common categories", {
  # Test with valid data - columns share common categories
  df <- data.frame(
    q1 = factor(c("Yes", "No", "Maybe", "Yes", "No"), levels = c("Yes", "No", "Maybe")),
    q2 = factor(c("Yes", "Yes", "No", "Maybe", "Yes"), levels = c("Yes", "No", "Maybe")),
    q3 = factor(c("No", "Maybe", "Yes", "No", "Maybe"), levels = c("Yes", "No", "Maybe"))
  )
  
  cols_pos <- c(q1 = 1, q2 = 2, q3 = 3)
  
  # Should return TRUE when all pairs share categories
  testthat::expect_true(check_category_pairs(df, cols_pos))
  
  # Test with columns that don't share categories
  df_no_overlap <- data.frame(
    q1 = factor(c("A", "B", "A", "B", "A"), levels = c("A", "B")),
    q2 = factor(c("C", "D", "C", "D", "C"), levels = c("C", "D"))
  )
  
  cols_no_overlap <- c(q1 = 1, q2 = 2)
  
  # Should error when columns don't share categories
  testthat::expect_error(
    check_category_pairs(df_no_overlap, cols_no_overlap),
    class = "rlang_error"
  )
  
  # Test with non-factor columns (uses unique values)
  df_numeric <- data.frame(
    v1 = c(1, 2, 3, 1, 2),
    v2 = c(2, 3, 4, 2, 3),
    v3 = c(1, 1, 2, 3, 3)
  )
  
  cols_numeric <- c(v1 = 1, v2 = 2, v3 = 3)
  
  # v1 and v2 share 2 and 3, v2 and v3 share 2 and 3, v1 and v3 share 1, 2, 3
  testthat::expect_true(check_category_pairs(df_numeric, cols_numeric))
  
  # Test with character columns
  df_char <- data.frame(
    c1 = c("red", "blue", "green", "red", "blue"),
    c2 = c("blue", "green", "yellow", "blue", "green")
  )
  
  cols_char <- c(c1 = 1, c2 = 2)
  
  # c1 and c2 share "blue" and "green"
  testthat::expect_true(check_category_pairs(df_char, cols_char))
})

testthat::test_that("trim_columns trims whitespace and collapses multiple spaces", {
  # Create test data with various whitespace issues
  df <- data.frame(
    .variable_label_prefix_dep = c(" Leading space", "Trailing space ", "  Multiple   spaces  "),
    .variable_label_prefix_indep = c("Normal", " Both sides ", "No  extra  spaces"),
    .variable_label_suffix_indep = c("", "  ", "   Multiple   "),
    other_col = c("Not affected", " Also not ", "  affected  ")
  )
  
  # Default columns to trim
  result <- trim_columns(df)
  
  # Check that whitespace is trimmed and multiple spaces collapsed
  testthat::expect_equal(result$.variable_label_prefix_dep[1], "Leading space")
  testthat::expect_equal(result$.variable_label_prefix_dep[2], "Trailing space")
  testthat::expect_equal(result$.variable_label_prefix_dep[3], "Multiple spaces")
  
  testthat::expect_equal(result$.variable_label_prefix_indep[1], "Normal")
  testthat::expect_equal(result$.variable_label_prefix_indep[2], "Both sides")
  testthat::expect_equal(result$.variable_label_prefix_indep[3], "No extra spaces")
  
  testthat::expect_equal(result$.variable_label_suffix_indep[1], "")
  testthat::expect_equal(result$.variable_label_suffix_indep[2], "")
  testthat::expect_equal(result$.variable_label_suffix_indep[3], "Multiple")
  
  # Other columns should not be affected
  testthat::expect_equal(result$other_col[1], "Not affected")
  testthat::expect_equal(result$other_col[2], " Also not ")
  testthat::expect_equal(result$other_col[3], "  affected  ")
  
  # Test with custom columns
  df2 <- data.frame(
    custom_col = c(" Trim me ", "  And  me  "),
    leave_alone = c(" Don't trim ", "  me  ")
  )
  
  result2 <- trim_columns(df2, cols = "custom_col")
  
  testthat::expect_equal(result2$custom_col[1], "Trim me")
  testthat::expect_equal(result2$custom_col[2], "And me")
  testthat::expect_equal(result2$leave_alone[1], " Don't trim ")
  testthat::expect_equal(result2$leave_alone[2], "  me  ")
})

testthat::test_that("trim_columns handles non-character columns gracefully", {
  df <- data.frame(
    .variable_label_prefix_dep = c(1, 2, 3),  # Numeric, not character
    .variable_label_prefix_indep = c(" Text ", " More ", " Text "),
    other = c(TRUE, FALSE, TRUE)
  )
  
  # Should not error on non-character columns
  result <- suppressWarnings(trim_columns(df))
  
  # Numeric column should be unchanged
  testthat::expect_equal(result$.variable_label_prefix_dep, c(1, 2, 3))
  
  # Character column should be trimmed
  testthat::expect_equal(result$.variable_label_prefix_indep, c("Text", "More", "Text"))
  
  # Logical column unchanged
  testthat::expect_equal(result$other, c(TRUE, FALSE, TRUE))
})

testthat::test_that("trim_columns handles missing columns", {
  df <- data.frame(
    col1 = c(" Keep ", " This "),
    col2 = c(" And ", " That ")
  )
  
  # Try to trim columns that don't exist - should not error
  testthat::expect_silent(
    trim_columns(df, cols = c("nonexistent_col"))
  )
})

################################################################################
# Regression tests for GH #216.
#
# refine_chapter_overview() called trim_columns() with ".variable_label_prefix"
# twice and never passed ".variable_label_suffix", so label suffixes kept their
# leading/trailing whitespace and internal runs of spaces. Those suffixes become
# section headings, where leading whitespace is significant in Markdown.

testthat::test_that("trim_columns default names each prefix and suffix once", {
  # The default previously listed ".variable_label_prefix_dep" twice and
  # omitted ".variable_label_suffix_dep".
  default_cols <- eval(formals(trim_columns)$cols)

  testthat::expect_equal(anyDuplicated(default_cols), 0L)
  testthat::expect_setequal(
    default_cols,
    c(
      ".variable_label_prefix_dep", ".variable_label_suffix_dep",
      ".variable_label_prefix_indep", ".variable_label_suffix_indep"
    )
  )
})

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

  untidy <- "^[[:space:]]|[[:space:]]$|  " # leading, trailing, or repeated whitespace
  testthat::expect_false(any(grepl(untidy, chapter_structure$.variable_label_prefix_dep)))
  testthat::expect_false(any(grepl(untidy, chapter_structure$.variable_label_suffix_dep)))

  # And the content itself survives, collapsed rather than stripped.
  testthat::expect_setequal(
    unique(chapter_structure$.variable_label_suffix_dep),
    c("first item", "second item")
  )
})
