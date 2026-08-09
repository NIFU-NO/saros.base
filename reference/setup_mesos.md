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
  read_syntax_pattern = "readRDS\\('",
  read_syntax_replacement = "readRDS('../../",
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
  to place all mesos_group folders. A value containing `/` or `\`
  creates nested directories, so `"Rapport/Del1"` places the group
  folders in `<mesos_var>/Rapport/Del1/`.

- files_to_process:

  Character vector of files used as templates for the mesos stubs.

- mesos_df:

  List of data frames where each is a mesos variable, optionally with a
  variable label indicating its pretty name. The values in the first
  column are the mesos groups, and NA among them is silently ignored,
  dropping the row. An optional second column gives each group's
  abbreviation, which names its folder; supply one for every group, as
  an abbreviation that is NA or empty is an error naming the group it
  belongs to. Omit the column entirely to have abbreviations generated
  from the group names.

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
