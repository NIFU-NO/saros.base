# Variants available from the package's internal template store.
#
# Lives in a helper rather than in test-chunk_templates.R because
# test-qmd_snapshots.R needs it too, and testthat sources each test file into
# its own environment.
chunk_template_variants <- function() {
  names <- grep("^default_chunk_templates_", names(saros.base:::.saros.env), value = TRUE)
  sort(as.integer(sub("^default_chunk_templates_", "", names)))
}
