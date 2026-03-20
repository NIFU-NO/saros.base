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
#> /tmp/RtmpCzR55J/Administration
#> /tmp/RtmpCzR55J/Administration/Application
#> /tmp/RtmpCzR55J/Administration/Application/Call
#> /tmp/RtmpCzR55J/Administration/Application/Formalities
#> /tmp/RtmpCzR55J/Administration/Application/CVs
#> /tmp/RtmpCzR55J/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpCzR55J/Administration/Application/Application
#> /tmp/RtmpCzR55J/Administration/Application/Pre-analysis
#> /tmp/RtmpCzR55J/Administration/Application/For submission
#> /tmp/RtmpCzR55J/Administration/Budget
#> /tmp/RtmpCzR55J/Administration/Contracts and agreements
#> /tmp/RtmpCzR55J/Administration/Invoices, accounting and receipts
#> /tmp/RtmpCzR55J/Administration/Status reports
#> /tmp/RtmpCzR55J/Administration/Logo and graphical materials
#> /tmp/RtmpCzR55J/Administration/Internal meetings
#> /tmp/RtmpCzR55J/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpCzR55J/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpCzR55J/Administration/Internal meetings/Minutes
#> /tmp/RtmpCzR55J/Materials
#> /tmp/RtmpCzR55J/Materials/Overall planning
#> /tmp/RtmpCzR55J/Materials/Consent form
#> /tmp/RtmpCzR55J/Materials/Ethical-GDPR approval
#> /tmp/RtmpCzR55J/Materials/Survey questionnaires
#> /tmp/RtmpCzR55J/Materials/Interview guides
#> /tmp/RtmpCzR55J/Materials/Interview guides/Staff
#> /tmp/RtmpCzR55J/Materials/Interview guides/Pupils
#> /tmp/RtmpCzR55J/Materials/Interview guides/Parents
#> /tmp/RtmpCzR55J/Materials/Interview guides/Researchers
#> /tmp/RtmpCzR55J/Materials/Interview guides/Leaders
#> /tmp/RtmpCzR55J/Materials/Interview guides/Teachers
#> /tmp/RtmpCzR55J/Materials/Interview guides/Principals
#> /tmp/RtmpCzR55J/Materials/Interview guides/Students
#> /tmp/RtmpCzR55J/Materials/Interview guides/Population
#> /tmp/RtmpCzR55J/Materials/Request of data from
#> /tmp/RtmpCzR55J/Materials/Literature review-design
#> /tmp/RtmpCzR55J/Materials/Intervention materials
#> /tmp/RtmpCzR55J/Materials/Randomizing participants
#> /tmp/RtmpCzR55J/Materials/Chapter overviews
#> /tmp/RtmpCzR55J/Literature
#> /tmp/RtmpCzR55J/Literature/Topic has policy relevance
#> /tmp/RtmpCzR55J/Literature/Pure theory and framework
#> /tmp/RtmpCzR55J/Literature/Similar empirical studies
#> /tmp/RtmpCzR55J/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpCzR55J/Literature/Relevant analytic methodology
#> /tmp/RtmpCzR55J/Literature/Unprocessed (remove from here)
#> /tmp/RtmpCzR55J/Data
#> /tmp/RtmpCzR55J/Data/Population data
#> /tmp/RtmpCzR55J/Data/Population data/Codebook
#> /tmp/RtmpCzR55J/Data/Sampling frame
#> /tmp/RtmpCzR55J/Data/Registry data
#> /tmp/RtmpCzR55J/Data/Collected respondent lists
#> /tmp/RtmpCzR55J/Data/Respondent list for survey system
#> /tmp/RtmpCzR55J/Data/Downloaded response data
#> /tmp/RtmpCzR55J/Data/Downloaded response data/Codebook
#> /tmp/RtmpCzR55J/Data/Qualitative data
#> /tmp/RtmpCzR55J/Data/Qualitative data/Interview recordings
#> /tmp/RtmpCzR55J/Data/Qualitative data/Observational notes
#> /tmp/RtmpCzR55J/Data/Text corpus
#> /tmp/RtmpCzR55J/Data/PDF-reports
#> /tmp/RtmpCzR55J/Data/Prepared data
#> /tmp/RtmpCzR55J/Data/Prepared data/Codebooks
#> /tmp/RtmpCzR55J/Saros_SSN
#> /tmp/RtmpCzR55J/Saros_SSN/Scripts
#> /tmp/RtmpCzR55J/Saros_SSN/Resources
#> /tmp/RtmpCzR55J/Saros_SSN/Draft generations
#> /tmp/RtmpCzR55J/Saros_SSN/Draft generations/main
#> /tmp/RtmpCzR55J/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpCzR55J/Saros_SSN/Drafts in editing
#> /tmp/RtmpCzR55J/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpCzR55J/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpCzR55J/Saros_SSN/Completed drafts
#> /tmp/RtmpCzR55J/Saros_SSN/Completed drafts/main
#> /tmp/RtmpCzR55J/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpCzR55J/Publications
#> /tmp/RtmpCzR55J/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpCzR55J/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpCzR55J/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpCzR55J/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpCzR55J/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpCzR55J/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpCzR55J/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpCzR55J/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpCzR55J/Outreach
#> /tmp/RtmpCzR55J/Outreach/Research conference presentation
#> /tmp/RtmpCzR55J/Outreach/Research conference poster
#> /tmp/RtmpCzR55J/Outreach/Stakeholders and reference group
#> /tmp/RtmpCzR55J/Outreach/Stakeholders' communication channels
#> /tmp/RtmpCzR55J/Outreach/Practitioners and special interest channels
#> /tmp/RtmpCzR55J/Outreach/Public through mass media channels
#> /tmp/RtmpCzR55J/Other
```
