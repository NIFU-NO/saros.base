testthat::test_that("validate_draft_report_args", {

  args <-
    formals(saros.base::draft_report)
  args <-
     args[!names(args) %in% saros.base:::.saros.env$ignore_args] |>
    lapply(FUN = eval) |>
    utils::modifyList(keep.null = TRUE,
                      val =
                        list(data = data.frame(a = 1),
                             chapter_structure = saros.base::refine_chapter_overview(chapter_overview=data.frame(chapter = c("Ch1", "Ch2"), dep=c(NA, "a_1")),
                                                                                     data=saros.base::ex_survey),
                             path = "test"))

   args |>
    saros.base:::validate_draft_report_args() |>
     testthat::expect_silent()

    # Test Case 2: Invalid argument
   args |>
     utils::modifyList(keep.null = TRUE,
                       val =
                         list(invalid_arg = 2)) |>
     saros.base:::validate_draft_report_args() |>
     testthat::expect_error(regexp = "not recognized valid arguments.")

    # Test Case 3: Missing required argument
   args |>
     utils::modifyList(keep.null = TRUE,
                       val =
                         list(data = NULL)) |>
     saros.base:::validate_draft_report_args() |>
     testthat::expect_error(regexp = "`data` argument must be provided")

    # Test Case 4: Invalid data type for 'data'
   args |>
     utils::modifyList(keep.null = TRUE,
                       val =
                         list(data = "invalid_data")) |>
     saros.base:::validate_draft_report_args() |>
     testthat::expect_warning(regexp = "`data` is invalid")

    # Test Case 5: An unnamed heading template. Without a rule of its own the
    # argument is silently a no-op -- `current_group %in% names(NULL)` is FALSE
    # for every group -- so the warning is the only thing that tells the caller
    # their template was never applied.
   args |>
     utils::modifyList(keep.null = TRUE,
                       val =
                         list(glue_heading_for_group = "By {tolower(heading)}")) |>
     saros.base:::validate_draft_report_args() |>
     testthat::expect_warning(regexp = "`glue_heading_for_group` is invalid")

})
