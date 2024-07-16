validate_path_lengths_on_win <-
  function(path,
           max_path_warning_threshold) {
    max_paths <-
      nchar(list.files(path=path,
                       all.files = TRUE, full.names = TRUE, recursive = TRUE))
    if(.Platform$OS.type == "windows" && max(max_paths, na.rm=TRUE) >= max_path_warning_threshold) {
      cli::cli_warn(c(x="{.val {length(max_path[max_path >= max_path_warning_threshold])}} files exceed {.arg max_path_warning_threshold} ({max_path_warning_threshold}) characters.",
                      i="This may create problems in Windows if path is on a Sharepoint/OneDrive.",
                      i="Omit warning by adjusting {.arg max_path_warning_threshold}"))
    }
  }
