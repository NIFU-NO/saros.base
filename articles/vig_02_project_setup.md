# Project setup

## 1 Create a research project folder from scratch

- The following is intended for creating and maintaining a consistent
  and well-organized folder structure, based on some international
  “standards”.
- If you have already set up a project structure or data collection,
  jump to [Section 2](#sec-tailor-project-settings).

### 1.1 Whatever you chose…

> **Warning**
>
> Irrespective of the path A or B taken below, you want to distinguish
> between
>
> - the folder where report generations are placed (never store your own
>   work here as it may be overwritten by Saros)
>
> - the folder for each chapter where one writes, edits and store
>   versions for proofing, etc. Saros will never touch these folders.
>
> - the folder where complete chapters are placed for publication on a
>   website. Quarto Website Project will read from this and generate a
>   website, reports as PDFs, DOCXs, etc.

### 1.2 Path A: Copy entire folder structure

Copy from an existing project using Saros, and edit the 00\*\_ R-files
and \_quarto.yaml files for project-specific settings.

``` r
saros.base::copy_folder_contents_to_dir(
  from, 
  to = getwd(),
  only_copy_folders = FALSE)
```

### 1.3 Path B: Add only Saros to an existing project folder

Very often you have an existing project going, and only want to add the
Saros-specific report production setup.

An easy basis to get going is the project template used by the [Nordic
Institute for the Studies of Innovation, Research, and Education
(NIFU)](https://www.nifu.no). Remember to have your project folder
synchronized if this already exists.

``` r
library(saros.base)
saros.base::download_zip_to_folder(out_path = fs::path(getwd(), "Saros")) # Set to your project folder's Saros-folder (keep absolute folder path as short as possible)
```

### 1.4 Path C: Generate a complete folder structure from a folder structure file

This will create empty folders and thus force projects to follow a
certain template. The template can be modified to an organization’s
liking.

``` r
# Modify these to your liking
project_path <- 
  fs::path(getwd())
project_initials <- "SMILE"
saros_folder_name <- "Saros"
project_structure_yaml_path <- "project_folder_structure.yaml"

# Se function help for more details
saros.base::initialize_saros_project(
  path = project_path, 
  structure_path = project_structure_yaml_path, 
  replacement_list = c("prosjekt_initialer" = project_initials),
  numbering_prefix = "global_max",
  numbering_inheritance = TRUE,
  word_separator = NULL,
  numbering_name_separator = " ",
  numbering_parent_child_separator = NULL,
  case = "asis",
  count_existing_folders = FALSE,
  r_files_out_path = fs::path(project_path, paste0(saros_folder_name, project_initials), "01_script", "script_templates"), 
  create = FALSE) # SET create = TRUE when you are satisfied with the folder structure
```

## 2 Tailor project settings

- Saros expands upon the inheritance idea in Quarto and allows setting
  and exempting settings inheritance-wise: organization level, project
  level, report cycle, chapter and chunk. This means that one can set
  defaults which can be overridden per project or per report.
- For instance, [NIFU](https://www.nifu.no) sets its organization-level
  settings that apply to all projects in one global R-file, which
  contains figure colour palette rules, special functions, and so forth.
  - This is currently limited to R-files used for generating reports and
    for rendering reports. The yaml metadata is currently duplicated per
    project, and will be in the future centralized in one location.
- File lanes in particular must be standardized across data collection
  cycles. Avoid that each implementation has its own folder in the
  project’s main folder - experience shows that it is very difficult to
  keep consistent folder structures across years when you are rarely
  confronted with how things have been done in the past. Try as much as
  possible to have the year folder at the bottom of the hierarchy - even
  if this means that you have to copy a number of subfolders every year.

### 2.1 Most important changes

This is a quick approach to changing the most important settings. See
further below for a more detailed explanation.

``` r
quarto_yaml <- yaml::read_yaml(file.path("02_resources", "YAML", "_quarto.yaml"))

quarto_yaml$website$title <- "PROJECT TITLE"
quarto_yaml$website$`site-url` <- "WEBSITE URL"
quarto_yaml$project_no <- "INTERNAL PROJECT NUMBER" # Usually not needed
quarto_yaml$funder <- "FUNDER"
quarto_yaml$funder_address <- "FUNDER'S ADDRESS"
yaml::write_yaml(quarto_yaml, file = file.path("02_resources", "YAML", "_quarto.yaml"))

report_yaml <- yaml::read_yaml(file.path("02_resources", "YAML", "_report_header.yaml"))
report_yaml$signer_1 <- "REPORT SIGNER 1"
report_yaml$signer_1_title <- "REPORT SIGNER 1 JOB TITLE"
report_yaml$signer_1 <- "REPORT SIGNER 2"
report_yaml$signer_1_title <- "REPORT SIGNER 2 JOB TITLE"
report_yaml$report_type <- "rapport" # Usually not needed
yaml::write_yaml(report_yaml, file = file.path("02_resources", "YAML", "_report_header.yaml"))
```
