testthat::test_that("refer_main_password_file", {
  file <- tempfile(fileext = ".htpasswd_private")
  saros.base:::write_htpasswd_file(x = data.frame(username = "test", password = "test"), file = file)
  if (interactive()) {
    saros.base:::refer_main_password_file(x = file, usernames = "test2", append_users = TRUE, password_input = "prompt") |>
      testthat::expect_equal(expected = NULL)
  }
  saros.base:::refer_main_password_file(x = file, usernames = "test3", append_users = TRUE, password_input = "12") |>
    testthat::expect_type("character")
})

testthat::test_that("refer_main_password_file vectorization works with multiple users", {
  # Create a password file with multiple users
  file <- tempfile(fileext = ".htpasswd_private")
  users_df <- data.frame(
    username = c("user1", "user2", "user3"),
    password = c("pass1", "pass2", "pass3")
  )
  saros.base:::write_htpasswd_file(x = users_df, file = file, header = TRUE)

  # Test retrieving multiple existing users at once
  result <- saros.base:::refer_main_password_file(
    x = file,
    usernames = c("user1", "user2", "user3")
  )

  testthat::expect_type(result, "character")
  testthat::expect_length(result, 3)
  testthat::expect_named(result, c("user1", "user2", "user3"))

  # Test retrieving a subset of users
  result_subset <- saros.base:::refer_main_password_file(
    x = file,
    usernames = c("user2", "user3")
  )

  testthat::expect_type(result_subset, "character")
  testthat::expect_length(result_subset, 2)
  testthat::expect_named(result_subset, c("user2", "user3"))

  # Test single user (still works)
  result_single <- saros.base:::refer_main_password_file(
    x = file,
    usernames = "user1"
  )

  testthat::expect_type(result_single, "character")
  testthat::expect_length(result_single, 1)
  testthat::expect_named(result_single, "user1")
})

testthat::test_that("refer_main_password_file handles missing users correctly", {
  # Create a password file with some users
  file <- tempfile(fileext = ".htpasswd_private")
  users_df <- data.frame(
    username = c("existing1", "existing2"),
    password = c("pass1", "pass2")
  )
  saros.base:::write_htpasswd_file(x = users_df, file = file, header = TRUE)

  # Test error when user not found and append_users = FALSE
  testthat::expect_error(
    saros.base:::refer_main_password_file(
      x = file,
      usernames = "nonexistent",
      append_users = FALSE
    ),
    "Unable to find password"
  )

  # Test appending new user with generated password
  result <- saros.base:::refer_main_password_file(
    x = file,
    usernames = "newuser",
    append_users = TRUE,
    password_input = "8"
  )

  testthat::expect_type(result, "character")
  testthat::expect_length(result, 1)
  testthat::expect_named(result, "newuser")

  # Verify the user was actually added to the file
  updated_table <- saros.base:::read_main_password_file(file = file)
  testthat::expect_true("newuser" %in% updated_table$username)
})

testthat::test_that("setup_access_restrictions validates arguments correctly", {
  testthat::skip_if_not_installed("fs")
  
  # Test that invalid username_folder_matching_df is rejected
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_validate", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  
  dir.create(local_base, recursive = TRUE, showWarnings = FALSE)
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Invalid dataframe - wrong columns
  bad_df <- data.frame(wrong = "col1", names = "col2")
  
  testthat::expect_error(
    setup_access_restrictions(
      remote_basepath = "/home",
      local_basepath = local_base,
      rel_path_base_to_parent_of_user_restricted_folder = "test",
      local_main_password_path = ".test",
      username_folder_matching_df = bad_df,
      type = "netlify"
    ),
    "username_folder_matching_df"
  )
  
  # Not a dataframe
  testthat::expect_error(
    setup_access_restrictions(
      remote_basepath = "/home",
      local_basepath = local_base,
      rel_path_base_to_parent_of_user_restricted_folder = "test",
      local_main_password_path = ".test",
      username_folder_matching_df = list(a = 1, b = 2),
      type = "netlify"
    ),
    "username_folder_matching_df"
  )
})

testthat::test_that("setup_access_restrictions creates netlify _headers file", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_netlify", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- "secure"
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "folder1"), recursive = TRUE, showWarnings = FALSE)
  
  # Create password file
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("folder1", "admin"), 
                   password = c("pass1", "adminpass")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run with netlify type - function returns NULL
  setup_access_restrictions(
    remote_basepath = "/home",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    warn = FALSE,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8",
    type = "netlify"
  )
  
  # Check _headers file was created
  headers_file <- file.path(local_base, "_headers")
  testthat::expect_true(file.exists(headers_file))
})

testthat::test_that("setup_access_restrictions creates apache .htaccess files", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_apache", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- "secure"
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "folder1"), recursive = TRUE, showWarnings = FALSE)
  
  # Create password file
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("folder1", "admin"), 
                   password = c("pass1", "adminpass")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run with apache type
  result <- setup_access_restrictions(
    remote_basepath = "/var/www",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    warn = FALSE,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8",
    type = "apache"
  )
  
  # Check .htaccess file was created
  htaccess_file <- file.path(abs_path, "folder1", ".htaccess")
  testthat::expect_true(file.exists(htaccess_file))
  
  # Check .htpasswd file was created
  htpasswd_file <- file.path(abs_path, "folder1", ".htpasswd")
  testthat::expect_true(file.exists(htpasswd_file))
})

testthat::test_that("setup_access_restrictions can create both types simultaneously", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_both", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- "protected"
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "area1"), recursive = TRUE, showWarnings = FALSE)
  
  # Create password file
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("area1", "admin"), 
                   password = c("pass1", "adminpass")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run with both types
  setup_access_restrictions(
    remote_basepath = "/home",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    warn = FALSE,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8",
    type = c("netlify", "apache")
  )
  
  # Check both file types exist
  headers_file <- file.path(local_base, "_headers")
  testthat::expect_true(file.exists(headers_file))
  
  htaccess_file <- file.path(abs_path, "area1", ".htaccess")
  testthat::expect_true(file.exists(htaccess_file))
})

testthat::test_that("setup_access_restrictions handles multiple rel_paths", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_multipaths", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path1 <- "project_a"
  rel_path2 <- "project_b"
  
  dir.create(file.path(local_base, rel_path1, "folder1"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(local_base, rel_path2, "folder2"), recursive = TRUE, showWarnings = FALSE)
  
  # Create password file
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("folder1", "folder2", "admin"), 
                   password = c("p1", "p2", "adm")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run with multiple paths
  result <- setup_access_restrictions(
    remote_basepath = "/home",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = c(rel_path1, rel_path2),
    warn = FALSE,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8",
    type = "netlify"
  )
  
  # Check _headers contains both paths
  headers_file <- file.path(local_base, "_headers")
  testthat::expect_true(file.exists(headers_file))
  
  content <- readLines(headers_file)
  testthat::expect_true(any(grepl("folder1", content)))
  testthat::expect_true(any(grepl("folder2", content)))
})

testthat::test_that("setup_access_restrictions strips trailing slash from remote_basepath", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_slash", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- "test"
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "folder1"), recursive = TRUE, showWarnings = FALSE)
  
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("folder1", "admin"), 
                   password = c("p1", "adm")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run with trailing slash - should work without error
  testthat::expect_no_error(
    setup_access_restrictions(
      remote_basepath = "/var/www/",  # Note trailing slash
      local_basepath = local_base,
      rel_path_base_to_parent_of_user_restricted_folder = rel_path,
      warn = FALSE,
      local_main_password_path = password_file,
      username_folder_matching_df = NULL,
      universal_usernames = "admin",
      log_rounds = 4,
      append_users = FALSE,
      password_input = "8",
      type = "apache"
    )
  )
  
  # File should still be created
  htaccess_file <- file.path(abs_path, "folder1", ".htaccess")
  testthat::expect_true(file.exists(htaccess_file))
})
