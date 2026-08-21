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
#> /tmp/Rtmpe7YOaS/Administration
#> /tmp/Rtmpe7YOaS/Administration/Application
#> /tmp/Rtmpe7YOaS/Administration/Application/Call
#> /tmp/Rtmpe7YOaS/Administration/Application/Formalities
#> /tmp/Rtmpe7YOaS/Administration/Application/CVs
#> /tmp/Rtmpe7YOaS/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/Rtmpe7YOaS/Administration/Application/Application
#> /tmp/Rtmpe7YOaS/Administration/Application/Pre-analysis
#> /tmp/Rtmpe7YOaS/Administration/Application/For submission
#> /tmp/Rtmpe7YOaS/Administration/Budget
#> /tmp/Rtmpe7YOaS/Administration/Contracts and agreements
#> /tmp/Rtmpe7YOaS/Administration/Invoices, accounting and receipts
#> /tmp/Rtmpe7YOaS/Administration/Status reports
#> /tmp/Rtmpe7YOaS/Administration/Logo and graphical materials
#> /tmp/Rtmpe7YOaS/Administration/Internal meetings
#> /tmp/Rtmpe7YOaS/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/Rtmpe7YOaS/Administration/Internal meetings/Internal presentations
#> /tmp/Rtmpe7YOaS/Administration/Internal meetings/Minutes
#> /tmp/Rtmpe7YOaS/Materials
#> /tmp/Rtmpe7YOaS/Materials/Overall planning
#> /tmp/Rtmpe7YOaS/Materials/Consent form
#> /tmp/Rtmpe7YOaS/Materials/Ethical-GDPR approval
#> /tmp/Rtmpe7YOaS/Materials/Survey questionnaires
#> /tmp/Rtmpe7YOaS/Materials/Interview guides
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Staff
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Pupils
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Parents
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Researchers
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Leaders
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Teachers
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Principals
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Students
#> /tmp/Rtmpe7YOaS/Materials/Interview guides/Population
#> /tmp/Rtmpe7YOaS/Materials/Request of data from
#> /tmp/Rtmpe7YOaS/Materials/Literature review-design
#> /tmp/Rtmpe7YOaS/Materials/Intervention materials
#> /tmp/Rtmpe7YOaS/Materials/Randomizing participants
#> /tmp/Rtmpe7YOaS/Materials/Chapter overviews
#> /tmp/Rtmpe7YOaS/Literature
#> /tmp/Rtmpe7YOaS/Literature/Topic has policy relevance
#> /tmp/Rtmpe7YOaS/Literature/Pure theory and framework
#> /tmp/Rtmpe7YOaS/Literature/Similar empirical studies
#> /tmp/Rtmpe7YOaS/Literature/Similar instruments and guides for data collection
#> /tmp/Rtmpe7YOaS/Literature/Relevant analytic methodology
#> /tmp/Rtmpe7YOaS/Literature/Unprocessed (remove from here)
#> /tmp/Rtmpe7YOaS/Data
#> /tmp/Rtmpe7YOaS/Data/Population data
#> /tmp/Rtmpe7YOaS/Data/Population data/Codebook
#> /tmp/Rtmpe7YOaS/Data/Sampling frame
#> /tmp/Rtmpe7YOaS/Data/Registry data
#> /tmp/Rtmpe7YOaS/Data/Collected respondent lists
#> /tmp/Rtmpe7YOaS/Data/Respondent list for survey system
#> /tmp/Rtmpe7YOaS/Data/Downloaded response data
#> /tmp/Rtmpe7YOaS/Data/Downloaded response data/Codebook
#> /tmp/Rtmpe7YOaS/Data/Qualitative data
#> /tmp/Rtmpe7YOaS/Data/Qualitative data/Interview recordings
#> /tmp/Rtmpe7YOaS/Data/Qualitative data/Observational notes
#> /tmp/Rtmpe7YOaS/Data/Text corpus
#> /tmp/Rtmpe7YOaS/Data/PDF-reports
#> /tmp/Rtmpe7YOaS/Data/Prepared data
#> /tmp/Rtmpe7YOaS/Data/Prepared data/Codebooks
#> /tmp/Rtmpe7YOaS/Saros_SSN
#> /tmp/Rtmpe7YOaS/Saros_SSN/Scripts
#> /tmp/Rtmpe7YOaS/Saros_SSN/Resources
#> /tmp/Rtmpe7YOaS/Saros_SSN/Draft generations
#> /tmp/Rtmpe7YOaS/Saros_SSN/Draft generations/main
#> /tmp/Rtmpe7YOaS/Saros_SSN/Draft generations/Reports
#> /tmp/Rtmpe7YOaS/Saros_SSN/Drafts in editing
#> /tmp/Rtmpe7YOaS/Saros_SSN/Drafts in editing/main
#> /tmp/Rtmpe7YOaS/Saros_SSN/Drafts in editing/Reports
#> /tmp/Rtmpe7YOaS/Saros_SSN/Completed drafts
#> /tmp/Rtmpe7YOaS/Saros_SSN/Completed drafts/main
#> /tmp/Rtmpe7YOaS/Saros_SSN/Completed drafts/Reports
#> /tmp/Rtmpe7YOaS/Publications
#> /tmp/Rtmpe7YOaS/Publications/Paper1-Short title (author initials)
#> /tmp/Rtmpe7YOaS/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/Rtmpe7YOaS/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/Rtmpe7YOaS/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/Rtmpe7YOaS/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/Rtmpe7YOaS/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/Rtmpe7YOaS/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/Rtmpe7YOaS/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/Rtmpe7YOaS/Outreach
#> /tmp/Rtmpe7YOaS/Outreach/Research conference presentation
#> /tmp/Rtmpe7YOaS/Outreach/Research conference poster
#> /tmp/Rtmpe7YOaS/Outreach/Stakeholders and reference group
#> /tmp/Rtmpe7YOaS/Outreach/Stakeholders' communication channels
#> /tmp/Rtmpe7YOaS/Outreach/Practitioners and special interest channels
#> /tmp/Rtmpe7YOaS/Outreach/Public through mass media channels
#> /tmp/Rtmpe7YOaS/Other
```
