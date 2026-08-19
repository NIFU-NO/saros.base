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
#> /tmp/RtmpBTNcfC/Administration
#> /tmp/RtmpBTNcfC/Administration/Application
#> /tmp/RtmpBTNcfC/Administration/Application/Call
#> /tmp/RtmpBTNcfC/Administration/Application/Formalities
#> /tmp/RtmpBTNcfC/Administration/Application/CVs
#> /tmp/RtmpBTNcfC/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpBTNcfC/Administration/Application/Application
#> /tmp/RtmpBTNcfC/Administration/Application/Pre-analysis
#> /tmp/RtmpBTNcfC/Administration/Application/For submission
#> /tmp/RtmpBTNcfC/Administration/Budget
#> /tmp/RtmpBTNcfC/Administration/Contracts and agreements
#> /tmp/RtmpBTNcfC/Administration/Invoices, accounting and receipts
#> /tmp/RtmpBTNcfC/Administration/Status reports
#> /tmp/RtmpBTNcfC/Administration/Logo and graphical materials
#> /tmp/RtmpBTNcfC/Administration/Internal meetings
#> /tmp/RtmpBTNcfC/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpBTNcfC/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpBTNcfC/Administration/Internal meetings/Minutes
#> /tmp/RtmpBTNcfC/Materials
#> /tmp/RtmpBTNcfC/Materials/Overall planning
#> /tmp/RtmpBTNcfC/Materials/Consent form
#> /tmp/RtmpBTNcfC/Materials/Ethical-GDPR approval
#> /tmp/RtmpBTNcfC/Materials/Survey questionnaires
#> /tmp/RtmpBTNcfC/Materials/Interview guides
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Staff
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Pupils
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Parents
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Researchers
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Leaders
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Teachers
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Principals
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Students
#> /tmp/RtmpBTNcfC/Materials/Interview guides/Population
#> /tmp/RtmpBTNcfC/Materials/Request of data from
#> /tmp/RtmpBTNcfC/Materials/Literature review-design
#> /tmp/RtmpBTNcfC/Materials/Intervention materials
#> /tmp/RtmpBTNcfC/Materials/Randomizing participants
#> /tmp/RtmpBTNcfC/Materials/Chapter overviews
#> /tmp/RtmpBTNcfC/Literature
#> /tmp/RtmpBTNcfC/Literature/Topic has policy relevance
#> /tmp/RtmpBTNcfC/Literature/Pure theory and framework
#> /tmp/RtmpBTNcfC/Literature/Similar empirical studies
#> /tmp/RtmpBTNcfC/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpBTNcfC/Literature/Relevant analytic methodology
#> /tmp/RtmpBTNcfC/Literature/Unprocessed (remove from here)
#> /tmp/RtmpBTNcfC/Data
#> /tmp/RtmpBTNcfC/Data/Population data
#> /tmp/RtmpBTNcfC/Data/Population data/Codebook
#> /tmp/RtmpBTNcfC/Data/Sampling frame
#> /tmp/RtmpBTNcfC/Data/Registry data
#> /tmp/RtmpBTNcfC/Data/Collected respondent lists
#> /tmp/RtmpBTNcfC/Data/Respondent list for survey system
#> /tmp/RtmpBTNcfC/Data/Downloaded response data
#> /tmp/RtmpBTNcfC/Data/Downloaded response data/Codebook
#> /tmp/RtmpBTNcfC/Data/Qualitative data
#> /tmp/RtmpBTNcfC/Data/Qualitative data/Interview recordings
#> /tmp/RtmpBTNcfC/Data/Qualitative data/Observational notes
#> /tmp/RtmpBTNcfC/Data/Text corpus
#> /tmp/RtmpBTNcfC/Data/PDF-reports
#> /tmp/RtmpBTNcfC/Data/Prepared data
#> /tmp/RtmpBTNcfC/Data/Prepared data/Codebooks
#> /tmp/RtmpBTNcfC/Saros_SSN
#> /tmp/RtmpBTNcfC/Saros_SSN/Scripts
#> /tmp/RtmpBTNcfC/Saros_SSN/Resources
#> /tmp/RtmpBTNcfC/Saros_SSN/Draft generations
#> /tmp/RtmpBTNcfC/Saros_SSN/Draft generations/main
#> /tmp/RtmpBTNcfC/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpBTNcfC/Saros_SSN/Drafts in editing
#> /tmp/RtmpBTNcfC/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpBTNcfC/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpBTNcfC/Saros_SSN/Completed drafts
#> /tmp/RtmpBTNcfC/Saros_SSN/Completed drafts/main
#> /tmp/RtmpBTNcfC/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpBTNcfC/Publications
#> /tmp/RtmpBTNcfC/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpBTNcfC/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpBTNcfC/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpBTNcfC/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpBTNcfC/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpBTNcfC/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpBTNcfC/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpBTNcfC/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpBTNcfC/Outreach
#> /tmp/RtmpBTNcfC/Outreach/Research conference presentation
#> /tmp/RtmpBTNcfC/Outreach/Research conference poster
#> /tmp/RtmpBTNcfC/Outreach/Stakeholders and reference group
#> /tmp/RtmpBTNcfC/Outreach/Stakeholders' communication channels
#> /tmp/RtmpBTNcfC/Outreach/Practitioners and special interest channels
#> /tmp/RtmpBTNcfC/Outreach/Public through mass media channels
#> /tmp/RtmpBTNcfC/Other
```
