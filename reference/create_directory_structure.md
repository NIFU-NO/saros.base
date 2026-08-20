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
#> /tmp/RtmpY2v6tu/Administration
#> /tmp/RtmpY2v6tu/Administration/Application
#> /tmp/RtmpY2v6tu/Administration/Application/Call
#> /tmp/RtmpY2v6tu/Administration/Application/Formalities
#> /tmp/RtmpY2v6tu/Administration/Application/CVs
#> /tmp/RtmpY2v6tu/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpY2v6tu/Administration/Application/Application
#> /tmp/RtmpY2v6tu/Administration/Application/Pre-analysis
#> /tmp/RtmpY2v6tu/Administration/Application/For submission
#> /tmp/RtmpY2v6tu/Administration/Budget
#> /tmp/RtmpY2v6tu/Administration/Contracts and agreements
#> /tmp/RtmpY2v6tu/Administration/Invoices, accounting and receipts
#> /tmp/RtmpY2v6tu/Administration/Status reports
#> /tmp/RtmpY2v6tu/Administration/Logo and graphical materials
#> /tmp/RtmpY2v6tu/Administration/Internal meetings
#> /tmp/RtmpY2v6tu/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpY2v6tu/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpY2v6tu/Administration/Internal meetings/Minutes
#> /tmp/RtmpY2v6tu/Materials
#> /tmp/RtmpY2v6tu/Materials/Overall planning
#> /tmp/RtmpY2v6tu/Materials/Consent form
#> /tmp/RtmpY2v6tu/Materials/Ethical-GDPR approval
#> /tmp/RtmpY2v6tu/Materials/Survey questionnaires
#> /tmp/RtmpY2v6tu/Materials/Interview guides
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Staff
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Pupils
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Parents
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Researchers
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Leaders
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Teachers
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Principals
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Students
#> /tmp/RtmpY2v6tu/Materials/Interview guides/Population
#> /tmp/RtmpY2v6tu/Materials/Request of data from
#> /tmp/RtmpY2v6tu/Materials/Literature review-design
#> /tmp/RtmpY2v6tu/Materials/Intervention materials
#> /tmp/RtmpY2v6tu/Materials/Randomizing participants
#> /tmp/RtmpY2v6tu/Materials/Chapter overviews
#> /tmp/RtmpY2v6tu/Literature
#> /tmp/RtmpY2v6tu/Literature/Topic has policy relevance
#> /tmp/RtmpY2v6tu/Literature/Pure theory and framework
#> /tmp/RtmpY2v6tu/Literature/Similar empirical studies
#> /tmp/RtmpY2v6tu/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpY2v6tu/Literature/Relevant analytic methodology
#> /tmp/RtmpY2v6tu/Literature/Unprocessed (remove from here)
#> /tmp/RtmpY2v6tu/Data
#> /tmp/RtmpY2v6tu/Data/Population data
#> /tmp/RtmpY2v6tu/Data/Population data/Codebook
#> /tmp/RtmpY2v6tu/Data/Sampling frame
#> /tmp/RtmpY2v6tu/Data/Registry data
#> /tmp/RtmpY2v6tu/Data/Collected respondent lists
#> /tmp/RtmpY2v6tu/Data/Respondent list for survey system
#> /tmp/RtmpY2v6tu/Data/Downloaded response data
#> /tmp/RtmpY2v6tu/Data/Downloaded response data/Codebook
#> /tmp/RtmpY2v6tu/Data/Qualitative data
#> /tmp/RtmpY2v6tu/Data/Qualitative data/Interview recordings
#> /tmp/RtmpY2v6tu/Data/Qualitative data/Observational notes
#> /tmp/RtmpY2v6tu/Data/Text corpus
#> /tmp/RtmpY2v6tu/Data/PDF-reports
#> /tmp/RtmpY2v6tu/Data/Prepared data
#> /tmp/RtmpY2v6tu/Data/Prepared data/Codebooks
#> /tmp/RtmpY2v6tu/Saros_SSN
#> /tmp/RtmpY2v6tu/Saros_SSN/Scripts
#> /tmp/RtmpY2v6tu/Saros_SSN/Resources
#> /tmp/RtmpY2v6tu/Saros_SSN/Draft generations
#> /tmp/RtmpY2v6tu/Saros_SSN/Draft generations/main
#> /tmp/RtmpY2v6tu/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpY2v6tu/Saros_SSN/Drafts in editing
#> /tmp/RtmpY2v6tu/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpY2v6tu/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpY2v6tu/Saros_SSN/Completed drafts
#> /tmp/RtmpY2v6tu/Saros_SSN/Completed drafts/main
#> /tmp/RtmpY2v6tu/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpY2v6tu/Publications
#> /tmp/RtmpY2v6tu/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpY2v6tu/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpY2v6tu/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpY2v6tu/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpY2v6tu/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpY2v6tu/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpY2v6tu/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpY2v6tu/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpY2v6tu/Outreach
#> /tmp/RtmpY2v6tu/Outreach/Research conference presentation
#> /tmp/RtmpY2v6tu/Outreach/Research conference poster
#> /tmp/RtmpY2v6tu/Outreach/Stakeholders and reference group
#> /tmp/RtmpY2v6tu/Outreach/Stakeholders' communication channels
#> /tmp/RtmpY2v6tu/Outreach/Practitioners and special interest channels
#> /tmp/RtmpY2v6tu/Outreach/Public through mass media channels
#> /tmp/RtmpY2v6tu/Other
```
