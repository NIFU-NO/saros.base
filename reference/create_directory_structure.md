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
#> /tmp/RtmpT45K6s/Administration
#> /tmp/RtmpT45K6s/Administration/Application
#> /tmp/RtmpT45K6s/Administration/Application/Call
#> /tmp/RtmpT45K6s/Administration/Application/Formalities
#> /tmp/RtmpT45K6s/Administration/Application/CVs
#> /tmp/RtmpT45K6s/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpT45K6s/Administration/Application/Application
#> /tmp/RtmpT45K6s/Administration/Application/Pre-analysis
#> /tmp/RtmpT45K6s/Administration/Application/For submission
#> /tmp/RtmpT45K6s/Administration/Budget
#> /tmp/RtmpT45K6s/Administration/Contracts and agreements
#> /tmp/RtmpT45K6s/Administration/Invoices, accounting and receipts
#> /tmp/RtmpT45K6s/Administration/Status reports
#> /tmp/RtmpT45K6s/Administration/Logo and graphical materials
#> /tmp/RtmpT45K6s/Administration/Internal meetings
#> /tmp/RtmpT45K6s/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpT45K6s/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpT45K6s/Administration/Internal meetings/Minutes
#> /tmp/RtmpT45K6s/Materials
#> /tmp/RtmpT45K6s/Materials/Overall planning
#> /tmp/RtmpT45K6s/Materials/Consent form
#> /tmp/RtmpT45K6s/Materials/Ethical-GDPR approval
#> /tmp/RtmpT45K6s/Materials/Survey questionnaires
#> /tmp/RtmpT45K6s/Materials/Interview guides
#> /tmp/RtmpT45K6s/Materials/Interview guides/Staff
#> /tmp/RtmpT45K6s/Materials/Interview guides/Pupils
#> /tmp/RtmpT45K6s/Materials/Interview guides/Parents
#> /tmp/RtmpT45K6s/Materials/Interview guides/Researchers
#> /tmp/RtmpT45K6s/Materials/Interview guides/Leaders
#> /tmp/RtmpT45K6s/Materials/Interview guides/Teachers
#> /tmp/RtmpT45K6s/Materials/Interview guides/Principals
#> /tmp/RtmpT45K6s/Materials/Interview guides/Students
#> /tmp/RtmpT45K6s/Materials/Interview guides/Population
#> /tmp/RtmpT45K6s/Materials/Request of data from
#> /tmp/RtmpT45K6s/Materials/Literature review-design
#> /tmp/RtmpT45K6s/Materials/Intervention materials
#> /tmp/RtmpT45K6s/Materials/Randomizing participants
#> /tmp/RtmpT45K6s/Materials/Chapter overviews
#> /tmp/RtmpT45K6s/Literature
#> /tmp/RtmpT45K6s/Literature/Topic has policy relevance
#> /tmp/RtmpT45K6s/Literature/Pure theory and framework
#> /tmp/RtmpT45K6s/Literature/Similar empirical studies
#> /tmp/RtmpT45K6s/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpT45K6s/Literature/Relevant analytic methodology
#> /tmp/RtmpT45K6s/Literature/Unprocessed (remove from here)
#> /tmp/RtmpT45K6s/Data
#> /tmp/RtmpT45K6s/Data/Population data
#> /tmp/RtmpT45K6s/Data/Population data/Codebook
#> /tmp/RtmpT45K6s/Data/Sampling frame
#> /tmp/RtmpT45K6s/Data/Registry data
#> /tmp/RtmpT45K6s/Data/Collected respondent lists
#> /tmp/RtmpT45K6s/Data/Respondent list for survey system
#> /tmp/RtmpT45K6s/Data/Downloaded response data
#> /tmp/RtmpT45K6s/Data/Downloaded response data/Codebook
#> /tmp/RtmpT45K6s/Data/Qualitative data
#> /tmp/RtmpT45K6s/Data/Qualitative data/Interview recordings
#> /tmp/RtmpT45K6s/Data/Qualitative data/Observational notes
#> /tmp/RtmpT45K6s/Data/Text corpus
#> /tmp/RtmpT45K6s/Data/PDF-reports
#> /tmp/RtmpT45K6s/Data/Prepared data
#> /tmp/RtmpT45K6s/Data/Prepared data/Codebooks
#> /tmp/RtmpT45K6s/Saros_SSN
#> /tmp/RtmpT45K6s/Saros_SSN/Scripts
#> /tmp/RtmpT45K6s/Saros_SSN/Resources
#> /tmp/RtmpT45K6s/Saros_SSN/Draft generations
#> /tmp/RtmpT45K6s/Saros_SSN/Draft generations/main
#> /tmp/RtmpT45K6s/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpT45K6s/Saros_SSN/Drafts in editing
#> /tmp/RtmpT45K6s/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpT45K6s/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpT45K6s/Saros_SSN/Completed drafts
#> /tmp/RtmpT45K6s/Saros_SSN/Completed drafts/main
#> /tmp/RtmpT45K6s/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpT45K6s/Publications
#> /tmp/RtmpT45K6s/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpT45K6s/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpT45K6s/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpT45K6s/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpT45K6s/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpT45K6s/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpT45K6s/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpT45K6s/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpT45K6s/Outreach
#> /tmp/RtmpT45K6s/Outreach/Research conference presentation
#> /tmp/RtmpT45K6s/Outreach/Research conference poster
#> /tmp/RtmpT45K6s/Outreach/Stakeholders and reference group
#> /tmp/RtmpT45K6s/Outreach/Stakeholders' communication channels
#> /tmp/RtmpT45K6s/Outreach/Practitioners and special interest channels
#> /tmp/RtmpT45K6s/Outreach/Public through mass media channels
#> /tmp/RtmpT45K6s/Other
```
