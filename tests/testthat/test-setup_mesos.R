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

# Tests for search_and_replace_files
testthat::test_that("search_and_replace_files performs basic replacement", {
  # Create temporary test files
  tmp_dir <- tempdir()
  test_file1 <- file.path(tmp_dir, "test1.txt")
  test_file2 <- file.path(tmp_dir, "test2.txt")
  
  writeLines("Hello World", test_file1)
  writeLines("Goodbye World", test_file2)
  
  result <- saros.base:::search_and_replace_files(
    files = c(test_file1, test_file2),
    pattern = "World",
    replacement = "Universe"
  )
  
  testthat::expect_equal(readLines(test_file1, warn = FALSE), "Hello Universe")
  testthat::expect_equal(readLines(test_file2, warn = FALSE), "Goodbye Universe")
  testthat::expect_equal(result, c(test_file1, test_file2))
  
  # Cleanup
  unlink(c(test_file1, test_file2))
})

testthat::test_that("search_and_replace_files handles multiple patterns", {
  tmp_dir <- tempdir()
  test_file <- file.path(tmp_dir, "test_multi.txt")
  
  writeLines(c("Line 1: foo", "Line 2: bar", "Line 3: baz"), test_file)
  
  result <- suppressWarnings(saros.base:::search_and_replace_files(
    files = test_file,
    pattern = c("foo", "bar"),
    replacement = c("FOO", "BAR")
  ))
  
  content <- readLines(test_file, warn = FALSE)
  testthat::expect_equal(content[1], "Line 1: FOO")
  testthat::expect_equal(content[2], "Line 2: BAR")
  testthat::expect_equal(content[3], "Line 3: baz")
  
  unlink(test_file)
})

testthat::test_that("search_and_replace_files returns files unchanged if pattern/replacement is NULL", {
  files <- c("file1.txt", "file2.txt")
  
  result1 <- saros.base:::search_and_replace_files(files, pattern = NULL, replacement = "test")
  testthat::expect_equal(result1, files)
  
  result2 <- saros.base:::search_and_replace_files(files, pattern = "test", replacement = NULL)
  testthat::expect_equal(result2, files)
})

testthat::test_that("search_and_replace_files validates input lengths", {
  testthat::expect_error(
    saros.base:::search_and_replace_files(
      files = "file.txt",
      pattern = c("a", "b"),
      replacement = "x"
    ),
    "must be character vectors of same length"
  )
  
  testthat::expect_error(
    saros.base:::search_and_replace_files(
      files = "file.txt",
      pattern = 123,
      replacement = "x"
    ),
    "must be character vectors of same length"
  )
})

# Tests for validate_includes_params
testthat::test_that("validate_includes_params accepts valid inputs", {
  testthat::expect_silent(
    saros.base:::validate_includes_params(
      prefix = "{{< include \"",
      suffix = "\" >}}",
      files_to_process = c("file1.md", "file2.md")
    )
  )
})

testthat::test_that("validate_includes_params rejects invalid prefix", {
  testthat::expect_error(
    saros.base:::validate_includes_params(
      prefix = c("a", "b"),
      suffix = "\" >}}",
      files_to_process = c("file1.md")
    ),
    "must be a string"
  )
  
  testthat::expect_error(
    saros.base:::validate_includes_params(
      prefix = NULL,
      suffix = "\" >}}",
      files_to_process = c("file1.md")
    ),
    "must be a string"
  )
})

testthat::test_that("validate_includes_params rejects invalid suffix", {
  testthat::expect_error(
    saros.base:::validate_includes_params(
      prefix = "{{< include \"",
      suffix = c("a", "b"),
      files_to_process = c("file1.md")
    ),
    "must be a string"
  )
})

testthat::test_that("validate_includes_params rejects invalid files_to_process", {
  testthat::expect_error(
    saros.base:::validate_includes_params(
      prefix = "{{< include \"",
      suffix = "\" >}}",
      files_to_process = 123
    ),
    "must be a character vector"
  )
})

# Tests for process_filename_by_level
testthat::test_that("process_filename_by_level handles innermost child correctly", {
  result <- saros.base:::process_filename_by_level("_file.md", path_lvl = 1, total_levels = 3, is_child = TRUE)
  testthat::expect_equal(result, "file.md")
})

testthat::test_that("process_filename_by_level adds underscore for non-innermost child", {
  result <- saros.base:::process_filename_by_level("file.md", path_lvl = 2, total_levels = 3, is_child = TRUE)
  testthat::expect_equal(result, "_file.md")
  
  # Already has underscore
  result2 <- saros.base:::process_filename_by_level("_file.md", path_lvl = 2, total_levels = 3, is_child = TRUE)
  testthat::expect_equal(result2, "_file.md")
})

testthat::test_that("process_filename_by_level handles parent files correctly", {
  result <- saros.base:::process_filename_by_level("file.md", path_lvl = 1, total_levels = 3, is_child = FALSE)
  testthat::expect_equal(result, "_file.md")
  
  # At top level, no underscore added
  result2 <- saros.base:::process_filename_by_level("file.md", path_lvl = 3, total_levels = 3, is_child = FALSE)
  testthat::expect_equal(result2, "file.md")
})

# Tests for create_include_content
testthat::test_that("create_include_content generates correct relative path", {
  result <- saros.base:::create_include_content("_file.md", path_lvl = 1, prefix = "{{< include \"", suffix = "\" >}}")
  testthat::expect_equal(result, "{{< include \"../_file.md\" >}}")
  
  result2 <- saros.base:::create_include_content("_file.md", path_lvl = 3, prefix = "{{< include \"", suffix = "\" >}}")
  testthat::expect_equal(result2, "{{< include \"../../../_file.md\" >}}")
})

testthat::test_that("create_include_content works with custom prefix/suffix", {
  result <- saros.base:::create_include_content("file.qmd", path_lvl = 2, prefix = "[", suffix = "]")
  testthat::expect_equal(result, "[../../file.qmd]")
})

# Tests for add_title_if_needed
testthat::test_that("add_title_if_needed adds title for specified files", {
  content <- "{{< include \"test.md\" >}}"
  result <- saros.base:::add_title_if_needed(content, "path/to/index.qmd", "Group A", c("index.qmd", "report.qmd"))
  
  testthat::expect_true(grepl("---", result))
  testthat::expect_true(grepl("title: Group A", result))
  testthat::expect_true(grepl("include", result))
})

testthat::test_that("add_title_if_needed does not add title when not in files_taking_title", {
  content <- "{{< include \"test.md\" >}}"
  result <- saros.base:::add_title_if_needed(content, "path/to/other.qmd", "Group A", c("index.qmd", "report.qmd"))
  
  testthat::expect_equal(result, content)
})

testthat::test_that("add_title_if_needed does not add title when mesos_group_pretty is NA", {
  content <- "{{< include \"test.md\" >}}"
  result <- saros.base:::add_title_if_needed(content, "path/to/index.qmd", NA_character_, c("index.qmd", "report.qmd"))
  
  testthat::expect_equal(result, content)
})

# Tests for extract_mesos_metadata
testthat::test_that("extract_mesos_metadata extracts basic metadata", {
  test_df <- data.frame(
    region = c("North", "South", "East"),
    abbr = c("N", "S", "E")
  )
  
  result <- saros.base:::extract_mesos_metadata(test_df)
  
  testthat::expect_equal(result$mesos_var, "region")
  testthat::expect_equal(result$mesos_groups_pretty, c("North", "South", "East"))
  testthat::expect_equal(result$mesos_groups_abbr, c("N", "S", "E"))
})

testthat::test_that("extract_mesos_metadata handles missing abbreviations column", {
  # When second column has all NAs, they get filtered out
  test_df <- data.frame(
    region = c("North Region", "South Region"),
    abbr = c(NA, NA)
  )
  
  result <- saros.base:::extract_mesos_metadata(test_df)
  
  testthat::expect_equal(result$mesos_var, "region")
  testthat::expect_equal(result$mesos_groups_pretty, c("North Region", "South Region"))
  # With all NAs in abbr column, they get filtered out (length 0)
  testthat::expect_equal(length(result$mesos_groups_abbr), 0)
})

testthat::test_that("extract_mesos_metadata handles NA values", {
  test_df <- data.frame(
    region = c("North", NA, "South"),
    abbr = c("N", NA, "S")
  )
  
  result <- saros.base:::extract_mesos_metadata(test_df)
  
  testthat::expect_equal(result$mesos_groups_pretty, c("North", "South"))
  testthat::expect_equal(result$mesos_groups_abbr, c("N", "S"))
})

# Tests for process_mesos_subfolders
testthat::test_that("process_mesos_subfolders splits paths correctly", {
  result <- saros.base:::process_mesos_subfolders("folder1/folder2/folder3", j = 1)
  testthat::expect_equal(result, c("folder1", "folder2", "folder3"))
})

testthat::test_that("process_mesos_subfolders handles backslashes", {
  result <- saros.base:::process_mesos_subfolders("folder1\\folder2\\folder3", j = 1)
  testthat::expect_equal(result, c("folder1", "folder2", "folder3"))
})

testthat::test_that("process_mesos_subfolders returns empty character for empty input", {
  result <- saros.base:::process_mesos_subfolders(character(), j = 1)
  testthat::expect_equal(result, character())
})

testthat::test_that("process_mesos_subfolders handles multiple paths with index", {
  result <- saros.base:::process_mesos_subfolders(c("a/b", "c/d/e"), j = 2)
  testthat::expect_equal(result, c("c", "d", "e"))
  
  # j beyond length uses last element
  result2 <- saros.base:::process_mesos_subfolders(c("a/b", "c/d/e"), j = 5)
  testthat::expect_equal(result2, c("c", "d", "e"))
})

