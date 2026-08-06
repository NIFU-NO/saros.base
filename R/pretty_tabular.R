tabular_write <- function(object, path, format) {
  # `writexl`, `readr` and `haven` are in Suggests, so availability is checked
  # immediately before each use (R-exts: "Packages in Suggests should be used
  # conditionally"). The guards are inline, one per branch, so each names the
  # package it protects and cannot drift away from the call it guards.
  switch(format,
    delim = utils::write.table(
      x = object, file = path, sep = "\t",
      row.names = FALSE, col.names = TRUE
    ),
    xlsx = {
      rlang::check_installed("writexl", reason = "to write xlsx files.")
      writexl::write_xlsx(x = object, path = path)
    },
    csv = {
      rlang::check_installed("readr", reason = "to write csv files.")
      readr::write_csv(x = object, file = path)
    },
    csv2 = {
      rlang::check_installed("readr", reason = "to write csv2 files.")
      readr::write_csv2(x = object, file = path)
    },
    tsv = {
      rlang::check_installed("readr", reason = "to write tsv files.")
      readr::write_tsv(x = object, file = path)
    },
    sav = {
      rlang::check_installed("haven", reason = "to write sav files.")
      haven::write_sav(data = object, path = path)
    },
    dta = {
      rlang::check_installed("haven", reason = "to write dta files.")
      haven::write_dta(data = object, path = path)
    },
    cli::cli_abort("Unsupported {.arg format}: {.val {format}}.")
  )
}
