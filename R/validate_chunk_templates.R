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
    chunk_templates
  }
