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
#> /tmp/RtmpRU9UL6/Administration
#> /tmp/RtmpRU9UL6/Administration/Application
#> /tmp/RtmpRU9UL6/Administration/Application/Call
#> /tmp/RtmpRU9UL6/Administration/Application/Formalities
#> /tmp/RtmpRU9UL6/Administration/Application/CVs
#> /tmp/RtmpRU9UL6/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpRU9UL6/Administration/Application/Application
#> /tmp/RtmpRU9UL6/Administration/Application/Pre-analysis
#> /tmp/RtmpRU9UL6/Administration/Application/For submission
#> /tmp/RtmpRU9UL6/Administration/Budget
#> /tmp/RtmpRU9UL6/Administration/Contracts and agreements
#> /tmp/RtmpRU9UL6/Administration/Invoices, accounting and receipts
#> /tmp/RtmpRU9UL6/Administration/Status reports
#> /tmp/RtmpRU9UL6/Administration/Logo and graphical materials
#> /tmp/RtmpRU9UL6/Administration/Internal meetings
#> /tmp/RtmpRU9UL6/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpRU9UL6/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpRU9UL6/Administration/Internal meetings/Minutes
#> /tmp/RtmpRU9UL6/Materials
#> /tmp/RtmpRU9UL6/Materials/Overall planning
#> /tmp/RtmpRU9UL6/Materials/Consent form
#> /tmp/RtmpRU9UL6/Materials/Ethical-GDPR approval
#> /tmp/RtmpRU9UL6/Materials/Survey questionnaires
#> /tmp/RtmpRU9UL6/Materials/Interview guides
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Staff
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Pupils
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Parents
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Researchers
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Leaders
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Teachers
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Principals
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Students
#> /tmp/RtmpRU9UL6/Materials/Interview guides/Population
#> /tmp/RtmpRU9UL6/Materials/Request of data from
#> /tmp/RtmpRU9UL6/Materials/Literature review-design
#> /tmp/RtmpRU9UL6/Materials/Intervention materials
#> /tmp/RtmpRU9UL6/Materials/Randomizing participants
#> /tmp/RtmpRU9UL6/Materials/Chapter overviews
#> /tmp/RtmpRU9UL6/Literature
#> /tmp/RtmpRU9UL6/Literature/Topic has policy relevance
#> /tmp/RtmpRU9UL6/Literature/Pure theory and framework
#> /tmp/RtmpRU9UL6/Literature/Similar empirical studies
#> /tmp/RtmpRU9UL6/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpRU9UL6/Literature/Relevant analytic methodology
#> /tmp/RtmpRU9UL6/Literature/Unprocessed (remove from here)
#> /tmp/RtmpRU9UL6/Data
#> /tmp/RtmpRU9UL6/Data/Population data
#> /tmp/RtmpRU9UL6/Data/Population data/Codebook
#> /tmp/RtmpRU9UL6/Data/Sampling frame
#> /tmp/RtmpRU9UL6/Data/Registry data
#> /tmp/RtmpRU9UL6/Data/Collected respondent lists
#> /tmp/RtmpRU9UL6/Data/Respondent list for survey system
#> /tmp/RtmpRU9UL6/Data/Downloaded response data
#> /tmp/RtmpRU9UL6/Data/Downloaded response data/Codebook
#> /tmp/RtmpRU9UL6/Data/Qualitative data
#> /tmp/RtmpRU9UL6/Data/Qualitative data/Interview recordings
#> /tmp/RtmpRU9UL6/Data/Qualitative data/Observational notes
#> /tmp/RtmpRU9UL6/Data/Text corpus
#> /tmp/RtmpRU9UL6/Data/PDF-reports
#> /tmp/RtmpRU9UL6/Data/Prepared data
#> /tmp/RtmpRU9UL6/Data/Prepared data/Codebooks
#> /tmp/RtmpRU9UL6/Saros_SSN
#> /tmp/RtmpRU9UL6/Saros_SSN/Scripts
#> /tmp/RtmpRU9UL6/Saros_SSN/Resources
#> /tmp/RtmpRU9UL6/Saros_SSN/Draft generations
#> /tmp/RtmpRU9UL6/Saros_SSN/Draft generations/main
#> /tmp/RtmpRU9UL6/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpRU9UL6/Saros_SSN/Drafts in editing
#> /tmp/RtmpRU9UL6/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpRU9UL6/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpRU9UL6/Saros_SSN/Completed drafts
#> /tmp/RtmpRU9UL6/Saros_SSN/Completed drafts/main
#> /tmp/RtmpRU9UL6/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpRU9UL6/Publications
#> /tmp/RtmpRU9UL6/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpRU9UL6/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpRU9UL6/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpRU9UL6/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpRU9UL6/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpRU9UL6/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpRU9UL6/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpRU9UL6/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpRU9UL6/Outreach
#> /tmp/RtmpRU9UL6/Outreach/Research conference presentation
#> /tmp/RtmpRU9UL6/Outreach/Research conference poster
#> /tmp/RtmpRU9UL6/Outreach/Stakeholders and reference group
#> /tmp/RtmpRU9UL6/Outreach/Stakeholders' communication channels
#> /tmp/RtmpRU9UL6/Outreach/Practitioners and special interest channels
#> /tmp/RtmpRU9UL6/Outreach/Public through mass media channels
#> /tmp/RtmpRU9UL6/Other
```
