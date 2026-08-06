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
#> /tmp/Rtmp0oi4wg/Administration
#> /tmp/Rtmp0oi4wg/Administration/Application
#> /tmp/Rtmp0oi4wg/Administration/Application/Call
#> /tmp/Rtmp0oi4wg/Administration/Application/Formalities
#> /tmp/Rtmp0oi4wg/Administration/Application/CVs
#> /tmp/Rtmp0oi4wg/Administration/Application/Collaboration and cooperation
#> agreements
#> /tmp/Rtmp0oi4wg/Administration/Application/Application
#> /tmp/Rtmp0oi4wg/Administration/Application/Pre-analysis
#> /tmp/Rtmp0oi4wg/Administration/Application/For submission
#> /tmp/Rtmp0oi4wg/Administration/Budget
#> /tmp/Rtmp0oi4wg/Administration/Contracts and agreements
#> /tmp/Rtmp0oi4wg/Administration/Invoices, accounting and receipts
#> /tmp/Rtmp0oi4wg/Administration/Status reports
#> /tmp/Rtmp0oi4wg/Administration/Logo and graphical materials
#> /tmp/Rtmp0oi4wg/Administration/Internal meetings
#> /tmp/Rtmp0oi4wg/Administration/Internal meetings/Meeting agendas and
#> invitations
#> /tmp/Rtmp0oi4wg/Administration/Internal meetings/Internal presentations
#> /tmp/Rtmp0oi4wg/Administration/Internal meetings/Minutes
#> /tmp/Rtmp0oi4wg/Materials
#> /tmp/Rtmp0oi4wg/Materials/Overall planning
#> /tmp/Rtmp0oi4wg/Materials/Consent form
#> /tmp/Rtmp0oi4wg/Materials/Ethical-GDPR approval
#> /tmp/Rtmp0oi4wg/Materials/Survey questionnaires
#> /tmp/Rtmp0oi4wg/Materials/Interview guides
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Staff
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Pupils
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Parents
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Researchers
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Leaders
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Teachers
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Principals
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Students
#> /tmp/Rtmp0oi4wg/Materials/Interview guides/Population
#> /tmp/Rtmp0oi4wg/Materials/Request of data from
#> /tmp/Rtmp0oi4wg/Materials/Literature review-design
#> /tmp/Rtmp0oi4wg/Materials/Intervention materials
#> /tmp/Rtmp0oi4wg/Materials/Randomizing participants
#> /tmp/Rtmp0oi4wg/Materials/Chapter overviews
#> /tmp/Rtmp0oi4wg/Literature
#> /tmp/Rtmp0oi4wg/Literature/Topic has policy relevance
#> /tmp/Rtmp0oi4wg/Literature/Pure theory and framework
#> /tmp/Rtmp0oi4wg/Literature/Similar empirical studies
#> /tmp/Rtmp0oi4wg/Literature/Similar instruments and guides for data collection
#> /tmp/Rtmp0oi4wg/Literature/Relevant analytic methodology
#> /tmp/Rtmp0oi4wg/Literature/Unprocessed (remove from here)
#> /tmp/Rtmp0oi4wg/Data
#> /tmp/Rtmp0oi4wg/Data/Population data
#> /tmp/Rtmp0oi4wg/Data/Population data/Codebook
#> /tmp/Rtmp0oi4wg/Data/Sampling frame
#> /tmp/Rtmp0oi4wg/Data/Registry data
#> /tmp/Rtmp0oi4wg/Data/Collected respondent lists
#> /tmp/Rtmp0oi4wg/Data/Respondent list for survey system
#> /tmp/Rtmp0oi4wg/Data/Downloaded response data
#> /tmp/Rtmp0oi4wg/Data/Downloaded response data/Codebook
#> /tmp/Rtmp0oi4wg/Data/Qualitative data
#> /tmp/Rtmp0oi4wg/Data/Qualitative data/Interview recordings
#> /tmp/Rtmp0oi4wg/Data/Qualitative data/Observational notes
#> /tmp/Rtmp0oi4wg/Data/Text corpus
#> /tmp/Rtmp0oi4wg/Data/PDF-reports
#> /tmp/Rtmp0oi4wg/Data/Prepared data
#> /tmp/Rtmp0oi4wg/Data/Prepared data/Codebooks
#> /tmp/Rtmp0oi4wg/Saros_SSN
#> /tmp/Rtmp0oi4wg/Saros_SSN/Scripts
#> /tmp/Rtmp0oi4wg/Saros_SSN/Resources
#> /tmp/Rtmp0oi4wg/Saros_SSN/Draft generations
#> /tmp/Rtmp0oi4wg/Saros_SSN/Draft generations/main
#> /tmp/Rtmp0oi4wg/Saros_SSN/Draft generations/Reports
#> /tmp/Rtmp0oi4wg/Saros_SSN/Drafts in editing
#> /tmp/Rtmp0oi4wg/Saros_SSN/Drafts in editing/main
#> /tmp/Rtmp0oi4wg/Saros_SSN/Drafts in editing/Reports
#> /tmp/Rtmp0oi4wg/Saros_SSN/Completed drafts
#> /tmp/Rtmp0oi4wg/Saros_SSN/Completed drafts/main
#> /tmp/Rtmp0oi4wg/Saros_SSN/Completed drafts/Reports
#> /tmp/Rtmp0oi4wg/Publications
#> /tmp/Rtmp0oi4wg/Publications/Paper1-Short title (author initials)
#> /tmp/Rtmp0oi4wg/Publications/Paper1-Short title (author initials)/Cover letter
#> & response to reviewers
#> /tmp/Rtmp0oi4wg/Publications/Paper1-Short title (author initials)/Manuscript
#> /tmp/Rtmp0oi4wg/Publications/Paper1-Short title (author initials)/Analysis
#> /tmp/Rtmp0oi4wg/Publications/Paper1-Short title (author initials)/Figures for
#> submission
#> /tmp/Rtmp0oi4wg/Publications/Paper1-Short title (author initials)/Tables for
#> submission
#> /tmp/Rtmp0oi4wg/Publications/Paper1-Short title (author initials)/Appendix
#> /tmp/Rtmp0oi4wg/Publications/Paper1-Short title (author initials)/Online
#> supplementary materials
#> /tmp/Rtmp0oi4wg/Outreach
#> /tmp/Rtmp0oi4wg/Outreach/Research conference presentation
#> /tmp/Rtmp0oi4wg/Outreach/Research conference poster
#> /tmp/Rtmp0oi4wg/Outreach/Stakeholders and reference group
#> /tmp/Rtmp0oi4wg/Outreach/Stakeholders' communication channels
#> /tmp/Rtmp0oi4wg/Outreach/Practitioners and special interest channels
#> /tmp/Rtmp0oi4wg/Outreach/Public through mass media channels
#> /tmp/Rtmp0oi4wg/Other
```
