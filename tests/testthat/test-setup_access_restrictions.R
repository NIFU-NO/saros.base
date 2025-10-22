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
