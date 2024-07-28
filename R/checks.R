err_msg <- function(infix) {
  stringi::stri_c(ignore_null=TRUE, "{.arg {arg}} must be a",
         infix,
         ", not {.obj_type_friendly {x}}.")
}


#' Is x A String?
#'
#' Returns TRUE if object is a character of length 1.
#'
#' @param x Object
#'
#' @return Bool
#' @export
#'
is_string <- function(x) {
  is.character(x) && length(x) == 1
}

check_string <- function(x, null.ok = FALSE, n = 1,
                         call = rlang::caller_env(),
                         arg = rlang::caller_arg(x)) {
  msg_suffix <- err_msg(stringi::stri_c(ignore_null=TRUE, " character vector",
                        if(!is.null(n)) " of length ",
                        if(!is.null(n)) n))
  if(is.null(x)) {
    if(!null.ok) {
      cli::cli_abort(message = msg_suffix, call = call)
    }
  } else if (!rlang::is_character(x, n=n)) {
    msg_prefix <- if(null.ok) "If not NULL, " else ""
    msg <- stringi::stri_c(ignore_null=TRUE, msg_prefix, msg_suffix)
    cli::cli_abort(message = msg, call = call)
  }
}



check_data_frame <- function(x, n=NULL, call = rlang::caller_env(),
                             arg = rlang::caller_arg(x)) {
  if(!inherits(x, "data.frame")) {
    cli::cli_abort(err_msg(" data.frame"),
                   call = call)
  }
  if(!is.null(n) && (ncol(x) == 0 || nrow(x) == 0)) {
    cli::cli_abort("{.arg {x} is an empty data frame.")
  }
}

