get_common_names_from_data <- function(data, sep="_", max_width=128) {
  out <- lapply(data, function(x) get_common_name(x=stringi::stri_remove_empty_na(unique(as.character(x)))))
  out <- out[order(lengths(out))]
  out <- unlist(out)
  out <- unname(out)
  out <- stringi::stri_remove_empty_na(out)
  out <- stringi::stri_sub(str = out, from = 1, to = max_width,
                           use_matrix = FALSE, ignore_negative_length = TRUE)
  out <- stringi::stri_c(out, collapse = sep, ignore_null = TRUE)
  out
}
