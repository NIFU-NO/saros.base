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
#> /tmp/RtmpMG9E2U/Administration
#> /tmp/RtmpMG9E2U/Administration/Application
#> /tmp/RtmpMG9E2U/Administration/Application/Call
#> /tmp/RtmpMG9E2U/Administration/Application/Formalities
#> /tmp/RtmpMG9E2U/Administration/Application/CVs
#> /tmp/RtmpMG9E2U/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpMG9E2U/Administration/Application/Application
#> /tmp/RtmpMG9E2U/Administration/Application/Pre-analysis
#> /tmp/RtmpMG9E2U/Administration/Application/For submission
#> /tmp/RtmpMG9E2U/Administration/Budget
#> /tmp/RtmpMG9E2U/Administration/Contracts and agreements
#> /tmp/RtmpMG9E2U/Administration/Invoices, accounting and receipts
#> /tmp/RtmpMG9E2U/Administration/Status reports
#> /tmp/RtmpMG9E2U/Administration/Logo and graphical materials
#> /tmp/RtmpMG9E2U/Administration/Internal meetings
#> /tmp/RtmpMG9E2U/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpMG9E2U/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpMG9E2U/Administration/Internal meetings/Minutes
#> /tmp/RtmpMG9E2U/Materials
#> /tmp/RtmpMG9E2U/Materials/Overall planning
#> /tmp/RtmpMG9E2U/Materials/Consent form
#> /tmp/RtmpMG9E2U/Materials/Ethical-GDPR approval
#> /tmp/RtmpMG9E2U/Materials/Survey questionnaires
#> /tmp/RtmpMG9E2U/Materials/Interview guides
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Staff
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Pupils
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Parents
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Researchers
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Leaders
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Teachers
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Principals
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Students
#> /tmp/RtmpMG9E2U/Materials/Interview guides/Population
#> /tmp/RtmpMG9E2U/Materials/Request of data from
#> /tmp/RtmpMG9E2U/Materials/Literature review-design
#> /tmp/RtmpMG9E2U/Materials/Intervention materials
#> /tmp/RtmpMG9E2U/Materials/Randomizing participants
#> /tmp/RtmpMG9E2U/Materials/Chapter overviews
#> /tmp/RtmpMG9E2U/Literature
#> /tmp/RtmpMG9E2U/Literature/Topic has policy relevance
#> /tmp/RtmpMG9E2U/Literature/Pure theory and framework
#> /tmp/RtmpMG9E2U/Literature/Similar empirical studies
#> /tmp/RtmpMG9E2U/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpMG9E2U/Literature/Relevant analytic methodology
#> /tmp/RtmpMG9E2U/Literature/Unprocessed (remove from here)
#> /tmp/RtmpMG9E2U/Data
#> /tmp/RtmpMG9E2U/Data/Population data
#> /tmp/RtmpMG9E2U/Data/Population data/Codebook
#> /tmp/RtmpMG9E2U/Data/Sampling frame
#> /tmp/RtmpMG9E2U/Data/Registry data
#> /tmp/RtmpMG9E2U/Data/Collected respondent lists
#> /tmp/RtmpMG9E2U/Data/Respondent list for survey system
#> /tmp/RtmpMG9E2U/Data/Downloaded response data
#> /tmp/RtmpMG9E2U/Data/Downloaded response data/Codebook
#> /tmp/RtmpMG9E2U/Data/Qualitative data
#> /tmp/RtmpMG9E2U/Data/Qualitative data/Interview recordings
#> /tmp/RtmpMG9E2U/Data/Qualitative data/Observational notes
#> /tmp/RtmpMG9E2U/Data/Text corpus
#> /tmp/RtmpMG9E2U/Data/PDF-reports
#> /tmp/RtmpMG9E2U/Data/Prepared data
#> /tmp/RtmpMG9E2U/Data/Prepared data/Codebooks
#> /tmp/RtmpMG9E2U/Saros_SSN
#> /tmp/RtmpMG9E2U/Saros_SSN/Scripts
#> /tmp/RtmpMG9E2U/Saros_SSN/Resources
#> /tmp/RtmpMG9E2U/Saros_SSN/Draft generations
#> /tmp/RtmpMG9E2U/Saros_SSN/Draft generations/main
#> /tmp/RtmpMG9E2U/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpMG9E2U/Saros_SSN/Drafts in editing
#> /tmp/RtmpMG9E2U/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpMG9E2U/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpMG9E2U/Saros_SSN/Completed drafts
#> /tmp/RtmpMG9E2U/Saros_SSN/Completed drafts/main
#> /tmp/RtmpMG9E2U/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpMG9E2U/Publications
#> /tmp/RtmpMG9E2U/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpMG9E2U/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpMG9E2U/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpMG9E2U/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpMG9E2U/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpMG9E2U/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpMG9E2U/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpMG9E2U/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpMG9E2U/Outreach
#> /tmp/RtmpMG9E2U/Outreach/Research conference presentation
#> /tmp/RtmpMG9E2U/Outreach/Research conference poster
#> /tmp/RtmpMG9E2U/Outreach/Stakeholders and reference group
#> /tmp/RtmpMG9E2U/Outreach/Stakeholders' communication channels
#> /tmp/RtmpMG9E2U/Outreach/Practitioners and special interest channels
#> /tmp/RtmpMG9E2U/Outreach/Public through mass media channels
#> /tmp/RtmpMG9E2U/Other
```
