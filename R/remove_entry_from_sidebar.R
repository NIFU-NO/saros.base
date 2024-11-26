#' Removes entries in sidebar if containing a filename regex pattern.
#'
#' @param path String, path to where your html-files are located. Defaults to "_site"
#' @param filename_as_regex Character vector of regex patterns to search for. Defaults to c("report\\.pdf", "report\\.docx")
#'
#' @export
#' @return Invisibly returns files processed

remove_entry_from_sidebar <-
    function(path = "_site",
             filename_as_regex = c(
                 "report\\.pdf",
                 "report\\.docx"
             )) {
        fs::dir_ls(
            path = path, all = FALSE, recurse = TRUE,
            type = "file", regexp = "\\.html"
        ) |>
            lapply(FUN = function(.x) {
                pattern_to_remove <-
                    paste0(
                        "<li class=\"sidebar-item\">\\s*<div class=\"sidebar-item-container\">\\s*<a href=\"[^\"]*",
                        filename_as_regex, "\"[^>]*>\\s*<span class=\"menu-text\">[^<]*</span></a>\\s*</div>\\s*</li>"
                    )
                .x |>
                    readLines() |>
                    paste0(collapse = "\n") |>
                    stringi::stri_replace_all_regex(
                        pattern = pattern_to_remove,
                        replacement = ""
                    ) |>
                    stringi::stri_split_lines1() |>
                    writeLines(con = .x, sep = "\n")
                .x
            }) |>
            unlist() |>
            invisible()
    }
