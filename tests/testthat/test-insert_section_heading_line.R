# `glue_heading_for_group` reaches the heading *text*; the pre-existing
# `prefix_heading_for_group`/`suffix_heading_for_group` cannot.
#
# Those two wrap the heading in whole lines -- `stri_c(prefix, "\n", "##", ...)`
# puts the prefix above the `##` and the suffix below the anchor -- so a report
# grouped by an indep variable emits
#
#   ## Self-efficacy
#   ### Gender
#
# and a reader who sees only the sub-heading and the figure has lost the noun
# the section is about. Reaching inside the heading is the only way to write
# "### By gender", and a search-and-replace over generated .qmd is too brittle.
#
# The template is keyed on the *grouping* column, matching the four sibling
# `*_heading_for_group` arguments, NOT on the column that supplies the text.
# Under the defaults those differ: `.variable_name_indep` is grouped on, while
# `replace_heading_for_group` makes `.variable_label_suffix_indep` supply the
# label. The fixture keeps both columns so that distinction can be pinned.

grouping_vars <- c(".chapter_number", ".variable_name_indep")

chapter_structure_fixture <-
  tibble::tibble(
    .chapter_number = c("Self-efficacy", "Self-efficacy"),
    .variable_name_indep = c("x1_sex", "x2_human_cap"),
    .variable_label_suffix_indep = c("Gender", "Human capital")
  )

# insert_section_heading_line() reads only the column *names* off this, to find
# which group `level` refers to.
grouped_data_fixture <-
  dplyr::distinct(
    chapter_structure_fixture,
    dplyr::pick(tidyselect::all_of(grouping_vars))
  )

# The path of chosen values down to this node, in the side-channel form
# gen_qmd_node() builds: values are the grouping columns, names are the value
# picked at each level.
heading_of <- function(level, value, ...) {
  grouping_structure <- grouping_vars
  names(grouping_structure) <- c("Self-efficacy", "x1_sex")
  saros.base:::insert_section_heading_line(
    grouped_data = grouped_data_fixture,
    level = level,
    chapter_structure = chapter_structure_fixture,
    value = value,
    grouping_structure = grouping_structure,
    replace_heading_for_group = c(".variable_label_suffix_indep" = ".variable_name_indep"),
    ...
  )
}

anchor_of <- function(x) sub("^.*\\{#sec-([^}]+)\\}.*$", "\\1", x)

################################################################################

testthat::test_that("a template rewrites the heading text of its group", {
  testthat::expect_match(
    heading_of(2, "x1_sex",
      glue_heading_for_group = c(.variable_name_indep = "By {tolower(heading)}")
    ),
    "^\n## By gender\\{#sec-"
  )
})

testthat::test_that("a group with no template of its own is left alone", {
  # Same call, same argument -- only the level differs, so this fails if the
  # template is applied to every heading rather than to the group named.
  testthat::expect_match(
    heading_of(1, "Self-efficacy",
      glue_heading_for_group = c(.variable_name_indep = "By {tolower(heading)}")
    ),
    "^\n# Self-efficacy\\{#sec-"
  )
})

testthat::test_that("the template is keyed on the grouping column, not on the column supplying the text", {
  # `.variable_label_suffix_indep` is where "Gender" comes from, but it is not
  # grouped on, so it names no heading and must not match.
  testthat::expect_match(
    heading_of(2, "x1_sex",
      glue_heading_for_group = c(.variable_label_suffix_indep = "By {tolower(heading)}")
    ),
    "^\n## Gender\\{#sec-"
  )
})

testthat::test_that("the default leaves the heading byte-identical", {
  testthat::expect_identical(
    heading_of(2, "x1_sex", glue_heading_for_group = NULL),
    heading_of(2, "x1_sex")
  )
})

testthat::test_that("the section anchor does not move when the template changes", {
  # The anchor is derived from `value`, never from the heading text, so editing
  # a template must not break a cross-reference or invalidate Quarto's freeze
  # cache (the property GH #213 established).
  plain <- heading_of(2, "x1_sex")
  templated <- heading_of(2, "x1_sex",
    glue_heading_for_group = c(.variable_name_indep = "Broken down by {tolower(heading)}")
  )
  testthat::expect_identical(anchor_of(templated), anchor_of(plain))
})

testthat::test_that("an ignored group stays ignored when it has a template", {
  testthat::expect_identical(
    heading_of(2, "x1_sex",
      ignore_heading_for_group = ".variable_name_indep",
      glue_heading_for_group = c(.variable_name_indep = "By {tolower(heading)}")
    ),
    character()
  )
})

testthat::test_that("a template composes with the line-level prefix and suffix", {
  testthat::expect_match(
    heading_of(2, "x1_sex",
      prefix_heading_for_group = c(.variable_name_indep = "PREFIX"),
      suffix_heading_for_group = c(.variable_name_indep = "SUFFIX"),
      glue_heading_for_group = c(.variable_name_indep = "By {tolower(heading)}")
    ),
    "^PREFIX\n## By gender\\{#sec-[^}]+\\}\nSUFFIX$"
  )
})

testthat::test_that("a malformed template aborts naming the argument that carries it", {
  # Matched on the wording glue_err() produces rather than on the argument name
  # alone: before this feature existed the call died with
  # `unused argument (glue_heading_for_group = ...)`, which contains the
  # argument name and would have satisfied a laxer regexp vacuously.
  cnd <- testthat::expect_error(
    heading_of(2, "x1_sex",
      glue_heading_for_group = c(.variable_name_indep = "By {tolower(heading)")
    ),
    regexp = "Template is invalid"
  )
  testthat::expect_match(conditionMessage(cnd), "glue_heading_for_group", fixed = TRUE)
})

################################################################################

testthat::test_that("draft_report() carries the template through to the generated qmd", {
  # The argument crosses four files between draft_report() and the heading, and
  # each engine passes it separately; this is the only test that exercises the
  # whole path. The marker is a literal so the assertion does not depend on
  # which label ex_survey happens to carry.
  path <- withr::local_tempdir()
  chapter_structure <- suppressMessages(suppressWarnings(
    saros.base::refine_chapter_overview(
      chapter_overview = data.frame(chapter = "Trivsel", dep = "a_1, a_2", indep = "x1_sex"),
      data = saros.base::ex_survey,
      label_separator = " - ",
      progress = FALSE
    )
  ))
  suppressMessages(saros.base::draft_report(
    data = saros.base::ex_survey,
    chapter_structure = chapter_structure,
    path = path,
    glue_heading_for_group = c(.variable_name_indep = "GLUED-{heading}")
  ))
  lines <- unlist(lapply(
    fs::dir_ls(path, recurse = TRUE, type = "file", glob = "*.qmd"),
    readLines, warn = FALSE
  ))
  testthat::expect_true(any(grepl("^#+ GLUED-", lines)))
})
