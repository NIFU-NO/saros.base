
create_heading <- function(x, level = NULL,
                           arg = rlang::caller_arg(x),
                           call = rlang::caller_env()) {

  check_string(x, n = NULL, null.ok = TRUE, arg = arg, call = call)
  if(is.null(level)) level <- names(x)[1]
  stringi::stri_c(ignore_null=TRUE,
    strrep("#", times=level), " ",
    x[level])
}

