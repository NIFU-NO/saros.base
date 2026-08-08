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
#> /tmp/RtmphbzvBO/Administration
#> /tmp/RtmphbzvBO/Administration/Application
#> /tmp/RtmphbzvBO/Administration/Application/Call
#> /tmp/RtmphbzvBO/Administration/Application/Formalities
#> /tmp/RtmphbzvBO/Administration/Application/CVs
#> /tmp/RtmphbzvBO/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/RtmphbzvBO/Administration/Application/Application
#> /tmp/RtmphbzvBO/Administration/Application/Pre-analysis
#> /tmp/RtmphbzvBO/Administration/Application/For submission
#> /tmp/RtmphbzvBO/Administration/Budget
#> /tmp/RtmphbzvBO/Administration/Contracts and agreements
#> /tmp/RtmphbzvBO/Administration/Invoices, accounting and receipts
#> /tmp/RtmphbzvBO/Administration/Status reports
#> /tmp/RtmphbzvBO/Administration/Logo and graphical materials
#> /tmp/RtmphbzvBO/Administration/Internal meetings
#> /tmp/RtmphbzvBO/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/RtmphbzvBO/Administration/Internal meetings/Internal presentations
#> /tmp/RtmphbzvBO/Administration/Internal meetings/Minutes
#> /tmp/RtmphbzvBO/Materials
#> /tmp/RtmphbzvBO/Materials/Overall planning
#> /tmp/RtmphbzvBO/Materials/Consent form
#> /tmp/RtmphbzvBO/Materials/Ethical-GDPR approval
#> /tmp/RtmphbzvBO/Materials/Survey questionnaires
#> /tmp/RtmphbzvBO/Materials/Interview guides
#> /tmp/RtmphbzvBO/Materials/Interview guides/Staff
#> /tmp/RtmphbzvBO/Materials/Interview guides/Pupils
#> /tmp/RtmphbzvBO/Materials/Interview guides/Parents
#> /tmp/RtmphbzvBO/Materials/Interview guides/Researchers
#> /tmp/RtmphbzvBO/Materials/Interview guides/Leaders
#> /tmp/RtmphbzvBO/Materials/Interview guides/Teachers
#> /tmp/RtmphbzvBO/Materials/Interview guides/Principals
#> /tmp/RtmphbzvBO/Materials/Interview guides/Students
#> /tmp/RtmphbzvBO/Materials/Interview guides/Population
#> /tmp/RtmphbzvBO/Materials/Request of data from
#> /tmp/RtmphbzvBO/Materials/Literature review-design
#> /tmp/RtmphbzvBO/Materials/Intervention materials
#> /tmp/RtmphbzvBO/Materials/Randomizing participants
#> /tmp/RtmphbzvBO/Materials/Chapter overviews
#> /tmp/RtmphbzvBO/Literature
#> /tmp/RtmphbzvBO/Literature/Topic has policy relevance
#> /tmp/RtmphbzvBO/Literature/Pure theory and framework
#> /tmp/RtmphbzvBO/Literature/Similar empirical studies
#> /tmp/RtmphbzvBO/Literature/Similar instruments and guides for data collection
#> /tmp/RtmphbzvBO/Literature/Relevant analytic methodology
#> /tmp/RtmphbzvBO/Literature/Unprocessed (remove from here)
#> /tmp/RtmphbzvBO/Data
#> /tmp/RtmphbzvBO/Data/Population data
#> /tmp/RtmphbzvBO/Data/Population data/Codebook
#> /tmp/RtmphbzvBO/Data/Sampling frame
#> /tmp/RtmphbzvBO/Data/Registry data
#> /tmp/RtmphbzvBO/Data/Collected respondent lists
#> /tmp/RtmphbzvBO/Data/Respondent list for survey system
#> /tmp/RtmphbzvBO/Data/Downloaded response data
#> /tmp/RtmphbzvBO/Data/Downloaded response data/Codebook
#> /tmp/RtmphbzvBO/Data/Qualitative data
#> /tmp/RtmphbzvBO/Data/Qualitative data/Interview recordings
#> /tmp/RtmphbzvBO/Data/Qualitative data/Observational notes
#> /tmp/RtmphbzvBO/Data/Text corpus
#> /tmp/RtmphbzvBO/Data/PDF-reports
#> /tmp/RtmphbzvBO/Data/Prepared data
#> /tmp/RtmphbzvBO/Data/Prepared data/Codebooks
#> /tmp/RtmphbzvBO/Saros_SSN
#> /tmp/RtmphbzvBO/Saros_SSN/Scripts
#> /tmp/RtmphbzvBO/Saros_SSN/Resources
#> /tmp/RtmphbzvBO/Saros_SSN/Draft generations
#> /tmp/RtmphbzvBO/Saros_SSN/Draft generations/main
#> /tmp/RtmphbzvBO/Saros_SSN/Draft generations/Reports
#> /tmp/RtmphbzvBO/Saros_SSN/Drafts in editing
#> /tmp/RtmphbzvBO/Saros_SSN/Drafts in editing/main
#> /tmp/RtmphbzvBO/Saros_SSN/Drafts in editing/Reports
#> /tmp/RtmphbzvBO/Saros_SSN/Completed drafts
#> /tmp/RtmphbzvBO/Saros_SSN/Completed drafts/main
#> /tmp/RtmphbzvBO/Saros_SSN/Completed drafts/Reports
#> /tmp/RtmphbzvBO/Publications
#> /tmp/RtmphbzvBO/Publications/Paper1-Short title (author initials)
#> /tmp/RtmphbzvBO/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/RtmphbzvBO/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/RtmphbzvBO/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/RtmphbzvBO/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/RtmphbzvBO/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/RtmphbzvBO/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/RtmphbzvBO/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/RtmphbzvBO/Outreach
#> /tmp/RtmphbzvBO/Outreach/Research conference presentation
#> /tmp/RtmphbzvBO/Outreach/Research conference poster
#> /tmp/RtmphbzvBO/Outreach/Stakeholders and reference group
#> /tmp/RtmphbzvBO/Outreach/Stakeholders' communication channels
#> /tmp/RtmphbzvBO/Outreach/Practitioners and special interest channels
#> /tmp/RtmphbzvBO/Outreach/Public through mass media channels
#> /tmp/RtmphbzvBO/Other
```
