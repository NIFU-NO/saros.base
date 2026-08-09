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
#> /tmp/RtmpgZ21X3/Administration
#> /tmp/RtmpgZ21X3/Administration/Application
#> /tmp/RtmpgZ21X3/Administration/Application/Call
#> /tmp/RtmpgZ21X3/Administration/Application/Formalities
#> /tmp/RtmpgZ21X3/Administration/Application/CVs
#> /tmp/RtmpgZ21X3/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpgZ21X3/Administration/Application/Application
#> /tmp/RtmpgZ21X3/Administration/Application/Pre-analysis
#> /tmp/RtmpgZ21X3/Administration/Application/For submission
#> /tmp/RtmpgZ21X3/Administration/Budget
#> /tmp/RtmpgZ21X3/Administration/Contracts and agreements
#> /tmp/RtmpgZ21X3/Administration/Invoices, accounting and receipts
#> /tmp/RtmpgZ21X3/Administration/Status reports
#> /tmp/RtmpgZ21X3/Administration/Logo and graphical materials
#> /tmp/RtmpgZ21X3/Administration/Internal meetings
#> /tmp/RtmpgZ21X3/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpgZ21X3/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpgZ21X3/Administration/Internal meetings/Minutes
#> /tmp/RtmpgZ21X3/Materials
#> /tmp/RtmpgZ21X3/Materials/Overall planning
#> /tmp/RtmpgZ21X3/Materials/Consent form
#> /tmp/RtmpgZ21X3/Materials/Ethical-GDPR approval
#> /tmp/RtmpgZ21X3/Materials/Survey questionnaires
#> /tmp/RtmpgZ21X3/Materials/Interview guides
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Staff
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Pupils
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Parents
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Researchers
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Leaders
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Teachers
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Principals
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Students
#> /tmp/RtmpgZ21X3/Materials/Interview guides/Population
#> /tmp/RtmpgZ21X3/Materials/Request of data from
#> /tmp/RtmpgZ21X3/Materials/Literature review-design
#> /tmp/RtmpgZ21X3/Materials/Intervention materials
#> /tmp/RtmpgZ21X3/Materials/Randomizing participants
#> /tmp/RtmpgZ21X3/Materials/Chapter overviews
#> /tmp/RtmpgZ21X3/Literature
#> /tmp/RtmpgZ21X3/Literature/Topic has policy relevance
#> /tmp/RtmpgZ21X3/Literature/Pure theory and framework
#> /tmp/RtmpgZ21X3/Literature/Similar empirical studies
#> /tmp/RtmpgZ21X3/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpgZ21X3/Literature/Relevant analytic methodology
#> /tmp/RtmpgZ21X3/Literature/Unprocessed (remove from here)
#> /tmp/RtmpgZ21X3/Data
#> /tmp/RtmpgZ21X3/Data/Population data
#> /tmp/RtmpgZ21X3/Data/Population data/Codebook
#> /tmp/RtmpgZ21X3/Data/Sampling frame
#> /tmp/RtmpgZ21X3/Data/Registry data
#> /tmp/RtmpgZ21X3/Data/Collected respondent lists
#> /tmp/RtmpgZ21X3/Data/Respondent list for survey system
#> /tmp/RtmpgZ21X3/Data/Downloaded response data
#> /tmp/RtmpgZ21X3/Data/Downloaded response data/Codebook
#> /tmp/RtmpgZ21X3/Data/Qualitative data
#> /tmp/RtmpgZ21X3/Data/Qualitative data/Interview recordings
#> /tmp/RtmpgZ21X3/Data/Qualitative data/Observational notes
#> /tmp/RtmpgZ21X3/Data/Text corpus
#> /tmp/RtmpgZ21X3/Data/PDF-reports
#> /tmp/RtmpgZ21X3/Data/Prepared data
#> /tmp/RtmpgZ21X3/Data/Prepared data/Codebooks
#> /tmp/RtmpgZ21X3/Saros_SSN
#> /tmp/RtmpgZ21X3/Saros_SSN/Scripts
#> /tmp/RtmpgZ21X3/Saros_SSN/Resources
#> /tmp/RtmpgZ21X3/Saros_SSN/Draft generations
#> /tmp/RtmpgZ21X3/Saros_SSN/Draft generations/main
#> /tmp/RtmpgZ21X3/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpgZ21X3/Saros_SSN/Drafts in editing
#> /tmp/RtmpgZ21X3/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpgZ21X3/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpgZ21X3/Saros_SSN/Completed drafts
#> /tmp/RtmpgZ21X3/Saros_SSN/Completed drafts/main
#> /tmp/RtmpgZ21X3/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpgZ21X3/Publications
#> /tmp/RtmpgZ21X3/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpgZ21X3/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpgZ21X3/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpgZ21X3/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpgZ21X3/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpgZ21X3/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpgZ21X3/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpgZ21X3/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpgZ21X3/Outreach
#> /tmp/RtmpgZ21X3/Outreach/Research conference presentation
#> /tmp/RtmpgZ21X3/Outreach/Research conference poster
#> /tmp/RtmpgZ21X3/Outreach/Stakeholders and reference group
#> /tmp/RtmpgZ21X3/Outreach/Stakeholders' communication channels
#> /tmp/RtmpgZ21X3/Outreach/Practitioners and special interest channels
#> /tmp/RtmpgZ21X3/Outreach/Public through mass media channels
#> /tmp/RtmpgZ21X3/Other
```
