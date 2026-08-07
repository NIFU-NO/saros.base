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
#> /tmp/RtmpP8VDya/Administration
#> /tmp/RtmpP8VDya/Administration/Application
#> /tmp/RtmpP8VDya/Administration/Application/Call
#> /tmp/RtmpP8VDya/Administration/Application/Formalities
#> /tmp/RtmpP8VDya/Administration/Application/CVs
#> /tmp/RtmpP8VDya/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpP8VDya/Administration/Application/Application
#> /tmp/RtmpP8VDya/Administration/Application/Pre-analysis
#> /tmp/RtmpP8VDya/Administration/Application/For submission
#> /tmp/RtmpP8VDya/Administration/Budget
#> /tmp/RtmpP8VDya/Administration/Contracts and agreements
#> /tmp/RtmpP8VDya/Administration/Invoices, accounting and receipts
#> /tmp/RtmpP8VDya/Administration/Status reports
#> /tmp/RtmpP8VDya/Administration/Logo and graphical materials
#> /tmp/RtmpP8VDya/Administration/Internal meetings
#> /tmp/RtmpP8VDya/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpP8VDya/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpP8VDya/Administration/Internal meetings/Minutes
#> /tmp/RtmpP8VDya/Materials
#> /tmp/RtmpP8VDya/Materials/Overall planning
#> /tmp/RtmpP8VDya/Materials/Consent form
#> /tmp/RtmpP8VDya/Materials/Ethical-GDPR approval
#> /tmp/RtmpP8VDya/Materials/Survey questionnaires
#> /tmp/RtmpP8VDya/Materials/Interview guides
#> /tmp/RtmpP8VDya/Materials/Interview guides/Staff
#> /tmp/RtmpP8VDya/Materials/Interview guides/Pupils
#> /tmp/RtmpP8VDya/Materials/Interview guides/Parents
#> /tmp/RtmpP8VDya/Materials/Interview guides/Researchers
#> /tmp/RtmpP8VDya/Materials/Interview guides/Leaders
#> /tmp/RtmpP8VDya/Materials/Interview guides/Teachers
#> /tmp/RtmpP8VDya/Materials/Interview guides/Principals
#> /tmp/RtmpP8VDya/Materials/Interview guides/Students
#> /tmp/RtmpP8VDya/Materials/Interview guides/Population
#> /tmp/RtmpP8VDya/Materials/Request of data from
#> /tmp/RtmpP8VDya/Materials/Literature review-design
#> /tmp/RtmpP8VDya/Materials/Intervention materials
#> /tmp/RtmpP8VDya/Materials/Randomizing participants
#> /tmp/RtmpP8VDya/Materials/Chapter overviews
#> /tmp/RtmpP8VDya/Literature
#> /tmp/RtmpP8VDya/Literature/Topic has policy relevance
#> /tmp/RtmpP8VDya/Literature/Pure theory and framework
#> /tmp/RtmpP8VDya/Literature/Similar empirical studies
#> /tmp/RtmpP8VDya/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpP8VDya/Literature/Relevant analytic methodology
#> /tmp/RtmpP8VDya/Literature/Unprocessed (remove from here)
#> /tmp/RtmpP8VDya/Data
#> /tmp/RtmpP8VDya/Data/Population data
#> /tmp/RtmpP8VDya/Data/Population data/Codebook
#> /tmp/RtmpP8VDya/Data/Sampling frame
#> /tmp/RtmpP8VDya/Data/Registry data
#> /tmp/RtmpP8VDya/Data/Collected respondent lists
#> /tmp/RtmpP8VDya/Data/Respondent list for survey system
#> /tmp/RtmpP8VDya/Data/Downloaded response data
#> /tmp/RtmpP8VDya/Data/Downloaded response data/Codebook
#> /tmp/RtmpP8VDya/Data/Qualitative data
#> /tmp/RtmpP8VDya/Data/Qualitative data/Interview recordings
#> /tmp/RtmpP8VDya/Data/Qualitative data/Observational notes
#> /tmp/RtmpP8VDya/Data/Text corpus
#> /tmp/RtmpP8VDya/Data/PDF-reports
#> /tmp/RtmpP8VDya/Data/Prepared data
#> /tmp/RtmpP8VDya/Data/Prepared data/Codebooks
#> /tmp/RtmpP8VDya/Saros_SSN
#> /tmp/RtmpP8VDya/Saros_SSN/Scripts
#> /tmp/RtmpP8VDya/Saros_SSN/Resources
#> /tmp/RtmpP8VDya/Saros_SSN/Draft generations
#> /tmp/RtmpP8VDya/Saros_SSN/Draft generations/main
#> /tmp/RtmpP8VDya/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpP8VDya/Saros_SSN/Drafts in editing
#> /tmp/RtmpP8VDya/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpP8VDya/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpP8VDya/Saros_SSN/Completed drafts
#> /tmp/RtmpP8VDya/Saros_SSN/Completed drafts/main
#> /tmp/RtmpP8VDya/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpP8VDya/Publications
#> /tmp/RtmpP8VDya/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpP8VDya/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpP8VDya/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpP8VDya/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpP8VDya/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpP8VDya/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpP8VDya/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpP8VDya/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpP8VDya/Outreach
#> /tmp/RtmpP8VDya/Outreach/Research conference presentation
#> /tmp/RtmpP8VDya/Outreach/Research conference poster
#> /tmp/RtmpP8VDya/Outreach/Stakeholders and reference group
#> /tmp/RtmpP8VDya/Outreach/Stakeholders' communication channels
#> /tmp/RtmpP8VDya/Outreach/Practitioners and special interest channels
#> /tmp/RtmpP8VDya/Outreach/Public through mass media channels
#> /tmp/RtmpP8VDya/Other
```
