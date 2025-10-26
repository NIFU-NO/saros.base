test_that("setup_mesos_structure requires main_directory", {
  expect_error(
    setup_mesos_structure(
      files_to_process = "_test.qmd",
      mesos_groups = list(region = c("North", "South"))
    ),
    "main_directory.*required"
  )
})

test_that("setup_mesos_structure requires files_to_process", {
  expect_error(
    setup_mesos_structure(
      main_directory = tempdir(),
      mesos_groups = list(region = c("North", "South"))
    ),
    "files_to_process.*required"
  )
})

test_that("setup_mesos_structure requires mesos_groups", {
  temp_file <- tempfile(pattern = "_", fileext = ".qmd")
  cat("# Test\n", file = temp_file)

  expect_error(
    setup_mesos_structure(
      main_directory = tempdir(),
      files_to_process = temp_file
    ),
    "mesos_groups.*required"
  )

  unlink(temp_file)
})

test_that("setup_mesos_structure works with named list", {
  # Create a temporary template file
  temp_dir <- tempfile()
  dir.create(temp_dir)

  temp_file <- file.path(temp_dir, "_test.qmd")
  cat("# Test content\n", file = temp_file)

  main_directory <- file.path(temp_dir, "output")

  result <- setup_mesos_structure(
    main_directory = main_directory,
    files_to_process = temp_file,
    mesos_groups = list(
      region = c("North", "South")
    )
  )

  # Check that directories were created
  expect_true(dir.exists(file.path(main_directory, "region")))
  expect_true(dir.exists(file.path(main_directory, "region", "North")))
  expect_true(dir.exists(file.path(main_directory, "region", "South")))

  # Check that stub files were created
  expect_true(file.exists(file.path(main_directory, "region", "North", "test.qmd")))
  expect_true(file.exists(file.path(main_directory, "region", "South", "test.qmd")))

  # Check that metadata files were created
  expect_true(file.exists(file.path(main_directory, "region", "_metadata.yml")))
  expect_true(file.exists(file.path(main_directory, "region", "North", "_metadata.yml")))
  expect_true(file.exists(file.path(main_directory, "region", "South", "_metadata.yml")))

  # Clean up
  unlink(temp_dir, recursive = TRUE)
})

test_that("convert_mesos_groups_to_df handles named list", {
  result <- convert_mesos_groups_to_df(
    list(region = c("North", "South"), dept = c("Sales", "IT"))
  )

  expect_equal(length(result), 2)
  expect_true(is.data.frame(result[[1]]))
  expect_equal(names(result[[1]]), "region")
  expect_equal(as.character(result[[1]]$region), c("North", "South"))
  expect_equal(attr(result[[1]]$region, "label"), "region")
})

test_that("convert_mesos_groups_to_df handles data frame", {
  df <- data.frame(
    region = c("North", "South"),
    dept = c("Sales", "IT")
  )

  result <- convert_mesos_groups_to_df(df)

  expect_equal(length(result), 2)
  expect_true(is.data.frame(result[[1]]))
  expect_equal(names(result[[1]]), "region")
  expect_equal(as.character(result[[1]]$region), c("North", "South"))
})

test_that("convert_mesos_groups_to_df handles list of data frames (legacy)", {
  legacy_format <- list(
    data.frame(region = c("North", "South")),
    data.frame(dept = c("Sales", "IT"))
  )

  result <- convert_mesos_groups_to_df(legacy_format)

  expect_equal(length(result), 2)
  expect_identical(result, legacy_format)
})

test_that("convert_mesos_groups_to_df errors on invalid input", {
  expect_error(
    convert_mesos_groups_to_df("invalid"),
    "mesos_groups"
  )

  expect_error(
    convert_mesos_groups_to_df(list(123)),
    "named list"
  )
})
