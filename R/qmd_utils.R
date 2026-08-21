# The setup chunk every generated chapter opens with (GH #119).
#
# The default chunk templates are namespace-qualified as of this change, so
# they no longer need this. It is here for the templates saros.base does not
# control: a project supplying its own `chunk_templates` writes `makeme(...)`
# and `gt(...)` the way the defaults used to, and until now nothing attached
# either package -- not the generated qmd, not this package, not the project
# templates in `inst/`. Such a chapter failed in a *chunk header*
# (`fig.height=fig_height_h_barchart(...)`), which knitr evaluates before the
# chunk body, so it died before running a line of its own code.
#
# Emitted unconditionally rather than alongside the dataset import, which is
# skipped entirely when `attach_chapter_dataset = FALSE`; the packages are
# needed either way.
#
# `include: false` keeps the startup messages out of the rendered chapter,
# which is what the dataset chunk beside it does by way of `echo: false` in
# the YAML.
chapter_setup_chunk <- function(chapter_foldername_clean,
                                packages = c("saros", "gt")) {
  # No packages means no chunk, not an empty one: knitr executes an empty
  # ```{r}``` block and renders a cell for it. `saros` and `gt` are in neither
  # Imports nor Suggests of this package, so a project whose own
  # `chunk_templates` need neither must be able to switch this off rather than
  # gain a hard dependency it never asked for.
  if (length(packages) == 0L) {
    return(NULL)
  }
  stringi::stri_c(
    "```{r}\n",
    "#| label: 'Setup for ", chapter_foldername_clean, "'\n",
    "#| include: false\n",
    stringi::stri_c("library(", packages, ")", collapse = "\n"),
    "\n```",
    ignore_null = TRUE
  )
}

# The chunk that establishes `parameters` for the chapter (GH #270).
#
# The mesos chunk templates read `parameters$save`, and `parameters` was
# assigned nowhere in this package -- it came from an organization's
# `general_formatting.R`, sourced in by a start section the caller had to
# supply. A chapter generated without one referenced a symbol nothing bound,
# which is why variants 2, 3 and 4 have never had render coverage.
#
# Separate from the packages chunk on purpose: `chapter_setup_packages = NULL`
# is the documented escape hatch for a project needing neither `saros` nor
# `gt`, and it must not silently take `parameters` with it.
#
# The `exists()` guard makes this a floor, not an override. A project whose
# `general_formatting.R` runs first -- in `report.qmd`, ahead of the chapter
# includes -- keeps its own object; one that runs afterwards overwrites this
# unconditionally, exactly as it did before. `inherits = FALSE` restricts the
# question to the document's own environment, so an unrelated `parameters`
# exported by an attached package cannot suppress the assignment.
#
# `save` is floored rather than assigned, which is the half of #270 the
# external file gets wrong: it assigns `parameters$save <- TRUE`
# unconditionally *after* aggregating, so `save` is the one key its own
# inheritance chain cannot carry. Here `_metadata.yml` wins and the default
# only applies when nothing in the chain set it.
chapter_parameters_chunk <- function(chapter_foldername_clean,
                                     enabled = TRUE) {
  if (!isTRUE(enabled)) {
    return(NULL)
  }
  stringi::stri_c(
    "```{r}\n",
    "#| label: 'Parameters for ", chapter_foldername_clean, "'\n",
    "#| include: false\n",
    'if (!exists("parameters", inherits = FALSE)) {\n',
    '  parameters <- saros.base::aggregate_metadata_yml()[["params"]]\n',
    "  if (is.null(parameters$save)) parameters$save <- TRUE\n",
    "}\n",
    "```",
    ignore_null = TRUE
  )
}

# Helper: Process template section file with optional glue templating
process_template_section <- function(filepath, chapter_structure = NULL, arg_name) {
  if (is.null(filepath) || !rlang::is_string(filepath)) {
    return(NULL)
  }

  # Read the template file
  content <- stringi::stri_c(
    collapse = "\n",
    ignore_null = TRUE,
    readLines(con = filepath)
  )

  # Apply glue templating if chapter_structure is provided
  if (inherits(chapter_structure, "data.frame")) {
    chapter_structure_simplified <- collapse_chapter_structure_to_chr(chapter_structure)
    tryCatch(
      glue::glue_data(chapter_structure_simplified, content, .na = ""),
      error = function(cnd) glue_err(cnd = cnd, arg_name = arg_name)
    )
  } else {
    content
  }
}

# Helper: Finalize QMD content by removing NAs and normalizing newlines
finalize_qmd_content <- function(sections) {
  out <- stringi::stri_remove_na(sections)
  out <- stringi::stri_c(out, collapse = "\n", ignore_null = TRUE)
  out <- stringi::stri_replace_all_regex(out,
    pattern = "\n{3,}",
    replacement = "\n\n\n"
  )
  out
}

# Helper: Generate markdown links to output files in different formats
generate_report_links <- function(output_filename, output_formats) {
  if (!is.character(output_filename) || !is.character(output_formats)) {
    return(NULL)
  }

  stringi::stri_c(
    lapply(output_formats, function(frmt) {
      # Convert typst to pdf for link purposes
      display_format <- if (frmt == "typst") "pdf" else frmt

      stringi::stri_c(
        "-\t[(", toupper(display_format), ")](",
        output_filename, ".", display_format, ")"
      )
    }),
    collapse = "\n"
  )
}
