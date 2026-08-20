# saros.base — working notes

Conventions and hard-won rules for this package. Each earned its place;
the evidence is kept short, as justification rather than narrative.
Issue numbers point at the case that established the rule.

## Running things

- **`NOT_CRAN=true` is required.** Without it the snapshot tests in
  `test-qmd_snapshots.R` `skip_on_cran()` silently. **Check the reported
  skip count is 0** before treating a run as evidence — a run once
  reported `0 failed, 99 passed` with 7 skips, and those skips were
  exactly the tests proving the change caused no output drift.
- **`TESTTHAT_PARALLEL=false` may be needed locally.** `DESCRIPTION`
  sets `Config/testthat/parallel: true`, which on some machines fails
  with `testthat subprocess failed to start` before any test runs.
- **`R_USER` must point at the directory holding your `.Renviron`.** On
  Windows with OneDrive-redirected Documents that is *not*
  `C:\Users\<you>`. Getting it wrong is invisible:
  [`.libPaths()`](https://rdrr.io/r/base/libPaths.html) is identical
  either way and every package still loads, but `R_LIBS_USER`, the
  locale settings and the project’s API credentials are all silently
  absent.
- **`Rscript -e` is fine for a one-liner, but not for a multi-line
  argument.** On Windows a multi-line `-e` string produces **no output
  and no error** — the failure is silent, so it reads as “the command
  printed nothing” rather than as a mistake. Nested quotes in a
  one-liner are fine. Put anything spanning more than one line in a
  script file and run `Rscript <file>`.
- **Regenerate `man/` with the roxygen2 version `DESCRIPTION` pins**
  whenever roxygen comments change (plain `#` comments do not require
  it). The `roxygen-drift` workflow catches a stale `man/`, and aborts
  up front if the pin and `DESCRIPTION` disagree. Do **not** move the
  pin to `latest`: 8.1.0 reflows multiple `importFrom()` entries into a
  multi-line call, which fights the checked-in `NAMESPACE`.
- **Clean up after `quarto render`** — rendering a file in `vignettes/`
  drops a generated `.gitignore` and a `<name>_files/` directory there.

## Tests and guards

- **Break the code and watch the test fail before trusting it.**
  Restore, re-run, then commit. “The test passes” and “the test would
  have caught this” are different claims; five would-be-vacuous tests
  were caught this way in one cycle.
- **When a guard passes pre-fix, find out *which* mechanism made it
  pass** — don’t rework the assertion. In \#256 a guard passed only
  because a *different* fault fired first, so the behaviour it was
  written to pin belonged to a different input. A guard that passes for
  a reason you have not identified is not evidence either way.
- **Some tests cannot fail against the unfixed code** — a guard on the
  *repair* rather than the defect, e.g. “the package’s own defaults must
  still pass”. Verify those by mutation: reintroduce the fault and watch
  the test fail (#242).
- **Ask what the fixtures never contain.** \#246 was a total render
  failure for any report with a univariate numeric variable, surviving
  because no fixture anywhere had a numeric column. Enumerate the input
  space, not the tests.
- **Add a positive control that fails if the fixture produced nothing**,
  so the real assertions cannot be trivially satisfiable.
- **Check whether the obvious predicate is the right one.** For \#210
  “two `before=TRUE` calls means doubled” is wrong; the discriminator is
  an *identical repeated call*.
- **Pair a snapshot with a plain property assertion.** A snapshot diff
  can be accepted carelessly; `opens == closes` cannot.
- **Say which instrument you chose and why** when the obvious one does
  not fit. Inheriting an instrument recommendation without re-checking
  its premise is how vacuous tests get written.
- **Don’t count a signature error as proof of a content bug**, and
  **don’t add a test that would pass if the wiring were broken**.
- **Don’t drop an invalid configuration by forcing flags to make it
  run.** Remove it and say why.

## Claims and premises

- **Re-verify the issue’s own framing against the code before
  implementing.** \#210 reads as a bug in this package; the functions it
  names exist nowhere in it. \#242 offered two readings of a wrong
  column name and the answer was a third — it belonged to the
  neighbouring schema.
- **Trace a pinned unit-level behaviour to its end-to-end consequence
  before honouring it.** A pin can encode an artifact of a broken path
  rather than a decision (#253). Three lines at the console can settle
  what three paragraphs of issue text framed as a matter of taste.
- **Look at the sibling implementations before treating an omission as
  an open design question.** In \#254 both neighbouring handlers set the
  label explicitly, which made it an omission rather than a choice.
- **Check reachability in both directions, including your own severity
  claims.** \#246 was filed as a cosmetic stray `:::` and was a complete
  render failure. Understating severity is as wrong as overstating it.
- **Make a scan match every form the thing can take.** A scan that
  under-reports looks exactly like a clean bill of health (#251).
- **Check that filtering you find is actually reached.** This package
  has had several arguments validated but never read (#232, \#245).
- **Don’t take a review comment at face value, in either direction.**
  When a comment says “if X”, run X. Verifying a *correct* comment is
  worth as much as refuting a wrong one — the severity, and sometimes
  the right fix, is in the mechanism.

## Code shape

- **Follow dead state all the way out** — parameter, return slot, loop
  variable, frame slot (#239).
- **Keep equal inputs mapping to equal outputs in name-generating
  helpers.** A positional fallback in
  [`filename_sanitizer()`](https://nifu-no.github.io/saros.base/reference/filename_sanitizer.md)
  split one chapter across three folders.
- **Give one `@param` tag one default.** Shared tags are how several
  documented defaults drifted unnoticed (#251).
- **Don’t hand-escape braces as `\{` inside `\code{}`** — it is not an
  escape and the backslash survives into rendered help. Inline code
  spans need *balanced* braces, not escaped ones. The same `\{` inside
  `\emph{}` does unescape.
- The package uses
  **[`rlang::arg_match()`](https://rlang.r-lib.org/reference/arg_match.html),
  not [`match.arg()`](https://rdrr.io/r/base/match.arg.html)**. For
  those arguments the documented first element is the effective default.
- **Preserve existing behaviour exactly, including bugs, and file the
  bug separately.**
- **Amend an unreleased `NEWS.md` claim in place** rather than
  superseding it with a later note — check the version first; `*.9001`
  has not shipped. Otherwise one unreleased section ends up holding two
  contradictory entries.

## Git

- **Don’t switch branches in a working tree an agent is using.** Query
  with `gh` and `git log <ref>` / `git diff <ref>...<ref>` instead of
  `checkout`.
- **Don’t trust `git branch --merged` after a squash merge** — it lists
  nothing, because the branch commits are not ancestors of `main`.
  Verify content instead: `git diff main..<branch>` with zero insertions
  means nothing would be lost. Read any insertions before
  force-deleting.
- **Merged branches are not deleted automatically**, and
  `git remote prune` only drops refs already gone upstream. Delete them
  explicitly.
- **Check `git status` before `git add`, and never `git add -A` here.**
- **Diagnose an “empty diff” with `git ls-files --eol`** before
  believing any story about it. Note `git show :<file>` *applies* EOL
  conversion, so it gives the wrong answer; `git cat-file blob` and
  `git ls-files --eol` are honest.
- **Don’t run a script that reverts the tree against uncommitted work.**
  Guard it:
  `if [ -n "$(git status --porcelain R/)" ]; then echo ABORT; exit 1; fi`

## CI

- **Check CI on `main` after merging, not only on the PR.** Each PR
  passes against its own base; the merged combination is a shape nothing
  tested until it exists.
- **Give every CI guard a reachable green state.**
- **Read the annotation before debugging a CI failure.** A session once
  lost ~9 hours to `The job was not acquired by Runner of type hosted` —
  infrastructure, not code.

## Subagents

- **Verify a subagent’s work yourself before shipping it.** Read the
  diff, re-run the tests, reproduce the strongest factual claim.
- **Expect a subagent to die mid-run and leave uncommitted work.**
- **Send scope corrections immediately** — they are delivered at the
  agent’s next tool round.
- **Tell an agent what NOT to fix, and why.** Flagging rather than
  silently correcting is what surfaces a question for a maintainer
  decision.
