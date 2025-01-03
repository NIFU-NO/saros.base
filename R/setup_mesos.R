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

create_includes_content_path_df <-
    function(files_to_process,
             main_directory = character(),
             mesos_var = character(),
             mesos_var_subfolders = character(), # Assumed always a character vector or NULL
             mesos_groups_abbr = character(),
             prefix = '{{< include \"',
             suffix = '\" >}}') {
        if (!rlang::is_string(prefix)) cli::cli_abort("{.arg prefix} must be a string.")
        if (!rlang::is_string(suffix)) cli::cli_abort("{.arg suffix} must be a string.")
        if (missing(files_to_process) || !is.character(files_to_process)) cli::cli_abort("{.arg files_to_process} must be a character vector.")
        ## By design, the order of this vector does not match the working order
        full_dir_path <- c(main_directory, mesos_var, mesos_var_subfolders, if (length(mesos_groups_abbr) > 0) "")

        includes_df <-
            seq_along(full_dir_path) |>
            lapply(FUN = function(path_lvl) {
                dir_path <- fs::path_join(stringi::stri_remove_empty_na(full_dir_path[seq_len(length(full_dir_path) - path_lvl + 1)]))

                lapply(files_to_process, function(filename_parent) {
                    filename_child <- filename_parent


                    if (path_lvl == 1) {
                        # If inner-most child path, remove leading underscore, and add mesos_group folders
                        filename_child <-
                            stringi::stri_replace_first_regex(filename_child,
                                pattern = "^_",
                                replacement = ""
                            )
                        if (length(mesos_groups_abbr) > 0) {
                            filename_child <- fs::path(mesos_groups_abbr, filename_child)
                        }
                    } else {
                        filename_child <-
                            stringi::stri_replace_first_regex(filename_child,
                                pattern = , "^(?!_)",
                                replacement = "_"
                            )
                    }
                    if (path_lvl != length(full_dir_path)) {
                        filename_parent <-
                            stringi::stri_replace_first_regex(filename_parent,
                                pattern = "^(?!_)",
                                replacement = "_"
                            )
                    }

                    data.frame(
                        content = paste0(paste0(rep("../", times = path_lvl), collapse = ""), filename_parent),
                        path = if (nchar(dir_path)) fs::path(dir_path, filename_child) else filename_child
                    )
                }) |>
                    dplyr::bind_rows()
            }) |>
            dplyr::bind_rows()
        if (nrow(includes_df) > 0) {
            includes_df[["content"]] <- paste0(prefix, includes_df[["content"]], suffix)
            includes_df
        }
    }



create_metadata_yml <- function(main_directory,
                                mesos_var,
                                mesos_var_pretty,
                                mesos_var_subfolder,
                                mesos_groups_pretty,
                                mesos_groups_abbr,
                                subtitle_separator = " - ") {
    ###
    mesos_groups_base_paths <- fs::path(main_directory, mesos_var, mesos_var_subfolder, mesos_groups_abbr)

    lapply(mesos_groups_pretty, function(mesos_group) {
        out <- list(params = list(mesos_group = mesos_group))
        if (rlang::is_string(subtitle_separator)) {
            out$title <- mesos_group
            out$subtitle <- paste0(basename(main_directory), subtitle_separator, mesos_var_pretty)
        }
        out
    }) |>
        stats::setNames(nm = fs::path(mesos_groups_base_paths, "_metadata.yml"))
}


create_mesos_stubs_from_main_files <- function(mesos_df,
                                               main_directory,
                                               mesos_var_subfolder,
                                               files_to_process,
                                               subtitle_separator = " - ",
                                               prefix = '{{< include \"',
                                               suffix = '\" >}}') {
    # For each mesos_var
    for (j in seq_len(length(mesos_df))) {
        mesos_var <- names(mesos_df[[j]])[1]
        mesos_var_pretty <- unname(get_raw_labels(mesos_df[[j]], col_pos = 1))
        if (is.null(mesos_var_pretty)) mesos_var_pretty <- mesos_var
        mesos_groups_pretty <- as.character(mesos_df[[j]][[1]])
        mesos_groups_pretty <- mesos_groups_pretty[!is.na(mesos_groups_pretty)]
        mesos_groups_abbr <- filename_sanitizer(mesos_groups_pretty, max_chars = 12, accept_hyphen = TRUE, make_unique = TRUE)
        # mesos_groups_base_paths <- fs::path(main_directory, mesos_var, mesos_var_subfolder, mesos_groups_abbr)
        fs::dir_create(fs::path(main_directory, mesos_var, mesos_var_subfolder))

        ## Assumes pre-cleaning of mesos_var_subfolder
        mesos_var_subfolders <- stringi::stri_split_regex(mesos_var_subfolder, pattern = "[/\\\\]")
        mesos_var_subfolders <- mesos_var_subfolders[[min(c(j, length(mesos_var_subfolder)))]]
        mesos_var_subfolders <- stringi::stri_remove_empty_na(mesos_var_subfolders)

        includes_df <- create_includes_content_path_df(
            files_to_process = basename(unname(files_to_process)),
            main_directory = main_directory,
            mesos_var = mesos_var,
            mesos_var_subfolders = mesos_var_subfolders,
            mesos_groups_abbr = mesos_groups_abbr,
            prefix = prefix,
            suffix = suffix
        )
        for (i in seq_len(nrow(includes_df))) {
            cat(includes_df[i, "content", drop = TRUE], file = includes_df[i, "path", drop = TRUE])
        }

        ########################
        # Write _metadata.yml in each mesos_var folder
        yaml::write_yaml(
            x = list(params = list(
                mesos_var = mesos_var,
                mesos_var_pretty = mesos_var_pretty
            )),
            file = fs::path(main_directory, mesos_var, "_metadata.yml")
        )
        # Write empty metadata.yml files in all child folders of mesos_var that is not the mesos_group folders
        # Uses trick of fs::path returning a character vector if mesos_var_subfolders is a vector
        # Avoids overwriting in case user has modified it manually
        for (f in fs::path(main_directory, mesos_var, mesos_var_subfolders, "_metadata.yml")) {
            cat(file = f, append = TRUE)
        }


        ###############################
        yml_contents <- create_metadata_yml(
            mesos_groups_pretty = mesos_groups_pretty,
            main_directory = main_directory,
            subtitle_separator = subtitle_separator,
            mesos_var = mesos_var,
            mesos_var_pretty = mesos_var_pretty,
            mesos_var_subfolder = mesos_var_subfolder,
            mesos_groups_abbr = mesos_groups_abbr
        )
        fs::dir_create(dirname(names(yml_contents)))
        for (i in seq_along(yml_contents)) {
            yaml::write_yaml(x = yml_contents[[i]], file = names(yml_contents)[i])
        }
        # for (i in seq_along(mesos_groups_pretty)) {
        #     mesos_group <- mesos_groups_pretty[i]

        #     # Write _metadata.yml in each mesos_group folder
        #     yml_contents <- list(
        #         params = list(mesos_group = mesos_group)
        #     )
        #     if (rlang::is_string(subtitle_separator)) {
        #         yml_contents$title <- mesos_group
        #         yml_contents$subtitle <- paste0(basename(main_directory), subtitle_separator, mesos_var_pretty)
        #     }
        #     yaml::write_yaml(
        #         x = yml_contents,
        #         file = fs::path(mesos_groups_base_paths[i], "_metadata.yml")
        #     )
        # }
    }
}



#' Simply create qmd-files and yml-files for mesos reports
#' @param main_directory String, path to where the _metadata.yml, stub QMD-files and their subfolders are created.
#' @param mesos_var_subfolder String, optional name of a subfolder of the mesos_var folder in where to place all mesos_group folders.
#' @param files_to_process Character vector of files used as templates for the mesos stubs.
#' @param mesos_df List of single-column data frames where each variable is a mesos variable, optionally with a variable label indicating its pretty name. The values in each variable are the mesos groups. NA is silently ignored.
#' @param main_files Character vector of files for which titles should be set as the mesos_group. Optional but recommended.
#' @param read_syntax_pattern,read_syntax_replacement Optional strings, any regex pattern to search and replace in the qmd-files. If NULL, will ignore it.
#' @param qmd_regex String. Experimental feature for allowing Rmarkdown, not yet tested.
#' @param subtitle_separator String or NULL. If a string will add title and subtitle fields to the _metadata.yml-files in the deepest child folders. The title is the mesos_group. The subtitle is a concatenation of the folder name of the main_directory and the mesos_var label.
#' @param prefix,suffix String for the include section of the stub qmd files.
#' @export
setup_mesos <- function(
    main_directory,
    mesos_var_subfolder = "",
    files_to_process,
    mesos_df,
    main_files = c("index", "report"),
    read_syntax_pattern = "qs::qread\\('",
    read_syntax_replacement = "qs::qread('../",
    qmd_regex = "\\.qmd",
    subtitle_separator = " - ",
    prefix = '{{< include \"../',
    suffix = '\" >}}') {
    ## Checks

    if (!inherits(main_directory, "character") || length(main_directory) == 0) cli::cli_abort("{.arg main_directory} must be a string, not {.obj_type_friendly {main_directory}}")
    if (is.null(mesos_var_subfolder) || length(mesos_var_subfolder) != 1 || is.na(mesos_var_subfolder)) mesos_var_subfolder <- ""
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
    if (!inherits(qmd_regex, "character") || length(qmd_regex) != 1) cli::cli_abort("{.arg qmd_regex} must be a string, not a {.obj_type_friendly {qmd_regex}}")
    if (!inherits(prefix, "character") || length(prefix) != 1) cli::cli_abort("{.arg prefix} must be a string, not a {.obj_type_friendly {prefix}}")
    if (!inherits(suffix, "character") || length(suffix) != 1) cli::cli_abort("{.arg suffix} must be a string, not a {.obj_type_friendly {suffix}}")


    create_mesos_stubs_from_main_files(
        mesos_df = mesos_df,
        main_directory = main_directory,
        mesos_var_subfolder = mesos_var_subfolder,
        files_to_process = files_to_process,
        subtitle_separator = subtitle_separator,
        prefix = prefix,
        suffix = suffix
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
