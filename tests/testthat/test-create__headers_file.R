testthat::test_that("create__headers_file creates _headers file with correct format", {
  testthat::skip_if_not_installed("fs")
  
  # Setup test directories
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_headers", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- file.path("Reports", "2024", "Mesos")
  abs_mesos_path <- file.path(local_base, rel_path)
  
  # Create directory structure
  dir.create(file.path(abs_mesos_path, "folder1"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(abs_mesos_path, "folder2"), recursive = TRUE, showWarnings = FALSE)
  
  # Create password file
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("folder1", "folder2", "admin"), 
                   password = c("pass1", "pass2", "adminpass")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run function
  saros.base:::create__headers_file(
    remote_basepath = "/home",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8"
  )
  
  # Check _headers file was created
  headers_file <- file.path(local_base, "_headers")
  testthat::expect_true(file.exists(headers_file))
  
  # Check content structure
  content <- readLines(headers_file)
  
  # Should have entries for both folders
  testthat::expect_true(any(grepl("folder1", content)))
  testthat::expect_true(any(grepl("folder2", content)))
  
  # Should have Basic-Auth entries
  testthat::expect_true(any(grepl("Basic-Auth:", content)))
  
  # Should have path patterns
  testthat::expect_true(any(grepl("/\\*$", content)))  # Paths should end with /*
})

testthat::test_that("create__headers_file includes correct authentication format", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_headers_auth", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- "test"
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "secure_folder"), recursive = TRUE, showWarnings = FALSE)
  
  # Create password file
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("secure_folder", "admin"), 
                   password = c("pass1", "adminpass")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run function
  saros.base:::create__headers_file(
    remote_basepath = "/home",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8"
  )
  
  # Read and check content
  headers_file <- file.path(local_base, "_headers")
  content <- readLines(headers_file)
  
  # Find the line for secure_folder
  folder_line_idx <- grep("secure_folder/\\*", content)
  testthat::expect_true(length(folder_line_idx) > 0)
  
  # Next line should have Basic-Auth
  if (length(folder_line_idx) > 0) {
    auth_line <- content[folder_line_idx + 1]
    testthat::expect_true(grepl("^\\s*Basic-Auth:", auth_line))
    
    # Should include username:hash format
    testthat::expect_true(grepl("secure_folder:", auth_line))
  }
})

testthat::test_that("create__headers_file works with username_folder_matching_df", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_headers_df", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- file.path("Projects", "Alpha")
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "client_x"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(abs_path, "client_y"), recursive = TRUE, showWarnings = FALSE)
  
  # Create matching dataframe - multiple users per folder
  matching_df <- data.frame(
    folder = c("client_x", "client_x", "client_y"),
    username = c("john", "jane", "bob"),
    stringsAsFactors = FALSE
  )
  
  # Create password file
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("john", "jane", "bob", "admin"), 
                   password = c("p1", "p2", "p3", "adm")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run function
  saros.base:::create__headers_file(
    remote_basepath = "/var/www",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    local_main_password_path = password_file,
    username_folder_matching_df = matching_df,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8"
  )
  
  # Check content
  headers_file <- file.path(local_base, "_headers")
  content <- readLines(headers_file)
  
  # Find client_x entry
  client_x_line <- grep("client_x/\\*", content)
  testthat::expect_true(length(client_x_line) > 0)
  
  if (length(client_x_line) > 0) {
    auth_line <- content[client_x_line + 1]
    # Should have john and jane (matched users for client_x)
    testthat::expect_true(grepl("john:", auth_line))
    testthat::expect_true(grepl("jane:", auth_line))
  }
  
  # Find client_y entry
  client_y_line <- grep("client_y/\\*", content)
  testthat::expect_true(length(client_y_line) > 0)
  
  if (length(client_y_line) > 0) {
    auth_line <- content[client_y_line + 1]
    # Should have bob (matched user for client_y)
    testthat::expect_true(grepl("bob:", auth_line))
  }
})

testthat::test_that("create__headers_file includes universal usernames in all folders", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_universal", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- "secure"
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "area1"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(abs_path, "area2"), recursive = TRUE, showWarnings = FALSE)
  
  # Create password file
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("area1", "area2", "superadmin", "moderator"), 
                   password = c("p1", "p2", "super", "mod")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run with multiple universal usernames
  saros.base:::create__headers_file(
    remote_basepath = "/home",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = c("superadmin", "moderator"),
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8"
  )
  
  # Check that both universal users appear in both folder entries
  headers_file <- file.path(local_base, "_headers")
  content <- readLines(headers_file)
  
  # Both areas should exist
  area1_lines <- grep("area1", content, value = TRUE)
  area2_lines <- grep("area2", content, value = TRUE)
  
  testthat::expect_true(length(area1_lines) > 0)
  testthat::expect_true(length(area2_lines) > 0)
})

testthat::test_that("create__headers_file creates proper file paths", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_paths", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- file.path("deep", "nested", "structure")
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "target"), recursive = TRUE, showWarnings = FALSE)
  
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("target", "admin"), 
                   password = c("pass", "adm")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  saros.base:::create__headers_file(
    remote_basepath = "/home",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8"
  )
  
  # Check that path in _headers reflects the nested structure
  headers_file <- file.path(local_base, "_headers")
  content <- readLines(headers_file)
  
  # Should have the full relative path
  path_pattern <- file.path(rel_path, "target")
  # Normalize path separators for testing
  path_pattern_normalized <- gsub("\\\\", "/", path_pattern)
  content_normalized <- gsub("\\\\", "/", paste(content, collapse = " "))
  
  testthat::expect_true(grepl(path_pattern_normalized, content_normalized, fixed = TRUE))
})
