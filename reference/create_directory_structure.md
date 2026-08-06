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
#> /tmp/RtmpcBUqkD/Administration
#> /tmp/RtmpcBUqkD/Administration/Application
#> /tmp/RtmpcBUqkD/Administration/Application/Call
#> /tmp/RtmpcBUqkD/Administration/Application/Formalities
#> /tmp/RtmpcBUqkD/Administration/Application/CVs
#> /tmp/RtmpcBUqkD/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpcBUqkD/Administration/Application/Application
#> /tmp/RtmpcBUqkD/Administration/Application/Pre-analysis
#> /tmp/RtmpcBUqkD/Administration/Application/For submission
#> /tmp/RtmpcBUqkD/Administration/Budget
#> /tmp/RtmpcBUqkD/Administration/Contracts and agreements
#> /tmp/RtmpcBUqkD/Administration/Invoices, accounting and receipts
#> /tmp/RtmpcBUqkD/Administration/Status reports
#> /tmp/RtmpcBUqkD/Administration/Logo and graphical materials
#> /tmp/RtmpcBUqkD/Administration/Internal meetings
#> /tmp/RtmpcBUqkD/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpcBUqkD/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpcBUqkD/Administration/Internal meetings/Minutes
#> /tmp/RtmpcBUqkD/Materials
#> /tmp/RtmpcBUqkD/Materials/Overall planning
#> /tmp/RtmpcBUqkD/Materials/Consent form
#> /tmp/RtmpcBUqkD/Materials/Ethical-GDPR approval
#> /tmp/RtmpcBUqkD/Materials/Survey questionnaires
#> /tmp/RtmpcBUqkD/Materials/Interview guides
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Staff
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Pupils
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Parents
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Researchers
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Leaders
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Teachers
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Principals
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Students
#> /tmp/RtmpcBUqkD/Materials/Interview guides/Population
#> /tmp/RtmpcBUqkD/Materials/Request of data from
#> /tmp/RtmpcBUqkD/Materials/Literature review-design
#> /tmp/RtmpcBUqkD/Materials/Intervention materials
#> /tmp/RtmpcBUqkD/Materials/Randomizing participants
#> /tmp/RtmpcBUqkD/Materials/Chapter overviews
#> /tmp/RtmpcBUqkD/Literature
#> /tmp/RtmpcBUqkD/Literature/Topic has policy relevance
#> /tmp/RtmpcBUqkD/Literature/Pure theory and framework
#> /tmp/RtmpcBUqkD/Literature/Similar empirical studies
#> /tmp/RtmpcBUqkD/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpcBUqkD/Literature/Relevant analytic methodology
#> /tmp/RtmpcBUqkD/Literature/Unprocessed (remove from here)
#> /tmp/RtmpcBUqkD/Data
#> /tmp/RtmpcBUqkD/Data/Population data
#> /tmp/RtmpcBUqkD/Data/Population data/Codebook
#> /tmp/RtmpcBUqkD/Data/Sampling frame
#> /tmp/RtmpcBUqkD/Data/Registry data
#> /tmp/RtmpcBUqkD/Data/Collected respondent lists
#> /tmp/RtmpcBUqkD/Data/Respondent list for survey system
#> /tmp/RtmpcBUqkD/Data/Downloaded response data
#> /tmp/RtmpcBUqkD/Data/Downloaded response data/Codebook
#> /tmp/RtmpcBUqkD/Data/Qualitative data
#> /tmp/RtmpcBUqkD/Data/Qualitative data/Interview recordings
#> /tmp/RtmpcBUqkD/Data/Qualitative data/Observational notes
#> /tmp/RtmpcBUqkD/Data/Text corpus
#> /tmp/RtmpcBUqkD/Data/PDF-reports
#> /tmp/RtmpcBUqkD/Data/Prepared data
#> /tmp/RtmpcBUqkD/Data/Prepared data/Codebooks
#> /tmp/RtmpcBUqkD/Saros_SSN
#> /tmp/RtmpcBUqkD/Saros_SSN/Scripts
#> /tmp/RtmpcBUqkD/Saros_SSN/Resources
#> /tmp/RtmpcBUqkD/Saros_SSN/Draft generations
#> /tmp/RtmpcBUqkD/Saros_SSN/Draft generations/main
#> /tmp/RtmpcBUqkD/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpcBUqkD/Saros_SSN/Drafts in editing
#> /tmp/RtmpcBUqkD/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpcBUqkD/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpcBUqkD/Saros_SSN/Completed drafts
#> /tmp/RtmpcBUqkD/Saros_SSN/Completed drafts/main
#> /tmp/RtmpcBUqkD/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpcBUqkD/Publications
#> /tmp/RtmpcBUqkD/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpcBUqkD/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpcBUqkD/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpcBUqkD/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpcBUqkD/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpcBUqkD/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpcBUqkD/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpcBUqkD/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpcBUqkD/Outreach
#> /tmp/RtmpcBUqkD/Outreach/Research conference presentation
#> /tmp/RtmpcBUqkD/Outreach/Research conference poster
#> /tmp/RtmpcBUqkD/Outreach/Stakeholders and reference group
#> /tmp/RtmpcBUqkD/Outreach/Stakeholders' communication channels
#> /tmp/RtmpcBUqkD/Outreach/Practitioners and special interest channels
#> /tmp/RtmpcBUqkD/Outreach/Public through mass media channels
#> /tmp/RtmpcBUqkD/Other
```
