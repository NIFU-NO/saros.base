tabular_write <- function(object, path, format) {
  # `writexl`, `readr` and `haven` are in Suggests, so their availability must be
  # checked before use (R-exts: "Packages in Suggests should be used conditionally").
  pkg <- switch(format,
    xlsx = "writexl",
    csv = ,
    csv2 = ,
    tsv = "readr",
    sav = ,
    dta = "haven",
    NULL
  )
  if (!is.null(pkg)) {
    rlang::check_installed(pkg, reason = paste0("to write ", format, " files."))
  }

  switch(format,
    delim = utils::write.table(x = object, file = path, sep = "\t", row.names = FALSE, col.names = TRUE),
    xlsx = writexl::write_xlsx(x = object, path = path),
    csv = readr::write_csv(x = object, file = path),
    csv2 = readr::write_csv2(x = object, file = path),
    tsv = readr::write_tsv(x = object, file = path),
    sav = haven::write_sav(data = object, path = path),
    dta = haven::write_dta(data = object, path = path),
    cli::cli_abort("Unsupported {.arg format}: {.val {format}}.")
  )
}
