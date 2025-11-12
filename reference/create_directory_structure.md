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
#> /tmp/RtmpCzm511/Administration
#> /tmp/RtmpCzm511/Administration/Application
#> /tmp/RtmpCzm511/Administration/Application/Call
#> /tmp/RtmpCzm511/Administration/Application/Formalities
#> /tmp/RtmpCzm511/Administration/Application/CVs
#> /tmp/RtmpCzm511/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpCzm511/Administration/Application/Application
#> /tmp/RtmpCzm511/Administration/Application/Pre-analysis
#> /tmp/RtmpCzm511/Administration/Application/For submission
#> /tmp/RtmpCzm511/Administration/Budget
#> /tmp/RtmpCzm511/Administration/Contracts and agreements
#> /tmp/RtmpCzm511/Administration/Invoices, accounting and receipts
#> /tmp/RtmpCzm511/Administration/Status reports
#> /tmp/RtmpCzm511/Administration/Logo and graphical materials
#> /tmp/RtmpCzm511/Administration/Internal meetings
#> /tmp/RtmpCzm511/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpCzm511/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpCzm511/Administration/Internal meetings/Minutes
#> /tmp/RtmpCzm511/Materials
#> /tmp/RtmpCzm511/Materials/Overall planning
#> /tmp/RtmpCzm511/Materials/Consent form
#> /tmp/RtmpCzm511/Materials/Ethical-GDPR approval
#> /tmp/RtmpCzm511/Materials/Survey questionnaires
#> /tmp/RtmpCzm511/Materials/Interview guides
#> /tmp/RtmpCzm511/Materials/Interview guides/Staff
#> /tmp/RtmpCzm511/Materials/Interview guides/Pupils
#> /tmp/RtmpCzm511/Materials/Interview guides/Parents
#> /tmp/RtmpCzm511/Materials/Interview guides/Researchers
#> /tmp/RtmpCzm511/Materials/Interview guides/Leaders
#> /tmp/RtmpCzm511/Materials/Interview guides/Teachers
#> /tmp/RtmpCzm511/Materials/Interview guides/Principals
#> /tmp/RtmpCzm511/Materials/Interview guides/Students
#> /tmp/RtmpCzm511/Materials/Interview guides/Population
#> /tmp/RtmpCzm511/Materials/Request of data from
#> /tmp/RtmpCzm511/Materials/Literature review-design
#> /tmp/RtmpCzm511/Materials/Intervention materials
#> /tmp/RtmpCzm511/Materials/Randomizing participants
#> /tmp/RtmpCzm511/Materials/Chapter overviews
#> /tmp/RtmpCzm511/Literature
#> /tmp/RtmpCzm511/Literature/Topic has policy relevance
#> /tmp/RtmpCzm511/Literature/Pure theory and framework
#> /tmp/RtmpCzm511/Literature/Similar empirical studies
#> /tmp/RtmpCzm511/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpCzm511/Literature/Relevant analytic methodology
#> /tmp/RtmpCzm511/Literature/Unprocessed (remove from here)
#> /tmp/RtmpCzm511/Data
#> /tmp/RtmpCzm511/Data/Population data
#> /tmp/RtmpCzm511/Data/Population data/Codebook
#> /tmp/RtmpCzm511/Data/Sampling frame
#> /tmp/RtmpCzm511/Data/Registry data
#> /tmp/RtmpCzm511/Data/Collected respondent lists
#> /tmp/RtmpCzm511/Data/Respondent list for survey system
#> /tmp/RtmpCzm511/Data/Downloaded response data
#> /tmp/RtmpCzm511/Data/Downloaded response data/Codebook
#> /tmp/RtmpCzm511/Data/Qualitative data
#> /tmp/RtmpCzm511/Data/Qualitative data/Interview recordings
#> /tmp/RtmpCzm511/Data/Qualitative data/Observational notes
#> /tmp/RtmpCzm511/Data/Text corpus
#> /tmp/RtmpCzm511/Data/PDF-reports
#> /tmp/RtmpCzm511/Data/Prepared data
#> /tmp/RtmpCzm511/Data/Prepared data/Codebooks
#> /tmp/RtmpCzm511/Saros_SSN
#> /tmp/RtmpCzm511/Saros_SSN/Scripts
#> /tmp/RtmpCzm511/Saros_SSN/Resources
#> /tmp/RtmpCzm511/Saros_SSN/Draft generations
#> /tmp/RtmpCzm511/Saros_SSN/Draft generations/main
#> /tmp/RtmpCzm511/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpCzm511/Saros_SSN/Drafts in editing
#> /tmp/RtmpCzm511/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpCzm511/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpCzm511/Saros_SSN/Completed drafts
#> /tmp/RtmpCzm511/Saros_SSN/Completed drafts/main
#> /tmp/RtmpCzm511/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpCzm511/Publications
#> /tmp/RtmpCzm511/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpCzm511/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpCzm511/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpCzm511/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpCzm511/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpCzm511/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpCzm511/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpCzm511/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpCzm511/Outreach
#> /tmp/RtmpCzm511/Outreach/Research conference presentation
#> /tmp/RtmpCzm511/Outreach/Research conference poster
#> /tmp/RtmpCzm511/Outreach/Stakeholders and reference group
#> /tmp/RtmpCzm511/Outreach/Stakeholders' communication channels
#> /tmp/RtmpCzm511/Outreach/Practitioners and special interest channels
#> /tmp/RtmpCzm511/Outreach/Public through mass media channels
#> /tmp/RtmpCzm511/Other
```
