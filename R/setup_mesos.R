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

create_mesos_stubs_from_main_files <- function(mesos_df,
                                               main_directory,
                                               files_to_process,
                                               subtitle_separator = " - ") {
    for (j in seq_len(length(mesos_df))) {
        mesos_var <- names(mesos_df[[j]])[1]
        mesos_var_pretty <- unname(get_raw_labels(mesos_df[[j]], col_pos = 1))
        if (is.null(mesos_var_pretty)) mesos_var_pretty <- mesos_var
        mesos_groups_pretty <- as.character(mesos_df[[j]][[1]])
        mesos_groups_pretty <- mesos_groups_pretty[!is.na(mesos_groups_pretty)]
        mesos_groups_abbr <- filename_sanitizer(mesos_groups_pretty, max_chars = 12, accept_hyphen = TRUE, make_unique = TRUE)
        mesos_groups_base_paths <- fs::path(main_directory, mesos_var, mesos_groups_abbr)
        fs::dir_create(fs::path(main_directory, mesos_var))
        fs::dir_create(mesos_groups_base_paths)


        # Write _metadata.yml in each mesos_var folder
        yaml::write_yaml(
            x = list(params = list(
                mesos_var = mesos_var,
                mesos_var_pretty = mesos_var_pretty
            )),
            file = fs::path(main_directory, mesos_var, "_metadata.yml")
        )

        for (f in seq_along(files_to_process)) {
            cat(paste0('{{< include "../../', basename(unname(files_to_process[f])), '" >}}'),
                file = fs::path(main_directory, mesos_var, basename(unname(files_to_process[f])))
            )
        }


        for (i in seq_along(mesos_groups_pretty)) {
            mesos_group <- mesos_groups_pretty[i]

            # Write _metadata.yml in each mesos_group foldre
            yml_contents <- list(
                params = list(mesos_group = mesos_group)
            )
            if (rlang::is_string(subtitle_separator)) {
                yml_contents$title <- mesos_group
                yml_contents$subtitle <- paste0(basename(main_directory), subtitle_separator, mesos_var_pretty)
            }
            yaml::write_yaml(
                x = yml_contents,
                file = fs::path(mesos_groups_base_paths[i], "_metadata.yml")
            )
            # Write chapter stubs in each mesos_group folder
            out_files <-
                fs::path(
                    mesos_groups_base_paths[i],
                    stringi::stri_replace_first_regex(basename(unname(files_to_process)),
                        pattern = "^_",
                        replacement = ""
                    )
                )

            for (k in seq_along(unname(files_to_process))) {
                cat(paste0('{{< include "../', basename(unname(files_to_process[k])), '" >}}'),
                    file = out_files[k]
                )
            }
        }
    }
}


#' Simply create qmd-files and yml-files for mesos reports
#' @param main_directory String, path to where the _metadata.yml, stub QMD-files and their subfolders are created.
#' @param files_to_process Character vector of files used as templates for the mesos stubs.
#' @param mesos_df List of single-column data frames where each variable is a mesos variable, optionally with a variable label indicating its pretty name. The values in each variable are the mesos groups. NA is silently ignored.
#' @param main_files Character vector of files for which titles should be set as the mesos_group. Optional but recommended.
#' @param read_syntax_pattern,read_syntax_replacement Optional strings, any regex pattern to search and replace in the qmd-files. If NULL, will ignore it.
#' @param qmd_regex String. Experimental feature for allowing Rmarkdown, not yet tested.
#' @param subtitle_separator String or NULL. If a string will add title and subtitle fields to the _metadata.yml-files in the deepest child folders. The title is the mesos_group. The subtitle is a concatenation of the folder name of the main_directory and the mesos_var label.
#' @export
setup_mesos <- function(
    main_directory,
    files_to_process,
    mesos_df,
    main_files = c("index", "report"),
    read_syntax_pattern = "qs::qread\\('",
    read_syntax_replacement = "qs::qread('../",
    qmd_regex = "\\.qmd",
    subtitle_separator = " - ") {
    ## Checks

    if (!inherits(main_directory, "character") || length(main_directory) == 0) cli::cli_abort("{.arg main_directory} must be a string, not {.obj_type_friendly {main_directory}}")
    if (!is.character(files_to_process) ||
        length(files_to_process) == 0 ||
        !all(file.exists(files_to_process))) {
        cli::cli_abort("{.arg files_to_process} must be a character vector of paths to existing files, not {.obj_type_friendly {files_to_process}}: {files_to_process}.")
    }
    check_files_to_process <- stringi::stri_extract_last_regex(files_to_process, pattern = "/[^_/\\\\]+$")
    check_files_to_process <- check_files_to_process[!is.na(check_files_to_process)]
    if (length(check_files_to_process)) {
        cli::cli_warn(c(
            "{.arg files_to_process} are expected to have filenames starting with underscore for most mesos setups. These are not:",
            "{check_files_to_process}"
        ))
    }
    if (!is.list(mesos_df)) cli::cli_abort("{.arg mesos_df} must be a list of single-column data.frames, not {.obj_type_friendly {mesos_df}}")
    if (!inherits(main_files, "character")) cli::cli_abort("{.arg main_files} must be a character vector, not a {.obj_type_friendly {main_files}}")
    if (!inherits(read_syntax_pattern, "character")) cli::cli_abort("{.arg read_syntax_pattern} must be a string (regex), not a {.obj_type_friendly {read_syntax_pattern}}")
    if (!inherits(read_syntax_replacement, "character")) cli::cli_abort("{.arg read_syntax_replacement} must be a string (regex), not a {.obj_type_friendly {read_syntax_replacement}}")
    if (!inherits(qmd_regex, "character") || length(qmd_regex) == 0) cli::cli_abort("{.arg qmd_regex} must be a string, not a {.obj_type_friendly {qmd_regex}}")


    create_mesos_stubs_from_main_files(
        mesos_df = mesos_df,
        main_directory = main_directory,
        files_to_process = files_to_process,
        subtitle_separator = subtitle_separator
    )

    if (is.character(read_syntax_pattern) &&
        is.character(read_syntax_replacement)) {
        search_and_replace_files(
            files = files_to_process,
            pattern = read_syntax_pattern,
            replacement = read_syntax_replacement
        )
    }


    list(
        files_renamed = files_to_process
    )
}
