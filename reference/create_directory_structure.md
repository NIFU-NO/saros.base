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
#> /tmp/RtmpnCjZ8Q/Administration
#> /tmp/RtmpnCjZ8Q/Administration/Application
#> /tmp/RtmpnCjZ8Q/Administration/Application/Call
#> /tmp/RtmpnCjZ8Q/Administration/Application/Formalities
#> /tmp/RtmpnCjZ8Q/Administration/Application/CVs
#> /tmp/RtmpnCjZ8Q/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpnCjZ8Q/Administration/Application/Application
#> /tmp/RtmpnCjZ8Q/Administration/Application/Pre-analysis
#> /tmp/RtmpnCjZ8Q/Administration/Application/For submission
#> /tmp/RtmpnCjZ8Q/Administration/Budget
#> /tmp/RtmpnCjZ8Q/Administration/Contracts and agreements
#> /tmp/RtmpnCjZ8Q/Administration/Invoices, accounting and receipts
#> /tmp/RtmpnCjZ8Q/Administration/Status reports
#> /tmp/RtmpnCjZ8Q/Administration/Logo and graphical materials
#> /tmp/RtmpnCjZ8Q/Administration/Internal meetings
#> /tmp/RtmpnCjZ8Q/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpnCjZ8Q/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpnCjZ8Q/Administration/Internal meetings/Minutes
#> /tmp/RtmpnCjZ8Q/Materials
#> /tmp/RtmpnCjZ8Q/Materials/Overall planning
#> /tmp/RtmpnCjZ8Q/Materials/Consent form
#> /tmp/RtmpnCjZ8Q/Materials/Ethical-GDPR approval
#> /tmp/RtmpnCjZ8Q/Materials/Survey questionnaires
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Staff
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Pupils
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Parents
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Researchers
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Leaders
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Teachers
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Principals
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Students
#> /tmp/RtmpnCjZ8Q/Materials/Interview guides/Population
#> /tmp/RtmpnCjZ8Q/Materials/Request of data from
#> /tmp/RtmpnCjZ8Q/Materials/Literature review-design
#> /tmp/RtmpnCjZ8Q/Materials/Intervention materials
#> /tmp/RtmpnCjZ8Q/Materials/Randomizing participants
#> /tmp/RtmpnCjZ8Q/Materials/Chapter overviews
#> /tmp/RtmpnCjZ8Q/Literature
#> /tmp/RtmpnCjZ8Q/Literature/Topic has policy relevance
#> /tmp/RtmpnCjZ8Q/Literature/Pure theory and framework
#> /tmp/RtmpnCjZ8Q/Literature/Similar empirical studies
#> /tmp/RtmpnCjZ8Q/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpnCjZ8Q/Literature/Relevant analytic methodology
#> /tmp/RtmpnCjZ8Q/Literature/Unprocessed (remove from here)
#> /tmp/RtmpnCjZ8Q/Data
#> /tmp/RtmpnCjZ8Q/Data/Population data
#> /tmp/RtmpnCjZ8Q/Data/Population data/Codebook
#> /tmp/RtmpnCjZ8Q/Data/Sampling frame
#> /tmp/RtmpnCjZ8Q/Data/Registry data
#> /tmp/RtmpnCjZ8Q/Data/Collected respondent lists
#> /tmp/RtmpnCjZ8Q/Data/Respondent list for survey system
#> /tmp/RtmpnCjZ8Q/Data/Downloaded response data
#> /tmp/RtmpnCjZ8Q/Data/Downloaded response data/Codebook
#> /tmp/RtmpnCjZ8Q/Data/Qualitative data
#> /tmp/RtmpnCjZ8Q/Data/Qualitative data/Interview recordings
#> /tmp/RtmpnCjZ8Q/Data/Qualitative data/Observational notes
#> /tmp/RtmpnCjZ8Q/Data/Text corpus
#> /tmp/RtmpnCjZ8Q/Data/PDF-reports
#> /tmp/RtmpnCjZ8Q/Data/Prepared data
#> /tmp/RtmpnCjZ8Q/Data/Prepared data/Codebooks
#> /tmp/RtmpnCjZ8Q/Saros_SSN
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Scripts
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Resources
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Draft generations
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Draft generations/main
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Drafts in editing
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Completed drafts
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Completed drafts/main
#> /tmp/RtmpnCjZ8Q/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpnCjZ8Q/Publications
#> /tmp/RtmpnCjZ8Q/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpnCjZ8Q/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpnCjZ8Q/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpnCjZ8Q/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpnCjZ8Q/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpnCjZ8Q/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpnCjZ8Q/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpnCjZ8Q/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpnCjZ8Q/Outreach
#> /tmp/RtmpnCjZ8Q/Outreach/Research conference presentation
#> /tmp/RtmpnCjZ8Q/Outreach/Research conference poster
#> /tmp/RtmpnCjZ8Q/Outreach/Stakeholders and reference group
#> /tmp/RtmpnCjZ8Q/Outreach/Stakeholders' communication channels
#> /tmp/RtmpnCjZ8Q/Outreach/Practitioners and special interest channels
#> /tmp/RtmpnCjZ8Q/Outreach/Public through mass media channels
#> /tmp/RtmpnCjZ8Q/Other
```
