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
#> /tmp/Rtmpzm1s9c/Administration
#> /tmp/Rtmpzm1s9c/Administration/Application
#> /tmp/Rtmpzm1s9c/Administration/Application/Call
#> /tmp/Rtmpzm1s9c/Administration/Application/Formalities
#> /tmp/Rtmpzm1s9c/Administration/Application/CVs
#> /tmp/Rtmpzm1s9c/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/Rtmpzm1s9c/Administration/Application/Application
#> /tmp/Rtmpzm1s9c/Administration/Application/Pre-analysis
#> /tmp/Rtmpzm1s9c/Administration/Application/For submission
#> /tmp/Rtmpzm1s9c/Administration/Budget
#> /tmp/Rtmpzm1s9c/Administration/Contracts and agreements
#> /tmp/Rtmpzm1s9c/Administration/Invoices, accounting and receipts
#> /tmp/Rtmpzm1s9c/Administration/Status reports
#> /tmp/Rtmpzm1s9c/Administration/Logo and graphical materials
#> /tmp/Rtmpzm1s9c/Administration/Internal meetings
#> /tmp/Rtmpzm1s9c/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/Rtmpzm1s9c/Administration/Internal meetings/Internal presentations
#> /tmp/Rtmpzm1s9c/Administration/Internal meetings/Minutes
#> /tmp/Rtmpzm1s9c/Materials
#> /tmp/Rtmpzm1s9c/Materials/Overall planning
#> /tmp/Rtmpzm1s9c/Materials/Consent form
#> /tmp/Rtmpzm1s9c/Materials/Ethical-GDPR approval
#> /tmp/Rtmpzm1s9c/Materials/Survey questionnaires
#> /tmp/Rtmpzm1s9c/Materials/Interview guides
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Staff
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Pupils
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Parents
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Researchers
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Leaders
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Teachers
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Principals
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Students
#> /tmp/Rtmpzm1s9c/Materials/Interview guides/Population
#> /tmp/Rtmpzm1s9c/Materials/Request of data from
#> /tmp/Rtmpzm1s9c/Materials/Literature review-design
#> /tmp/Rtmpzm1s9c/Materials/Intervention materials
#> /tmp/Rtmpzm1s9c/Materials/Randomizing participants
#> /tmp/Rtmpzm1s9c/Materials/Chapter overviews
#> /tmp/Rtmpzm1s9c/Literature
#> /tmp/Rtmpzm1s9c/Literature/Topic has policy relevance
#> /tmp/Rtmpzm1s9c/Literature/Pure theory and framework
#> /tmp/Rtmpzm1s9c/Literature/Similar empirical studies
#> /tmp/Rtmpzm1s9c/Literature/Similar instruments and guides for data collection
#> /tmp/Rtmpzm1s9c/Literature/Relevant analytic methodology
#> /tmp/Rtmpzm1s9c/Literature/Unprocessed (remove from here)
#> /tmp/Rtmpzm1s9c/Data
#> /tmp/Rtmpzm1s9c/Data/Population data
#> /tmp/Rtmpzm1s9c/Data/Population data/Codebook
#> /tmp/Rtmpzm1s9c/Data/Sampling frame
#> /tmp/Rtmpzm1s9c/Data/Registry data
#> /tmp/Rtmpzm1s9c/Data/Collected respondent lists
#> /tmp/Rtmpzm1s9c/Data/Respondent list for survey system
#> /tmp/Rtmpzm1s9c/Data/Downloaded response data
#> /tmp/Rtmpzm1s9c/Data/Downloaded response data/Codebook
#> /tmp/Rtmpzm1s9c/Data/Qualitative data
#> /tmp/Rtmpzm1s9c/Data/Qualitative data/Interview recordings
#> /tmp/Rtmpzm1s9c/Data/Qualitative data/Observational notes
#> /tmp/Rtmpzm1s9c/Data/Text corpus
#> /tmp/Rtmpzm1s9c/Data/PDF-reports
#> /tmp/Rtmpzm1s9c/Data/Prepared data
#> /tmp/Rtmpzm1s9c/Data/Prepared data/Codebooks
#> /tmp/Rtmpzm1s9c/Saros_SSN
#> /tmp/Rtmpzm1s9c/Saros_SSN/Scripts
#> /tmp/Rtmpzm1s9c/Saros_SSN/Resources
#> /tmp/Rtmpzm1s9c/Saros_SSN/Draft generations
#> /tmp/Rtmpzm1s9c/Saros_SSN/Draft generations/main
#> /tmp/Rtmpzm1s9c/Saros_SSN/Draft generations/Reports
#> /tmp/Rtmpzm1s9c/Saros_SSN/Drafts in editing
#> /tmp/Rtmpzm1s9c/Saros_SSN/Drafts in editing/main
#> /tmp/Rtmpzm1s9c/Saros_SSN/Drafts in editing/Reports
#> /tmp/Rtmpzm1s9c/Saros_SSN/Completed drafts
#> /tmp/Rtmpzm1s9c/Saros_SSN/Completed drafts/main
#> /tmp/Rtmpzm1s9c/Saros_SSN/Completed drafts/Reports
#> /tmp/Rtmpzm1s9c/Publications
#> /tmp/Rtmpzm1s9c/Publications/Paper1-Short title (author initials)
#> /tmp/Rtmpzm1s9c/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/Rtmpzm1s9c/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/Rtmpzm1s9c/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/Rtmpzm1s9c/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/Rtmpzm1s9c/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/Rtmpzm1s9c/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/Rtmpzm1s9c/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/Rtmpzm1s9c/Outreach
#> /tmp/Rtmpzm1s9c/Outreach/Research conference presentation
#> /tmp/Rtmpzm1s9c/Outreach/Research conference poster
#> /tmp/Rtmpzm1s9c/Outreach/Stakeholders and reference group
#> /tmp/Rtmpzm1s9c/Outreach/Stakeholders' communication channels
#> /tmp/Rtmpzm1s9c/Outreach/Practitioners and special interest channels
#> /tmp/Rtmpzm1s9c/Outreach/Public through mass media channels
#> /tmp/Rtmpzm1s9c/Other
```
