testthat::test_that("filename_sanitizer works with typical input", {
  x <- c("Too long a name", "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, c("Too_long_a_name", "with_invalid"))
})

testthat::test_that("filename_sanitizer handles max_chars", {
  x <- c("Too long a name", "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x, max_chars = 10)
  testthat::expect_equal(result, c("Too_long_a", "with_inval"))
})

testthat::test_that("filename_sanitizer handles accept_hyphen", {
  x <- c("Too-long-a-name", "with-invalid-*^/&#")
  result <- saros.base:::filename_sanitizer(x, accept_hyphen = TRUE)
  testthat::expect_equal(result, c("Too-long-a-name", "with-invalid"))
})

testthat::test_that("filename_sanitizer handles valid_obj", {
  x <- c("123Too long a name", "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x, valid_obj = TRUE)
  testthat::expect_equal(result, c("Too_long_a_name", "with_invalid"))
})

testthat::test_that("filename_sanitizer handles to_lower", {
  x <- c("Too long a name", "WITH INVALID *^/&#")
  result <- saros.base:::filename_sanitizer(x, to_lower = TRUE)
  testthat::expect_equal(result, c("too_long_a_name", "with_invalid"))
})

testthat::test_that("filename_sanitizer handles make_unique", {
  x <- c("Too long a name", "Too long a name")
  result <- saros.base:::filename_sanitizer(x, make_unique = TRUE)
  testthat::expect_equal(result, c("Too_long_a_name", "Too_long_a_name_1"))
})

testthat::test_that("filename_sanitizer handles custom sep", {
  x <- c("Too long a name", "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x, sep = "-")
  testthat::expect_equal(result, c("Too-long-a-name", "with-invalid"))
})

testthat::test_that("filename_sanitizer handles empty input", {
  x <- character(0)
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, character(0))
})

testthat::test_that("filename_sanitizer handles NA values in input", {
  x <- c("Too long a name", NA, "with invalid *^/&#")
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, c("Too_long_a_name", NA, "with_invalid"))
})

testthat::test_that("filename_sanitizer handles special characters", {
  x <- c("hello-world", "goodbye-world")
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, c("hello_world", "goodbye_world"))
})

testthat::test_that("filename_sanitizer handles numeric characters", {
  x <- c("12345", "67890")
  result <- saros.base:::filename_sanitizer(x)
  testthat::expect_equal(result, c("12345", "67890"))
})

testthat::test_that("filename_sanitizer handles different character lengths", {
  x <- c("short", "a very very very long name")
  result <- saros.base:::filename_sanitizer(x, max_chars = 10)
  testthat::expect_equal(result, c("short", "a_very_ver"))
})

testthat::test_that("filename_sanitizer handles truncation", {
  x <- c("too_long_a_name", "another_long_name")
  result <- saros.base:::filename_sanitizer(x, max_chars = 8)
  testthat::expect_equal(result, c("too_long", "another"))
})

################################################################################
# GH #244: filename_sanitizer() used to return "" whenever every character was
# stripped -- the regex replaced them all with `sep`, and
# avoid_ending_with_specials() then removed those. Callers build paths from the
# result, and fs::path() drops an empty segment silently, so <parent>/""/file
# resolves to <parent>/file and overwrites whatever lives there.

testthat::test_that("filename_sanitizer never returns an empty string", {
  pathological <- list(
    all_punctuation = c("***", "///", "!!!", "???", "..."),
    hyphens_only = c("---", "-"),
    whitespace_only = c("   ", "\t", "\n", " \t\n "),
    the_empty_string = "",
    # Built from code points rather than written literally, so the test does
    # not depend on this file's encoding surviving a round trip: CJK, em/en
    # dashes and guillemets, all of which
    # iconv(to = "ASCII//TRANSLIT", sub = "") can drop entirely.
    transliterates_away = c(
      intToUtf8(c(0x4e2d, 0x6587)),
      intToUtf8(c(0x65e5, 0x672c, 0x8a9e)),
      intToUtf8(c(0x2014, 0x2013)),
      intToUtf8(c(0x00ab, 0x00bb))
    ),
    mixed = c("Skole A", "***", "///", "!!!")
  )

  for (label in names(pathological)) {
    for (accept_hyphen in c(FALSE, TRUE)) {
      result <- saros.base:::filename_sanitizer(
        pathological[[label]],
        max_chars = 12, accept_hyphen = accept_hyphen, make_unique = TRUE
      )
      testthat::expect_true(
        all(nzchar(result)),
        info = paste0(label, ", accept_hyphen = ", accept_hyphen)
      )
    }
  }
})

testthat::test_that("filename_sanitizer never returns an empty string under any flag combination", {
  # `valid_obj` strips leading non-alphabetic characters and `to_lower` and
  # `sep` rewrite the rest, so the substitution has to survive all of them.
  x <- c("***", "123", intToUtf8(0x2014))
  grid <- expand.grid(
    valid_obj = c(FALSE, TRUE), to_lower = c(FALSE, TRUE),
    make_unique = c(FALSE, TRUE), sep = c("_", "-", "."),
    stringsAsFactors = FALSE
  )

  for (i in seq_len(nrow(grid))) {
    result <- saros.base:::filename_sanitizer(
      x,
      sep = grid$sep[i], valid_obj = grid$valid_obj[i],
      to_lower = grid$to_lower[i], make_unique = grid$make_unique[i]
    )
    testthat::expect_true(
      all(nzchar(result)),
      info = paste(names(grid), unlist(grid[i, ]), sep = " = ", collapse = ", ")
    )
  }
})

testthat::test_that("filename_sanitizer never returns an empty string when max_chars truncates the name away", {
  # Emptiness does not only come from the character class: truncating "_abc" to
  # one character leaves the separator, which avoid_ending_with_specials()
  # removes.
  result <- saros.base:::filename_sanitizer(c("_abc", "!def"), max_chars = 1)
  testthat::expect_true(all(nzchar(result)))
})

testthat::test_that("filename_sanitizer substitutes a path-safe segment", {
  result <- saros.base:::filename_sanitizer(c("Skole A", "***", "///"),
    max_chars = 12, accept_hyphen = TRUE, make_unique = TRUE
  )

  # Names that sanitize away collapse onto one substitute, which make_unique
  # then separates -- exactly as it does for any other collapsing input.
  testthat::expect_equal(result, c("Skole_A", "unnamed", "unnamed_1"))
  testthat::expect_equal(anyDuplicated(result), 0L)

  # The property that matters: the result survives as its own path component.
  for (segment in result) {
    testthat::expect_length(fs::path_split(fs::path("parent", segment, "file.yml"))[[1]], 3)
  }
})

testthat::test_that("filename_sanitizer maps equal inputs to equal outputs without make_unique", {
  # add_chapter_foldername_to_chapter_structure() sanitizes the whole chapter
  # column -- one element per row, so a chapter repeats -- with
  # make_unique = FALSE. A substitute derived from the element's position would
  # give one chapter a different folder name in each of its rows.
  result <- saros.base:::filename_sanitizer(
    c("Intro", "***", "***", "***", "Outro"),
    max_chars = 64, accept_hyphen = FALSE, make_unique = FALSE
  )

  testthat::expect_true(all(nzchar(result)))
  testthat::expect_length(unique(result[2:4]), 1L)
})

testthat::test_that("a chapter that sanitizes away still gets exactly one folder name", {
  # The same invariant at the call site that depends on it. Not a #244 guard --
  # this passes before the fix too, because "" was at least a *consistent*
  # empty name. It guards the fix itself: the first attempt substituted
  # "unnamed<position>", which split this one chapter across three folders.
  chapter_structure <- tibble::tibble(
    chapter = c("Intro", "***", "***", "***", "Outro"),
    .variable_name_dep = paste0("v", 1:5)
  )

  result <- saros.base:::add_chapter_foldername_to_chapter_structure(chapter_structure)

  testthat::expect_true(all(nzchar(result$.chapter_foldername)))
  per_chapter <- tapply(
    result$.chapter_foldername, result$chapter,
    function(names) length(unique(names))
  )
  testthat::expect_true(all(per_chapter == 1L))
})

testthat::test_that("filename_sanitizer leaves NA and zero-length input alone", {
  # NA means "no name supplied", which is not the same as "a name that
  # sanitized away", and callers such as create_includes_content_path_df()
  # distinguish the two.
  testthat::expect_equal(
    saros.base:::filename_sanitizer(c("***", NA, "ok")),
    c("unnamed", NA, "ok")
  )
  testthat::expect_equal(saros.base:::filename_sanitizer(character(0)), character(0))
})
