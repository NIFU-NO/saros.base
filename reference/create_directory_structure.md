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
#> /tmp/RtmpSq1LaN/Administration
#> /tmp/RtmpSq1LaN/Administration/Application
#> /tmp/RtmpSq1LaN/Administration/Application/Call
#> /tmp/RtmpSq1LaN/Administration/Application/Formalities
#> /tmp/RtmpSq1LaN/Administration/Application/CVs
#> /tmp/RtmpSq1LaN/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpSq1LaN/Administration/Application/Application
#> /tmp/RtmpSq1LaN/Administration/Application/Pre-analysis
#> /tmp/RtmpSq1LaN/Administration/Application/For submission
#> /tmp/RtmpSq1LaN/Administration/Budget
#> /tmp/RtmpSq1LaN/Administration/Contracts and agreements
#> /tmp/RtmpSq1LaN/Administration/Invoices, accounting and receipts
#> /tmp/RtmpSq1LaN/Administration/Status reports
#> /tmp/RtmpSq1LaN/Administration/Logo and graphical materials
#> /tmp/RtmpSq1LaN/Administration/Internal meetings
#> /tmp/RtmpSq1LaN/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpSq1LaN/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpSq1LaN/Administration/Internal meetings/Minutes
#> /tmp/RtmpSq1LaN/Materials
#> /tmp/RtmpSq1LaN/Materials/Overall planning
#> /tmp/RtmpSq1LaN/Materials/Consent form
#> /tmp/RtmpSq1LaN/Materials/Ethical-GDPR approval
#> /tmp/RtmpSq1LaN/Materials/Survey questionnaires
#> /tmp/RtmpSq1LaN/Materials/Interview guides
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Staff
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Pupils
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Parents
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Researchers
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Leaders
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Teachers
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Principals
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Students
#> /tmp/RtmpSq1LaN/Materials/Interview guides/Population
#> /tmp/RtmpSq1LaN/Materials/Request of data from
#> /tmp/RtmpSq1LaN/Materials/Literature review-design
#> /tmp/RtmpSq1LaN/Materials/Intervention materials
#> /tmp/RtmpSq1LaN/Materials/Randomizing participants
#> /tmp/RtmpSq1LaN/Materials/Chapter overviews
#> /tmp/RtmpSq1LaN/Literature
#> /tmp/RtmpSq1LaN/Literature/Topic has policy relevance
#> /tmp/RtmpSq1LaN/Literature/Pure theory and framework
#> /tmp/RtmpSq1LaN/Literature/Similar empirical studies
#> /tmp/RtmpSq1LaN/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpSq1LaN/Literature/Relevant analytic methodology
#> /tmp/RtmpSq1LaN/Literature/Unprocessed (remove from here)
#> /tmp/RtmpSq1LaN/Data
#> /tmp/RtmpSq1LaN/Data/Population data
#> /tmp/RtmpSq1LaN/Data/Population data/Codebook
#> /tmp/RtmpSq1LaN/Data/Sampling frame
#> /tmp/RtmpSq1LaN/Data/Registry data
#> /tmp/RtmpSq1LaN/Data/Collected respondent lists
#> /tmp/RtmpSq1LaN/Data/Respondent list for survey system
#> /tmp/RtmpSq1LaN/Data/Downloaded response data
#> /tmp/RtmpSq1LaN/Data/Downloaded response data/Codebook
#> /tmp/RtmpSq1LaN/Data/Qualitative data
#> /tmp/RtmpSq1LaN/Data/Qualitative data/Interview recordings
#> /tmp/RtmpSq1LaN/Data/Qualitative data/Observational notes
#> /tmp/RtmpSq1LaN/Data/Text corpus
#> /tmp/RtmpSq1LaN/Data/PDF-reports
#> /tmp/RtmpSq1LaN/Data/Prepared data
#> /tmp/RtmpSq1LaN/Data/Prepared data/Codebooks
#> /tmp/RtmpSq1LaN/Saros_SSN
#> /tmp/RtmpSq1LaN/Saros_SSN/Scripts
#> /tmp/RtmpSq1LaN/Saros_SSN/Resources
#> /tmp/RtmpSq1LaN/Saros_SSN/Draft generations
#> /tmp/RtmpSq1LaN/Saros_SSN/Draft generations/main
#> /tmp/RtmpSq1LaN/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpSq1LaN/Saros_SSN/Drafts in editing
#> /tmp/RtmpSq1LaN/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpSq1LaN/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpSq1LaN/Saros_SSN/Completed drafts
#> /tmp/RtmpSq1LaN/Saros_SSN/Completed drafts/main
#> /tmp/RtmpSq1LaN/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpSq1LaN/Publications
#> /tmp/RtmpSq1LaN/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpSq1LaN/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpSq1LaN/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpSq1LaN/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpSq1LaN/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpSq1LaN/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpSq1LaN/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpSq1LaN/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpSq1LaN/Outreach
#> /tmp/RtmpSq1LaN/Outreach/Research conference presentation
#> /tmp/RtmpSq1LaN/Outreach/Research conference poster
#> /tmp/RtmpSq1LaN/Outreach/Stakeholders and reference group
#> /tmp/RtmpSq1LaN/Outreach/Stakeholders' communication channels
#> /tmp/RtmpSq1LaN/Outreach/Practitioners and special interest channels
#> /tmp/RtmpSq1LaN/Outreach/Public through mass media channels
#> /tmp/RtmpSq1LaN/Other
```
