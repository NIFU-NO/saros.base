testthat::test_that("glue_err works", {
  testfun <- function(a=2, template = "{a}") {
    tryCatch(glue::glue(template),
             error = function(cnd) saros.base:::glue_err(cnd=cnd, arg_name="testfun"))
  }
  testthat::expect_equal(testfun(), "2")
  testthat::expect_error(testfun(a=mean), regexp = "Template is invalid")
  testthat::expect_error(testfun(template="{b}"), regexp = "Template is invalid")

})
