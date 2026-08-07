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
#> /tmp/RtmpRvDdI6/Administration
#> /tmp/RtmpRvDdI6/Administration/Application
#> /tmp/RtmpRvDdI6/Administration/Application/Call
#> /tmp/RtmpRvDdI6/Administration/Application/Formalities
#> /tmp/RtmpRvDdI6/Administration/Application/CVs
#> /tmp/RtmpRvDdI6/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpRvDdI6/Administration/Application/Application
#> /tmp/RtmpRvDdI6/Administration/Application/Pre-analysis
#> /tmp/RtmpRvDdI6/Administration/Application/For submission
#> /tmp/RtmpRvDdI6/Administration/Budget
#> /tmp/RtmpRvDdI6/Administration/Contracts and agreements
#> /tmp/RtmpRvDdI6/Administration/Invoices, accounting and receipts
#> /tmp/RtmpRvDdI6/Administration/Status reports
#> /tmp/RtmpRvDdI6/Administration/Logo and graphical materials
#> /tmp/RtmpRvDdI6/Administration/Internal meetings
#> /tmp/RtmpRvDdI6/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpRvDdI6/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpRvDdI6/Administration/Internal meetings/Minutes
#> /tmp/RtmpRvDdI6/Materials
#> /tmp/RtmpRvDdI6/Materials/Overall planning
#> /tmp/RtmpRvDdI6/Materials/Consent form
#> /tmp/RtmpRvDdI6/Materials/Ethical-GDPR approval
#> /tmp/RtmpRvDdI6/Materials/Survey questionnaires
#> /tmp/RtmpRvDdI6/Materials/Interview guides
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Staff
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Pupils
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Parents
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Researchers
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Leaders
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Teachers
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Principals
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Students
#> /tmp/RtmpRvDdI6/Materials/Interview guides/Population
#> /tmp/RtmpRvDdI6/Materials/Request of data from
#> /tmp/RtmpRvDdI6/Materials/Literature review-design
#> /tmp/RtmpRvDdI6/Materials/Intervention materials
#> /tmp/RtmpRvDdI6/Materials/Randomizing participants
#> /tmp/RtmpRvDdI6/Materials/Chapter overviews
#> /tmp/RtmpRvDdI6/Literature
#> /tmp/RtmpRvDdI6/Literature/Topic has policy relevance
#> /tmp/RtmpRvDdI6/Literature/Pure theory and framework
#> /tmp/RtmpRvDdI6/Literature/Similar empirical studies
#> /tmp/RtmpRvDdI6/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpRvDdI6/Literature/Relevant analytic methodology
#> /tmp/RtmpRvDdI6/Literature/Unprocessed (remove from here)
#> /tmp/RtmpRvDdI6/Data
#> /tmp/RtmpRvDdI6/Data/Population data
#> /tmp/RtmpRvDdI6/Data/Population data/Codebook
#> /tmp/RtmpRvDdI6/Data/Sampling frame
#> /tmp/RtmpRvDdI6/Data/Registry data
#> /tmp/RtmpRvDdI6/Data/Collected respondent lists
#> /tmp/RtmpRvDdI6/Data/Respondent list for survey system
#> /tmp/RtmpRvDdI6/Data/Downloaded response data
#> /tmp/RtmpRvDdI6/Data/Downloaded response data/Codebook
#> /tmp/RtmpRvDdI6/Data/Qualitative data
#> /tmp/RtmpRvDdI6/Data/Qualitative data/Interview recordings
#> /tmp/RtmpRvDdI6/Data/Qualitative data/Observational notes
#> /tmp/RtmpRvDdI6/Data/Text corpus
#> /tmp/RtmpRvDdI6/Data/PDF-reports
#> /tmp/RtmpRvDdI6/Data/Prepared data
#> /tmp/RtmpRvDdI6/Data/Prepared data/Codebooks
#> /tmp/RtmpRvDdI6/Saros_SSN
#> /tmp/RtmpRvDdI6/Saros_SSN/Scripts
#> /tmp/RtmpRvDdI6/Saros_SSN/Resources
#> /tmp/RtmpRvDdI6/Saros_SSN/Draft generations
#> /tmp/RtmpRvDdI6/Saros_SSN/Draft generations/main
#> /tmp/RtmpRvDdI6/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpRvDdI6/Saros_SSN/Drafts in editing
#> /tmp/RtmpRvDdI6/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpRvDdI6/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpRvDdI6/Saros_SSN/Completed drafts
#> /tmp/RtmpRvDdI6/Saros_SSN/Completed drafts/main
#> /tmp/RtmpRvDdI6/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpRvDdI6/Publications
#> /tmp/RtmpRvDdI6/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpRvDdI6/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpRvDdI6/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpRvDdI6/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpRvDdI6/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpRvDdI6/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpRvDdI6/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpRvDdI6/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpRvDdI6/Outreach
#> /tmp/RtmpRvDdI6/Outreach/Research conference presentation
#> /tmp/RtmpRvDdI6/Outreach/Research conference poster
#> /tmp/RtmpRvDdI6/Outreach/Stakeholders and reference group
#> /tmp/RtmpRvDdI6/Outreach/Stakeholders' communication channels
#> /tmp/RtmpRvDdI6/Outreach/Practitioners and special interest channels
#> /tmp/RtmpRvDdI6/Outreach/Public through mass media channels
#> /tmp/RtmpRvDdI6/Other
```
