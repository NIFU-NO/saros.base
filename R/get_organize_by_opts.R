#' Get Core Chapter Structure Column Names
#'
#' Returns the vector of core column names available as organize_by options.
#' @return A character vector.
#'
#' @export
#' @examples
#' get_organize_by_opts()
#'
get_organize_by_opts <- function() {
    .saros.env$core_chapter_structure_cols
}
