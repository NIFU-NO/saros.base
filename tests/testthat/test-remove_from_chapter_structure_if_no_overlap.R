testthat::test_that("remove_from_chapter_structure_if_no_overlap handles basic cases", {
    # Create test data
    test_data <- data.frame(
        var1 = c(1, NA, 3, NA, 5),
        var2 = c(NA, 2, 3, NA, 5),
        var3 = c(NA, NA, NA, NA, NA),
        var4 = c(1, 2, 3, 4, 5)
    )

    # Test case 1: Variables with some overlap
    ch_struct1 <- data.frame(
        .variable_name_dep = "var1",
        .variable_name_indep = "var2"
    )

    result1 <- saros.base:::remove_from_chapter_structure_if_no_overlap(ch_struct1, test_data)
    testthat::expect_equal(nrow(result1), 1) # Should keep as there's overlap

    # Test case 2: Variables with no overlap
    ch_struct2 <- data.frame(
        .variable_name_dep = c("var1", "var1"),
        .variable_name_indep = c("var2", "var3")
    )

    result2 <- saros.base:::remove_from_chapter_structure_if_no_overlap(ch_struct2, test_data)
    testthat::expect_equal(result2, data.frame(.variable_name_dep = "var1", .variable_name_indep = "var2")) # Should remove var1-var3 combination
})

testthat::test_that("remove_from_chapter_structure_if_no_overlap handles NA and missing combinations", {
    test_data <- data.frame(
        var1 = 1:5,
        var2 = 1:5
    )

    # Test case: NA in variable names
    ch_struct <- data.frame(
        .variable_name_dep = c("var1", "var1", NA),
        .variable_name_indep = c("var2", NA, "var2"),
        other_col = 1:3,
        stringsAsFactors = FALSE
    )

    result <- remove_from_chapter_structure_if_no_overlap(ch_struct, test_data)
    testthat::expect_equal(nrow(result), 3) # Should keep NA combinations
    testthat::expect_equal(ncol(result), 3) # Should maintain all columns
})

testthat::test_that("remove_from_chapter_structure_if_no_overlap maintains tibble properties", {
    test_data <- tibble::tibble(
        var1 = 1:5,
        var2 = 1:5
    )

    ch_struct <- tibble::tibble(
        .variable_name_dep = "var1",
        .variable_name_indep = "var2"
    )

    result <- remove_from_chapter_structure_if_no_overlap(ch_struct, test_data)
    testthat::expect_s3_class(result, "tbl_df")
    testthat::expect_equal(nrow(result), 1)
})

testthat::test_that("remove_from_chapter_structure_if_no_overlap handles single-column data frames", {
    test_data <- data.frame(
        var1 = 1:5
    )

    ch_struct <- data.frame(
        .variable_name_dep = "var1",
        stringsAsFactors = FALSE
    )

    result <- saros.base:::remove_from_chapter_structure_if_no_overlap(ch_struct, test_data)
    testthat::expect_equal(nrow(result), 1)
    testthat::expect_equal(ncol(result), 1)
})

testthat::test_that("keep_dep_indep_if_no_overlap works in refine_chapter_overview", {
    # Create test data
    test_data <- data.frame(
        var1 = c(1, NA, 3),
        var2 = c(NA, 2, NA)
    )
    attr(test_data[["var1"]], "label") <- "Variable 1"
    attr(test_data[["var2"]], "label") <- "Variable 2"

    test_overview <- data.frame(
        chapter = "test",
        dep = "var1",
        indep = "var2"
    )

    # Test with keep_dep_indep_if_no_overlap = TRUE
    result_keep <- saros.base::refine_chapter_overview(
        chapter_overview = test_overview,
        data = test_data,
        keep_dep_indep_if_no_overlap = TRUE
    )

    # Test with keep_dep_indep_if_no_overlap = FALSE (default)
    result_remove <- saros.base::refine_chapter_overview(
        chapter_overview = test_overview,
        data = test_data
    )

    testthat::expect_equal(nrow(result_keep), nrow(result_remove))
})
