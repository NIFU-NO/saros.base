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
#> /tmp/RtmpKNAHBN/Administration
#> /tmp/RtmpKNAHBN/Administration/Application
#> /tmp/RtmpKNAHBN/Administration/Application/Call
#> /tmp/RtmpKNAHBN/Administration/Application/Formalities
#> /tmp/RtmpKNAHBN/Administration/Application/CVs
#> /tmp/RtmpKNAHBN/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpKNAHBN/Administration/Application/Application
#> /tmp/RtmpKNAHBN/Administration/Application/Pre-analysis
#> /tmp/RtmpKNAHBN/Administration/Application/For submission
#> /tmp/RtmpKNAHBN/Administration/Budget
#> /tmp/RtmpKNAHBN/Administration/Contracts and agreements
#> /tmp/RtmpKNAHBN/Administration/Invoices, accounting and receipts
#> /tmp/RtmpKNAHBN/Administration/Status reports
#> /tmp/RtmpKNAHBN/Administration/Logo and graphical materials
#> /tmp/RtmpKNAHBN/Administration/Internal meetings
#> /tmp/RtmpKNAHBN/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpKNAHBN/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpKNAHBN/Administration/Internal meetings/Minutes
#> /tmp/RtmpKNAHBN/Materials
#> /tmp/RtmpKNAHBN/Materials/Overall planning
#> /tmp/RtmpKNAHBN/Materials/Consent form
#> /tmp/RtmpKNAHBN/Materials/Ethical-GDPR approval
#> /tmp/RtmpKNAHBN/Materials/Survey questionnaires
#> /tmp/RtmpKNAHBN/Materials/Interview guides
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Staff
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Pupils
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Parents
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Researchers
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Leaders
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Teachers
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Principals
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Students
#> /tmp/RtmpKNAHBN/Materials/Interview guides/Population
#> /tmp/RtmpKNAHBN/Materials/Request of data from
#> /tmp/RtmpKNAHBN/Materials/Literature review-design
#> /tmp/RtmpKNAHBN/Materials/Intervention materials
#> /tmp/RtmpKNAHBN/Materials/Randomizing participants
#> /tmp/RtmpKNAHBN/Materials/Chapter overviews
#> /tmp/RtmpKNAHBN/Literature
#> /tmp/RtmpKNAHBN/Literature/Topic has policy relevance
#> /tmp/RtmpKNAHBN/Literature/Pure theory and framework
#> /tmp/RtmpKNAHBN/Literature/Similar empirical studies
#> /tmp/RtmpKNAHBN/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpKNAHBN/Literature/Relevant analytic methodology
#> /tmp/RtmpKNAHBN/Literature/Unprocessed (remove from here)
#> /tmp/RtmpKNAHBN/Data
#> /tmp/RtmpKNAHBN/Data/Population data
#> /tmp/RtmpKNAHBN/Data/Population data/Codebook
#> /tmp/RtmpKNAHBN/Data/Sampling frame
#> /tmp/RtmpKNAHBN/Data/Registry data
#> /tmp/RtmpKNAHBN/Data/Collected respondent lists
#> /tmp/RtmpKNAHBN/Data/Respondent list for survey system
#> /tmp/RtmpKNAHBN/Data/Downloaded response data
#> /tmp/RtmpKNAHBN/Data/Downloaded response data/Codebook
#> /tmp/RtmpKNAHBN/Data/Qualitative data
#> /tmp/RtmpKNAHBN/Data/Qualitative data/Interview recordings
#> /tmp/RtmpKNAHBN/Data/Qualitative data/Observational notes
#> /tmp/RtmpKNAHBN/Data/Text corpus
#> /tmp/RtmpKNAHBN/Data/PDF-reports
#> /tmp/RtmpKNAHBN/Data/Prepared data
#> /tmp/RtmpKNAHBN/Data/Prepared data/Codebooks
#> /tmp/RtmpKNAHBN/Saros_SSN
#> /tmp/RtmpKNAHBN/Saros_SSN/Scripts
#> /tmp/RtmpKNAHBN/Saros_SSN/Resources
#> /tmp/RtmpKNAHBN/Saros_SSN/Draft generations
#> /tmp/RtmpKNAHBN/Saros_SSN/Draft generations/main
#> /tmp/RtmpKNAHBN/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpKNAHBN/Saros_SSN/Drafts in editing
#> /tmp/RtmpKNAHBN/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpKNAHBN/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpKNAHBN/Saros_SSN/Completed drafts
#> /tmp/RtmpKNAHBN/Saros_SSN/Completed drafts/main
#> /tmp/RtmpKNAHBN/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpKNAHBN/Publications
#> /tmp/RtmpKNAHBN/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpKNAHBN/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpKNAHBN/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpKNAHBN/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpKNAHBN/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpKNAHBN/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpKNAHBN/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpKNAHBN/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpKNAHBN/Outreach
#> /tmp/RtmpKNAHBN/Outreach/Research conference presentation
#> /tmp/RtmpKNAHBN/Outreach/Research conference poster
#> /tmp/RtmpKNAHBN/Outreach/Stakeholders and reference group
#> /tmp/RtmpKNAHBN/Outreach/Stakeholders' communication channels
#> /tmp/RtmpKNAHBN/Outreach/Practitioners and special interest channels
#> /tmp/RtmpKNAHBN/Outreach/Public through mass media channels
#> /tmp/RtmpKNAHBN/Other
```
