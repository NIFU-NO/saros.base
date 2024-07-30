
#' Get Global Options for Chunk Templates
#'
#' @param variant Positive integer.
#' @return List with options in R
#' @export
#'
#' @examples get_chunk_template_defaults()
get_chunk_template_defaults <- function(variant=1) {
  template_name <- paste0("default_chunk_templates_", variant)
  if(!template_name %in% names(.saros.env)) {
    cli::cli_abort("{.arg variant}={.val {variant}} is invalid.")
  }
  .saros.env[[template_name]]
}
