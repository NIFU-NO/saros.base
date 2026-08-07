validate_chunk_templates <-
  function(chunk_templates) {
    if(is.null(chunk_templates)) {
      cli::cli_inform("{.arg chunk_templates} is NULL. Using global defaults.")
      chunk_templates <- get_chunk_template_defaults()
    }
    if(!inherits(chunk_templates, "data.frame")) {
      cli::cli_abort("{.arg chunk_templates} must be a data.frame, not {.obj_type_friendly {chunk_templates}}.")
    }
    core_columns <- c(".template_name", ".template", ".variable_type_dep")
    for(col in core_columns) {
      if(!col %in% core_columns) {
        cli::cli_abort("{.arg chunk_templates} must contain {.var {col}}.")
      }
    }
    if(nrow(chunk_templates)==0) {
      cli::cli_abort("{.arg chunk_templates} must contain at least one template.")
    }
    warn_if_insert_text_duplicated(chunk_templates)
    chunk_templates
  }

# Text of every `insert_text(...)` call in `template`, with parentheses balanced
# so that a nested call in an argument does not truncate the match.
extract_insert_text_calls <- function(template) {
  if (length(template) != 1L || is.na(template)) {
    return(character())
  }
  starts <- gregexpr("insert_text[[:space:]]*\\(", template)[[1]]
  if (starts[1] == -1L) {
    return(character())
  }

  chars <- strsplit(template, "", fixed = TRUE)[[1]]
  depth <- cumsum((chars == "(") - (chars == ")"))
  opens <- starts + attr(starts, "match.length") - 1L

  ends <- vapply(
    opens,
    function(open) {
      close <- which(
        seq_along(chars) > open & chars == ")" & depth == depth[open] - 1L
      )
      if (length(close) == 0L) NA_integer_ else close[1]
    },
    integer(1)
  )

  keep <- !is.na(ends)
  substring(template, as.integer(starts)[keep], ends[keep])
}

# The wrap is written out longhand in two places -- the generation script and
# the mutation helper -- so the two copies are separately authored and drift in
# spacing (`before=TRUE` against `before = TRUE`). Compare with whitespace
# removed rather than byte-for-byte, so that drift does not hide the repeat.
normalise_insert_text_call <- function(x) {
  gsub("[[:space:]]", "", x)
}

# Projects inject auxiliary text by wrapping every `.template` with a pair of
# `insert_text()` calls (#210). That wrap is applied in two places -- the
# generation script and a template-mutation helper -- and neither knows about
# the other, so it is easy to apply twice. Each wrapped passage is then emitted
# twice in the generated qmd.
#
# The wrapping itself is project-side; saros.base only ever sees the already
# doubled string arriving in `.template`, so this is a lint on user-supplied
# data: it warns and leaves the templates untouched.
#
# The discriminator is an *identical repeated call*, not a call count. A
# template may legitimately address several insertion points, but those calls
# differ in their arguments (a different chunk, or a different `before`).
# Re-wrapping is the case that reproduces one call verbatim.
warn_if_insert_text_duplicated <- function(chunk_templates) {
  if (!".template" %in% names(chunk_templates)) {
    return(invisible(NULL))
  }

  templates <- as.character(chunk_templates[[".template"]])
  repeated <- lapply(templates, function(template) {
    calls <- extract_insert_text_calls(template)
    keys <- normalise_insert_text_call(calls)
    # The first occurrence of each call that occurs more than once, reported in
    # the template's own spelling rather than the normalised form.
    calls[!duplicated(keys) & duplicated(keys, fromLast = TRUE)]
  })

  affected <- lengths(repeated) > 0L
  if (!any(affected)) {
    return(invisible(NULL))
  }

  n_affected <- sum(affected)
  template_names <- if (".template_name" %in% names(chunk_templates)) {
    unique(as.character(chunk_templates[[".template_name"]][affected]))
  } else {
    as.character(which(affected))
  }
  calls <- unique(unlist(repeated[affected], use.names = FALSE))

  cli::cli_warn(c(
    # Counted in rows rather than template names: one name legitimately spans
    # several rows (one per variable-type combination), so a name count and the
    # de-duplicated list below would disagree.
    "!" = "{.arg chunk_templates} has {n_affected} row{?s} where the same {.code insert_text()} call appears more than once.",
    i = "In {.var .template_name}: {.val {template_names}}.",
    i = "Repeated: {.code {calls}}.",
    i = "This usually means the auxiliary-text wrapping was applied twice, once when building the templates and again when mutating them. Each wrapped passage will be inserted twice in the generated qmd."
  ))
  invisible(NULL)
}
