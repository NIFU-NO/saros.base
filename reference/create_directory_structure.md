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
#> /tmp/RtmpziyIk1/Administration
#> /tmp/RtmpziyIk1/Administration/Application
#> /tmp/RtmpziyIk1/Administration/Application/Call
#> /tmp/RtmpziyIk1/Administration/Application/Formalities
#> /tmp/RtmpziyIk1/Administration/Application/CVs
#> /tmp/RtmpziyIk1/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpziyIk1/Administration/Application/Application
#> /tmp/RtmpziyIk1/Administration/Application/Pre-analysis
#> /tmp/RtmpziyIk1/Administration/Application/For submission
#> /tmp/RtmpziyIk1/Administration/Budget
#> /tmp/RtmpziyIk1/Administration/Contracts and agreements
#> /tmp/RtmpziyIk1/Administration/Invoices, accounting and receipts
#> /tmp/RtmpziyIk1/Administration/Status reports
#> /tmp/RtmpziyIk1/Administration/Logo and graphical materials
#> /tmp/RtmpziyIk1/Administration/Internal meetings
#> /tmp/RtmpziyIk1/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpziyIk1/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpziyIk1/Administration/Internal meetings/Minutes
#> /tmp/RtmpziyIk1/Materials
#> /tmp/RtmpziyIk1/Materials/Overall planning
#> /tmp/RtmpziyIk1/Materials/Consent form
#> /tmp/RtmpziyIk1/Materials/Ethical-GDPR approval
#> /tmp/RtmpziyIk1/Materials/Survey questionnaires
#> /tmp/RtmpziyIk1/Materials/Interview guides
#> /tmp/RtmpziyIk1/Materials/Interview guides/Staff
#> /tmp/RtmpziyIk1/Materials/Interview guides/Pupils
#> /tmp/RtmpziyIk1/Materials/Interview guides/Parents
#> /tmp/RtmpziyIk1/Materials/Interview guides/Researchers
#> /tmp/RtmpziyIk1/Materials/Interview guides/Leaders
#> /tmp/RtmpziyIk1/Materials/Interview guides/Teachers
#> /tmp/RtmpziyIk1/Materials/Interview guides/Principals
#> /tmp/RtmpziyIk1/Materials/Interview guides/Students
#> /tmp/RtmpziyIk1/Materials/Interview guides/Population
#> /tmp/RtmpziyIk1/Materials/Request of data from
#> /tmp/RtmpziyIk1/Materials/Literature review-design
#> /tmp/RtmpziyIk1/Materials/Intervention materials
#> /tmp/RtmpziyIk1/Materials/Randomizing participants
#> /tmp/RtmpziyIk1/Materials/Chapter overviews
#> /tmp/RtmpziyIk1/Literature
#> /tmp/RtmpziyIk1/Literature/Topic has policy relevance
#> /tmp/RtmpziyIk1/Literature/Pure theory and framework
#> /tmp/RtmpziyIk1/Literature/Similar empirical studies
#> /tmp/RtmpziyIk1/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpziyIk1/Literature/Relevant analytic methodology
#> /tmp/RtmpziyIk1/Literature/Unprocessed (remove from here)
#> /tmp/RtmpziyIk1/Data
#> /tmp/RtmpziyIk1/Data/Population data
#> /tmp/RtmpziyIk1/Data/Population data/Codebook
#> /tmp/RtmpziyIk1/Data/Sampling frame
#> /tmp/RtmpziyIk1/Data/Registry data
#> /tmp/RtmpziyIk1/Data/Collected respondent lists
#> /tmp/RtmpziyIk1/Data/Respondent list for survey system
#> /tmp/RtmpziyIk1/Data/Downloaded response data
#> /tmp/RtmpziyIk1/Data/Downloaded response data/Codebook
#> /tmp/RtmpziyIk1/Data/Qualitative data
#> /tmp/RtmpziyIk1/Data/Qualitative data/Interview recordings
#> /tmp/RtmpziyIk1/Data/Qualitative data/Observational notes
#> /tmp/RtmpziyIk1/Data/Text corpus
#> /tmp/RtmpziyIk1/Data/PDF-reports
#> /tmp/RtmpziyIk1/Data/Prepared data
#> /tmp/RtmpziyIk1/Data/Prepared data/Codebooks
#> /tmp/RtmpziyIk1/Saros_SSN
#> /tmp/RtmpziyIk1/Saros_SSN/Scripts
#> /tmp/RtmpziyIk1/Saros_SSN/Resources
#> /tmp/RtmpziyIk1/Saros_SSN/Draft generations
#> /tmp/RtmpziyIk1/Saros_SSN/Draft generations/main
#> /tmp/RtmpziyIk1/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpziyIk1/Saros_SSN/Drafts in editing
#> /tmp/RtmpziyIk1/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpziyIk1/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpziyIk1/Saros_SSN/Completed drafts
#> /tmp/RtmpziyIk1/Saros_SSN/Completed drafts/main
#> /tmp/RtmpziyIk1/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpziyIk1/Publications
#> /tmp/RtmpziyIk1/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpziyIk1/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpziyIk1/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpziyIk1/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpziyIk1/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpziyIk1/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpziyIk1/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpziyIk1/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpziyIk1/Outreach
#> /tmp/RtmpziyIk1/Outreach/Research conference presentation
#> /tmp/RtmpziyIk1/Outreach/Research conference poster
#> /tmp/RtmpziyIk1/Outreach/Stakeholders and reference group
#> /tmp/RtmpziyIk1/Outreach/Stakeholders' communication channels
#> /tmp/RtmpziyIk1/Outreach/Practitioners and special interest channels
#> /tmp/RtmpziyIk1/Outreach/Public through mass media channels
#> /tmp/RtmpziyIk1/Other
```
