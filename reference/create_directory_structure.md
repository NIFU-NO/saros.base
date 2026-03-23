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
#> /tmp/RtmplLGAG8/Administration
#> /tmp/RtmplLGAG8/Administration/Application
#> /tmp/RtmplLGAG8/Administration/Application/Call
#> /tmp/RtmplLGAG8/Administration/Application/Formalities
#> /tmp/RtmplLGAG8/Administration/Application/CVs
#> /tmp/RtmplLGAG8/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmplLGAG8/Administration/Application/Application
#> /tmp/RtmplLGAG8/Administration/Application/Pre-analysis
#> /tmp/RtmplLGAG8/Administration/Application/For submission
#> /tmp/RtmplLGAG8/Administration/Budget
#> /tmp/RtmplLGAG8/Administration/Contracts and agreements
#> /tmp/RtmplLGAG8/Administration/Invoices, accounting and receipts
#> /tmp/RtmplLGAG8/Administration/Status reports
#> /tmp/RtmplLGAG8/Administration/Logo and graphical materials
#> /tmp/RtmplLGAG8/Administration/Internal meetings
#> /tmp/RtmplLGAG8/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmplLGAG8/Administration/Internal meetings/Internal presentations
#> /tmp/RtmplLGAG8/Administration/Internal meetings/Minutes
#> /tmp/RtmplLGAG8/Materials
#> /tmp/RtmplLGAG8/Materials/Overall planning
#> /tmp/RtmplLGAG8/Materials/Consent form
#> /tmp/RtmplLGAG8/Materials/Ethical-GDPR approval
#> /tmp/RtmplLGAG8/Materials/Survey questionnaires
#> /tmp/RtmplLGAG8/Materials/Interview guides
#> /tmp/RtmplLGAG8/Materials/Interview guides/Staff
#> /tmp/RtmplLGAG8/Materials/Interview guides/Pupils
#> /tmp/RtmplLGAG8/Materials/Interview guides/Parents
#> /tmp/RtmplLGAG8/Materials/Interview guides/Researchers
#> /tmp/RtmplLGAG8/Materials/Interview guides/Leaders
#> /tmp/RtmplLGAG8/Materials/Interview guides/Teachers
#> /tmp/RtmplLGAG8/Materials/Interview guides/Principals
#> /tmp/RtmplLGAG8/Materials/Interview guides/Students
#> /tmp/RtmplLGAG8/Materials/Interview guides/Population
#> /tmp/RtmplLGAG8/Materials/Request of data from
#> /tmp/RtmplLGAG8/Materials/Literature review-design
#> /tmp/RtmplLGAG8/Materials/Intervention materials
#> /tmp/RtmplLGAG8/Materials/Randomizing participants
#> /tmp/RtmplLGAG8/Materials/Chapter overviews
#> /tmp/RtmplLGAG8/Literature
#> /tmp/RtmplLGAG8/Literature/Topic has policy relevance
#> /tmp/RtmplLGAG8/Literature/Pure theory and framework
#> /tmp/RtmplLGAG8/Literature/Similar empirical studies
#> /tmp/RtmplLGAG8/Literature/Similar instruments and guides for data collection
#> /tmp/RtmplLGAG8/Literature/Relevant analytic methodology
#> /tmp/RtmplLGAG8/Literature/Unprocessed (remove from here)
#> /tmp/RtmplLGAG8/Data
#> /tmp/RtmplLGAG8/Data/Population data
#> /tmp/RtmplLGAG8/Data/Population data/Codebook
#> /tmp/RtmplLGAG8/Data/Sampling frame
#> /tmp/RtmplLGAG8/Data/Registry data
#> /tmp/RtmplLGAG8/Data/Collected respondent lists
#> /tmp/RtmplLGAG8/Data/Respondent list for survey system
#> /tmp/RtmplLGAG8/Data/Downloaded response data
#> /tmp/RtmplLGAG8/Data/Downloaded response data/Codebook
#> /tmp/RtmplLGAG8/Data/Qualitative data
#> /tmp/RtmplLGAG8/Data/Qualitative data/Interview recordings
#> /tmp/RtmplLGAG8/Data/Qualitative data/Observational notes
#> /tmp/RtmplLGAG8/Data/Text corpus
#> /tmp/RtmplLGAG8/Data/PDF-reports
#> /tmp/RtmplLGAG8/Data/Prepared data
#> /tmp/RtmplLGAG8/Data/Prepared data/Codebooks
#> /tmp/RtmplLGAG8/Saros_SSN
#> /tmp/RtmplLGAG8/Saros_SSN/Scripts
#> /tmp/RtmplLGAG8/Saros_SSN/Resources
#> /tmp/RtmplLGAG8/Saros_SSN/Draft generations
#> /tmp/RtmplLGAG8/Saros_SSN/Draft generations/main
#> /tmp/RtmplLGAG8/Saros_SSN/Draft generations/Reports
#> /tmp/RtmplLGAG8/Saros_SSN/Drafts in editing
#> /tmp/RtmplLGAG8/Saros_SSN/Drafts in editing/main
#> /tmp/RtmplLGAG8/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmplLGAG8/Saros_SSN/Completed drafts
#> /tmp/RtmplLGAG8/Saros_SSN/Completed drafts/main
#> /tmp/RtmplLGAG8/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmplLGAG8/Publications
#> /tmp/RtmplLGAG8/Publications/Paper1-Short title (author initials)
#> /tmp/RtmplLGAG8/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmplLGAG8/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmplLGAG8/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmplLGAG8/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmplLGAG8/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmplLGAG8/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmplLGAG8/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmplLGAG8/Outreach
#> /tmp/RtmplLGAG8/Outreach/Research conference presentation
#> /tmp/RtmplLGAG8/Outreach/Research conference poster
#> /tmp/RtmplLGAG8/Outreach/Stakeholders and reference group
#> /tmp/RtmplLGAG8/Outreach/Stakeholders' communication channels
#> /tmp/RtmplLGAG8/Outreach/Practitioners and special interest channels
#> /tmp/RtmplLGAG8/Outreach/Public through mass media channels
#> /tmp/RtmplLGAG8/Other
```
