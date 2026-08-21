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
#> /tmp/RtmpBbbOvF/Administration
#> /tmp/RtmpBbbOvF/Administration/Application
#> /tmp/RtmpBbbOvF/Administration/Application/Call
#> /tmp/RtmpBbbOvF/Administration/Application/Formalities
#> /tmp/RtmpBbbOvF/Administration/Application/CVs
#> /tmp/RtmpBbbOvF/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpBbbOvF/Administration/Application/Application
#> /tmp/RtmpBbbOvF/Administration/Application/Pre-analysis
#> /tmp/RtmpBbbOvF/Administration/Application/For submission
#> /tmp/RtmpBbbOvF/Administration/Budget
#> /tmp/RtmpBbbOvF/Administration/Contracts and agreements
#> /tmp/RtmpBbbOvF/Administration/Invoices, accounting and receipts
#> /tmp/RtmpBbbOvF/Administration/Status reports
#> /tmp/RtmpBbbOvF/Administration/Logo and graphical materials
#> /tmp/RtmpBbbOvF/Administration/Internal meetings
#> /tmp/RtmpBbbOvF/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpBbbOvF/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpBbbOvF/Administration/Internal meetings/Minutes
#> /tmp/RtmpBbbOvF/Materials
#> /tmp/RtmpBbbOvF/Materials/Overall planning
#> /tmp/RtmpBbbOvF/Materials/Consent form
#> /tmp/RtmpBbbOvF/Materials/Ethical-GDPR approval
#> /tmp/RtmpBbbOvF/Materials/Survey questionnaires
#> /tmp/RtmpBbbOvF/Materials/Interview guides
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Staff
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Pupils
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Parents
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Researchers
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Leaders
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Teachers
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Principals
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Students
#> /tmp/RtmpBbbOvF/Materials/Interview guides/Population
#> /tmp/RtmpBbbOvF/Materials/Request of data from
#> /tmp/RtmpBbbOvF/Materials/Literature review-design
#> /tmp/RtmpBbbOvF/Materials/Intervention materials
#> /tmp/RtmpBbbOvF/Materials/Randomizing participants
#> /tmp/RtmpBbbOvF/Materials/Chapter overviews
#> /tmp/RtmpBbbOvF/Literature
#> /tmp/RtmpBbbOvF/Literature/Topic has policy relevance
#> /tmp/RtmpBbbOvF/Literature/Pure theory and framework
#> /tmp/RtmpBbbOvF/Literature/Similar empirical studies
#> /tmp/RtmpBbbOvF/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpBbbOvF/Literature/Relevant analytic methodology
#> /tmp/RtmpBbbOvF/Literature/Unprocessed (remove from here)
#> /tmp/RtmpBbbOvF/Data
#> /tmp/RtmpBbbOvF/Data/Population data
#> /tmp/RtmpBbbOvF/Data/Population data/Codebook
#> /tmp/RtmpBbbOvF/Data/Sampling frame
#> /tmp/RtmpBbbOvF/Data/Registry data
#> /tmp/RtmpBbbOvF/Data/Collected respondent lists
#> /tmp/RtmpBbbOvF/Data/Respondent list for survey system
#> /tmp/RtmpBbbOvF/Data/Downloaded response data
#> /tmp/RtmpBbbOvF/Data/Downloaded response data/Codebook
#> /tmp/RtmpBbbOvF/Data/Qualitative data
#> /tmp/RtmpBbbOvF/Data/Qualitative data/Interview recordings
#> /tmp/RtmpBbbOvF/Data/Qualitative data/Observational notes
#> /tmp/RtmpBbbOvF/Data/Text corpus
#> /tmp/RtmpBbbOvF/Data/PDF-reports
#> /tmp/RtmpBbbOvF/Data/Prepared data
#> /tmp/RtmpBbbOvF/Data/Prepared data/Codebooks
#> /tmp/RtmpBbbOvF/Saros_SSN
#> /tmp/RtmpBbbOvF/Saros_SSN/Scripts
#> /tmp/RtmpBbbOvF/Saros_SSN/Resources
#> /tmp/RtmpBbbOvF/Saros_SSN/Draft generations
#> /tmp/RtmpBbbOvF/Saros_SSN/Draft generations/main
#> /tmp/RtmpBbbOvF/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpBbbOvF/Saros_SSN/Drafts in editing
#> /tmp/RtmpBbbOvF/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpBbbOvF/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpBbbOvF/Saros_SSN/Completed drafts
#> /tmp/RtmpBbbOvF/Saros_SSN/Completed drafts/main
#> /tmp/RtmpBbbOvF/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpBbbOvF/Publications
#> /tmp/RtmpBbbOvF/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpBbbOvF/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpBbbOvF/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpBbbOvF/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpBbbOvF/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpBbbOvF/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpBbbOvF/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpBbbOvF/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpBbbOvF/Outreach
#> /tmp/RtmpBbbOvF/Outreach/Research conference presentation
#> /tmp/RtmpBbbOvF/Outreach/Research conference poster
#> /tmp/RtmpBbbOvF/Outreach/Stakeholders and reference group
#> /tmp/RtmpBbbOvF/Outreach/Stakeholders' communication channels
#> /tmp/RtmpBbbOvF/Outreach/Practitioners and special interest channels
#> /tmp/RtmpBbbOvF/Outreach/Public through mass media channels
#> /tmp/RtmpBbbOvF/Other
```
