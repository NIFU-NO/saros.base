# About the Saros system

This vignette is an orientation to the Saros system as a whole: what it
is for, what it is built from, and how a report gets made. It is
background reading rather than a how-to. The other vignettes are the
practical guides; start with `vig_01_basic_file_system` if you want to
get something running.

## What Saros is

Saros stands for *Semi-Automatic Reporting of Ordinary Surveys*. It is a
family of R packages, plus a set of conventions, for producing reports
from survey data: efficiently, flexibly, and in a way that can be
quality assured and repeated the same way next time.

The core idea is that a great deal of a survey report is mechanical.
Given a dataset and a short description of which variables belong in
which chapter, the shape of the report is largely determined: a table
here, a bar chart there, a significance test where two variables are
crossed. Saros generates that scaffolding as Quarto (`.qmd`) source
files, and leaves the parts that require judgment — interpretation,
emphasis, argument — to the human authors.

> **Semi-automatic, not automatic**
>
> Saros does not write the report. It writes a *draft*, and the draft is
> expected to be edited. The generated `.qmd` files are ordinary text
> files that authors change freely; nothing in Saros requires the output
> to stay as generated.

## Purpose and goals

The purpose of the system is:

> To offer NIFU and its collaborators a publishing system that is
> innovative in its mode of dissemination, its methodological quality
> assurance, and its way of working.

The goals below are grouped for readability.

### A better experience for readers

- Institution-specific reports (see [Macro, mesos and
  micro](#macro-mesos-and-micro) below), so that a participating school
  or organization can see its own results.
- Interactive figures and tables, where extra detail is available on
  demand rather than crowding the page.
- Easier onward use of the results:
  - Direct URL references to a specific figure or subheading.
  - Both a PDF and an HTML/website version (with DOCX and EPUB envisaged
    later).
  - Anonymized data.
  - A separate web app for building your own figures. This exists
    already and has been moved out of Saros; see
    [SarosFlexiApp](https://nifu.shinyapps.io/sarosflexiapp/).
- A better experience on mobile devices than a PDF can offer.
- Potentially faster feedback to the groups that took part.
- Room to present trend analyses.
- More than one color palette. NIFU’s Word report template is limited to
  a single palette, whereas Saros allows one for nominal variables,
  another for ordinal variables, and so on.
- Room for a comment field on the website, so readers can contribute
  interpretations or point out errors.

### Stronger quality assurance

- Fewer ad-hoc choices, because templates fix the routine ones.
- Project setups that resemble each other, so that reviewing one
  prepares you to review the next.

### Transparency and reproducibility

- Alignment with article publication and with Sikt’s Survey Bank.
- Archiving of data.
- Room to publish more about the project and the data than a report or
  an ordinary project web page allows — including CRediT-style
  attribution for contributors who did not author a publication but did
  contribute, and a record of how they contributed.

### Efficiency and capacity

- Time saved on routine work is time available for quality assurance of
  design, instruments, data, analysis and dissemination — and for
  writing articles.
- Faster writing, because formatting and inserting a figure is a
  keystroke away.
- Less exposure to the risk that a single highly quantitatively skilled
  person is the only one who can produce the report.
- A lower barrier to entry for quantitative reporting, so more
  colleagues can take part as a form of skills development.
- Less routine work, and therefore, it is hoped, less turnover.
- Document assembly tasks that are considerably simpler and more
  transparent than in LaTeX or Word.

## Success criteria

The system is intended to satisfy the following criteria.

**Modularity and fallbacks.** If a module fails, it should be easy to
fall back to the old-fashioned alternative for that module alone. Module
inputs and outputs are standardized so a module can be swapped out. In
the long run the implementation language should not matter much — R,
Stata or Python.

**Best practice.** The system should draw on the experience of
comparable organizations, and it should be possible to update a
statistical recommendation across a whole report relatively easily.
(Doing so across *all* reports is possible in principle but not
advisable.)

**Flexibility.** Beyond swapping modules, individual functions need to
accommodate preferences and needs: good defaults, with the option to
override them if you know better.

**Buy-in.** Gradual implementation, low-hanging fruit first, several
people involved so the interface makes sense to more than its author,
good documentation and training with examples, and standardization where
standardization helps.

**Cost-benefit.** The benefit must be substantially larger than the cost
of changing over.

**Strategic execution.** Funding for the transition should preferably be
stable, and ideally external.

## Macro, mesos and micro

A recurring distinction in Saros is the level a report describes.

| Level | Who it describes | In Saros |
|----|----|----|
| Macro | Everyone in the survey | The main report |
| Mesos | One participating institution, region or other group | A *mesos* report |
| Micro | The individual respondent | Not reported on; respondents are not identifiable |

> **“Mesos” is the term the code uses**
>
> Of these three, only *mesos* is a term in `saros.base` itself — as
> [`setup_mesos()`](https://nifu-no.github.io/saros.base/reference/setup_mesos.md),
> [`setup_mesos_structure()`](https://nifu-no.github.io/saros.base/reference/setup_mesos_structure.md),
> and the `mesos_var` / `mesos_group` arguments. “Macro” and “micro” are
> framing for this vignette and do not appear anywhere in the package’s
> code or function documentation.

A mesos report is the same report, filtered to one group and set against
the rest. In the generated chunk templates this appears as a `crowd`
argument taking the values `"target"` (the institution being reported
on) and `"others"` (everyone else), so a figure can show the
institution’s own answers next to the overall picture.

Mesos reports are what makes password protection necessary: each
institution should see its own report and no others.
[`setup_access_restrictions()`](https://nifu-no.github.io/saros.base/reference/setup_access_restrictions.md)
and
[`create_email_credentials()`](https://nifu-no.github.io/saros.base/reference/create_email_credentials.md)
handle that side.

> **Warning**
>
> Offering institutions a report of their own in exchange for
> participating raises ethical questions about pressure on respondents.
> These are discussed in `vig_08_adopting_saros`.

## How a Saros report is produced

Production runs in three phases: an automatic phase before the manual
work, the manual work itself, and an automatic phase after it.

      Input                    Pre-PISVEEP              PISVEEP            Post-PISVEEP            Output
                               (automatic)              (manual)           (automatic)

      chapter overview  --->   load paths and     --->  Pick out     --->  copy finished   --->   website
      configuration and        prepare data             Inspect            drafts                 PDF / DOCX
        templates              build chapter            Summarize          render site            archive
      population data            overview                Vary              issue mesos
      survey data              read settings and         Elaborate           passwords
      supporting data            chapter overview        Exemplify          archive
                               generate drafts           Position
                               copy drafts to the
                                 working folder

**PISVEEP** is the name given to the manual pass a chapter author makes
over the generated draft. The initials are the same in Norwegian and
English:

| Letter | Step | Norwegian | What the author does |
|----|----|----|----|
| P | Pick out | *Plukk ut* | Choose which of the generated elements to keep |
| I | Inspect | *Inspiser* | Read the numbers and check they say what they appear to say |
| S | Summarize | *Sammenfatt* | Draw the results together |
| V | Vary | *Varier* | Vary the presentation so the chapter does not read as a list |
| E | Elaborate | *Elaborer* | Add the interpretation the numbers do not supply |
| E | Exemplify | *Eksemplifiser* | Give concrete examples |
| P | Position | *Posisjoner* | Place the findings in relation to other knowledge |

### The steps of a survey cycle

Some of these steps would apply whether or not you used Saros, and some
are irrelevant if, for example, you have no population register. The
role called *data cleaner* below is whoever prepares the data — a
research assistant, data analyst or similar.

1.  The data cleaner cleans the population data and draws the sample.
    This is saved.
2.  The survey is carried out.
    1.  The data cleaner ensures variable numbering and question wording
        follow best practice, and in particular what Saros expects. See
        `vig_05_standard_variable_names`.
    2.  The data cleaner retrieves the data from Qualtrics, SurveyXact
        or Nettskjema.
3.  The data cleaner cleans the survey data. See `vig_04_prepare_data`.
4.  The data cleaner updates the population data with response status,
    for the methods chapter.
5.  The project lead and data cleaner adjust the report settings.
6.  The project lead and data cleaner prepare the chapter overview. See
    `vig_06_prepare_chapter_overview`.
7.  The data cleaner generates the draft report with
    [`draft_report()`](https://nifu-no.github.io/saros.base/reference/draft_report.md).
8.  The chapter authors work through PISVEEP.
9.  The chapter authors place all finished drafts in the folder for
    completed drafts.
10. The data cleaner assembles the full report for the website, PDF,
    DOCX and so on.
11. Where required, the data cleaner sets up password protection for the
    mesos pages.
12. The data cleaner copies the rendered site to the server.
13. Where required, the data cleaner sends passwords out to the
    institutions.
14. The data cleaner freezes and caches the website, archives the data,
    and closes the cycle.

## What Saros is built from

Saros is only the first part of the chain. Underneath it sits a stack of
general-purpose, open-source tools, and the file formats at every stage
are plain text that any editor can open.

      dataset            \
      chapter overview    >---> saros.base ---> .qmd
      settings           /                        |
                                                  v
                                      knitr (R) / Jupyter (Python) /
                                      IJulia (Julia) / plain Markdown
                                                  |
                                                  v
                                                 .md
                                                  |
                                                  v
                                               Pandoc
                                                  |
            +--------+--------+--------+----------+--------+--------+
            v        v        v        v          v        v        v
          docx     html    LaTeX PDF  Beamer   Typst PDF   ePub    pptx

### The Saros packages

- **[saros.base](https://nifu-no.github.io/saros.base/)** — this
  package. Generates chapter drafts in Quarto format from a dataset and
  a chapter overview, and provides the tools for publishing the finished
  reports, including password protection.
- **[saros](https://github.com/NIFU-NO/saros)** — the functions the
  chapter authors call from inside the generated drafts, chiefly
  `makeme()` for producing a figure or table.
- **[saros.utils](https://github.com/NIFU-NO/saros.utils)** — non-core
  utilities.
- **[remove_empty_headings](https://github.com/NIFU-NO/remove_empty_headings)**
  — a small Lua filter that strips empty headings out of the generated
  drafts before compilation.

> **The package split**
>
> Saros began as a single `saros` package and was split so that draft
> generation (`saros.base`) is separate from the functions used inside
> the drafts (`saros`). Earlier planning documents list a wider split —
> `sarosverse`, `saros.structure`, `saros.psych`, `saros.causal`,
> `saros.text`, `saros.qual`, `saros.docx` — which was not carried out
> in that form. Treat the list above as current.

### Packages and templates built for NIFU

- **[nifutypst](https://github.com/NIFU-NO/nifutypst)** — a Quarto
  template for converting to PDF with NIFU’s layout. Maintained by
  Henrik Karlstrøm, with contributions from Stephan Daus.
- **[nifudocx](https://github.com/NIFU-NO/nifudocx)** — the equivalent
  Quarto template for DOCX. Maintained by Stephan Daus.
- **[nifutheme](https://github.com/NIFU-NO/nifutheme)** — NIFU’s color
  palettes and other graphical elements for R. Developed by Henrik
  Karlstrøm.
- **[nifutemplates](https://github.com/NIFU-NO/nifutemplates)** — the
  general files, templates and images needed to build a NIFU report
  website quickly and consistently.

### Third-party technologies

All of the following are free and open-source software developed outside
NIFU.

- **[Quarto](https://quarto.org)** — the successor to R Markdown. Lets
  you combine formatted text with images, tables, and R or Python code,
  while document-wide or project-wide settings live in one place. Saros
  generates R syntax only, but nothing stops you adding Python yourself.
- **[Pandoc](https://pandoc.org)** — a universal document converter.
  Quarto uses it to produce HTML, DOCX, PPTX, PDF and the rest.
- **[Typst](https://typst.app)** — a modern replacement for LaTeX for
  typesetting PDFs. Where LaTeX is slow to compile and cryptic when it
  fails, Typst compiles more or less instantly, reports comprehensible
  errors, and has a simpler syntax.
- **[R](https://www.r-project.org)** — the engine.
- **[RStudio](https://posit.co)** — the interface that ties the above
  together.
- **[GitHub](https://github.com)** — version control for several Saros
  components, and worth using for projects that build on Saros, to keep
  the R files and resources you have invested time in. You should not
  need it for anything else in the project.

### Possible additions

- For the R parts of the process,
  [renv](https://rstudio.github.io/renv/) freezes the set of installed
  packages, so that an update cannot disturb something that already
  worked.

## The traditional report format

Part of the motivation for Saros is an analysis of what a conventional
survey report actually contains. If the structure is that predictable,
much of it can be generated.

> **Note**
>
> This section is an outline of intent rather than a specification, and
> is still being worked out.

### A methods chapter about a survey

- Topics covered in the report (roughly, the dependent variables)
- Sampling and procedures
- A map of the sample, where there is clustering by county or
  municipality
- Background variables (roughly, the independent variables)
- Respondents and response rate
- Representativeness

### A results chapter about a survey

For each set of dependent variables:

- A univariate table
- A univariate bar chart — frequencies if under 100 responses, otherwise
  percentages
- A univariate description in prose: introduce the battery, give the
  minimum and maximum for the combined category, the spread across
  indicators, any unused categories, and which indicators have the least
  and most dispersion

Then, for each independent variable:

- A bivariate table
- A bivariate bar chart
- A bivariate significance test — chi-squared, t-test or correlation,
  with correction for multiple tests
- Typical breakdowns: respondent group, change since last time, and the
  fixed background variables

And finally a summary, as a box of bullet points, written by hand.

## Objections and known limitations

These are collected in `vig_10_objections_and_limitations`.
