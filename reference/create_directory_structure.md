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
#> /tmp/RtmpZkohGj/Administration
#> /tmp/RtmpZkohGj/Administration/Application
#> /tmp/RtmpZkohGj/Administration/Application/Call
#> /tmp/RtmpZkohGj/Administration/Application/Formalities
#> /tmp/RtmpZkohGj/Administration/Application/CVs
#> /tmp/RtmpZkohGj/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpZkohGj/Administration/Application/Application
#> /tmp/RtmpZkohGj/Administration/Application/Pre-analysis
#> /tmp/RtmpZkohGj/Administration/Application/For submission
#> /tmp/RtmpZkohGj/Administration/Budget
#> /tmp/RtmpZkohGj/Administration/Contracts and agreements
#> /tmp/RtmpZkohGj/Administration/Invoices, accounting and receipts
#> /tmp/RtmpZkohGj/Administration/Status reports
#> /tmp/RtmpZkohGj/Administration/Logo and graphical materials
#> /tmp/RtmpZkohGj/Administration/Internal meetings
#> /tmp/RtmpZkohGj/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpZkohGj/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpZkohGj/Administration/Internal meetings/Minutes
#> /tmp/RtmpZkohGj/Materials
#> /tmp/RtmpZkohGj/Materials/Overall planning
#> /tmp/RtmpZkohGj/Materials/Consent form
#> /tmp/RtmpZkohGj/Materials/Ethical-GDPR approval
#> /tmp/RtmpZkohGj/Materials/Survey questionnaires
#> /tmp/RtmpZkohGj/Materials/Interview guides
#> /tmp/RtmpZkohGj/Materials/Interview guides/Staff
#> /tmp/RtmpZkohGj/Materials/Interview guides/Pupils
#> /tmp/RtmpZkohGj/Materials/Interview guides/Parents
#> /tmp/RtmpZkohGj/Materials/Interview guides/Researchers
#> /tmp/RtmpZkohGj/Materials/Interview guides/Leaders
#> /tmp/RtmpZkohGj/Materials/Interview guides/Teachers
#> /tmp/RtmpZkohGj/Materials/Interview guides/Principals
#> /tmp/RtmpZkohGj/Materials/Interview guides/Students
#> /tmp/RtmpZkohGj/Materials/Interview guides/Population
#> /tmp/RtmpZkohGj/Materials/Request of data from
#> /tmp/RtmpZkohGj/Materials/Literature review-design
#> /tmp/RtmpZkohGj/Materials/Intervention materials
#> /tmp/RtmpZkohGj/Materials/Randomizing participants
#> /tmp/RtmpZkohGj/Materials/Chapter overviews
#> /tmp/RtmpZkohGj/Literature
#> /tmp/RtmpZkohGj/Literature/Topic has policy relevance
#> /tmp/RtmpZkohGj/Literature/Pure theory and framework
#> /tmp/RtmpZkohGj/Literature/Similar empirical studies
#> /tmp/RtmpZkohGj/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpZkohGj/Literature/Relevant analytic methodology
#> /tmp/RtmpZkohGj/Literature/Unprocessed (remove from here)
#> /tmp/RtmpZkohGj/Data
#> /tmp/RtmpZkohGj/Data/Population data
#> /tmp/RtmpZkohGj/Data/Population data/Codebook
#> /tmp/RtmpZkohGj/Data/Sampling frame
#> /tmp/RtmpZkohGj/Data/Registry data
#> /tmp/RtmpZkohGj/Data/Collected respondent lists
#> /tmp/RtmpZkohGj/Data/Respondent list for survey system
#> /tmp/RtmpZkohGj/Data/Downloaded response data
#> /tmp/RtmpZkohGj/Data/Downloaded response data/Codebook
#> /tmp/RtmpZkohGj/Data/Qualitative data
#> /tmp/RtmpZkohGj/Data/Qualitative data/Interview recordings
#> /tmp/RtmpZkohGj/Data/Qualitative data/Observational notes
#> /tmp/RtmpZkohGj/Data/Text corpus
#> /tmp/RtmpZkohGj/Data/PDF-reports
#> /tmp/RtmpZkohGj/Data/Prepared data
#> /tmp/RtmpZkohGj/Data/Prepared data/Codebooks
#> /tmp/RtmpZkohGj/Saros_SSN
#> /tmp/RtmpZkohGj/Saros_SSN/Scripts
#> /tmp/RtmpZkohGj/Saros_SSN/Resources
#> /tmp/RtmpZkohGj/Saros_SSN/Draft generations
#> /tmp/RtmpZkohGj/Saros_SSN/Draft generations/main
#> /tmp/RtmpZkohGj/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpZkohGj/Saros_SSN/Drafts in editing
#> /tmp/RtmpZkohGj/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpZkohGj/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpZkohGj/Saros_SSN/Completed drafts
#> /tmp/RtmpZkohGj/Saros_SSN/Completed drafts/main
#> /tmp/RtmpZkohGj/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpZkohGj/Publications
#> /tmp/RtmpZkohGj/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpZkohGj/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpZkohGj/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpZkohGj/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpZkohGj/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpZkohGj/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpZkohGj/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpZkohGj/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpZkohGj/Outreach
#> /tmp/RtmpZkohGj/Outreach/Research conference presentation
#> /tmp/RtmpZkohGj/Outreach/Research conference poster
#> /tmp/RtmpZkohGj/Outreach/Stakeholders and reference group
#> /tmp/RtmpZkohGj/Outreach/Stakeholders' communication channels
#> /tmp/RtmpZkohGj/Outreach/Practitioners and special interest channels
#> /tmp/RtmpZkohGj/Outreach/Public through mass media channels
#> /tmp/RtmpZkohGj/Other
```
