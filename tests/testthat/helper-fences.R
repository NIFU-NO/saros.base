# Div-fence accounting for GH #246, shared by the two layers that guard it:
# the template-store scan in test-chunk_templates.R and the emitted-.qmd
# property assertion in test-qmd_snapshots.R. Single-sourced deliberately --
# the two layers only mean anything if they agree on what a fence is.
#
# Pandoc div syntax: an opening fence is three or more colons followed by an
# attribute block (`::: {#tbl-x}`) or a bare word class (`::: panel-tabset`); a
# closing fence is the colons alone. draft_report() emits trailing whitespace
# on both, so the closing pattern tolerates it.
#
# Colon *width* is deliberately not tracked. Pandoc uses it to disambiguate
# nesting, but the default templates nest with a uniform `:::`, and counting
# widths separately would report a template as unbalanced for a legal style
# choice rather than for the defect this guards.

fence_open_pattern <- "^:::+[ \t]*[{[:alnum:]]"
fence_close_pattern <- "^:::+[ \t]*$"

# Both patterns are line-anchored, so a `:::` inside an R string literal is not
# counted -- variants 2 and 4 build child documents from quoted vectors of
# markdown lines, where every such line begins with a quote.
fence_balance <- function(text) {
  lines <- unlist(strsplit(paste(text, collapse = "\n"), "\n", fixed = TRUE))
  opens <- grepl(fence_open_pattern, lines)
  closes <- grepl(fence_close_pattern, lines)
  depth <- cumsum(opens - closes)

  list(
    opens = sum(opens),
    closes = sum(closes),
    # Counts can balance while the order is wrong (`:::` before its opener), so
    # the running depth is reported separately: a negative minimum means a
    # close preceded its open.
    min_depth = if (length(depth)) min(depth) else 0,
    final_depth = if (length(depth)) depth[length(depth)] else 0
  )
}
