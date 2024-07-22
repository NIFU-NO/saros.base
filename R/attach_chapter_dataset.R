attach_chapter_dataset <- function(chapter_structure_chapter,
                                   data,
                                   path,
                                   chapter_foldername_clean,
                                   mesos_var,
                                   auxiliary_variables,
                                   serialized_format = "rds") {

  if(is.null(chapter_foldername_clean) || is.na(chapter_foldername_clean)) {
    cli::cli_abort("{.arg chapter_foldername_clean} must be a string (without a dot), not {.val {chapter_foldername_clean}} ({.obj_type_pretty {chapter_foldername_clean}}).")
  }
  if(is.null(serialized_format) || is.na(serialized_format)) {
    cli::cli_abort("{.arg serialized_format} must be a string (without a dot), not {.val {serialized_format}} ({.obj_type_pretty {serialized_format}}).")
  }


  dep_vars <- names(unlist(eval_cols(unique(as.character(chapter_structure_chapter$.variable_selection_dep)), data=data)))
  indep_vars <- names(unlist(eval_cols(unique(as.character(chapter_structure_chapter$.variable_selection_indep)), data=data)))

  data_chapter <- data[, names(data) %in% unique(c(dep_vars,
                                                   indep_vars,
                                                   mesos_var,
                                                   auxiliary_variables)), drop = FALSE]

  filename_chapter_dataset <-
    stringi::stri_c("data_", chapter_foldername_clean, ".", serialized_format, ignore_null = TRUE)
  filepath_chapter_dataset_absolute <- file.path(path, chapter_foldername_clean, filename_chapter_dataset)
  filepath_chapter_dataset_relative <- file.path(chapter_foldername_clean, filename_chapter_dataset)


  serialize_write(object = data_chapter,
                  path = filepath_chapter_dataset_absolute,
                  format = serialized_format)

  r_chunk_header <- stringi::stri_c("```{r}\n",
                                    "#| label: 'Import data for ",
                                    chapter_foldername_clean,
                                    "'",
                                    sep="", ignore_null = TRUE)
  import_code <- stringi::stri_c("data_",
                                 chapter_foldername_clean,
                                 " <- ",
                                 serialize_read_syntax(serialized_format),
                                 "('", filepath_chapter_dataset_relative, "')",
                                 sep="", ignore_null = TRUE)
  stringi::stri_c(r_chunk_header, import_code, "```", sep="\n")
}
