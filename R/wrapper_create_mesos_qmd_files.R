create_mesos_qmd_files <- function(
    dir_path = tempdir(),
    mesos_var,
    mesos_groups,
    main_files = c("index", "report")) {
    ####
    new_qmd_files <- fs::dir_ls(
        path = dir_path, regexp = "\\.qmd",
        recurse = FALSE
    )
    if (length(new_qmd_files) == 0) {
        cli::cli_warn("No files found.")
        return()
    }
    new_qmd_files <-
        new_qmd_files |>
        stringi::stri_replace_last_fixed(pattern = "\\.qmd", replacement = "") |>
        basename() |>
        tidyr::expand_grid(
            main_file = _,
            mesos_group = mesos_groups
        ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
            main_file_no_ = stringi::stri_replace_first_regex(.data$main_file,
                pattern = "^_", replacement = ""
            ),
            new_file_path = fs::path(
                .env$dir_path,
                .data$mesos_group,
                paste0(.data$main_file_no_, ".qmd")
            ),
            contents = {
                yaml <- list(params = list(
                    mesos_var = .env$mesos_var,
                    mesos_group = .data$mesos_group
                ))
                if (.data$main_file_no_ %in% main_files) {
                    yaml$title <- paste0(.data$mesos_group)
                }
                yaml <- yaml::as.yaml(x = yaml)
                paste0("---\n", yaml, "---\n", paste0(
                    "\n{{< include ../",
                    .data$main_file, ".qmd >}}\n"
                ), sep = "\n")
            }
        )




    dir.create(dirname(new_qmd_files$new_file_path),
        showWarnings = FALSE, recursive = TRUE
    )
    for (i in seq_len(nrow(new_qmd_files))) {
        cat(new_qmd_files[i, "contents", drop = TRUE], file = new_qmd_files[i,
            "new_file_path",
            drop = TRUE
        ])
    }
    new_qmd_files
}


#' Simply create qmd-files for mesos reports
#' @param mesos_var String, variable used during rendering with saros::makeme() to obtain the column in the dataset which it will filter on.
#' @param mesos_groups Character vector for which stub-qmd files will be made
#' @param mesos_group_path String, path to parent folder where mesos subfolders are found.
#' @param read_syntax_pattern,read_syntax_replacement Strings, any regex pattern to search and replace in the qmd-files.
#' @param files_to_process_regex String. regex pattern to use for finding the files in subfolders.
#' @param main_files Character vector of files for which titles should be set as the mesos_group. Optional but recommended.
#' @export
wrapper_create_mesos_qmd_files <- function(
    mesos_var,
    mesos_groups,
    mesos_group_path = tempdir(),
    read_syntax_pattern = "qs::qread\\('",
    read_syntax_replacement = "qs::qread('../",
    files_to_process_regex = "[0-9]+_|index|report",
    main_files = c("index", "report")) {
    ## Checks
    if (!rlang::is_string(mesos_var) || !is.character(mesos_groups) || !rlang::is_string(mesos_group_path) || !file.exists(mesos_group_path)) {
        cli::cli_abort("{.arg mesos_var} must be a string, {.arg mesos_groups} must be a character vector, and {mesos_group_path} must be an existing directory.")
    }


    wd <- getwd()

    setwd(mesos_group_path)

    files_to_be_renamed <-
        list.files(path = ".", recursive = FALSE, pattern = files_to_process_regex)
    files_to_be_renamed <-
        rlang::set_names(paste0("_", files_to_be_renamed), nm = files_to_be_renamed)
    if (!all(files_to_be_renamed == "_")) {
        file.rename(
            from = names(files_to_be_renamed),
            to = unname(files_to_be_renamed)
        )
    }

    files_to_be_renamed |>
        lapply(FUN = function(.x) {
            readLines(.x) |>
                stringi::stri_replace_all_regex(read_syntax_pattern, read_syntax_replacement) |>
                writeLines(.x)
        })

    create_mesos_qmd_files(
        dir_path = ".",
        mesos_var = mesos_var,
        mesos_groups = mesos_groups,
        main_files = main_files
    )
    setwd(wd)
    files_to_be_renamed
}
