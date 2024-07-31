glue_err <- function(cnd, arg_name=NULL) {
  cli::cli_abort(c("Template is invalid",
                   x = "Problem with: {.arg {arg_name}}.",
                   i = "Check that curly braces are doubled if you really want to write a curly brace, e.g. {{{{r}}}}."),
                 parent = cnd)
}
