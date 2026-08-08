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
#> /tmp/Rtmp7DSbDK/Administration
#> /tmp/Rtmp7DSbDK/Administration/Application
#> /tmp/Rtmp7DSbDK/Administration/Application/Call
#> /tmp/Rtmp7DSbDK/Administration/Application/Formalities
#> /tmp/Rtmp7DSbDK/Administration/Application/CVs
#> /tmp/Rtmp7DSbDK/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/Rtmp7DSbDK/Administration/Application/Application
#> /tmp/Rtmp7DSbDK/Administration/Application/Pre-analysis
#> /tmp/Rtmp7DSbDK/Administration/Application/For submission
#> /tmp/Rtmp7DSbDK/Administration/Budget
#> /tmp/Rtmp7DSbDK/Administration/Contracts and agreements
#> /tmp/Rtmp7DSbDK/Administration/Invoices, accounting and receipts
#> /tmp/Rtmp7DSbDK/Administration/Status reports
#> /tmp/Rtmp7DSbDK/Administration/Logo and graphical materials
#> /tmp/Rtmp7DSbDK/Administration/Internal meetings
#> /tmp/Rtmp7DSbDK/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/Rtmp7DSbDK/Administration/Internal meetings/Internal presentations
#> /tmp/Rtmp7DSbDK/Administration/Internal meetings/Minutes
#> /tmp/Rtmp7DSbDK/Materials
#> /tmp/Rtmp7DSbDK/Materials/Overall planning
#> /tmp/Rtmp7DSbDK/Materials/Consent form
#> /tmp/Rtmp7DSbDK/Materials/Ethical-GDPR approval
#> /tmp/Rtmp7DSbDK/Materials/Survey questionnaires
#> /tmp/Rtmp7DSbDK/Materials/Interview guides
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Staff
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Pupils
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Parents
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Researchers
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Leaders
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Teachers
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Principals
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Students
#> /tmp/Rtmp7DSbDK/Materials/Interview guides/Population
#> /tmp/Rtmp7DSbDK/Materials/Request of data from
#> /tmp/Rtmp7DSbDK/Materials/Literature review-design
#> /tmp/Rtmp7DSbDK/Materials/Intervention materials
#> /tmp/Rtmp7DSbDK/Materials/Randomizing participants
#> /tmp/Rtmp7DSbDK/Materials/Chapter overviews
#> /tmp/Rtmp7DSbDK/Literature
#> /tmp/Rtmp7DSbDK/Literature/Topic has policy relevance
#> /tmp/Rtmp7DSbDK/Literature/Pure theory and framework
#> /tmp/Rtmp7DSbDK/Literature/Similar empirical studies
#> /tmp/Rtmp7DSbDK/Literature/Similar instruments and guides for data collection
#> /tmp/Rtmp7DSbDK/Literature/Relevant analytic methodology
#> /tmp/Rtmp7DSbDK/Literature/Unprocessed (remove from here)
#> /tmp/Rtmp7DSbDK/Data
#> /tmp/Rtmp7DSbDK/Data/Population data
#> /tmp/Rtmp7DSbDK/Data/Population data/Codebook
#> /tmp/Rtmp7DSbDK/Data/Sampling frame
#> /tmp/Rtmp7DSbDK/Data/Registry data
#> /tmp/Rtmp7DSbDK/Data/Collected respondent lists
#> /tmp/Rtmp7DSbDK/Data/Respondent list for survey system
#> /tmp/Rtmp7DSbDK/Data/Downloaded response data
#> /tmp/Rtmp7DSbDK/Data/Downloaded response data/Codebook
#> /tmp/Rtmp7DSbDK/Data/Qualitative data
#> /tmp/Rtmp7DSbDK/Data/Qualitative data/Interview recordings
#> /tmp/Rtmp7DSbDK/Data/Qualitative data/Observational notes
#> /tmp/Rtmp7DSbDK/Data/Text corpus
#> /tmp/Rtmp7DSbDK/Data/PDF-reports
#> /tmp/Rtmp7DSbDK/Data/Prepared data
#> /tmp/Rtmp7DSbDK/Data/Prepared data/Codebooks
#> /tmp/Rtmp7DSbDK/Saros_SSN
#> /tmp/Rtmp7DSbDK/Saros_SSN/Scripts
#> /tmp/Rtmp7DSbDK/Saros_SSN/Resources
#> /tmp/Rtmp7DSbDK/Saros_SSN/Draft generations
#> /tmp/Rtmp7DSbDK/Saros_SSN/Draft generations/main
#> /tmp/Rtmp7DSbDK/Saros_SSN/Draft generations/Reports
#> /tmp/Rtmp7DSbDK/Saros_SSN/Drafts in editing
#> /tmp/Rtmp7DSbDK/Saros_SSN/Drafts in editing/main
#> /tmp/Rtmp7DSbDK/Saros_SSN/Drafts in editing/Reports
#> /tmp/Rtmp7DSbDK/Saros_SSN/Completed drafts
#> /tmp/Rtmp7DSbDK/Saros_SSN/Completed drafts/main
#> /tmp/Rtmp7DSbDK/Saros_SSN/Completed drafts/Reports
#> /tmp/Rtmp7DSbDK/Publications
#> /tmp/Rtmp7DSbDK/Publications/Paper1-Short title (author initials)
#> /tmp/Rtmp7DSbDK/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/Rtmp7DSbDK/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/Rtmp7DSbDK/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/Rtmp7DSbDK/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/Rtmp7DSbDK/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/Rtmp7DSbDK/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/Rtmp7DSbDK/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/Rtmp7DSbDK/Outreach
#> /tmp/Rtmp7DSbDK/Outreach/Research conference presentation
#> /tmp/Rtmp7DSbDK/Outreach/Research conference poster
#> /tmp/Rtmp7DSbDK/Outreach/Stakeholders and reference group
#> /tmp/Rtmp7DSbDK/Outreach/Stakeholders' communication channels
#> /tmp/Rtmp7DSbDK/Outreach/Practitioners and special interest channels
#> /tmp/Rtmp7DSbDK/Outreach/Public through mass media channels
#> /tmp/Rtmp7DSbDK/Other
```
