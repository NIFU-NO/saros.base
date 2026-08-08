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

################################################################################
# Regression tests for GH #245.
#
# `draft_report(log_file=)` was documented, declared as a formal and validated,
# but never read. It was not always dead: c73000f ("Remove timing in
# draft_report as it takes short time now") deleted the run-time entry it used
# to write and left the argument behind.
#
# Separately, both functions documented a default of `"_log.txt"` while the
# actual default was -- and deliberately remains -- `NULL`.

# The smallest overview that still refines into a usable chapter_structure.
# `ex_survey` has 32 columns and this uses one, so the unused list is long.
local_one_chapter_structure <- function() {
  suppressMessages(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(
        chapter = "Bakgrunn", dep = "x1_sex", indep = ""
      ),
      data = saros.base::ex_survey
    )
  )
}

testthat::test_that("draft_report(log_file=) writes the log file it documents", {
  log_file <- withr::local_tempfile(fileext = ".txt")

  suppressMessages(
    saros.base::draft_report(
      chapter_structure = local_one_chapter_structure(),
      data = saros.base::ex_survey,
      path = withr::local_tempdir(),
      log_file = log_file
    )
  )

  testthat::expect_true(file.exists(log_file))

  content <- paste(readLines(log_file, warn = FALSE), collapse = "\n")
  testthat::expect_match(content, "Not using the following variables", fixed = TRUE)
  # In `data`, absent from this chapter_structure.
  testthat::expect_match(content, "open_comments", fixed = TRUE)
  # The one variable the report actually uses, so it must not be listed.
  testthat::expect_false(grepl("x1_sex", content, fixed = TRUE))
})

testthat::test_that("draft_report(log_file=) counts auxiliary_variables as used", {
  # `log_unused_variables()` has always had an `auxiliary_variables` parameter
  # that no caller ever supplied. `refine_chapter_overview()` has no such
  # argument and so cannot supply it; `draft_report()` is the only function
  # that can, which is what makes its list the accurate one.
  chapter_structure <- local_one_chapter_structure()

  without_aux <- withr::local_tempfile(fileext = ".txt")
  suppressMessages(
    saros.base::draft_report(
      chapter_structure = chapter_structure,
      data = saros.base::ex_survey,
      path = withr::local_tempdir(),
      log_file = without_aux
    )
  )

  with_aux <- withr::local_tempfile(fileext = ".txt")
  suppressMessages(
    saros.base::draft_report(
      chapter_structure = chapter_structure,
      data = saros.base::ex_survey,
      path = withr::local_tempdir(),
      auxiliary_variables = "open_comments",
      log_file = with_aux
    )
  )

  testthat::expect_match(
    paste(readLines(without_aux, warn = FALSE), collapse = "\n"),
    "open_comments",
    fixed = TRUE
  )
  testthat::expect_false(
    grepl(
      "open_comments",
      paste(readLines(with_aux, warn = FALSE), collapse = "\n"),
      fixed = TRUE
    )
  )
})

testthat::test_that("draft_report(log_file = NULL) writes no log at all", {
  # Pins the decision that logging stays off by default, and in particular that
  # the `"_log.txt"` the docs used to claim is never written into the working
  # directory. NB: this also passed against the pre-fix code, where the
  # argument was inert -- it guards the decision, not the defect.
  out_path <- withr::local_tempdir()
  working_dir <- withr::local_tempdir()

  withr::with_dir(working_dir, {
    suppressMessages(
      saros.base::draft_report(
        chapter_structure = local_one_chapter_structure(),
        data = saros.base::ex_survey,
        path = out_path
      )
    )
  })

  testthat::expect_false(file.exists(file.path(working_dir, "_log.txt")))
  testthat::expect_equal(list.files(working_dir, all.files = TRUE, no.. = TRUE), character(0))
})

# Pull the `*default:*` value out of the roxygen @param block for `param`.
roxygen_documented_default <- function(path, param) {
  src <- readLines(path, warn = FALSE)

  start <- grep(paste0("^\\s*#'\\s*@param\\s+", param, "\\s"), src)
  if (length(start) != 1L) {
    return(paste0("<", length(start), " @param blocks for ", param, ">"))
  }

  section <- src[(start + 1L):length(src)]
  next_tag <- grep("^\\s*#'\\s*@", section)
  if (length(next_tag) > 0L) section <- section[seq_len(next_tag[1] - 1L)]

  hit <- regmatches(section, regexec("\\*default:\\*\\s*`([^`]*)`", section))
  hit <- Filter(function(x) length(x) == 2L, hit)
  if (length(hit) != 1L) {
    return(paste0("<", length(hit), " documented defaults for ", param, ">"))
  }
  hit[[1]][2]
}

testthat::test_that("the documented default for log_file matches the formal", {
  # The doc/formal drift this pins has now appeared twice (#232, #245). A
  # general sweep of every `*default:*` in R/ is feasible -- the same parse
  # works -- but currently reports roughly fifteen further genuine mismatches
  # in these two files alone, plus false positives on multi-argument @param
  # tags that carry one combined default and on `match.arg()`-style arguments
  # whose documented default is the effective first element. That is its own
  # piece of work; this test pins the argument at hand.
  testthat::skip_on_cran()

  r_dir <- testthat::test_path("..", "..", "R")
  # An *installed* package also has an R/ directory, but it holds the .rdb
  # rather than sources, so scanning it would pass vacuously.
  testthat::skip_if(
    length(list.files(r_dir, pattern = "[.][Rr]$")) == 0,
    "no R/ sources available (running against an installed package)"
  )

  specs <- list(
    draft_report.R = saros.base::draft_report,
    refine_chapter_overview.R = saros.base::refine_chapter_overview
  )

  documented <- vapply(
    names(specs),
    function(file) roxygen_documented_default(file.path(r_dir, file), "log_file"),
    character(1)
  )
  actual <- vapply(
    specs,
    function(fn) paste(deparse(formals(fn)$log_file), collapse = ""),
    character(1)
  )

  testthat::expect_equal(documented, actual)
})
