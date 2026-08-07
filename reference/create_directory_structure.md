# Create a Pre-defined Directory Hierarchy on Disk

Create a Pre-defined Directory Hierarchy on Disk

## Usage

``` r
create_directory_structure(
  path,
  structure_path = system.file("templates", "_project_structure_en.yaml", package =
    "saros.base"),
  numbering_prefix = c("none", "max_local", "max_global"),
  numbering_inheritance = TRUE,
  word_separator = NULL,
  numbering_parent_child_separator = word_separator,
  numbering_name_separator = " ",
  case = c("asis", "sentence", "title", "lower", "upper", "snake"),
  replacement_list = c(project_initials = "SSN"),
  create = FALSE,
  count_existing_folders = FALSE
)
```

## Arguments

- path:

  String, path to where to create the project files

- structure_path:

  String. Path to the YAML file that defines the folder structure.
  Defaults to system.file("templates", "\_project_structure_en.yaml").

- numbering_prefix:

  String. One of c("none", "max_local", "max_global").

- numbering_inheritance:

  Flag. Whether to inherit numbering from parent folder.

- word_separator:

  String. Replace separators between words in folder names. Defaults to
  NULL.

- numbering_parent_child_separator:

  String. Defaults to word_separator.

- numbering_name_separator:

  String. Separator between numbering part and name.

- case:

  String. One of c("asis", "sentence", "lower", "upper", "title",
  "snake").

- replacement_list:

  named character vector. Each name in this vector will be replaced with
  its `"{{value}}"` in the structure_path file

- create:

  Boolean. Defaults to TRUE in initialize_saros_project(), FALSE in
  create_directory_structure().

- count_existing_folders:

  Boolean. Defaults to FALSE.

## Value

No return value, called for side effects

## Examples

``` r
struct <- create_directory_structure(path = tempdir(), create = FALSE)
#> /tmp/Rtmp2nhNvv/Administration
#> /tmp/Rtmp2nhNvv/Administration/Application
#> /tmp/Rtmp2nhNvv/Administration/Application/Call
#> /tmp/Rtmp2nhNvv/Administration/Application/Formalities
#> /tmp/Rtmp2nhNvv/Administration/Application/CVs
#> /tmp/Rtmp2nhNvv/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/Rtmp2nhNvv/Administration/Application/Application
#> /tmp/Rtmp2nhNvv/Administration/Application/Pre-analysis
#> /tmp/Rtmp2nhNvv/Administration/Application/For submission
#> /tmp/Rtmp2nhNvv/Administration/Budget
#> /tmp/Rtmp2nhNvv/Administration/Contracts and agreements
#> /tmp/Rtmp2nhNvv/Administration/Invoices, accounting and receipts
#> /tmp/Rtmp2nhNvv/Administration/Status reports
#> /tmp/Rtmp2nhNvv/Administration/Logo and graphical materials
#> /tmp/Rtmp2nhNvv/Administration/Internal meetings
#> /tmp/Rtmp2nhNvv/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/Rtmp2nhNvv/Administration/Internal meetings/Internal presentations
#> /tmp/Rtmp2nhNvv/Administration/Internal meetings/Minutes
#> /tmp/Rtmp2nhNvv/Materials
#> /tmp/Rtmp2nhNvv/Materials/Overall planning
#> /tmp/Rtmp2nhNvv/Materials/Consent form
#> /tmp/Rtmp2nhNvv/Materials/Ethical-GDPR approval
#> /tmp/Rtmp2nhNvv/Materials/Survey questionnaires
#> /tmp/Rtmp2nhNvv/Materials/Interview guides
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Staff
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Pupils
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Parents
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Researchers
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Leaders
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Teachers
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Principals
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Students
#> /tmp/Rtmp2nhNvv/Materials/Interview guides/Population
#> /tmp/Rtmp2nhNvv/Materials/Request of data from
#> /tmp/Rtmp2nhNvv/Materials/Literature review-design
#> /tmp/Rtmp2nhNvv/Materials/Intervention materials
#> /tmp/Rtmp2nhNvv/Materials/Randomizing participants
#> /tmp/Rtmp2nhNvv/Materials/Chapter overviews
#> /tmp/Rtmp2nhNvv/Literature
#> /tmp/Rtmp2nhNvv/Literature/Topic has policy relevance
#> /tmp/Rtmp2nhNvv/Literature/Pure theory and framework
#> /tmp/Rtmp2nhNvv/Literature/Similar empirical studies
#> /tmp/Rtmp2nhNvv/Literature/Similar instruments and guides for data collection
#> /tmp/Rtmp2nhNvv/Literature/Relevant analytic methodology
#> /tmp/Rtmp2nhNvv/Literature/Unprocessed (remove from here)
#> /tmp/Rtmp2nhNvv/Data
#> /tmp/Rtmp2nhNvv/Data/Population data
#> /tmp/Rtmp2nhNvv/Data/Population data/Codebook
#> /tmp/Rtmp2nhNvv/Data/Sampling frame
#> /tmp/Rtmp2nhNvv/Data/Registry data
#> /tmp/Rtmp2nhNvv/Data/Collected respondent lists
#> /tmp/Rtmp2nhNvv/Data/Respondent list for survey system
#> /tmp/Rtmp2nhNvv/Data/Downloaded response data
#> /tmp/Rtmp2nhNvv/Data/Downloaded response data/Codebook
#> /tmp/Rtmp2nhNvv/Data/Qualitative data
#> /tmp/Rtmp2nhNvv/Data/Qualitative data/Interview recordings
#> /tmp/Rtmp2nhNvv/Data/Qualitative data/Observational notes
#> /tmp/Rtmp2nhNvv/Data/Text corpus
#> /tmp/Rtmp2nhNvv/Data/PDF-reports
#> /tmp/Rtmp2nhNvv/Data/Prepared data
#> /tmp/Rtmp2nhNvv/Data/Prepared data/Codebooks
#> /tmp/Rtmp2nhNvv/Saros_SSN
#> /tmp/Rtmp2nhNvv/Saros_SSN/Scripts
#> /tmp/Rtmp2nhNvv/Saros_SSN/Resources
#> /tmp/Rtmp2nhNvv/Saros_SSN/Draft generations
#> /tmp/Rtmp2nhNvv/Saros_SSN/Draft generations/main
#> /tmp/Rtmp2nhNvv/Saros_SSN/Draft generations/Reports
#> /tmp/Rtmp2nhNvv/Saros_SSN/Drafts in editing
#> /tmp/Rtmp2nhNvv/Saros_SSN/Drafts in editing/main
#> /tmp/Rtmp2nhNvv/Saros_SSN/Drafts in editing/Reports
#> /tmp/Rtmp2nhNvv/Saros_SSN/Completed drafts
#> /tmp/Rtmp2nhNvv/Saros_SSN/Completed drafts/main
#> /tmp/Rtmp2nhNvv/Saros_SSN/Completed drafts/Reports
#> /tmp/Rtmp2nhNvv/Publications
#> /tmp/Rtmp2nhNvv/Publications/Paper1-Short title (author initials)
#> /tmp/Rtmp2nhNvv/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/Rtmp2nhNvv/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/Rtmp2nhNvv/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/Rtmp2nhNvv/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/Rtmp2nhNvv/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/Rtmp2nhNvv/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/Rtmp2nhNvv/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/Rtmp2nhNvv/Outreach
#> /tmp/Rtmp2nhNvv/Outreach/Research conference presentation
#> /tmp/Rtmp2nhNvv/Outreach/Research conference poster
#> /tmp/Rtmp2nhNvv/Outreach/Stakeholders and reference group
#> /tmp/Rtmp2nhNvv/Outreach/Stakeholders' communication channels
#> /tmp/Rtmp2nhNvv/Outreach/Practitioners and special interest channels
#> /tmp/Rtmp2nhNvv/Outreach/Public through mass media channels
#> /tmp/Rtmp2nhNvv/Other
```
