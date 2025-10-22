testthat::test_that("create_htaccess creates .htaccess files with correct content", {
  testthat::skip_if_not_installed("fs")
  
  # Setup test directories
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_htaccess", paste0("run_", as.integer(Sys.time())))
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
  
  # Run function with password_input to avoid prompts
  saros.base:::create_htaccess(
    remote_basepath = "/var/www",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    local_main_password_path = password_file,
    username_folder_matching_df = NULL,
    universal_usernames = "admin",
    log_rounds = 4,  # Lower rounds for faster testing
    append_users = FALSE,
    password_input = "8"
  )
  
  # Check .htaccess files were created
  htaccess1 <- file.path(abs_mesos_path, "folder1", ".htaccess")
  htaccess2 <- file.path(abs_mesos_path, "folder2", ".htaccess")
  
  testthat::expect_true(file.exists(htaccess1))
  testthat::expect_true(file.exists(htaccess2))
  
  # Check content of .htaccess
  content1 <- readLines(htaccess1)
  testthat::expect_true(any(grepl("folder1", content1)))
  testthat::expect_true(any(grepl("AuthName", content1)))
  testthat::expect_true(any(grepl("AuthUserFile", content1)))
  testthat::expect_true(any(grepl("AuthType Basic", content1)))
  testthat::expect_true(any(grepl("Require valid-user", content1)))
  
  # Check .htpasswd files were created
  htpasswd1 <- file.path(abs_mesos_path, "folder1", ".htpasswd")
  htpasswd2 <- file.path(abs_mesos_path, "folder2", ".htpasswd")
  
  testthat::expect_true(file.exists(htpasswd1))
  testthat::expect_true(file.exists(htpasswd2))
  
  # Check .htpasswd content structure
  passwd_content1 <- readLines(htpasswd1)
  testthat::expect_true(any(grepl("^folder1:", passwd_content1)))
  testthat::expect_true(any(grepl("^admin:", passwd_content1)))
})

testthat::test_that("create_htaccess works with username_folder_matching_df", {
  testthat::skip_if_not_installed("fs")
  
  # Setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_htaccess_df", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- file.path("Reports", "2024", "Mesos")
  abs_mesos_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_mesos_path, "company_a"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(abs_mesos_path, "company_b"), recursive = TRUE, showWarnings = FALSE)
  
  # Create matching dataframe
  matching_df <- data.frame(
    folder = c("company_a", "company_b", "company_b"),
    username = c("user1", "user2", "user3"),
    stringsAsFactors = FALSE
  )
  
  # Create password file with all users
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = c("user1", "user2", "user3", "admin"), 
                   password = c("p1", "p2", "p3", "adm")),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  # Run function
  saros.base:::create_htaccess(
    remote_basepath = "/home",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    local_main_password_path = password_file,
    username_folder_matching_df = matching_df,
    universal_usernames = "admin",
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8"
  )
  
  # Check that htpasswd for company_a has user1
  htpasswd_a <- file.path(abs_mesos_path, "company_a", ".htpasswd")
  content_a <- readLines(htpasswd_a)
  testthat::expect_true(any(grepl("^user1:", content_a)))
  testthat::expect_true(any(grepl("^admin:", content_a)))
  
  # Check that htpasswd for company_b has user2 and user3
  htpasswd_b <- file.path(abs_mesos_path, "company_b", ".htpasswd")
  content_b <- readLines(htpasswd_b)
  testthat::expect_true(any(grepl("^user2:", content_b)))
  testthat::expect_true(any(grepl("^user3:", content_b)))
  testthat::expect_true(any(grepl("^admin:", content_b)))
})

testthat::test_that("create_htaccess returns invisibly", {
  testthat::skip_if_not_installed("fs")
  
  # Minimal setup
  temp_base <- tempdir()
  test_dir <- file.path(temp_base, "test_invisible", paste0("run_", as.integer(Sys.time())))
  local_base <- file.path(test_dir, "_site")
  rel_path <- "test"
  abs_path <- file.path(local_base, rel_path)
  
  dir.create(file.path(abs_path, "folder1"), recursive = TRUE, showWarnings = FALSE)
  
  password_file <- file.path(test_dir, ".test_htpasswd")
  saros.base:::write_htpasswd_file(
    x = data.frame(username = "folder1", password = "pass1"),
    file = password_file,
    header = TRUE
  )
  
  on.exit(unlink(test_dir, recursive = TRUE), add = TRUE)
  
  result <- saros.base:::create_htaccess(
    remote_basepath = "/test",
    local_basepath = local_base,
    rel_path_base_to_parent_of_user_restricted_folder = rel_path,
    local_main_password_path = password_file,
    universal_usernames = character(0),
    log_rounds = 4,
    append_users = FALSE,
    password_input = "8"
  )
  
  testthat::expect_null(result)
})
