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
#> /tmp/RtmpRqnDIE/Administration
#> /tmp/RtmpRqnDIE/Administration/Application
#> /tmp/RtmpRqnDIE/Administration/Application/Call
#> /tmp/RtmpRqnDIE/Administration/Application/Formalities
#> /tmp/RtmpRqnDIE/Administration/Application/CVs
#> /tmp/RtmpRqnDIE/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpRqnDIE/Administration/Application/Application
#> /tmp/RtmpRqnDIE/Administration/Application/Pre-analysis
#> /tmp/RtmpRqnDIE/Administration/Application/For submission
#> /tmp/RtmpRqnDIE/Administration/Budget
#> /tmp/RtmpRqnDIE/Administration/Contracts and agreements
#> /tmp/RtmpRqnDIE/Administration/Invoices, accounting and receipts
#> /tmp/RtmpRqnDIE/Administration/Status reports
#> /tmp/RtmpRqnDIE/Administration/Logo and graphical materials
#> /tmp/RtmpRqnDIE/Administration/Internal meetings
#> /tmp/RtmpRqnDIE/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpRqnDIE/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpRqnDIE/Administration/Internal meetings/Minutes
#> /tmp/RtmpRqnDIE/Materials
#> /tmp/RtmpRqnDIE/Materials/Overall planning
#> /tmp/RtmpRqnDIE/Materials/Consent form
#> /tmp/RtmpRqnDIE/Materials/Ethical-GDPR approval
#> /tmp/RtmpRqnDIE/Materials/Survey questionnaires
#> /tmp/RtmpRqnDIE/Materials/Interview guides
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Staff
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Pupils
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Parents
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Researchers
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Leaders
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Teachers
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Principals
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Students
#> /tmp/RtmpRqnDIE/Materials/Interview guides/Population
#> /tmp/RtmpRqnDIE/Materials/Request of data from
#> /tmp/RtmpRqnDIE/Materials/Literature review-design
#> /tmp/RtmpRqnDIE/Materials/Intervention materials
#> /tmp/RtmpRqnDIE/Materials/Randomizing participants
#> /tmp/RtmpRqnDIE/Materials/Chapter overviews
#> /tmp/RtmpRqnDIE/Literature
#> /tmp/RtmpRqnDIE/Literature/Topic has policy relevance
#> /tmp/RtmpRqnDIE/Literature/Pure theory and framework
#> /tmp/RtmpRqnDIE/Literature/Similar empirical studies
#> /tmp/RtmpRqnDIE/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpRqnDIE/Literature/Relevant analytic methodology
#> /tmp/RtmpRqnDIE/Literature/Unprocessed (remove from here)
#> /tmp/RtmpRqnDIE/Data
#> /tmp/RtmpRqnDIE/Data/Population data
#> /tmp/RtmpRqnDIE/Data/Population data/Codebook
#> /tmp/RtmpRqnDIE/Data/Sampling frame
#> /tmp/RtmpRqnDIE/Data/Registry data
#> /tmp/RtmpRqnDIE/Data/Collected respondent lists
#> /tmp/RtmpRqnDIE/Data/Respondent list for survey system
#> /tmp/RtmpRqnDIE/Data/Downloaded response data
#> /tmp/RtmpRqnDIE/Data/Downloaded response data/Codebook
#> /tmp/RtmpRqnDIE/Data/Qualitative data
#> /tmp/RtmpRqnDIE/Data/Qualitative data/Interview recordings
#> /tmp/RtmpRqnDIE/Data/Qualitative data/Observational notes
#> /tmp/RtmpRqnDIE/Data/Text corpus
#> /tmp/RtmpRqnDIE/Data/PDF-reports
#> /tmp/RtmpRqnDIE/Data/Prepared data
#> /tmp/RtmpRqnDIE/Data/Prepared data/Codebooks
#> /tmp/RtmpRqnDIE/Saros_SSN
#> /tmp/RtmpRqnDIE/Saros_SSN/Scripts
#> /tmp/RtmpRqnDIE/Saros_SSN/Resources
#> /tmp/RtmpRqnDIE/Saros_SSN/Draft generations
#> /tmp/RtmpRqnDIE/Saros_SSN/Draft generations/main
#> /tmp/RtmpRqnDIE/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpRqnDIE/Saros_SSN/Drafts in editing
#> /tmp/RtmpRqnDIE/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpRqnDIE/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpRqnDIE/Saros_SSN/Completed drafts
#> /tmp/RtmpRqnDIE/Saros_SSN/Completed drafts/main
#> /tmp/RtmpRqnDIE/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpRqnDIE/Publications
#> /tmp/RtmpRqnDIE/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpRqnDIE/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpRqnDIE/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpRqnDIE/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpRqnDIE/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpRqnDIE/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpRqnDIE/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpRqnDIE/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpRqnDIE/Outreach
#> /tmp/RtmpRqnDIE/Outreach/Research conference presentation
#> /tmp/RtmpRqnDIE/Outreach/Research conference poster
#> /tmp/RtmpRqnDIE/Outreach/Stakeholders and reference group
#> /tmp/RtmpRqnDIE/Outreach/Stakeholders' communication channels
#> /tmp/RtmpRqnDIE/Outreach/Practitioners and special interest channels
#> /tmp/RtmpRqnDIE/Outreach/Public through mass media channels
#> /tmp/RtmpRqnDIE/Other
```
