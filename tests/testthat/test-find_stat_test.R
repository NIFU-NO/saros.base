testthat::test_that("saros.base:::find_test2 handles univariates", {
    # Numeric one-sample t-test
    testthat::expect_equal(
        saros.base:::find_test2(rnorm(100))$.bi_test,
        "One-sample t-test"
    )

    # Factor chi-square goodness of fit
    testthat::expect_equal(
        saros.base:::find_test2(factor(rep(c("A", "B"), 50)))$.bi_test,
        "Chi-squared Goodness-of-Fit Test"
    )
})

testthat::test_that("saros.base:::find_test2 handles bivariates", {
    x_num <- rnorm(100)
    y_num <- rnorm(100)
    x_int <- rpois(100, 4)
    y_int <- rpois(100, 4)
    x_fact <- factor(rep(c("A", "B"), 50))
    y_fact <- factor(rep(c("Yes", "No"), 50))
    x_ord <- ordered(rep(c("Low", "Med", "High"), 33))
    y_ord <- ordered(rep(c("Low", "Med", "High"), 33))

    x_with_na <- c(1:9, NA)
    y_with_na <- c(NA, 2:10)


    # numeric ~ numeric
    testthat::expect_equal(
        saros.base:::find_test2(y_num, x_num)$.bi_test,
        "Pearson Cor"
    )

    # integer ~ numeric
    testthat::expect_equal(
        saros.base:::find_test2(y_int, x_num)$.bi_test,
        "Pearson Cor"
    )

    # numeric ~ integer
    testthat::expect_equal(
        saros.base:::find_test2(y_num, x_int)$.bi_test,
        "Pearson Cor"
    )

    # integer ~ integer
    testthat::expect_equal(
        saros.base:::find_test2(y_int, x_int)$.bi_test,
        "Pearson Cor"
    )


    # numeric ~ factor
    testthat::expect_equal(
        saros.base:::find_test2(y_num, x_fact)$.bi_test,
        "ANOVA"
    )

    # integer ~ factor
    testthat::expect_equal(
        saros.base:::find_test2(y_int, x_fact)$.bi_test,
        "ANOVA"
    )

    # integer ~ ordered
    testthat::expect_equal(
        saros.base:::find_test2(y_int, x_ord)$.bi_test,
        "Spearman Rank Cor"
    )

    # numeric ~ ordered
    testthat::expect_equal(
        saros.base:::find_test2(y_num, x_ord)$.bi_test,
        "Spearman Rank Cor"
    )

    # factor ~ factor
    testthat::expect_equal(
        saros.base:::find_test2(y_fact, x_fact)$.bi_test,
        "Chi-sq"
    )

    # factor ~ numeric
    testthat::expect_equal(
        saros.base:::find_test2(y_fact, x_num)$.bi_test,
        "ANOVA"
    )

    # factor ~ integer
    testthat::expect_equal(
        saros.base:::find_test2(y_fact, x_int)$.bi_test,
        "ANOVA"
    )

    # factor ~ ordered
    testthat::expect_equal(
        saros.base:::find_test2(y_fact, x_ord)$.bi_test,
        "Chi-sq"
    )

    # ordered ~ ordered
    testthat::expect_equal(
        saros.base:::find_test2(y_ord, x_ord)$.bi_test,
        "Spearman Rank Cor"
    )

    # ordered ~ numeric
    testthat::expect_equal(
        saros.base:::find_test2(y_ord, x_num)$.bi_test,
        "Spearman Rank Cor"
    )

    # ordered ~ factor
    testthat::expect_equal(
        saros.base:::find_test2(y_ord, x_fact)$.bi_test,
        "Kruskal-Wallis chisq"
    )

    # Warning for unsupported combinations
    testthat::expect_warning(
        saros.base:::find_test2(letters[1:10], rnorm(10)),
        "Unable to find a suitable statistical test"
    )

    # NA values
    result <- saros.base:::find_test2(y_with_na, x_with_na)
    testthat::expect_false(is.na(result$.p_value))
    testthat::expect_equal(result$.bi_test, "Pearson Cor")
})
