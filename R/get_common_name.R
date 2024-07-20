get_common_name <- function(x) {
  out <- Reduce(f = intersect, strsplit(x, split = ""))

  if(length(out)>0 && all(!is.na(out))) {
    out <- stringi::stri_c(out, collapse = "", ignore_null = TRUE)
    if(nchar(out)>0) {
      x <- out
    }
  }
  x
}


