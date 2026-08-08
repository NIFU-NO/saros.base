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
#> /tmp/RtmpvIDxpz/Administration
#> /tmp/RtmpvIDxpz/Administration/Application
#> /tmp/RtmpvIDxpz/Administration/Application/Call
#> /tmp/RtmpvIDxpz/Administration/Application/Formalities
#> /tmp/RtmpvIDxpz/Administration/Application/CVs
#> /tmp/RtmpvIDxpz/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpvIDxpz/Administration/Application/Application
#> /tmp/RtmpvIDxpz/Administration/Application/Pre-analysis
#> /tmp/RtmpvIDxpz/Administration/Application/For submission
#> /tmp/RtmpvIDxpz/Administration/Budget
#> /tmp/RtmpvIDxpz/Administration/Contracts and agreements
#> /tmp/RtmpvIDxpz/Administration/Invoices, accounting and receipts
#> /tmp/RtmpvIDxpz/Administration/Status reports
#> /tmp/RtmpvIDxpz/Administration/Logo and graphical materials
#> /tmp/RtmpvIDxpz/Administration/Internal meetings
#> /tmp/RtmpvIDxpz/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpvIDxpz/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpvIDxpz/Administration/Internal meetings/Minutes
#> /tmp/RtmpvIDxpz/Materials
#> /tmp/RtmpvIDxpz/Materials/Overall planning
#> /tmp/RtmpvIDxpz/Materials/Consent form
#> /tmp/RtmpvIDxpz/Materials/Ethical-GDPR approval
#> /tmp/RtmpvIDxpz/Materials/Survey questionnaires
#> /tmp/RtmpvIDxpz/Materials/Interview guides
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Staff
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Pupils
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Parents
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Researchers
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Leaders
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Teachers
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Principals
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Students
#> /tmp/RtmpvIDxpz/Materials/Interview guides/Population
#> /tmp/RtmpvIDxpz/Materials/Request of data from
#> /tmp/RtmpvIDxpz/Materials/Literature review-design
#> /tmp/RtmpvIDxpz/Materials/Intervention materials
#> /tmp/RtmpvIDxpz/Materials/Randomizing participants
#> /tmp/RtmpvIDxpz/Materials/Chapter overviews
#> /tmp/RtmpvIDxpz/Literature
#> /tmp/RtmpvIDxpz/Literature/Topic has policy relevance
#> /tmp/RtmpvIDxpz/Literature/Pure theory and framework
#> /tmp/RtmpvIDxpz/Literature/Similar empirical studies
#> /tmp/RtmpvIDxpz/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpvIDxpz/Literature/Relevant analytic methodology
#> /tmp/RtmpvIDxpz/Literature/Unprocessed (remove from here)
#> /tmp/RtmpvIDxpz/Data
#> /tmp/RtmpvIDxpz/Data/Population data
#> /tmp/RtmpvIDxpz/Data/Population data/Codebook
#> /tmp/RtmpvIDxpz/Data/Sampling frame
#> /tmp/RtmpvIDxpz/Data/Registry data
#> /tmp/RtmpvIDxpz/Data/Collected respondent lists
#> /tmp/RtmpvIDxpz/Data/Respondent list for survey system
#> /tmp/RtmpvIDxpz/Data/Downloaded response data
#> /tmp/RtmpvIDxpz/Data/Downloaded response data/Codebook
#> /tmp/RtmpvIDxpz/Data/Qualitative data
#> /tmp/RtmpvIDxpz/Data/Qualitative data/Interview recordings
#> /tmp/RtmpvIDxpz/Data/Qualitative data/Observational notes
#> /tmp/RtmpvIDxpz/Data/Text corpus
#> /tmp/RtmpvIDxpz/Data/PDF-reports
#> /tmp/RtmpvIDxpz/Data/Prepared data
#> /tmp/RtmpvIDxpz/Data/Prepared data/Codebooks
#> /tmp/RtmpvIDxpz/Saros_SSN
#> /tmp/RtmpvIDxpz/Saros_SSN/Scripts
#> /tmp/RtmpvIDxpz/Saros_SSN/Resources
#> /tmp/RtmpvIDxpz/Saros_SSN/Draft generations
#> /tmp/RtmpvIDxpz/Saros_SSN/Draft generations/main
#> /tmp/RtmpvIDxpz/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpvIDxpz/Saros_SSN/Drafts in editing
#> /tmp/RtmpvIDxpz/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpvIDxpz/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpvIDxpz/Saros_SSN/Completed drafts
#> /tmp/RtmpvIDxpz/Saros_SSN/Completed drafts/main
#> /tmp/RtmpvIDxpz/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpvIDxpz/Publications
#> /tmp/RtmpvIDxpz/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpvIDxpz/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpvIDxpz/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpvIDxpz/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpvIDxpz/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpvIDxpz/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpvIDxpz/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpvIDxpz/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpvIDxpz/Outreach
#> /tmp/RtmpvIDxpz/Outreach/Research conference presentation
#> /tmp/RtmpvIDxpz/Outreach/Research conference poster
#> /tmp/RtmpvIDxpz/Outreach/Stakeholders and reference group
#> /tmp/RtmpvIDxpz/Outreach/Stakeholders' communication channels
#> /tmp/RtmpvIDxpz/Outreach/Practitioners and special interest channels
#> /tmp/RtmpvIDxpz/Outreach/Public through mass media channels
#> /tmp/RtmpvIDxpz/Other
```
