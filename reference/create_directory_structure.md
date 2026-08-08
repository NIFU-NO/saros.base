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
#> /tmp/RtmpGZot8Q/Administration
#> /tmp/RtmpGZot8Q/Administration/Application
#> /tmp/RtmpGZot8Q/Administration/Application/Call
#> /tmp/RtmpGZot8Q/Administration/Application/Formalities
#> /tmp/RtmpGZot8Q/Administration/Application/CVs
#> /tmp/RtmpGZot8Q/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpGZot8Q/Administration/Application/Application
#> /tmp/RtmpGZot8Q/Administration/Application/Pre-analysis
#> /tmp/RtmpGZot8Q/Administration/Application/For submission
#> /tmp/RtmpGZot8Q/Administration/Budget
#> /tmp/RtmpGZot8Q/Administration/Contracts and agreements
#> /tmp/RtmpGZot8Q/Administration/Invoices, accounting and receipts
#> /tmp/RtmpGZot8Q/Administration/Status reports
#> /tmp/RtmpGZot8Q/Administration/Logo and graphical materials
#> /tmp/RtmpGZot8Q/Administration/Internal meetings
#> /tmp/RtmpGZot8Q/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpGZot8Q/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpGZot8Q/Administration/Internal meetings/Minutes
#> /tmp/RtmpGZot8Q/Materials
#> /tmp/RtmpGZot8Q/Materials/Overall planning
#> /tmp/RtmpGZot8Q/Materials/Consent form
#> /tmp/RtmpGZot8Q/Materials/Ethical-GDPR approval
#> /tmp/RtmpGZot8Q/Materials/Survey questionnaires
#> /tmp/RtmpGZot8Q/Materials/Interview guides
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Staff
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Pupils
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Parents
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Researchers
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Leaders
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Teachers
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Principals
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Students
#> /tmp/RtmpGZot8Q/Materials/Interview guides/Population
#> /tmp/RtmpGZot8Q/Materials/Request of data from
#> /tmp/RtmpGZot8Q/Materials/Literature review-design
#> /tmp/RtmpGZot8Q/Materials/Intervention materials
#> /tmp/RtmpGZot8Q/Materials/Randomizing participants
#> /tmp/RtmpGZot8Q/Materials/Chapter overviews
#> /tmp/RtmpGZot8Q/Literature
#> /tmp/RtmpGZot8Q/Literature/Topic has policy relevance
#> /tmp/RtmpGZot8Q/Literature/Pure theory and framework
#> /tmp/RtmpGZot8Q/Literature/Similar empirical studies
#> /tmp/RtmpGZot8Q/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpGZot8Q/Literature/Relevant analytic methodology
#> /tmp/RtmpGZot8Q/Literature/Unprocessed (remove from here)
#> /tmp/RtmpGZot8Q/Data
#> /tmp/RtmpGZot8Q/Data/Population data
#> /tmp/RtmpGZot8Q/Data/Population data/Codebook
#> /tmp/RtmpGZot8Q/Data/Sampling frame
#> /tmp/RtmpGZot8Q/Data/Registry data
#> /tmp/RtmpGZot8Q/Data/Collected respondent lists
#> /tmp/RtmpGZot8Q/Data/Respondent list for survey system
#> /tmp/RtmpGZot8Q/Data/Downloaded response data
#> /tmp/RtmpGZot8Q/Data/Downloaded response data/Codebook
#> /tmp/RtmpGZot8Q/Data/Qualitative data
#> /tmp/RtmpGZot8Q/Data/Qualitative data/Interview recordings
#> /tmp/RtmpGZot8Q/Data/Qualitative data/Observational notes
#> /tmp/RtmpGZot8Q/Data/Text corpus
#> /tmp/RtmpGZot8Q/Data/PDF-reports
#> /tmp/RtmpGZot8Q/Data/Prepared data
#> /tmp/RtmpGZot8Q/Data/Prepared data/Codebooks
#> /tmp/RtmpGZot8Q/Saros_SSN
#> /tmp/RtmpGZot8Q/Saros_SSN/Scripts
#> /tmp/RtmpGZot8Q/Saros_SSN/Resources
#> /tmp/RtmpGZot8Q/Saros_SSN/Draft generations
#> /tmp/RtmpGZot8Q/Saros_SSN/Draft generations/main
#> /tmp/RtmpGZot8Q/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpGZot8Q/Saros_SSN/Drafts in editing
#> /tmp/RtmpGZot8Q/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpGZot8Q/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpGZot8Q/Saros_SSN/Completed drafts
#> /tmp/RtmpGZot8Q/Saros_SSN/Completed drafts/main
#> /tmp/RtmpGZot8Q/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpGZot8Q/Publications
#> /tmp/RtmpGZot8Q/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpGZot8Q/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpGZot8Q/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpGZot8Q/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpGZot8Q/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpGZot8Q/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpGZot8Q/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpGZot8Q/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpGZot8Q/Outreach
#> /tmp/RtmpGZot8Q/Outreach/Research conference presentation
#> /tmp/RtmpGZot8Q/Outreach/Research conference poster
#> /tmp/RtmpGZot8Q/Outreach/Stakeholders and reference group
#> /tmp/RtmpGZot8Q/Outreach/Stakeholders' communication channels
#> /tmp/RtmpGZot8Q/Outreach/Practitioners and special interest channels
#> /tmp/RtmpGZot8Q/Outreach/Public through mass media channels
#> /tmp/RtmpGZot8Q/Other
```
