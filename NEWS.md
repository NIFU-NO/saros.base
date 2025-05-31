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
