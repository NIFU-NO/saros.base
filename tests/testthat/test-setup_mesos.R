# Unit Tests
testthat::test_that("With no subfolders specified, returns empty tibble", {
  files <- c("_file1.md")
  result <- saros.base:::create_includes_content_path_df(files_to_process = files)
  testthat::expect_equal(result, tibble::tibble())
})

testthat::test_that("Handles mesos_var_subfolders correctly", {
  files <- c("_file1.md")
  main_dir <- "main"
  mesos_var <- "mesos"
  subfolders <- c("sub1", "sub2")
  result <- saros.base:::create_includes_content_path_df(
    files_to_process = files,
    main_directory = main_dir,
    mesos_var = mesos_var,
    mesos_var_subfolders = subfolders
  )

  testthat::expect_equal(result,
    expected = tibble::tibble(
      content = c(
        "{{< include \"../_file1.md\" >}}",
        "{{< include \"../../_file1.md\" >}}", "{{< include \"../../../_file1.md\" >}}",
        "{{< include \"../../../../_file1.md\" >}}"
      ),
      mesos_group = NA_character_, mesos_group_pretty = NA_character_,
      path = fs::as_fs_path(c(
        "main/mesos/sub1/sub2/file1.md",
        "main/mesos/sub1/_file1.md",
        "main/mesos/_file1.md",
        "main/_file1.md"
      ))
    )
  )
})

testthat::test_that("Handles mesos_groups_abbr with subfolders", {
  files <- c("_file1.md")
  main_dir <- "main"
  mesos_var <- "mesos"
  subfolders <- c("sub1")
  groups_abbr <- c("groupA")
  result <- saros.base:::create_includes_content_path_df(
    files_to_process = files,
    main_directory = main_dir,
    mesos_var = mesos_var,
    mesos_var_subfolders = subfolders,
    mesos_groups_abbr = groups_abbr,
    mesos_groups_pretty = "Group A"
  )

  testthat::expect_equal(
    result,
    tibble::tibble(
      content = c(
        "{{< include \"../_file1.md\" >}}",
        "{{< include \"../../_file1.md\" >}}",
        "{{< include \"../../../_file1.md\" >}}",
        "{{< include \"../../../../_file1.md\" >}}"
      ),
      mesos_group = c("groupA", rep(NA_character_, 3)),
      mesos_group_pretty = c("Group A", rep(NA_character_, 3)),
      path = fs::as_fs_path(c(
        "main/mesos/sub1/groupA/file1.md",
        "main/mesos/sub1/_file1.md",
        "main/mesos/_file1.md",
        "main/_file1.md"
      ))
    )
  )
})

testthat::test_that("Handles multiple mesos_groups_abbr", {
  files <- c("_file1.md")
  mesos_var <- "mesos"
  groups_abbr <- c("groupA", "groupB")
  groups_pretty <- c("Group A", "Group B")
  result <- saros.base:::create_includes_content_path_df(
    files_to_process = files,
    mesos_var = mesos_var,
    mesos_groups_abbr = groups_abbr,
    mesos_groups_pretty = groups_pretty
  )

  testthat::expect_equal(
    result,
    tibble::tibble(
      content = c(
        "{{< include \"../_file1.md\" >}}",
        "{{< include \"../_file1.md\" >}}",
        "{{< include \"../../_file1.md\" >}}"
      ),
      mesos_group = c("groupA", "groupB", NA),
      mesos_group_pretty = c("Group A", "Group B", NA),
      path = fs::as_fs_path(c(
        "mesos/groupA/file1.md",
        "mesos/groupB/file1.md",
        "mesos/_file1.md"
      ))
    )
  )
})

testthat::test_that("Handles empty files_to_process", {
  files <- character()
  result <- saros.base:::create_includes_content_path_df(files_to_process = files)

  testthat::expect_equal(result, tibble::tibble())
})
