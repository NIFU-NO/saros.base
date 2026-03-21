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
#> /tmp/RtmprPDuoS/Administration
#> /tmp/RtmprPDuoS/Administration/Application
#> /tmp/RtmprPDuoS/Administration/Application/Call
#> /tmp/RtmprPDuoS/Administration/Application/Formalities
#> /tmp/RtmprPDuoS/Administration/Application/CVs
#> /tmp/RtmprPDuoS/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmprPDuoS/Administration/Application/Application
#> /tmp/RtmprPDuoS/Administration/Application/Pre-analysis
#> /tmp/RtmprPDuoS/Administration/Application/For submission
#> /tmp/RtmprPDuoS/Administration/Budget
#> /tmp/RtmprPDuoS/Administration/Contracts and agreements
#> /tmp/RtmprPDuoS/Administration/Invoices, accounting and receipts
#> /tmp/RtmprPDuoS/Administration/Status reports
#> /tmp/RtmprPDuoS/Administration/Logo and graphical materials
#> /tmp/RtmprPDuoS/Administration/Internal meetings
#> /tmp/RtmprPDuoS/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmprPDuoS/Administration/Internal meetings/Internal presentations
#> /tmp/RtmprPDuoS/Administration/Internal meetings/Minutes
#> /tmp/RtmprPDuoS/Materials
#> /tmp/RtmprPDuoS/Materials/Overall planning
#> /tmp/RtmprPDuoS/Materials/Consent form
#> /tmp/RtmprPDuoS/Materials/Ethical-GDPR approval
#> /tmp/RtmprPDuoS/Materials/Survey questionnaires
#> /tmp/RtmprPDuoS/Materials/Interview guides
#> /tmp/RtmprPDuoS/Materials/Interview guides/Staff
#> /tmp/RtmprPDuoS/Materials/Interview guides/Pupils
#> /tmp/RtmprPDuoS/Materials/Interview guides/Parents
#> /tmp/RtmprPDuoS/Materials/Interview guides/Researchers
#> /tmp/RtmprPDuoS/Materials/Interview guides/Leaders
#> /tmp/RtmprPDuoS/Materials/Interview guides/Teachers
#> /tmp/RtmprPDuoS/Materials/Interview guides/Principals
#> /tmp/RtmprPDuoS/Materials/Interview guides/Students
#> /tmp/RtmprPDuoS/Materials/Interview guides/Population
#> /tmp/RtmprPDuoS/Materials/Request of data from
#> /tmp/RtmprPDuoS/Materials/Literature review-design
#> /tmp/RtmprPDuoS/Materials/Intervention materials
#> /tmp/RtmprPDuoS/Materials/Randomizing participants
#> /tmp/RtmprPDuoS/Materials/Chapter overviews
#> /tmp/RtmprPDuoS/Literature
#> /tmp/RtmprPDuoS/Literature/Topic has policy relevance
#> /tmp/RtmprPDuoS/Literature/Pure theory and framework
#> /tmp/RtmprPDuoS/Literature/Similar empirical studies
#> /tmp/RtmprPDuoS/Literature/Similar instruments and guides for data collection
#> /tmp/RtmprPDuoS/Literature/Relevant analytic methodology
#> /tmp/RtmprPDuoS/Literature/Unprocessed (remove from here)
#> /tmp/RtmprPDuoS/Data
#> /tmp/RtmprPDuoS/Data/Population data
#> /tmp/RtmprPDuoS/Data/Population data/Codebook
#> /tmp/RtmprPDuoS/Data/Sampling frame
#> /tmp/RtmprPDuoS/Data/Registry data
#> /tmp/RtmprPDuoS/Data/Collected respondent lists
#> /tmp/RtmprPDuoS/Data/Respondent list for survey system
#> /tmp/RtmprPDuoS/Data/Downloaded response data
#> /tmp/RtmprPDuoS/Data/Downloaded response data/Codebook
#> /tmp/RtmprPDuoS/Data/Qualitative data
#> /tmp/RtmprPDuoS/Data/Qualitative data/Interview recordings
#> /tmp/RtmprPDuoS/Data/Qualitative data/Observational notes
#> /tmp/RtmprPDuoS/Data/Text corpus
#> /tmp/RtmprPDuoS/Data/PDF-reports
#> /tmp/RtmprPDuoS/Data/Prepared data
#> /tmp/RtmprPDuoS/Data/Prepared data/Codebooks
#> /tmp/RtmprPDuoS/Saros_SSN
#> /tmp/RtmprPDuoS/Saros_SSN/Scripts
#> /tmp/RtmprPDuoS/Saros_SSN/Resources
#> /tmp/RtmprPDuoS/Saros_SSN/Draft generations
#> /tmp/RtmprPDuoS/Saros_SSN/Draft generations/main
#> /tmp/RtmprPDuoS/Saros_SSN/Draft generations/Reports
#> /tmp/RtmprPDuoS/Saros_SSN/Drafts in editing
#> /tmp/RtmprPDuoS/Saros_SSN/Drafts in editing/main
#> /tmp/RtmprPDuoS/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmprPDuoS/Saros_SSN/Completed drafts
#> /tmp/RtmprPDuoS/Saros_SSN/Completed drafts/main
#> /tmp/RtmprPDuoS/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmprPDuoS/Publications
#> /tmp/RtmprPDuoS/Publications/Paper1-Short title (author initials)
#> /tmp/RtmprPDuoS/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmprPDuoS/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmprPDuoS/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmprPDuoS/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmprPDuoS/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmprPDuoS/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmprPDuoS/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmprPDuoS/Outreach
#> /tmp/RtmprPDuoS/Outreach/Research conference presentation
#> /tmp/RtmprPDuoS/Outreach/Research conference poster
#> /tmp/RtmprPDuoS/Outreach/Stakeholders and reference group
#> /tmp/RtmprPDuoS/Outreach/Stakeholders' communication channels
#> /tmp/RtmprPDuoS/Outreach/Practitioners and special interest channels
#> /tmp/RtmprPDuoS/Outreach/Public through mass media channels
#> /tmp/RtmprPDuoS/Other
```
