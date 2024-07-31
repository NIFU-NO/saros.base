collapse_chapter_structure_to_chr <- function(data, sep=",", sep2=",", last=",", trunc = 30) {
  data |>
  lapply(FUN = function(col) {
    col <- as.character(col)
    uniques <- unique(col)
    uniques <- uniques[!is.na(uniques)]
    cli::ansi_collapse(uniques, sep=sep, sep2 = sep2, last = last, trunc = trunc, width = Inf)
  }) |>
    unlist()
}
