# Objections and known limitations

This vignette collects the objections most often raised against adopting
Saros, together with the answers to them, and the limitations that are
expected to persist. It is a companion to `vig_00_about_saros`, which
makes the positive case.

## Objections

### Our report also needs chapters that are not about surveys

That is fine. Leave the `dep` column empty for those chapters in the
chapter overview. They still count as chapters, but Saros generates an
empty document for them, which you then write by hand.

You can also add non-survey chapters afterwards, though you will then
need to adjust the chapter numbering.

> **Note**
>
> This behavior is deliberate in the code, not a happy accident: chapter
> overview rows with no dependent variable are explicitly preserved
> through the filtering steps, and content generation is skipped for a
> chapter whose dependent variables are all absent.

### Is it not risky for everyone to depend on RStudio?

- R is considerably more popular than Stata or SPSS, and its popularity
  is growing — internationally and nationally, and within the social
  sciences specifically.
- Documentation, online resources and functionality are much better.
- RStudio is free, and will remain so for the foreseeable future.
- A substantial and growing number of colleagues already use R or are
  learning it.
- The system is modular, so in the worst case a step such as data
  cleaning can be done without R.
- When the system works as intended there is little need for statistical
  software during chapter writing at all.
- Nothing comparable to Saros could be built in Stata or SPSS alone.
- A fallback based on Python could be integrated in the future.

### What about Tableau?

- It is not a complete solution: not a publishing system, and not well
  integrated with the other technologies in the chain.
- The per-user annual license cost is substantial.
- It can be slow to load.
- Data sharing is awkward.
- Scaling content to a website is awkward.
- Dynamic updating appears to be missing.

### Are we removing the interesting work? Are we automating ourselves out of a job?

No. See the goals in `vig_00_about_saros` for what the freed-up time is
meant to go to. There is always more than enough to do, and the
statistical and technical work does not disappear — it moves up the
value chain, toward design, quality assurance and interpretation.

### Are we locking ourselves into one way of presenting the data?

No. Saros helps the chapter authors part of the way. Anything more
advanced you want to build in the document, you can still build; the
generated `.qmd` is ordinary Quarto source and you are free to replace
any of it.

## Known limitations

For current bugs and improvement proposals, see the issue trackers:

- [saros.base issues](https://github.com/NIFU-NO/saros.base/issues) —
  draft generation, mesos structure, access restrictions.
- [saros issues](https://github.com/NIFU-NO/saros/issues) — the
  functions chapter authors call inside the drafts.

The following are expected to remain for the foreseeable future.

**Learning something new is hard.** There is no way around this one.

**Quarto has no co-authoring, continuous version control or comment
threads.** There is no equivalent of tracked changes and margin comments
in a shared Word document. The mitigation is that a Quarto file is a
plain text file: it opens in any editor, and it works with ordinary
version control.

**Editing has to happen in the `.qmd`.** What is prepared for the manual
PISVEEP pass may be available as QMD, DOCX and/or PDF, but the edits
must go into the QMD so that the automatic post-PISVEEP stage can turn
it into the website. QMD opens in any text editor, or in RStudio for a
visual editor with live rendering.

**Chapters with a lot of interactive content produce large web pages.**
They do not take long to load, but the pages are not small.

**Means in charts and tables follow statistical recommendations**, which
constrains how they can be presented.

**Breaking down by two variables at once is not directly supported.**
The workaround is to construct the interaction between the two breakdown
variables in advance, as a variable in the data, before Saros generates
the drafts.

**Sorting is flexible, but `descending` currently reverses every sorting
variable** rather than just the one you meant.
