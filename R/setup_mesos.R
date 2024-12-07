set_underscore_on_filenames <- function(files_to_process) {
    if (!is.character(files_to_process) ||
        length(files_to_process) == 0 ||
        !all(file.exists(files_to_process))) {
        cli::cli_abort("{.arg files_to_process} must be a character vector of paths to existing files, not {.obj_type_friendly {files_to_process}}: {files_to_process}.")
    }



    files_to_be_renamed <-
        rlang::set_names(stringi::stri_replace_last_fixed(files_to_process, pattern = "/", replacement = "/_"),
            nm = files_to_process
        )
    file.rename(
        from = names(files_to_be_renamed),
        to = unname(files_to_be_renamed)
    )
    files_to_be_renamed
}


search_and_replace_files <- function(
    files,
    pattern,
    replacement) {
    if (!is.character(pattern) ||
        !is.character(replacement) ||
        length(pattern) != length(replacement)) {
        cli::cli_abort("{.arg pattern} and {.arg replacement} must be character vectors of same length.")
    }
    files |>
        unname() |>
        lapply(FUN = function(.x) {
            readLines(.x) |>
                stringi::stri_replace_all_regex(pattern, replacement) |>
                writeLines(.x)
        })
    files
}

create_mesos_stubs_from_main_files <- function(
    files,
    mesos_var,
    mesos_groups,
    qmd_regex = "\\.qmd",
    main_files = c("index", "report")) {
    ####

    if (!is.character(files) || !any(file.exists(files))) {
        cli::cli_warn("No files found.")
        return()
    }
    if (!rlang::is_string(mesos_var) || !is.character(mesos_groups)) {
        cli::cli_abort("{.arg mesos_var} must be a string and {.arg mesos_groups} must be a character vector.")
    }

    dir_path <- unique(dirname(files))
    if (length(dir_path) > 1) cli::cli_abort("All files must be in the same folder.")

    new_qmd_files <-
        files |>
        stringi::stri_replace_last_fixed(pattern = qmd_regex, replacement = "") |>
        basename() |>
        tidyr::expand_grid(
            main_file = _,
            mesos_group = mesos_groups
        ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
            main_file_no_ = stringi::stri_replace_first_regex(.data$main_file,
                pattern = "^_|\\.[r]qmd", replacement = ""
            ),
            new_file_path = fs::path(
                .env$dir_path,
                .data$mesos_group,
                .data$main_file_no_
            ),
            contents = {
                yaml <- list(
                    params = list(
                        mesos_var = .env$mesos_var,
                        mesos_group = .data$mesos_group
                    )
                )
                if (.data$main_file_no_ %in% main_files) {
                    yaml$title <- paste0(.data$mesos_group)
                }
                yaml <- yaml::as.yaml(x = yaml)
                paste0("---\n", yaml, "---\n", paste0(
                    "\n{{< include ../",
                    .data$main_file, " >}}\n"
                ), sep = "\n")
            }
        )


    fs::dir_create(dirname(new_qmd_files$new_file_path), recurse = TRUE)
    for (i in seq_len(nrow(new_qmd_files))) {
        cat(new_qmd_files[i, "contents", drop = TRUE], file = new_qmd_files[i,
            "new_file_path",
            drop = TRUE
        ])
    }
    new_qmd_files
}


#' Simply create qmd-files for mesos reports
#' @param files_to_process Character vector of files used as templates for the mesos stubs.
#' @param mesos_var String, variable used during rendering with saros::makeme() to obtain the column in the dataset which it will filter on.
#' @param mesos_groups Character vector for which stub-qmd files will be made
#' @param main_files Character vector of files for which titles should be set as the mesos_group. Optional but recommended.
#' @param read_syntax_pattern,read_syntax_replacement Optional strings, any regex pattern to search and replace in the qmd-files. If NULL, will ignore it.
#' @param qmd_regex String. Experimental feature for allowing Rmarkdown, not yet tested.
#' @export
setup_mesos <- function(
    files_to_process,
    mesos_var,
    mesos_groups,
    main_files = c("index", "report"),
    read_syntax_pattern = "qs::qread\\('",
    read_syntax_replacement = "qs::qread('../",
    qmd_regex = "\\.qmd") {
    ## Checks


    files_to_be_renamed <-
        set_underscore_on_filenames(files_to_process = files_to_process)

    if (is.character(read_syntax_pattern) &&
        is.character(read_syntax_replacement)) {
        search_and_replace_files(
            files = unname(files_to_be_renamed),
            pattern = read_syntax_pattern, replacement = read_syntax_replacement
        )
    }

    mesos_files <-
        create_mesos_stubs_from_main_files(
            files = unname(files_to_be_renamed),
            mesos_var = mesos_var,
            mesos_groups = mesos_groups,
            main_files = main_files,
            qmd_regex = qmd_regex
        )

    list(
        files_renamed = files_to_be_renamed,
        mesos_subfolder_files = mesos_files
    )
}
