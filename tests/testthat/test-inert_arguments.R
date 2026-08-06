# Regression tests for GH #232.
#
# Both arguments were documented, present in the signature, and never read.

################################################################################
testthat::test_that("create_r_files() honours r_add_file_scope", {
  source_csv <- withr::local_tempfile(fileext = ".csv")
  utils::write.csv2(
    data.frame(
      folder_name = "01_folder",
      file_name = "01_script",
      file_scope = "SCOPE TEXT",
      folder_scope = "FOLDER SCOPE",
      optional = 1L,
      r_files_source_path = "x"
    ),
    file = source_csv,
    row.names = FALSE
  )

  with_scope <- withr::local_tempdir()
  saros.base::create_r_files(
    r_files_out_path = with_scope,
    r_files_source_path = source_csv,
    r_add_file_scope = TRUE
  )

  without_scope <- withr::local_tempdir()
  saros.base::create_r_files(
    r_files_out_path = without_scope,
    r_files_source_path = source_csv,
    r_add_file_scope = FALSE
  )

  written <- fs::path(with_scope, "01_script.R")
  omitted <- fs::path(without_scope, "01_script.R")

  # The placeholder file is created either way ...
  testthat::expect_true(fs::file_exists(written))
  testthat::expect_true(fs::file_exists(omitted))

  # ... but only the flagged one carries the scope text.
  testthat::expect_match(
    paste(readLines(written, warn = FALSE), collapse = "\n"),
    "SCOPE TEXT",
    fixed = TRUE
  )
  testthat::expect_false(
    grepl("SCOPE TEXT", paste(readLines(omitted, warn = FALSE), collapse = "\n"), fixed = TRUE)
  )
})

################################################################################
# Password file in the format read_main_password_file() expects.
local_password_file <- function(usernames, envir = parent.frame()) {
  path <- withr::local_tempfile(.local_envir = envir)
  writeLines(
    c("username:password", paste0(usernames, ":secret", seq_along(usernames))),
    path
  )
  path
}

testthat::test_that("create_email_credentials() warns about credentialled users with no email", {
  # "ada" has a password but no email address, so would silently receive nothing.
  password_file <- local_password_file(c("ada", "grace"))
  emails <- data.frame(username = "grace", email = "grace@example.net")

  testthat::expect_warning(
    saros.base::create_email_credentials(
      email_data_frame = emails,
      local_main_password_path = password_file
    ),
    regexp = "ada"
  )
})

testthat::test_that("create_email_credentials() honours ignore_missing_emails", {
  password_file <- local_password_file(c("ada", "grace"))
  emails <- data.frame(username = "grace", email = "grace@example.net")

  testthat::expect_no_warning(
    saros.base::create_email_credentials(
      email_data_frame = emails,
      local_main_password_path = password_file,
      ignore_missing_emails = TRUE
    )
  )
})

testthat::test_that("create_email_credentials() is silent when every account has an email", {
  password_file <- local_password_file(c("ada", "grace"))
  emails <- data.frame(
    username = c("ada", "grace"),
    email = c("ada@example.net", "grace@example.net")
  )

  testthat::expect_no_warning(
    saros.base::create_email_credentials(
      email_data_frame = emails,
      local_main_password_path = password_file
    )
  )
})

testthat::test_that("create_email_credentials() still warns in the original direction", {
  # Pre-existing behaviour: an email row with no matching password entry.
  password_file <- local_password_file("grace")
  emails <- data.frame(
    username = c("grace", "hopper"),
    email = c("grace@example.net", "hopper@example.net")
  )

  testthat::expect_warning(
    saros.base::create_email_credentials(
      email_data_frame = emails,
      local_main_password_path = password_file
    ),
    regexp = "hopper"
  )
})
