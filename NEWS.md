# saros.base 1.2.0
* Added file logging for excluded/ignored variables via `log_file` parameter in `refine_chapter_overview()`. All removal functions now log which variables/entries are excluded and why (all NA, low n, non-significant, no overlap, type mismatch).

# saros.base 1.1.0

* `create_directory_structure()` example does not create files and folders on disk to save time. 
* Templates for mesos output now include newlines between target and others. Thanks to Jon Furuholt for the suggestion.
* `draft_report()` now has argument `write_qmd` to toggle the creation of qmd-files.
* Attempted fix of internal arrange2 sorting function. Very hard to get right.

# saros.base 1.0.0

## Major changes

* Total revision of the entire architecture for maximum flexibility, stability and performance. 
* Uses glue templates for creating chunks, see `refine_chapter_structure()`.
* `draft_report()` 
* Breaking changes for mesos setup, now uses `setup_mesos()` as well for creating stub files referring to a smaller set of main files created by `draft_report()`.
* Countless bugfixes.

## Minor changes
* Helper function `remove_entry_from_sidebar()` for post-processing HTML-files
* Many more validations of arguments and better error messages.

# saros.base 0.2.2

* Added vignettes.

# saros.base 0.2.1

* CRAN release.
