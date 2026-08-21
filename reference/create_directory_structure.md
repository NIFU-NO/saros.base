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
#> /tmp/RtmpvNnfqR/Administration
#> /tmp/RtmpvNnfqR/Administration/Application
#> /tmp/RtmpvNnfqR/Administration/Application/Call
#> /tmp/RtmpvNnfqR/Administration/Application/Formalities
#> /tmp/RtmpvNnfqR/Administration/Application/CVs
#> /tmp/RtmpvNnfqR/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmpvNnfqR/Administration/Application/Application
#> /tmp/RtmpvNnfqR/Administration/Application/Pre-analysis
#> /tmp/RtmpvNnfqR/Administration/Application/For submission
#> /tmp/RtmpvNnfqR/Administration/Budget
#> /tmp/RtmpvNnfqR/Administration/Contracts and agreements
#> /tmp/RtmpvNnfqR/Administration/Invoices, accounting and receipts
#> /tmp/RtmpvNnfqR/Administration/Status reports
#> /tmp/RtmpvNnfqR/Administration/Logo and graphical materials
#> /tmp/RtmpvNnfqR/Administration/Internal meetings
#> /tmp/RtmpvNnfqR/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmpvNnfqR/Administration/Internal meetings/Internal presentations
#> /tmp/RtmpvNnfqR/Administration/Internal meetings/Minutes
#> /tmp/RtmpvNnfqR/Materials
#> /tmp/RtmpvNnfqR/Materials/Overall planning
#> /tmp/RtmpvNnfqR/Materials/Consent form
#> /tmp/RtmpvNnfqR/Materials/Ethical-GDPR approval
#> /tmp/RtmpvNnfqR/Materials/Survey questionnaires
#> /tmp/RtmpvNnfqR/Materials/Interview guides
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Staff
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Pupils
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Parents
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Researchers
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Leaders
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Teachers
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Principals
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Students
#> /tmp/RtmpvNnfqR/Materials/Interview guides/Population
#> /tmp/RtmpvNnfqR/Materials/Request of data from
#> /tmp/RtmpvNnfqR/Materials/Literature review-design
#> /tmp/RtmpvNnfqR/Materials/Intervention materials
#> /tmp/RtmpvNnfqR/Materials/Randomizing participants
#> /tmp/RtmpvNnfqR/Materials/Chapter overviews
#> /tmp/RtmpvNnfqR/Literature
#> /tmp/RtmpvNnfqR/Literature/Topic has policy relevance
#> /tmp/RtmpvNnfqR/Literature/Pure theory and framework
#> /tmp/RtmpvNnfqR/Literature/Similar empirical studies
#> /tmp/RtmpvNnfqR/Literature/Similar instruments and guides for data collection
#> /tmp/RtmpvNnfqR/Literature/Relevant analytic methodology
#> /tmp/RtmpvNnfqR/Literature/Unprocessed (remove from here)
#> /tmp/RtmpvNnfqR/Data
#> /tmp/RtmpvNnfqR/Data/Population data
#> /tmp/RtmpvNnfqR/Data/Population data/Codebook
#> /tmp/RtmpvNnfqR/Data/Sampling frame
#> /tmp/RtmpvNnfqR/Data/Registry data
#> /tmp/RtmpvNnfqR/Data/Collected respondent lists
#> /tmp/RtmpvNnfqR/Data/Respondent list for survey system
#> /tmp/RtmpvNnfqR/Data/Downloaded response data
#> /tmp/RtmpvNnfqR/Data/Downloaded response data/Codebook
#> /tmp/RtmpvNnfqR/Data/Qualitative data
#> /tmp/RtmpvNnfqR/Data/Qualitative data/Interview recordings
#> /tmp/RtmpvNnfqR/Data/Qualitative data/Observational notes
#> /tmp/RtmpvNnfqR/Data/Text corpus
#> /tmp/RtmpvNnfqR/Data/PDF-reports
#> /tmp/RtmpvNnfqR/Data/Prepared data
#> /tmp/RtmpvNnfqR/Data/Prepared data/Codebooks
#> /tmp/RtmpvNnfqR/Saros_SSN
#> /tmp/RtmpvNnfqR/Saros_SSN/Scripts
#> /tmp/RtmpvNnfqR/Saros_SSN/Resources
#> /tmp/RtmpvNnfqR/Saros_SSN/Draft generations
#> /tmp/RtmpvNnfqR/Saros_SSN/Draft generations/main
#> /tmp/RtmpvNnfqR/Saros_SSN/Draft generations/Reports
#> /tmp/RtmpvNnfqR/Saros_SSN/Drafts in editing
#> /tmp/RtmpvNnfqR/Saros_SSN/Drafts in editing/main
#> /tmp/RtmpvNnfqR/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmpvNnfqR/Saros_SSN/Completed drafts
#> /tmp/RtmpvNnfqR/Saros_SSN/Completed drafts/main
#> /tmp/RtmpvNnfqR/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmpvNnfqR/Publications
#> /tmp/RtmpvNnfqR/Publications/Paper1-Short title (author initials)
#> /tmp/RtmpvNnfqR/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmpvNnfqR/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmpvNnfqR/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmpvNnfqR/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmpvNnfqR/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmpvNnfqR/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmpvNnfqR/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmpvNnfqR/Outreach
#> /tmp/RtmpvNnfqR/Outreach/Research conference presentation
#> /tmp/RtmpvNnfqR/Outreach/Research conference poster
#> /tmp/RtmpvNnfqR/Outreach/Stakeholders and reference group
#> /tmp/RtmpvNnfqR/Outreach/Stakeholders' communication channels
#> /tmp/RtmpvNnfqR/Outreach/Practitioners and special interest channels
#> /tmp/RtmpvNnfqR/Outreach/Public through mass media channels
#> /tmp/RtmpvNnfqR/Other
```
