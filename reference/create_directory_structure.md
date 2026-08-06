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
#> /tmp/RtmpgypmyL/Administration
#> /tmp/RtmpgypmyL/Administration/Application
#> /tmp/RtmpgypmyL/Administration/Application/Call
#> /tmp/RtmpgypmyL/Administration/Application/Formalities
#> /tmp/RtmpgypmyL/Administration/Application/CVs
#> /tmp/RtmpgypmyL/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpgypmyL/Administration/Application/Application
#> /tmp/RtmpgypmyL/Administration/Application/Pre-analysis
#> /tmp/RtmpgypmyL/Administration/Application/For submission
#> /tmp/RtmpgypmyL/Administration/Budget
#> /tmp/RtmpgypmyL/Administration/Contracts and agreements
#> /tmp/RtmpgypmyL/Administration/Invoices, accounting and receipts
#> /tmp/RtmpgypmyL/Administration/Status reports
#> /tmp/RtmpgypmyL/Administration/Logo and graphical materials
#> /tmp/RtmpgypmyL/Administration/Internal meetings
#> /tmp/RtmpgypmyL/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpgypmyL/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpgypmyL/Administration/Internal meetings/Minutes
#> /tmp/RtmpgypmyL/Materials
#> /tmp/RtmpgypmyL/Materials/Overall planning
#> /tmp/RtmpgypmyL/Materials/Consent form
#> /tmp/RtmpgypmyL/Materials/Ethical-GDPR approval
#> /tmp/RtmpgypmyL/Materials/Survey questionnaires
#> /tmp/RtmpgypmyL/Materials/Interview guides
#> /tmp/RtmpgypmyL/Materials/Interview guides/Staff
#> /tmp/RtmpgypmyL/Materials/Interview guides/Pupils
#> /tmp/RtmpgypmyL/Materials/Interview guides/Parents
#> /tmp/RtmpgypmyL/Materials/Interview guides/Researchers
#> /tmp/RtmpgypmyL/Materials/Interview guides/Leaders
#> /tmp/RtmpgypmyL/Materials/Interview guides/Teachers
#> /tmp/RtmpgypmyL/Materials/Interview guides/Principals
#> /tmp/RtmpgypmyL/Materials/Interview guides/Students
#> /tmp/RtmpgypmyL/Materials/Interview guides/Population
#> /tmp/RtmpgypmyL/Materials/Request of data from
#> /tmp/RtmpgypmyL/Materials/Literature review-design
#> /tmp/RtmpgypmyL/Materials/Intervention materials
#> /tmp/RtmpgypmyL/Materials/Randomizing participants
#> /tmp/RtmpgypmyL/Materials/Chapter overviews
#> /tmp/RtmpgypmyL/Literature
#> /tmp/RtmpgypmyL/Literature/Topic has policy relevance
#> /tmp/RtmpgypmyL/Literature/Pure theory and framework
#> /tmp/RtmpgypmyL/Literature/Similar empirical studies
#> /tmp/RtmpgypmyL/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpgypmyL/Literature/Relevant analytic methodology
#> /tmp/RtmpgypmyL/Literature/Unprocessed (remove from here)
#> /tmp/RtmpgypmyL/Data
#> /tmp/RtmpgypmyL/Data/Population data
#> /tmp/RtmpgypmyL/Data/Population data/Codebook
#> /tmp/RtmpgypmyL/Data/Sampling frame
#> /tmp/RtmpgypmyL/Data/Registry data
#> /tmp/RtmpgypmyL/Data/Collected respondent lists
#> /tmp/RtmpgypmyL/Data/Respondent list for survey system
#> /tmp/RtmpgypmyL/Data/Downloaded response data
#> /tmp/RtmpgypmyL/Data/Downloaded response data/Codebook
#> /tmp/RtmpgypmyL/Data/Qualitative data
#> /tmp/RtmpgypmyL/Data/Qualitative data/Interview recordings
#> /tmp/RtmpgypmyL/Data/Qualitative data/Observational notes
#> /tmp/RtmpgypmyL/Data/Text corpus
#> /tmp/RtmpgypmyL/Data/PDF-reports
#> /tmp/RtmpgypmyL/Data/Prepared data
#> /tmp/RtmpgypmyL/Data/Prepared data/Codebooks
#> /tmp/RtmpgypmyL/Saros_SSN
#> /tmp/RtmpgypmyL/Saros_SSN/Scripts
#> /tmp/RtmpgypmyL/Saros_SSN/Resources
#> /tmp/RtmpgypmyL/Saros_SSN/Draft generations
#> /tmp/RtmpgypmyL/Saros_SSN/Draft generations/main
#> /tmp/RtmpgypmyL/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpgypmyL/Saros_SSN/Drafts in editing
#> /tmp/RtmpgypmyL/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpgypmyL/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpgypmyL/Saros_SSN/Completed drafts
#> /tmp/RtmpgypmyL/Saros_SSN/Completed drafts/main
#> /tmp/RtmpgypmyL/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpgypmyL/Publications
#> /tmp/RtmpgypmyL/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpgypmyL/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpgypmyL/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpgypmyL/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpgypmyL/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpgypmyL/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpgypmyL/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpgypmyL/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpgypmyL/Outreach
#> /tmp/RtmpgypmyL/Outreach/Research conference presentation
#> /tmp/RtmpgypmyL/Outreach/Research conference poster
#> /tmp/RtmpgypmyL/Outreach/Stakeholders and reference group
#> /tmp/RtmpgypmyL/Outreach/Stakeholders' communication channels
#> /tmp/RtmpgypmyL/Outreach/Practitioners and special interest channels
#> /tmp/RtmpgypmyL/Outreach/Public through mass media channels
#> /tmp/RtmpgypmyL/Other
```
