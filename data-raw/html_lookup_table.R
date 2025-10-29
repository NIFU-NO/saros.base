get_table <- function(ref_url, cols) {
  char_table <- rvest::read_html(ref_url)
  char_table <- rvest::html_table(char_table)
  char_table <- char_table[1:4]
  char_table <- lapply(char_table, function(x) x[, cols])
  char_table <- do.call(rbind, char_table)
  char_table <- char_table[char_table[[1]] != "" & char_table[[2]] != "" & !is.na(char_table[[1]]) & !is.na(char_table[[2]]), ]
  char_table <- char_table[!duplicated(char_table[[cols[2]]]), ]
  names(char_table) <- c("symbol", "html_name")
  dplyr::arrange(char_table, .data$html_name)
  char_table
}

html_lookup_table <-
  dplyr::bind_rows(
    get_table(
      ref_url = "http://www.w3schools.com/charsets/ref_html_8859.asp",
      cols = c("Character", "Entity Name")
    ),
    get_table(
      ref_url = "https://www.ascii-code.com/ISO-8859-1",
      cols = c("Symbol", "HTML Name")
    )
  ) |>
  dplyr::distinct(.data$html_name, .keep_all = TRUE) |>
  as.data.frame()
usethis::use_data(html_lookup_table, internal = TRUE, overwrite = TRUE)
