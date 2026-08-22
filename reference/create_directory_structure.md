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
#> /tmp/Rtmprow2hC/Administration
#> /tmp/Rtmprow2hC/Administration/Application
#> /tmp/Rtmprow2hC/Administration/Application/Call
#> /tmp/Rtmprow2hC/Administration/Application/Formalities
#> /tmp/Rtmprow2hC/Administration/Application/CVs
#> /tmp/Rtmprow2hC/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/Rtmprow2hC/Administration/Application/Application
#> /tmp/Rtmprow2hC/Administration/Application/Pre-analysis
#> /tmp/Rtmprow2hC/Administration/Application/For submission
#> /tmp/Rtmprow2hC/Administration/Budget
#> /tmp/Rtmprow2hC/Administration/Contracts and agreements
#> /tmp/Rtmprow2hC/Administration/Invoices, accounting and receipts
#> /tmp/Rtmprow2hC/Administration/Status reports
#> /tmp/Rtmprow2hC/Administration/Logo and graphical materials
#> /tmp/Rtmprow2hC/Administration/Internal meetings
#> /tmp/Rtmprow2hC/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/Rtmprow2hC/Administration/Internal meetings/Internal presentations
#> /tmp/Rtmprow2hC/Administration/Internal meetings/Minutes
#> /tmp/Rtmprow2hC/Materials
#> /tmp/Rtmprow2hC/Materials/Overall planning
#> /tmp/Rtmprow2hC/Materials/Consent form
#> /tmp/Rtmprow2hC/Materials/Ethical-GDPR approval
#> /tmp/Rtmprow2hC/Materials/Survey questionnaires
#> /tmp/Rtmprow2hC/Materials/Interview guides
#> /tmp/Rtmprow2hC/Materials/Interview guides/Staff
#> /tmp/Rtmprow2hC/Materials/Interview guides/Pupils
#> /tmp/Rtmprow2hC/Materials/Interview guides/Parents
#> /tmp/Rtmprow2hC/Materials/Interview guides/Researchers
#> /tmp/Rtmprow2hC/Materials/Interview guides/Leaders
#> /tmp/Rtmprow2hC/Materials/Interview guides/Teachers
#> /tmp/Rtmprow2hC/Materials/Interview guides/Principals
#> /tmp/Rtmprow2hC/Materials/Interview guides/Students
#> /tmp/Rtmprow2hC/Materials/Interview guides/Population
#> /tmp/Rtmprow2hC/Materials/Request of data from
#> /tmp/Rtmprow2hC/Materials/Literature review-design
#> /tmp/Rtmprow2hC/Materials/Intervention materials
#> /tmp/Rtmprow2hC/Materials/Randomizing participants
#> /tmp/Rtmprow2hC/Materials/Chapter overviews
#> /tmp/Rtmprow2hC/Literature
#> /tmp/Rtmprow2hC/Literature/Topic has policy relevance
#> /tmp/Rtmprow2hC/Literature/Pure theory and framework
#> /tmp/Rtmprow2hC/Literature/Similar empirical studies
#> /tmp/Rtmprow2hC/Literature/Similar instruments and guides for data collection
#> /tmp/Rtmprow2hC/Literature/Relevant analytic methodology
#> /tmp/Rtmprow2hC/Literature/Unprocessed (remove from here)
#> /tmp/Rtmprow2hC/Data
#> /tmp/Rtmprow2hC/Data/Population data
#> /tmp/Rtmprow2hC/Data/Population data/Codebook
#> /tmp/Rtmprow2hC/Data/Sampling frame
#> /tmp/Rtmprow2hC/Data/Registry data
#> /tmp/Rtmprow2hC/Data/Collected respondent lists
#> /tmp/Rtmprow2hC/Data/Respondent list for survey system
#> /tmp/Rtmprow2hC/Data/Downloaded response data
#> /tmp/Rtmprow2hC/Data/Downloaded response data/Codebook
#> /tmp/Rtmprow2hC/Data/Qualitative data
#> /tmp/Rtmprow2hC/Data/Qualitative data/Interview recordings
#> /tmp/Rtmprow2hC/Data/Qualitative data/Observational notes
#> /tmp/Rtmprow2hC/Data/Text corpus
#> /tmp/Rtmprow2hC/Data/PDF-reports
#> /tmp/Rtmprow2hC/Data/Prepared data
#> /tmp/Rtmprow2hC/Data/Prepared data/Codebooks
#> /tmp/Rtmprow2hC/Saros_SSN
#> /tmp/Rtmprow2hC/Saros_SSN/Scripts
#> /tmp/Rtmprow2hC/Saros_SSN/Resources
#> /tmp/Rtmprow2hC/Saros_SSN/Draft generations
#> /tmp/Rtmprow2hC/Saros_SSN/Draft generations/main
#> /tmp/Rtmprow2hC/Saros_SSN/Draft generations/Reports
#> /tmp/Rtmprow2hC/Saros_SSN/Drafts in editing
#> /tmp/Rtmprow2hC/Saros_SSN/Drafts in editing/main
#> /tmp/Rtmprow2hC/Saros_SSN/Drafts in editing/Reports
#> /tmp/Rtmprow2hC/Saros_SSN/Completed drafts
#> /tmp/Rtmprow2hC/Saros_SSN/Completed drafts/main
#> /tmp/Rtmprow2hC/Saros_SSN/Completed drafts/Reports
#> /tmp/Rtmprow2hC/Publications
#> /tmp/Rtmprow2hC/Publications/Paper1-Short title (author initials)
#> /tmp/Rtmprow2hC/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/Rtmprow2hC/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/Rtmprow2hC/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/Rtmprow2hC/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/Rtmprow2hC/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/Rtmprow2hC/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/Rtmprow2hC/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/Rtmprow2hC/Outreach
#> /tmp/Rtmprow2hC/Outreach/Research conference presentation
#> /tmp/Rtmprow2hC/Outreach/Research conference poster
#> /tmp/Rtmprow2hC/Outreach/Stakeholders and reference group
#> /tmp/Rtmprow2hC/Outreach/Stakeholders' communication channels
#> /tmp/Rtmprow2hC/Outreach/Practitioners and special interest channels
#> /tmp/Rtmprow2hC/Outreach/Public through mass media channels
#> /tmp/Rtmprow2hC/Other
```
