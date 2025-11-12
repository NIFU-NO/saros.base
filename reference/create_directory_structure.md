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
#> /tmp/RtmpClqKEn/Administration
#> /tmp/RtmpClqKEn/Administration/Application
#> /tmp/RtmpClqKEn/Administration/Application/Call
#> /tmp/RtmpClqKEn/Administration/Application/Formalities
#> /tmp/RtmpClqKEn/Administration/Application/CVs
#> /tmp/RtmpClqKEn/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpClqKEn/Administration/Application/Application
#> /tmp/RtmpClqKEn/Administration/Application/Pre-analysis
#> /tmp/RtmpClqKEn/Administration/Application/For submission
#> /tmp/RtmpClqKEn/Administration/Budget
#> /tmp/RtmpClqKEn/Administration/Contracts and agreements
#> /tmp/RtmpClqKEn/Administration/Invoices, accounting and receipts
#> /tmp/RtmpClqKEn/Administration/Status reports
#> /tmp/RtmpClqKEn/Administration/Logo and graphical materials
#> /tmp/RtmpClqKEn/Administration/Internal meetings
#> /tmp/RtmpClqKEn/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpClqKEn/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpClqKEn/Administration/Internal meetings/Minutes
#> /tmp/RtmpClqKEn/Materials
#> /tmp/RtmpClqKEn/Materials/Overall planning
#> /tmp/RtmpClqKEn/Materials/Consent form
#> /tmp/RtmpClqKEn/Materials/Ethical-GDPR approval
#> /tmp/RtmpClqKEn/Materials/Survey questionnaires
#> /tmp/RtmpClqKEn/Materials/Interview guides
#> /tmp/RtmpClqKEn/Materials/Interview guides/Staff
#> /tmp/RtmpClqKEn/Materials/Interview guides/Pupils
#> /tmp/RtmpClqKEn/Materials/Interview guides/Parents
#> /tmp/RtmpClqKEn/Materials/Interview guides/Researchers
#> /tmp/RtmpClqKEn/Materials/Interview guides/Leaders
#> /tmp/RtmpClqKEn/Materials/Interview guides/Teachers
#> /tmp/RtmpClqKEn/Materials/Interview guides/Principals
#> /tmp/RtmpClqKEn/Materials/Interview guides/Students
#> /tmp/RtmpClqKEn/Materials/Interview guides/Population
#> /tmp/RtmpClqKEn/Materials/Request of data from
#> /tmp/RtmpClqKEn/Materials/Literature review-design
#> /tmp/RtmpClqKEn/Materials/Intervention materials
#> /tmp/RtmpClqKEn/Materials/Randomizing participants
#> /tmp/RtmpClqKEn/Materials/Chapter overviews
#> /tmp/RtmpClqKEn/Literature
#> /tmp/RtmpClqKEn/Literature/Topic has policy relevance
#> /tmp/RtmpClqKEn/Literature/Pure theory and framework
#> /tmp/RtmpClqKEn/Literature/Similar empirical studies
#> /tmp/RtmpClqKEn/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpClqKEn/Literature/Relevant analytic methodology
#> /tmp/RtmpClqKEn/Literature/Unprocessed (remove from here)
#> /tmp/RtmpClqKEn/Data
#> /tmp/RtmpClqKEn/Data/Population data
#> /tmp/RtmpClqKEn/Data/Population data/Codebook
#> /tmp/RtmpClqKEn/Data/Sampling frame
#> /tmp/RtmpClqKEn/Data/Registry data
#> /tmp/RtmpClqKEn/Data/Collected respondent lists
#> /tmp/RtmpClqKEn/Data/Respondent list for survey system
#> /tmp/RtmpClqKEn/Data/Downloaded response data
#> /tmp/RtmpClqKEn/Data/Downloaded response data/Codebook
#> /tmp/RtmpClqKEn/Data/Qualitative data
#> /tmp/RtmpClqKEn/Data/Qualitative data/Interview recordings
#> /tmp/RtmpClqKEn/Data/Qualitative data/Observational notes
#> /tmp/RtmpClqKEn/Data/Text corpus
#> /tmp/RtmpClqKEn/Data/PDF-reports
#> /tmp/RtmpClqKEn/Data/Prepared data
#> /tmp/RtmpClqKEn/Data/Prepared data/Codebooks
#> /tmp/RtmpClqKEn/Saros_SSN
#> /tmp/RtmpClqKEn/Saros_SSN/Scripts
#> /tmp/RtmpClqKEn/Saros_SSN/Resources
#> /tmp/RtmpClqKEn/Saros_SSN/Draft generations
#> /tmp/RtmpClqKEn/Saros_SSN/Draft generations/main
#> /tmp/RtmpClqKEn/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpClqKEn/Saros_SSN/Drafts in editing
#> /tmp/RtmpClqKEn/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpClqKEn/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpClqKEn/Saros_SSN/Completed drafts
#> /tmp/RtmpClqKEn/Saros_SSN/Completed drafts/main
#> /tmp/RtmpClqKEn/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpClqKEn/Publications
#> /tmp/RtmpClqKEn/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpClqKEn/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpClqKEn/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpClqKEn/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpClqKEn/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpClqKEn/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpClqKEn/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpClqKEn/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpClqKEn/Outreach
#> /tmp/RtmpClqKEn/Outreach/Research conference presentation
#> /tmp/RtmpClqKEn/Outreach/Research conference poster
#> /tmp/RtmpClqKEn/Outreach/Stakeholders and reference group
#> /tmp/RtmpClqKEn/Outreach/Stakeholders' communication channels
#> /tmp/RtmpClqKEn/Outreach/Practitioners and special interest channels
#> /tmp/RtmpClqKEn/Outreach/Public through mass media channels
#> /tmp/RtmpClqKEn/Other
```
