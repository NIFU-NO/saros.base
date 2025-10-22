testthat::test_that("check_variable_labels detects all label issues", {
  # Create a comprehensive dataset with various label issues
  df <- data.frame(
    v01 = 1:5,           # Short label
    v02 = 1:5,           # Missing label
    v03 = 1:5,           # Duplicate label (with v04)
    v04 = 1:5,           # Duplicate label (with v03)
    v05 = c("a","b","c","d","e"), # Duplicate label (different type, should not flag)
    v06 = 1:5,           # Multiple separators
    v07 = 1:5,           # Leading whitespace
    v08 = 1:5,           # Trailing whitespace
    v09 = 1:5,           # Double whitespace
    v10 = 1:5,           # HTML tags
    v11 = 1:5,           # Special characters (@)
    v12 = 1:5,           # Special characters (€)
    v13 = 1:5,           # Ellipsis (two dots)
    v14 = 1:5,           # Ellipsis (four dots)
    v15 = 1:5,           # Ellipsis (five dots)
    v16 = 1:5,           # Good label
    v17 = 1:5,           # Good label with one separator
    v18 = 1:5            # Good label with proper ellipsis
  )
  
  # Set labels with various issues
  attr(df$v01, "label") <- "OK"                                    # Too short (< 3 chars)
  # v02 has no label (missing)
  attr(df$v03, "label") <- "Same Label"                            # Duplicate
  attr(df$v04, "label") <- "Same Label"                            # Duplicate
  attr(df$v05, "label") <- "Same Label"                            # Different type, not duplicate
  attr(df$v06, "label") <- "Question - Part 1 - Subsection"       # Multiple separators
  attr(df$v07, "label") <- " Leading space"                        # Leading whitespace
  attr(df$v08, "label") <- "Trailing space "                       # Trailing whitespace
  attr(df$v09, "label") <- "Double  space"                         # Double whitespace
  attr(df$v10, "label") <- "Label with <b>bold</b> text"          # HTML tags
  attr(df$v11, "label") <- "Label with @ symbol"                  # Special character
  attr(df$v12, "label") <- "Label with € currency"                # Special character
  attr(df$v13, "label") <- "Label with.."                          # Two dots (bad ellipsis)
  attr(df$v14, "label") <- "Label with...."                        # Four dots (bad ellipsis)
  attr(df$v15, "label") <- "Label with....."                       # Five dots (bad ellipsis)
  attr(df$v16, "label") <- "Good Label"                            # No issues
  attr(df$v17, "label") <- "Gender - Male"                         # One separator (OK)
  attr(df$v18, "label") <- "Label ending properly..."              # Proper ellipsis (OK)
  
  # Run check
  result <- suppressWarnings(check_variable_labels(df, separator = " - "))
  
  # Basic structure checks
  testthat::expect_s3_class(result, "data.frame")
  expected_cols <- c("variable", "label", "type", "issue_missing_or_short",
                    "issue_duplicate_labels", "issue_multiple_separators",
                    "issue_whitespace", "issue_html", "issue_special_char",
                    "issue_ellipsis")
  testthat::expect_true(all(expected_cols %in% colnames(result)))
  
  # Only variables with issues should be returned (15 out of 18)
  testthat::expect_equal(nrow(result), 14)
  
  # Missing or short labels: v01, v02
  missing_short <- result[result$issue_missing_or_short, "variable"]
  testthat::expect_equal(sort(missing_short), c("v01", "v02"))
  
  # Duplicate labels: v03, v04 (v05 is different type, not flagged)
  duplicates <- result[result$issue_duplicate_labels, "variable"]
  testthat::expect_equal(sort(duplicates), c("v03", "v04"))
  
  # Multiple separators: v06
  mult_sep <- result[result$issue_multiple_separators, "variable"]
  testthat::expect_equal(mult_sep, "v06")
  
  # Whitespace issues: v07, v08, v09
  whitespace <- result[result$issue_whitespace, "variable"]
  testthat::expect_equal(sort(whitespace), c("v07", "v08", "v09"))
  
  # HTML tags: v10
  html <- result[result$issue_html, "variable"]
  testthat::expect_equal(html, "v10")
  
  # Special characters: v10, v11, v12
  # Dots and hyphens should not be considered special characters
  special <- result[result$issue_special_char, "variable"]
  testthat::expect_equal(sort(special), c("v10", "v11", "v12"))
  
  # Ellipsis issues: v13, v14, v15
  ellipsis <- result[result$issue_ellipsis, "variable"]
  testthat::expect_equal(sort(ellipsis), c("v13", "v14", "v15"))
  
  # Variables without issues should not be in result
  testthat::expect_false("v16" %in% result$variable)
  testthat::expect_false("v17" %in% result$variable)
  testthat::expect_false("v18" %in% result$variable)
  
  # Test that function returns invisible when all labels are good
  df_good <- data.frame(a = 1:3, b = 4:6)
  attr(df_good$a, "label") <- "Good Label A"
  attr(df_good$b, "label") <- "Good Label B"
  result_good <- suppressMessages(check_variable_labels(df_good))
  testthat::expect_null(result_good)
})
