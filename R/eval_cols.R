
eval_cols <- function(x, data,
                      call = rlang::caller_env()) {
  check_string(x = x, n = NULL, null.ok = FALSE, call = call)
  check_data_frame(data, call = call)
  x_cond_evaluate <- !is.na(x) & stringi::stri_length(x)>0
  lapply(seq_along(x), function(i) {
    if(x_cond_evaluate[i]) {
      expr <- stringi::stri_c('tidyselect::eval_select(expr = rlang::expr(c(',
                              x[i],
                              ')), data = data)',
                              ignore_null=TRUE)
      out <- rlang::try_fetch(eval(parse(text = expr)),
                              error = function(e) cli::cli_abort("Column {.var {x[i]}} doesn't exist in data.",
                                                                 call = call)
      )

    } else out <- NA_integer_
  })

}
