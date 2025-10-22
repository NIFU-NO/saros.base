process_yaml <- function(yaml_file = NULL,
                         format = "html",
                         title = NULL,
                         authors = NULL,
                         add_fences = TRUE,
                         chapter_number = NA_integer_) {
  if (!is_string(yaml_file)) {
    yaml_section <-
      list(
        format = format,
        echo = FALSE,
        `fig-dpi` = 800,
        authors = authors
      )
  } else {
    yaml_section <- yaml::read_yaml(file = yaml_file)
    if (any(names(yaml_section) == "translations")) {
      yaml_section$translations <- unlist(yaml_section$translations, recursive = FALSE)
    }
    yaml_section$title <- title

    if (is.character(authors)) {
      yaml_section$authors <- authors
    }
  }

  if (is.null(yaml_section$authors) || all(nchar(yaml_section$authors) == 0)) {
    yaml_section$authors <- NULL
  }
  if (!is.na(chapter_number)) {
    yaml_section[["number-offset"]] <- chapter_number - 1
  }


  yaml_section <- yaml::as.yaml(yaml_section,
    handlers = list(
      logical = function(x) {
        result <- ifelse(x, "true", "false")
        class(result) <- "verbatim"
        result
      }
    )
  )

  if (add_fences) {
    yaml_section <- add_yaml_fences(yaml_section)
  }
  yaml_section
}

add_yaml_fences <- function(x) {
  stringi::stri_c("---",
    x,
    "---",
    sep = "\n",
    ignore_null = TRUE
  )
}


find_yaml_formats <- function(yaml_file) {
  x <- yaml::read_yaml(file = yaml_file)
  x <- names(x$format)
  stringi::stri_extract_last_words(x)
}
