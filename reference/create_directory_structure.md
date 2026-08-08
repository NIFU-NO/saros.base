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
#> /tmp/RtmpppBKC1/Administration
#> /tmp/RtmpppBKC1/Administration/Application
#> /tmp/RtmpppBKC1/Administration/Application/Call
#> /tmp/RtmpppBKC1/Administration/Application/Formalities
#> /tmp/RtmpppBKC1/Administration/Application/CVs
#> /tmp/RtmpppBKC1/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpppBKC1/Administration/Application/Application
#> /tmp/RtmpppBKC1/Administration/Application/Pre-analysis
#> /tmp/RtmpppBKC1/Administration/Application/For submission
#> /tmp/RtmpppBKC1/Administration/Budget
#> /tmp/RtmpppBKC1/Administration/Contracts and agreements
#> /tmp/RtmpppBKC1/Administration/Invoices, accounting and receipts
#> /tmp/RtmpppBKC1/Administration/Status reports
#> /tmp/RtmpppBKC1/Administration/Logo and graphical materials
#> /tmp/RtmpppBKC1/Administration/Internal meetings
#> /tmp/RtmpppBKC1/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpppBKC1/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpppBKC1/Administration/Internal meetings/Minutes
#> /tmp/RtmpppBKC1/Materials
#> /tmp/RtmpppBKC1/Materials/Overall planning
#> /tmp/RtmpppBKC1/Materials/Consent form
#> /tmp/RtmpppBKC1/Materials/Ethical-GDPR approval
#> /tmp/RtmpppBKC1/Materials/Survey questionnaires
#> /tmp/RtmpppBKC1/Materials/Interview guides
#> /tmp/RtmpppBKC1/Materials/Interview guides/Staff
#> /tmp/RtmpppBKC1/Materials/Interview guides/Pupils
#> /tmp/RtmpppBKC1/Materials/Interview guides/Parents
#> /tmp/RtmpppBKC1/Materials/Interview guides/Researchers
#> /tmp/RtmpppBKC1/Materials/Interview guides/Leaders
#> /tmp/RtmpppBKC1/Materials/Interview guides/Teachers
#> /tmp/RtmpppBKC1/Materials/Interview guides/Principals
#> /tmp/RtmpppBKC1/Materials/Interview guides/Students
#> /tmp/RtmpppBKC1/Materials/Interview guides/Population
#> /tmp/RtmpppBKC1/Materials/Request of data from
#> /tmp/RtmpppBKC1/Materials/Literature review-design
#> /tmp/RtmpppBKC1/Materials/Intervention materials
#> /tmp/RtmpppBKC1/Materials/Randomizing participants
#> /tmp/RtmpppBKC1/Materials/Chapter overviews
#> /tmp/RtmpppBKC1/Literature
#> /tmp/RtmpppBKC1/Literature/Topic has policy relevance
#> /tmp/RtmpppBKC1/Literature/Pure theory and framework
#> /tmp/RtmpppBKC1/Literature/Similar empirical studies
#> /tmp/RtmpppBKC1/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpppBKC1/Literature/Relevant analytic methodology
#> /tmp/RtmpppBKC1/Literature/Unprocessed (remove from here)
#> /tmp/RtmpppBKC1/Data
#> /tmp/RtmpppBKC1/Data/Population data
#> /tmp/RtmpppBKC1/Data/Population data/Codebook
#> /tmp/RtmpppBKC1/Data/Sampling frame
#> /tmp/RtmpppBKC1/Data/Registry data
#> /tmp/RtmpppBKC1/Data/Collected respondent lists
#> /tmp/RtmpppBKC1/Data/Respondent list for survey system
#> /tmp/RtmpppBKC1/Data/Downloaded response data
#> /tmp/RtmpppBKC1/Data/Downloaded response data/Codebook
#> /tmp/RtmpppBKC1/Data/Qualitative data
#> /tmp/RtmpppBKC1/Data/Qualitative data/Interview recordings
#> /tmp/RtmpppBKC1/Data/Qualitative data/Observational notes
#> /tmp/RtmpppBKC1/Data/Text corpus
#> /tmp/RtmpppBKC1/Data/PDF-reports
#> /tmp/RtmpppBKC1/Data/Prepared data
#> /tmp/RtmpppBKC1/Data/Prepared data/Codebooks
#> /tmp/RtmpppBKC1/Saros_SSN
#> /tmp/RtmpppBKC1/Saros_SSN/Scripts
#> /tmp/RtmpppBKC1/Saros_SSN/Resources
#> /tmp/RtmpppBKC1/Saros_SSN/Draft generations
#> /tmp/RtmpppBKC1/Saros_SSN/Draft generations/main
#> /tmp/RtmpppBKC1/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpppBKC1/Saros_SSN/Drafts in editing
#> /tmp/RtmpppBKC1/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpppBKC1/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpppBKC1/Saros_SSN/Completed drafts
#> /tmp/RtmpppBKC1/Saros_SSN/Completed drafts/main
#> /tmp/RtmpppBKC1/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpppBKC1/Publications
#> /tmp/RtmpppBKC1/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpppBKC1/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpppBKC1/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpppBKC1/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpppBKC1/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpppBKC1/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpppBKC1/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpppBKC1/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpppBKC1/Outreach
#> /tmp/RtmpppBKC1/Outreach/Research conference presentation
#> /tmp/RtmpppBKC1/Outreach/Research conference poster
#> /tmp/RtmpppBKC1/Outreach/Stakeholders and reference group
#> /tmp/RtmpppBKC1/Outreach/Stakeholders' communication channels
#> /tmp/RtmpppBKC1/Outreach/Practitioners and special interest channels
#> /tmp/RtmpppBKC1/Outreach/Public through mass media channels
#> /tmp/RtmpppBKC1/Other
```
