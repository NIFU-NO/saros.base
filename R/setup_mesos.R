search_and_replace_files <- function(
  files,
  pattern,
  replacement
) {
    if (is.null(pattern) || is.null(replacement)) {
        return(files)
    }
    if (!is.character(pattern) ||
        !is.character(replacement) ||
        length(pattern) != length(replacement)) {
        cli::cli_abort("{.arg pattern} and {.arg replacement} must be character vectors of same length.")
    }

    files |>
        unname() |>
        lapply(FUN = function(.x) {
            readLines(.x, warn = FALSE) |>
                stringi::stri_replace_all_regex(pattern, replacement) |>
                writeLines(.x)
        })
    files
}

# Helper: Validate input parameters for includes creation
validate_includes_params <- function(prefix, suffix, files_to_process) {
    if (!rlang::is_string(prefix)) cli::cli_abort("{.arg prefix} must be a string.")
    if (!rlang::is_string(suffix)) cli::cli_abort("{.arg suffix} must be a string.")
    if (missing(files_to_process) || !is.character(files_to_process)) cli::cli_abort("{.arg files_to_process} must be a character vector.")
}

# Helper: Process filename based on path level
process_filename_by_level <- function(filename, path_lvl, total_levels, is_child = TRUE) {
    if (is_child && path_lvl == 1) {
        # Inner-most child: remove leading underscore
        stringi::stri_replace_first_regex(filename, pattern = "^_", replacement = "")
    } else if (is_child && path_lvl != 1) {
        # Add leading underscore if not present
        stringi::stri_replace_first_regex(filename, pattern = "^(?!_)", replacement = "_")
    } else if (!is_child && path_lvl != total_levels) {
        # Parent file: add leading underscore if not at top level
        stringi::stri_replace_first_regex(filename, pattern = "^(?!_)", replacement = "_")
    } else {
        filename
    }
}

# Helper: Create include content with relative path
#
# Every stub includes the file one directory above it, so the hop is always a
# single "../" regardless of depth. `create_includes_content_path_df()` emits
# one stub per level and `process_mesos_subfolders()` has already split
# `mesos_var_subfolder` into one element per directory, so consecutive levels
# differ by exactly one path component.
create_include_content <- function(filename_parent, prefix, suffix) {
    paste0(prefix, "../", filename_parent, suffix)
}

# Helper: Add title YAML if file requires it
add_title_if_needed <- function(content, path, mesos_group_pretty, files_taking_title) {
    if (basename(path) %in% files_taking_title && !is.na(mesos_group_pretty)) {
        yaml_header <- add_yaml_fences(yaml::as.yaml(list(title = mesos_group_pretty)))
        paste(yaml_header, content, sep = "\n\n")
    } else {
        content
    }
}

# Helper: Process a single file at a specific path level
process_file_at_level <- function(filename_parent, path_lvl, total_levels,
                                  mesos_groups_abbr, mesos_groups_pretty,
                                  prefix, suffix, files_taking_title) {
    filename_child <- process_filename_by_level(filename_parent, path_lvl, total_levels, is_child = TRUE)
    filename_parent_processed <- process_filename_by_level(filename_parent, path_lvl, total_levels, is_child = FALSE)

    mesos_group <- NA_character_
    mesos_group_pretty <- NA_character_

    # Add mesos group folders for innermost level
    if (path_lvl == 1 && length(mesos_groups_abbr) > 0) {
        mesos_group <- mesos_groups_abbr
        mesos_group_pretty <- mesos_groups_pretty
        filename_child <- fs::path(mesos_groups_abbr, filename_child)
    }

    content <- create_include_content(filename_parent_processed, prefix, suffix)

    data.frame(
        content = content,
        mesos_group = mesos_group,
        mesos_group_pretty = mesos_group_pretty,
        path = filename_child,
        stringsAsFactors = FALSE
    ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
            content = add_title_if_needed(
                .data$content, .data$path,
                .data$mesos_group_pretty, files_taking_title
            )
        ) |>
        dplyr::ungroup()
}

create_includes_content_path_df <-
    function(files_to_process,
             main_directory = character(),
             mesos_var = character(),
             mesos_var_subfolders = character(), # Assumed always a character vector or NULL
             mesos_groups_abbr = character(),
             mesos_groups_pretty = character(),
             files_taking_title = c("index.qmd", "report.qmd"),
             prefix = '{{< include \"',
             suffix = '\" >}}') {
        validate_includes_params(prefix, suffix, files_to_process)

        ## By design, the order of this vector does not match the working order
        full_dir_path <- c(
            main_directory, mesos_var, mesos_var_subfolders,
            if (length(mesos_groups_abbr) > 0) ""
        )
        total_levels <- length(full_dir_path)

        # Levels are walked from the deepest (group folders) upwards. The
        # directory holding the authored sources is the terminus of the include
        # chain and must not receive a stub -- writing one there would overwrite
        # the sources with an include pointing outside the tree.
        #
        # Where that directory sits depends on `main_directory`:
        #   supplied  -> it is `full_dir_path[1]`, so the outermost level is
        #                skipped;
        #   empty     -> the sources live in the working directory, which is not
        #                part of `full_dir_path` at all, so every level here is
        #                an intermediate one and all of them need a stub.
        has_main_directory <- length(main_directory) > 0 && any(nzchar(main_directory))
        n_stub_levels <- if (has_main_directory) total_levels - 1L else total_levels

        includes_df <-
            seq_len(max(n_stub_levels, 0L)) |>
            lapply(FUN = function(path_lvl) {
                dir_path <- fs::path_join(stringi::stri_remove_empty_na(
                    full_dir_path[seq_len(total_levels - path_lvl + 1)]
                ))

                lapply(files_to_process, function(filename_parent) {
                    process_file_at_level(
                        filename_parent, path_lvl, total_levels,
                        mesos_groups_abbr, mesos_groups_pretty,
                        prefix, suffix, files_taking_title
                    )
                }) |>
                    dplyr::bind_rows() |>
                    dplyr::mutate(
                        path = if (nchar(dir_path)) fs::path(dir_path, .data$path) else .data$path
                    )
            }) |>
            dplyr::bind_rows()

        includes_df
    }


create_index_qmd <- function(
  main_directory = character(),
  mesos_var = character(),
  mesos_var_pretty = character()
) {
    if (length(mesos_var) != length(mesos_var_pretty)) cli::cli_abort("mesos_var and mesos_var_pretty must be of same length.")
    for (i in seq_along(mesos_var)) {
        contents <- add_yaml_fences(yaml::as.yaml(list(title = mesos_var_pretty[i])))
        # Trailing newline: without it readLines() and other text tools warn
        # about an "incomplete final line".
        cat(contents, "\n", sep = "", file = fs::path_join(c(main_directory, mesos_var[i], "index.qmd")))
    }
}

create_metadata_yml <- function(main_directory = character(),
                                mesos_var = character(),
                                mesos_var_pretty = character(),
                                mesos_var_subfolder = character(),
                                mesos_groups_pretty,
                                mesos_groups_abbr,
                                subtitle_separator = " - ") {
    if (length(mesos_groups_pretty) != length(mesos_groups_abbr)) cli::cli_abort("{.arg mesos_groups_pretty} must be of same length as {.arg mesos_groups_abbr}")
    ###
    main_dir <- if (is.null(main_directory)) character() else main_directory
    mesos_var_subfolder <- if (is.null(mesos_var_subfolder)) character() else mesos_var_subfolder
    base_path <- fs::path_join(stringi::stri_remove_empty_na(c(main_dir, mesos_var, mesos_var_subfolder)))


    lapply(mesos_groups_pretty, function(mesos_group_pretty) {
        out <- list(params = list(mesos_group = mesos_group_pretty))
        if (rlang::is_string(subtitle_separator)) {
            out$title <- mesos_group_pretty
            out$subtitle <- paste(c(basename(main_dir), mesos_var_pretty, mesos_group_pretty), collapse = subtitle_separator)
        }
        out
    }) |>
        stats::setNames(nm = fs::path(base_path, mesos_groups_abbr, "_metadata.yml"))
}


# Helper: Refuse abbreviations that cannot address a folder of their own (GH #244)
#
# Each abbreviation names one group folder. An empty one makes fs::path() drop
# the segment, so the group's _metadata.yml lands on <mesos_var>/_metadata.yml
# and destroys params$mesos_var for every sibling group, while the group's own
# folder is never created. A duplicated one makes two groups share a folder, and
# the last group written wins. Both failures are silent and both destroy files
# that already exist, so this aborts rather than warns.
#
# This guards the abbreviations however they arose -- filename_sanitizer() no
# longer returns "", but an explicit abbreviation column is passed through
# untouched and make.unique() is not applied to it.
validate_mesos_groups_abbr <- function(mesos_var,
                                       mesos_groups_pretty,
                                       mesos_groups_abbr) {
    # The pretty names identify the offending groups in the message, but the
    # two vectors are NA-filtered independently above and can differ in length;
    # fall back to positions when they do not line up.
    labels <- if (length(mesos_groups_pretty) == length(mesos_groups_abbr)) {
        mesos_groups_pretty
    } else {
        paste("group", seq_along(mesos_groups_abbr))
    }

    # The messages name no argument. This helper is reached from setup_mesos(),
    # whose argument is `mesos_df`, and from setup_mesos_structure(), whose
    # argument is `mesos_groups` and may be a named list in which "a column of
    # abbreviations" is not a thing the caller can point at. Naming either one
    # misdirects half the callers, so the messages state the property that must
    # hold instead.
    is_empty <- is.na(mesos_groups_abbr) | !nzchar(mesos_groups_abbr)
    if (any(is_empty)) {
        cli::cli_abort(c(
            "Every mesos group needs a non-empty abbreviation, as it names the group's folder.",
            "x" = "Mesos variable {.val {mesos_var}} has no usable abbreviation for {.val {labels[is_empty]}}.",
            "i" = "Give each of these groups an explicit, non-empty abbreviation."
        ))
    }

    duplicates <- unique(mesos_groups_abbr[duplicated(mesos_groups_abbr)])
    if (length(duplicates) > 0) {
        cli::cli_abort(c(
            "Mesos group abbreviations must be unique, as each names its own folder.",
            "x" = "Mesos variable {.val {mesos_var}} uses {.val {duplicates}} for more than one group.",
            "i" = "Groups sharing an abbreviation: {.val {labels[mesos_groups_abbr %in% duplicates]}}."
        ))
    }

    invisible(mesos_groups_abbr)
}

# Helper: Extract mesos variable metadata from data frame
extract_mesos_metadata <- function(mesos_df_entry) {
    mesos_var <- names(mesos_df_entry)[1]
    # get_raw_labels() returns NA_character_ for an unlabelled column, never
    # NULL, so an is.null() guard here never fired: the display name stayed NA
    # and yaml::as.yaml() wrote it out as `.na.character` -- visible as the
    # title of <mesos_var>/index.qmd. Fall back to the column name instead.
    mesos_var_pretty <- unname(get_raw_labels(mesos_df_entry, col_pos = 1))
    if (length(mesos_var_pretty) != 1 || is.na(mesos_var_pretty) || !nzchar(mesos_var_pretty)) {
        mesos_var_pretty <- mesos_var
    }

    # One mask over both columns (GH #253), the same shape as #248's fix in
    # handle_legacy_format().
    #
    # These two vectors used to be filtered for NA independently, and nothing
    # held them in step: an NA in one column but not the other shifted every
    # later element of that vector relative to the other, so a group was paired
    # with the abbreviation belonging to a different group.
    # validate_mesos_groups_abbr() (GH #244) did not object, because the
    # borrowed abbreviation is neither empty nor duplicated.
    #
    # `keep` is derived from the group names because a missing group name is
    # what makes a row unusable, and `?setup_mesos` documents that NA in
    # `mesos_df` is silently ignored. The abbreviation column is indexed by that
    # same mask rather than filtered on its own, so the row's abbreviation goes
    # with the row.
    mesos_groups_pretty <- as.character(mesos_df_entry[[1]])
    keep <- !is.na(mesos_groups_pretty)
    mesos_groups_pretty <- mesos_groups_pretty[keep]

    if (ncol(mesos_df_entry) >= 2 && !is.null(mesos_df_entry[[2]])) {
        # A missing abbreviation is a fault to be reported, not a row to drop --
        # dropping it is what shortened the column in the first place. Both
        # spellings of "absent" become "" so that validate_mesos_groups_abbr()
        # rejects it by naming the group it belongs to, as #252 already arranged
        # for the setup_mesos_structure() route.
        #
        # That includes an abbreviation column of nothing but NA. Filtering used
        # to reduce such a column to length zero, which did not mean "generate
        # abbreviations": it made create_includes_content_path_df() skip the
        # group-folder level and create_metadata_yml() abort on its length
        # guard, after <mesos_var>/_metadata.yml, index.qmd and the stubs had
        # been written, with a message naming two internal variables. Only an
        # absent column means "generate them".
        mesos_groups_abbr <- as.character(mesos_df_entry[[2]])[keep]
        mesos_groups_abbr[is.na(mesos_groups_abbr)] <- ""
    } else {
        mesos_groups_abbr <- filename_sanitizer(mesos_groups_pretty, max_chars = 12, accept_hyphen = TRUE, make_unique = TRUE)
    }

    validate_mesos_groups_abbr(
        mesos_var = mesos_var,
        mesos_groups_pretty = mesos_groups_pretty,
        mesos_groups_abbr = mesos_groups_abbr
    )

    list(
        mesos_var = mesos_var,
        mesos_var_pretty = mesos_var_pretty,
        mesos_groups_pretty = mesos_groups_pretty,
        mesos_groups_abbr = mesos_groups_abbr
    )
}

# Helper: Process mesos variable subfolders
process_mesos_subfolders <- function(mesos_var_subfolder, j) {
    if (length(mesos_var_subfolder)) {
        mesos_var_subfolders <- stringi::stri_split_regex(mesos_var_subfolder, pattern = "[/\\\\]")
        mesos_var_subfolders <- mesos_var_subfolders[[min(c(j, length(mesos_var_subfolder)))]]
        stringi::stri_remove_empty_na(mesos_var_subfolders)
    } else {
        character()
    }
}

# Helper: Write stub QMD files from includes data frame
write_stub_files <- function(includes_df) {
    for (i in seq_len(nrow(includes_df))) {
        fs::dir_create(dirname(includes_df[i, "path", drop = TRUE]))
        cat(includes_df[i, "content", drop = TRUE], "\n",
            sep = "", file = includes_df[i, "path", drop = TRUE])
    }
}

# Helper: Write mesos variable metadata files
write_mesos_var_metadata <- function(main_directory, mesos_var, mesos_var_pretty) {
    yaml::write_yaml(
        x = list(params = list(
            mesos_var = mesos_var,
            mesos_var_pretty = mesos_var_pretty
        )),
        file = fs::path(if (length(main_directory)) main_directory else ".", mesos_var, "_metadata.yml")
    )

    create_index_qmd(
        main_directory = main_directory,
        mesos_var = mesos_var,
        mesos_var_pretty = mesos_var_pretty
    )
}

# What an intermediate `_metadata.yml` contains when the package has nothing to
# put in it (GH #272).
#
# An empty *file* is not an option: Quarto rejects a zero-byte `_metadata.yml`
# at project level with "Directory metadata validation failed ... YAML value is
# missing", which takes down the whole render before any R runs. Nor is
# `yaml::write_yaml(list(), f)`, the obvious fix -- it emits `[]`, a sequence
# rather than a mapping, which Quarto also rejects. Measured:
#
#   no file at all   accepted        "{}"           accepted
#   zero bytes       REJECTED        "[]"           REJECTED
#   a comment alone  REJECTED        "# ...\n{}"    accepted
#
# Hence a literal `{}`, written by hand rather than serialised.
subfolder_metadata_placeholder <- c(
    "# Placeholder written by saros.base. Quarto rejects an empty _metadata.yml,",
    "# so this is an empty mapping rather than an empty file. Add keys freely.",
    "{}"
)

# Helper: Write placeholder metadata files for subfolders
#
# `mesos_var_subfolders` holds one element per directory level, so the paths
# must nest cumulatively. `fs::path()` vectorises over them instead, which for
# c("Rapport", "Del1") yields the siblings <var>/Rapport and <var>/Del1 -- the
# second does not exist, and writing to it errors.
write_subfolder_metadata <- function(main_directory, mesos_var, mesos_var_subfolders) {
    base <- if (length(main_directory)) main_directory else "."
    for (depth in seq_along(mesos_var_subfolders)) {
        f <- fs::path_join(c(
            base, mesos_var, mesos_var_subfolders[seq_len(depth)], "_metadata.yml"
        ))
        # A file a project has filled in is left alone -- that is what the
        # previous `cat(append = TRUE)` bought, and it must survive. A
        # zero-byte one is overwritten rather than kept: it is the artifact of
        # #272 and leaves the project unrenderable, so re-running repairs it.
        if (fs::file_exists(f) && file.size(f) > 0) next
        writeLines(subfolder_metadata_placeholder, con = f)
    }
}

# Helper: Write group-level metadata files
write_group_metadata <- function(yml_contents) {
    fs::dir_create(dirname(names(yml_contents)))
    for (i in seq_along(yml_contents)) {
        yaml::write_yaml(x = yml_contents[[i]], file = names(yml_contents)[i])
    }
}

create_mesos_stubs_from_main_files <- function(mesos_df,
                                               main_directory,
                                               mesos_var_subfolder,
                                               files_to_process,
                                               files_taking_title,
                                               subtitle_separator = " - ",
                                               prefix = '{{< include \"',
                                               suffix = '\" >}}') {
    # Metadata for every mesos_var is extracted -- and therefore validated by
    # validate_mesos_groups_abbr() -- before the writing loop starts, so a bad
    # abbreviation in the second mesos variable does not leave the first one
    # half-written (GH #244).
    metadata_per_var <- lapply(mesos_df, extract_mesos_metadata)

    # For each mesos_var
    for (j in seq_len(length(mesos_df))) {
        # Extract metadata
        metadata <- metadata_per_var[[j]]
        mesos_var_subfolders <- process_mesos_subfolders(mesos_var_subfolder, j)

        # Create all the brief qmd stubs
        includes_df <- create_includes_content_path_df(
            files_to_process = basename(unname(files_to_process)),
            main_directory = main_directory,
            mesos_var = metadata$mesos_var,
            mesos_var_subfolders = mesos_var_subfolders,
            mesos_groups_abbr = metadata$mesos_groups_abbr,
            mesos_groups_pretty = metadata$mesos_groups_pretty,
            files_taking_title = files_taking_title,
            prefix = prefix,
            suffix = suffix
        )

        # Write stub files
        write_stub_files(includes_df)

        # Write _metadata.yml and index.qmd in each mesos_var folder
        write_mesos_var_metadata(main_directory, metadata$mesos_var, metadata$mesos_var_pretty)

        # Write empty metadata.yml files in subfolders that are not mesos_group folders
        write_subfolder_metadata(main_directory, metadata$mesos_var, mesos_var_subfolders)

        # Write group-level metadata
        yml_contents <- create_metadata_yml(
            main_directory = main_directory,
            mesos_var = metadata$mesos_var,
            mesos_var_pretty = metadata$mesos_var_pretty,
            mesos_var_subfolder = mesos_var_subfolders,
            mesos_groups_pretty = metadata$mesos_groups_pretty,
            mesos_groups_abbr = metadata$mesos_groups_abbr,
            subtitle_separator = subtitle_separator
        )
        write_group_metadata(yml_contents)
    }
}


#' Simply create qmd-files and yml-files for mesos reports
#' @param main_directory String, path to where the _metadata.yml, stub QMD-files
#'      and their subfolders are created.
#' @param mesos_var_subfolder String, optional name of a subfolder of the
#'      mesos_var folder in where to place all mesos_group folders. A value
#'      containing `/` or `\` creates nested directories, so `"Rapport/Del1"`
#'      places the group folders in `<mesos_var>/Rapport/Del1/`.
#' @param files_to_process Character vector of files used as templates for the mesos stubs.
#' @param mesos_df List of data frames where each is a mesos variable, optionally
#'      with a variable label indicating its pretty name. The values in the first
#'      column are the mesos groups, and NA among them is silently ignored,
#'      dropping the row. An optional second column gives each group's
#'      abbreviation, which names its folder; supply one for every group, as an
#'      abbreviation that is NA or empty is an error naming the group it belongs
#'      to. Omit the column entirely to have abbreviations generated from the
#'      group names.
#' @param files_taking_title Character vector of files for which titles should
#'      be set. Optional but recommended.
#' @param read_syntax_pattern,read_syntax_replacement Optional strings, any
#'      regex pattern to search and replace in the qmd-files. If NULL, will ignore it.
#' @param qmd_regex String. Experimental feature for allowing Rmarkdown, not yet tested.
#' @param subtitle_separator String or NULL. If a string will add title and subtitle
#'     fields to the _metadata.yml-files in the deepest child folders. The title is
#'     the mesos_group. The subtitle is a concatenation of the folder name of the
#'     main_directory and the mesos_var label.
#' @param prefix,suffix String for the include section of the stub qmd files.
#' @export
setup_mesos <- function(
  main_directory = character(),
  mesos_var_subfolder = character(),
  files_to_process,
  mesos_df,
  files_taking_title = c("index.qmd", "report.qmd"),
  read_syntax_pattern = "readRDS\\('",
  read_syntax_replacement = "readRDS('../../",
  qmd_regex = "\\.qmd",
  subtitle_separator = " - ",
  prefix = '{{< include \"',
  suffix = '\" >}}'
) {
    ## Checks

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
    if (!is.list(mesos_df)) {
        cli::cli_abort("{.arg mesos_df} must be a list of single-column data.frames, not {.obj_type_friendly {mesos_df}}")
    }
    if (!inherits(files_taking_title, "character")) {
        cli::cli_abort("{.arg files_taking_title} must be a character vector, not a {.obj_type_friendly {files_taking_title}}")
    }
    if (!is.null(read_syntax_pattern) && !inherits(read_syntax_pattern, "character")) {
        cli::cli_abort("{.arg read_syntax_pattern} must be a string (regex) or NULL (i.e. ignore), not a {.obj_type_friendly {read_syntax_pattern}}")
    }
    if (!is.null(read_syntax_replacement) && !inherits(read_syntax_replacement, "character")) {
        cli::cli_abort("{.arg read_syntax_replacement} must be a string (regex) or NULL (i.e. ignore), not a {.obj_type_friendly {read_syntax_replacement}}")
    }
    if (!inherits(qmd_regex, "character") || length(qmd_regex) != 1) {
        cli::cli_abort("{.arg qmd_regex} must be a string, not a {.obj_type_friendly {qmd_regex}}")
    }
    if (!inherits(prefix, "character") || length(prefix) != 1) {
        cli::cli_abort("{.arg prefix} must be a string, not a {.obj_type_friendly {prefix}}")
    }
    if (!inherits(suffix, "character") || length(suffix) != 1) {
        cli::cli_abort("{.arg suffix} must be a string, not a {.obj_type_friendly {suffix}}")
    }


    create_mesos_stubs_from_main_files(
        mesos_df = mesos_df,
        main_directory = main_directory,
        mesos_var_subfolder = mesos_var_subfolder,
        files_to_process = files_to_process,
        files_taking_title = files_taking_title,
        subtitle_separator = subtitle_separator,
        prefix = prefix,
        suffix = suffix
    )

    if (is.character(read_syntax_pattern) &&
        is.character(read_syntax_replacement) &&
        nchar(read_syntax_pattern) > 0 &&
        nchar(read_syntax_replacement) > 0) {
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
