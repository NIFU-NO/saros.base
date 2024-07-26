
#' Get Global Options for Chunk Templates
#'
#' @return List with options in R
#' @export
#'
#' @examples get_chunk_template_defaults()
get_chunk_template_defaults <- function() {
  .saros.env$default_chunk_templates
}
