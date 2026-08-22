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
#> /tmp/RtmpFeA7dZ/Administration
#> /tmp/RtmpFeA7dZ/Administration/Application
#> /tmp/RtmpFeA7dZ/Administration/Application/Call
#> /tmp/RtmpFeA7dZ/Administration/Application/Formalities
#> /tmp/RtmpFeA7dZ/Administration/Application/CVs
#> /tmp/RtmpFeA7dZ/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpFeA7dZ/Administration/Application/Application
#> /tmp/RtmpFeA7dZ/Administration/Application/Pre-analysis
#> /tmp/RtmpFeA7dZ/Administration/Application/For submission
#> /tmp/RtmpFeA7dZ/Administration/Budget
#> /tmp/RtmpFeA7dZ/Administration/Contracts and agreements
#> /tmp/RtmpFeA7dZ/Administration/Invoices, accounting and receipts
#> /tmp/RtmpFeA7dZ/Administration/Status reports
#> /tmp/RtmpFeA7dZ/Administration/Logo and graphical materials
#> /tmp/RtmpFeA7dZ/Administration/Internal meetings
#> /tmp/RtmpFeA7dZ/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpFeA7dZ/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpFeA7dZ/Administration/Internal meetings/Minutes
#> /tmp/RtmpFeA7dZ/Materials
#> /tmp/RtmpFeA7dZ/Materials/Overall planning
#> /tmp/RtmpFeA7dZ/Materials/Consent form
#> /tmp/RtmpFeA7dZ/Materials/Ethical-GDPR approval
#> /tmp/RtmpFeA7dZ/Materials/Survey questionnaires
#> /tmp/RtmpFeA7dZ/Materials/Interview guides
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Staff
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Pupils
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Parents
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Researchers
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Leaders
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Teachers
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Principals
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Students
#> /tmp/RtmpFeA7dZ/Materials/Interview guides/Population
#> /tmp/RtmpFeA7dZ/Materials/Request of data from
#> /tmp/RtmpFeA7dZ/Materials/Literature review-design
#> /tmp/RtmpFeA7dZ/Materials/Intervention materials
#> /tmp/RtmpFeA7dZ/Materials/Randomizing participants
#> /tmp/RtmpFeA7dZ/Materials/Chapter overviews
#> /tmp/RtmpFeA7dZ/Literature
#> /tmp/RtmpFeA7dZ/Literature/Topic has policy relevance
#> /tmp/RtmpFeA7dZ/Literature/Pure theory and framework
#> /tmp/RtmpFeA7dZ/Literature/Similar empirical studies
#> /tmp/RtmpFeA7dZ/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpFeA7dZ/Literature/Relevant analytic methodology
#> /tmp/RtmpFeA7dZ/Literature/Unprocessed (remove from here)
#> /tmp/RtmpFeA7dZ/Data
#> /tmp/RtmpFeA7dZ/Data/Population data
#> /tmp/RtmpFeA7dZ/Data/Population data/Codebook
#> /tmp/RtmpFeA7dZ/Data/Sampling frame
#> /tmp/RtmpFeA7dZ/Data/Registry data
#> /tmp/RtmpFeA7dZ/Data/Collected respondent lists
#> /tmp/RtmpFeA7dZ/Data/Respondent list for survey system
#> /tmp/RtmpFeA7dZ/Data/Downloaded response data
#> /tmp/RtmpFeA7dZ/Data/Downloaded response data/Codebook
#> /tmp/RtmpFeA7dZ/Data/Qualitative data
#> /tmp/RtmpFeA7dZ/Data/Qualitative data/Interview recordings
#> /tmp/RtmpFeA7dZ/Data/Qualitative data/Observational notes
#> /tmp/RtmpFeA7dZ/Data/Text corpus
#> /tmp/RtmpFeA7dZ/Data/PDF-reports
#> /tmp/RtmpFeA7dZ/Data/Prepared data
#> /tmp/RtmpFeA7dZ/Data/Prepared data/Codebooks
#> /tmp/RtmpFeA7dZ/Saros_SSN
#> /tmp/RtmpFeA7dZ/Saros_SSN/Scripts
#> /tmp/RtmpFeA7dZ/Saros_SSN/Resources
#> /tmp/RtmpFeA7dZ/Saros_SSN/Draft generations
#> /tmp/RtmpFeA7dZ/Saros_SSN/Draft generations/main
#> /tmp/RtmpFeA7dZ/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpFeA7dZ/Saros_SSN/Drafts in editing
#> /tmp/RtmpFeA7dZ/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpFeA7dZ/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpFeA7dZ/Saros_SSN/Completed drafts
#> /tmp/RtmpFeA7dZ/Saros_SSN/Completed drafts/main
#> /tmp/RtmpFeA7dZ/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpFeA7dZ/Publications
#> /tmp/RtmpFeA7dZ/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpFeA7dZ/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpFeA7dZ/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpFeA7dZ/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpFeA7dZ/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpFeA7dZ/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpFeA7dZ/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpFeA7dZ/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpFeA7dZ/Outreach
#> /tmp/RtmpFeA7dZ/Outreach/Research conference presentation
#> /tmp/RtmpFeA7dZ/Outreach/Research conference poster
#> /tmp/RtmpFeA7dZ/Outreach/Stakeholders and reference group
#> /tmp/RtmpFeA7dZ/Outreach/Stakeholders' communication channels
#> /tmp/RtmpFeA7dZ/Outreach/Practitioners and special interest channels
#> /tmp/RtmpFeA7dZ/Outreach/Public through mass media channels
#> /tmp/RtmpFeA7dZ/Other
```
