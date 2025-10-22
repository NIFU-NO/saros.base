testthat::test_that("validate_access_folder_paths validates all path arguments", {
  # Valid inputs - should not error
  testthat::expect_silent(
    validate_access_folder_paths(
      remote_basepath = "https://example.com",
      local_basepath = "_site",
      rel_path_base_to_parent_of_user_restricted_folder = file.path("Reports", "2023", "Mesos")
    )
  )
  
  # Test with different valid paths
  testthat::expect_silent(
    validate_access_folder_paths(
      remote_basepath = "/var/www/html",
      local_basepath = "output",
      rel_path_base_to_parent_of_user_restricted_folder = "docs/restricted"
    )
  )
  
  # Invalid remote_basepath (not a string)
  testthat::expect_error(
    validate_access_folder_paths(
      remote_basepath = NULL,
      local_basepath = "_site"
    )
  )
  
  testthat::expect_error(
    validate_access_folder_paths(
      remote_basepath = "r-project.org",
      local_basepath = NULL
    )
  )
  
  # Test warn = TRUE (should warn instead of abort)
  testthat::expect_warning(
    validate_access_folder_paths(
      remote_basepath = NULL,
      local_basepath = "_site",
      warn = TRUE
    )
  )
})
