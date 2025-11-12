# Simply create qmd-files and yml-files for mesos reports

Simply create qmd-files and yml-files for mesos reports

## Usage

``` r
setup_mesos(
  main_directory = character(),
  mesos_var_subfolder = character(),
  files_to_process,
  mesos_df,
  files_taking_title = c("index.qmd", "report.qmd"),
  read_syntax_pattern = "qs::qread\\('",
  read_syntax_replacement = "qs::qread('../../",
  qmd_regex = "\\.qmd",
  subtitle_separator = " - ",
  prefix = "{{< include \"",
  suffix = "\" >}}"
)
```

## Arguments

- main_directory:

  String, path to where the \_metadata.yml, stub QMD-files and their
  subfolders are created.

- mesos_var_subfolder:

  String, optional name of a subfolder of the mesos_var folder in where
  to place all mesos_group folders.

- files_to_process:

  Character vector of files used as templates for the mesos stubs.

- mesos_df:

  List of single-column data frames where each variable is a mesos
  variable, optionally with a variable label indicating its pretty name.
  The values in each variable are the mesos groups. NA is silently
  ignored.

- files_taking_title:

  Character vector of files for which titles should be set. Optional but
  recommended.

- read_syntax_pattern, read_syntax_replacement:

  Optional strings, any regex pattern to search and replace in the
  qmd-files. If NULL, will ignore it.

- qmd_regex:

  String. Experimental feature for allowing Rmarkdown, not yet tested.

- subtitle_separator:

  String or NULL. If a string will add title and subtitle fields to the
  \_metadata.yml-files in the deepest child folders. The title is the
  mesos_group. The subtitle is a concatenation of the folder name of the
  main_directory and the mesos_var label.

- prefix, suffix:

  String for the include section of the stub qmd files.
