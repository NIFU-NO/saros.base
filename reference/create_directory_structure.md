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
#> /tmp/RtmpoXUAnd/Administration
#> /tmp/RtmpoXUAnd/Administration/Application
#> /tmp/RtmpoXUAnd/Administration/Application/Call
#> /tmp/RtmpoXUAnd/Administration/Application/Formalities
#> /tmp/RtmpoXUAnd/Administration/Application/CVs
#> /tmp/RtmpoXUAnd/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpoXUAnd/Administration/Application/Application
#> /tmp/RtmpoXUAnd/Administration/Application/Pre-analysis
#> /tmp/RtmpoXUAnd/Administration/Application/For submission
#> /tmp/RtmpoXUAnd/Administration/Budget
#> /tmp/RtmpoXUAnd/Administration/Contracts and agreements
#> /tmp/RtmpoXUAnd/Administration/Invoices, accounting and receipts
#> /tmp/RtmpoXUAnd/Administration/Status reports
#> /tmp/RtmpoXUAnd/Administration/Logo and graphical materials
#> /tmp/RtmpoXUAnd/Administration/Internal meetings
#> /tmp/RtmpoXUAnd/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpoXUAnd/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpoXUAnd/Administration/Internal meetings/Minutes
#> /tmp/RtmpoXUAnd/Materials
#> /tmp/RtmpoXUAnd/Materials/Overall planning
#> /tmp/RtmpoXUAnd/Materials/Consent form
#> /tmp/RtmpoXUAnd/Materials/Ethical-GDPR approval
#> /tmp/RtmpoXUAnd/Materials/Survey questionnaires
#> /tmp/RtmpoXUAnd/Materials/Interview guides
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Staff
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Pupils
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Parents
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Researchers
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Leaders
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Teachers
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Principals
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Students
#> /tmp/RtmpoXUAnd/Materials/Interview guides/Population
#> /tmp/RtmpoXUAnd/Materials/Request of data from
#> /tmp/RtmpoXUAnd/Materials/Literature review-design
#> /tmp/RtmpoXUAnd/Materials/Intervention materials
#> /tmp/RtmpoXUAnd/Materials/Randomizing participants
#> /tmp/RtmpoXUAnd/Materials/Chapter overviews
#> /tmp/RtmpoXUAnd/Literature
#> /tmp/RtmpoXUAnd/Literature/Topic has policy relevance
#> /tmp/RtmpoXUAnd/Literature/Pure theory and framework
#> /tmp/RtmpoXUAnd/Literature/Similar empirical studies
#> /tmp/RtmpoXUAnd/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpoXUAnd/Literature/Relevant analytic methodology
#> /tmp/RtmpoXUAnd/Literature/Unprocessed (remove from here)
#> /tmp/RtmpoXUAnd/Data
#> /tmp/RtmpoXUAnd/Data/Population data
#> /tmp/RtmpoXUAnd/Data/Population data/Codebook
#> /tmp/RtmpoXUAnd/Data/Sampling frame
#> /tmp/RtmpoXUAnd/Data/Registry data
#> /tmp/RtmpoXUAnd/Data/Collected respondent lists
#> /tmp/RtmpoXUAnd/Data/Respondent list for survey system
#> /tmp/RtmpoXUAnd/Data/Downloaded response data
#> /tmp/RtmpoXUAnd/Data/Downloaded response data/Codebook
#> /tmp/RtmpoXUAnd/Data/Qualitative data
#> /tmp/RtmpoXUAnd/Data/Qualitative data/Interview recordings
#> /tmp/RtmpoXUAnd/Data/Qualitative data/Observational notes
#> /tmp/RtmpoXUAnd/Data/Text corpus
#> /tmp/RtmpoXUAnd/Data/PDF-reports
#> /tmp/RtmpoXUAnd/Data/Prepared data
#> /tmp/RtmpoXUAnd/Data/Prepared data/Codebooks
#> /tmp/RtmpoXUAnd/Saros_SSN
#> /tmp/RtmpoXUAnd/Saros_SSN/Scripts
#> /tmp/RtmpoXUAnd/Saros_SSN/Resources
#> /tmp/RtmpoXUAnd/Saros_SSN/Draft generations
#> /tmp/RtmpoXUAnd/Saros_SSN/Draft generations/main
#> /tmp/RtmpoXUAnd/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpoXUAnd/Saros_SSN/Drafts in editing
#> /tmp/RtmpoXUAnd/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpoXUAnd/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpoXUAnd/Saros_SSN/Completed drafts
#> /tmp/RtmpoXUAnd/Saros_SSN/Completed drafts/main
#> /tmp/RtmpoXUAnd/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpoXUAnd/Publications
#> /tmp/RtmpoXUAnd/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpoXUAnd/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpoXUAnd/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpoXUAnd/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpoXUAnd/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpoXUAnd/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpoXUAnd/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpoXUAnd/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpoXUAnd/Outreach
#> /tmp/RtmpoXUAnd/Outreach/Research conference presentation
#> /tmp/RtmpoXUAnd/Outreach/Research conference poster
#> /tmp/RtmpoXUAnd/Outreach/Stakeholders and reference group
#> /tmp/RtmpoXUAnd/Outreach/Stakeholders' communication channels
#> /tmp/RtmpoXUAnd/Outreach/Practitioners and special interest channels
#> /tmp/RtmpoXUAnd/Outreach/Public through mass media channels
#> /tmp/RtmpoXUAnd/Other
```
