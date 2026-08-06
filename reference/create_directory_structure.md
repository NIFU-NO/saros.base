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
#> /tmp/RtmpBH5Xyj/Administration
#> /tmp/RtmpBH5Xyj/Administration/Application
#> /tmp/RtmpBH5Xyj/Administration/Application/Call
#> /tmp/RtmpBH5Xyj/Administration/Application/Formalities
#> /tmp/RtmpBH5Xyj/Administration/Application/CVs
#> /tmp/RtmpBH5Xyj/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpBH5Xyj/Administration/Application/Application
#> /tmp/RtmpBH5Xyj/Administration/Application/Pre-analysis
#> /tmp/RtmpBH5Xyj/Administration/Application/For submission
#> /tmp/RtmpBH5Xyj/Administration/Budget
#> /tmp/RtmpBH5Xyj/Administration/Contracts and agreements
#> /tmp/RtmpBH5Xyj/Administration/Invoices, accounting and receipts
#> /tmp/RtmpBH5Xyj/Administration/Status reports
#> /tmp/RtmpBH5Xyj/Administration/Logo and graphical materials
#> /tmp/RtmpBH5Xyj/Administration/Internal meetings
#> /tmp/RtmpBH5Xyj/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpBH5Xyj/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpBH5Xyj/Administration/Internal meetings/Minutes
#> /tmp/RtmpBH5Xyj/Materials
#> /tmp/RtmpBH5Xyj/Materials/Overall planning
#> /tmp/RtmpBH5Xyj/Materials/Consent form
#> /tmp/RtmpBH5Xyj/Materials/Ethical-GDPR approval
#> /tmp/RtmpBH5Xyj/Materials/Survey questionnaires
#> /tmp/RtmpBH5Xyj/Materials/Interview guides
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Staff
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Pupils
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Parents
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Researchers
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Leaders
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Teachers
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Principals
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Students
#> /tmp/RtmpBH5Xyj/Materials/Interview guides/Population
#> /tmp/RtmpBH5Xyj/Materials/Request of data from
#> /tmp/RtmpBH5Xyj/Materials/Literature review-design
#> /tmp/RtmpBH5Xyj/Materials/Intervention materials
#> /tmp/RtmpBH5Xyj/Materials/Randomizing participants
#> /tmp/RtmpBH5Xyj/Materials/Chapter overviews
#> /tmp/RtmpBH5Xyj/Literature
#> /tmp/RtmpBH5Xyj/Literature/Topic has policy relevance
#> /tmp/RtmpBH5Xyj/Literature/Pure theory and framework
#> /tmp/RtmpBH5Xyj/Literature/Similar empirical studies
#> /tmp/RtmpBH5Xyj/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpBH5Xyj/Literature/Relevant analytic methodology
#> /tmp/RtmpBH5Xyj/Literature/Unprocessed (remove from here)
#> /tmp/RtmpBH5Xyj/Data
#> /tmp/RtmpBH5Xyj/Data/Population data
#> /tmp/RtmpBH5Xyj/Data/Population data/Codebook
#> /tmp/RtmpBH5Xyj/Data/Sampling frame
#> /tmp/RtmpBH5Xyj/Data/Registry data
#> /tmp/RtmpBH5Xyj/Data/Collected respondent lists
#> /tmp/RtmpBH5Xyj/Data/Respondent list for survey system
#> /tmp/RtmpBH5Xyj/Data/Downloaded response data
#> /tmp/RtmpBH5Xyj/Data/Downloaded response data/Codebook
#> /tmp/RtmpBH5Xyj/Data/Qualitative data
#> /tmp/RtmpBH5Xyj/Data/Qualitative data/Interview recordings
#> /tmp/RtmpBH5Xyj/Data/Qualitative data/Observational notes
#> /tmp/RtmpBH5Xyj/Data/Text corpus
#> /tmp/RtmpBH5Xyj/Data/PDF-reports
#> /tmp/RtmpBH5Xyj/Data/Prepared data
#> /tmp/RtmpBH5Xyj/Data/Prepared data/Codebooks
#> /tmp/RtmpBH5Xyj/Saros_SSN
#> /tmp/RtmpBH5Xyj/Saros_SSN/Scripts
#> /tmp/RtmpBH5Xyj/Saros_SSN/Resources
#> /tmp/RtmpBH5Xyj/Saros_SSN/Draft generations
#> /tmp/RtmpBH5Xyj/Saros_SSN/Draft generations/main
#> /tmp/RtmpBH5Xyj/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpBH5Xyj/Saros_SSN/Drafts in editing
#> /tmp/RtmpBH5Xyj/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpBH5Xyj/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpBH5Xyj/Saros_SSN/Completed drafts
#> /tmp/RtmpBH5Xyj/Saros_SSN/Completed drafts/main
#> /tmp/RtmpBH5Xyj/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpBH5Xyj/Publications
#> /tmp/RtmpBH5Xyj/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpBH5Xyj/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpBH5Xyj/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpBH5Xyj/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpBH5Xyj/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpBH5Xyj/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpBH5Xyj/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpBH5Xyj/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpBH5Xyj/Outreach
#> /tmp/RtmpBH5Xyj/Outreach/Research conference presentation
#> /tmp/RtmpBH5Xyj/Outreach/Research conference poster
#> /tmp/RtmpBH5Xyj/Outreach/Stakeholders and reference group
#> /tmp/RtmpBH5Xyj/Outreach/Stakeholders' communication channels
#> /tmp/RtmpBH5Xyj/Outreach/Practitioners and special interest channels
#> /tmp/RtmpBH5Xyj/Outreach/Public through mass media channels
#> /tmp/RtmpBH5Xyj/Other
```
