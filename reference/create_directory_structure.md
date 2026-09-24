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
#> /tmp/RtmpEWpp6Y/Administration
#> /tmp/RtmpEWpp6Y/Administration/Application
#> /tmp/RtmpEWpp6Y/Administration/Application/Call
#> /tmp/RtmpEWpp6Y/Administration/Application/Formalities
#> /tmp/RtmpEWpp6Y/Administration/Application/CVs
#> /tmp/RtmpEWpp6Y/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpEWpp6Y/Administration/Application/Application
#> /tmp/RtmpEWpp6Y/Administration/Application/Pre-analysis
#> /tmp/RtmpEWpp6Y/Administration/Application/For submission
#> /tmp/RtmpEWpp6Y/Administration/Budget
#> /tmp/RtmpEWpp6Y/Administration/Contracts and agreements
#> /tmp/RtmpEWpp6Y/Administration/Invoices, accounting and receipts
#> /tmp/RtmpEWpp6Y/Administration/Status reports
#> /tmp/RtmpEWpp6Y/Administration/Logo and graphical materials
#> /tmp/RtmpEWpp6Y/Administration/Internal meetings
#> /tmp/RtmpEWpp6Y/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpEWpp6Y/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpEWpp6Y/Administration/Internal meetings/Minutes
#> /tmp/RtmpEWpp6Y/Materials
#> /tmp/RtmpEWpp6Y/Materials/Overall planning
#> /tmp/RtmpEWpp6Y/Materials/Consent form
#> /tmp/RtmpEWpp6Y/Materials/Ethical-GDPR approval
#> /tmp/RtmpEWpp6Y/Materials/Survey questionnaires
#> /tmp/RtmpEWpp6Y/Materials/Interview guides
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Staff
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Pupils
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Parents
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Researchers
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Leaders
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Teachers
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Principals
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Students
#> /tmp/RtmpEWpp6Y/Materials/Interview guides/Population
#> /tmp/RtmpEWpp6Y/Materials/Request of data from
#> /tmp/RtmpEWpp6Y/Materials/Literature review-design
#> /tmp/RtmpEWpp6Y/Materials/Intervention materials
#> /tmp/RtmpEWpp6Y/Materials/Randomizing participants
#> /tmp/RtmpEWpp6Y/Materials/Chapter overviews
#> /tmp/RtmpEWpp6Y/Literature
#> /tmp/RtmpEWpp6Y/Literature/Topic has policy relevance
#> /tmp/RtmpEWpp6Y/Literature/Pure theory and framework
#> /tmp/RtmpEWpp6Y/Literature/Similar empirical studies
#> /tmp/RtmpEWpp6Y/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpEWpp6Y/Literature/Relevant analytic methodology
#> /tmp/RtmpEWpp6Y/Literature/Unprocessed (remove from here)
#> /tmp/RtmpEWpp6Y/Data
#> /tmp/RtmpEWpp6Y/Data/Population data
#> /tmp/RtmpEWpp6Y/Data/Population data/Codebook
#> /tmp/RtmpEWpp6Y/Data/Sampling frame
#> /tmp/RtmpEWpp6Y/Data/Registry data
#> /tmp/RtmpEWpp6Y/Data/Collected respondent lists
#> /tmp/RtmpEWpp6Y/Data/Respondent list for survey system
#> /tmp/RtmpEWpp6Y/Data/Downloaded response data
#> /tmp/RtmpEWpp6Y/Data/Downloaded response data/Codebook
#> /tmp/RtmpEWpp6Y/Data/Qualitative data
#> /tmp/RtmpEWpp6Y/Data/Qualitative data/Interview recordings
#> /tmp/RtmpEWpp6Y/Data/Qualitative data/Observational notes
#> /tmp/RtmpEWpp6Y/Data/Text corpus
#> /tmp/RtmpEWpp6Y/Data/PDF-reports
#> /tmp/RtmpEWpp6Y/Data/Prepared data
#> /tmp/RtmpEWpp6Y/Data/Prepared data/Codebooks
#> /tmp/RtmpEWpp6Y/Saros_SSN
#> /tmp/RtmpEWpp6Y/Saros_SSN/Scripts
#> /tmp/RtmpEWpp6Y/Saros_SSN/Resources
#> /tmp/RtmpEWpp6Y/Saros_SSN/Draft generations
#> /tmp/RtmpEWpp6Y/Saros_SSN/Draft generations/main
#> /tmp/RtmpEWpp6Y/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpEWpp6Y/Saros_SSN/Drafts in editing
#> /tmp/RtmpEWpp6Y/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpEWpp6Y/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpEWpp6Y/Saros_SSN/Completed drafts
#> /tmp/RtmpEWpp6Y/Saros_SSN/Completed drafts/main
#> /tmp/RtmpEWpp6Y/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpEWpp6Y/Publications
#> /tmp/RtmpEWpp6Y/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpEWpp6Y/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpEWpp6Y/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpEWpp6Y/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpEWpp6Y/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpEWpp6Y/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpEWpp6Y/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpEWpp6Y/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpEWpp6Y/Outreach
#> /tmp/RtmpEWpp6Y/Outreach/Research conference presentation
#> /tmp/RtmpEWpp6Y/Outreach/Research conference poster
#> /tmp/RtmpEWpp6Y/Outreach/Stakeholders and reference group
#> /tmp/RtmpEWpp6Y/Outreach/Stakeholders' communication channels
#> /tmp/RtmpEWpp6Y/Outreach/Practitioners and special interest channels
#> /tmp/RtmpEWpp6Y/Outreach/Public through mass media channels
#> /tmp/RtmpEWpp6Y/Other
```
