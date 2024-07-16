
get_authors <- function(data, col) {
  if(!is.null(data[[col]]) &&
     !all(is.na(data[[col]]))) {

    if(is.factor(data[[col]])) {

      return(levels(data[[col]]))

    } else if(is.character(data[[col]])) {

      return(unique(data[[col]]))

    } else cli::cli_abort("{.arg {col}} must be factor or character, not {.obj_type_friendly {data[[col]]}}.")
  } else ''
}

#' Given Ordered Integer Vector, Return Requested Set.
#'
#' Useful for identifying which categories are to be collected.
#'
#' @param vec A vector of any type.
#' @param set A character string, one of c(".top", ".upper", ".mid_upper", ".lower",
#'   ".mid_lower", ".bottom")
#' @param spread_n The number of values to extract when set is "spread".
#' @param sort Whether to sort the output, defaults to FALSE.
#' @return Selected set of vector.
#' @export
#' @examples
#' subset_vector(vec=1:7, set=".mid_lower")

subset_vector <-
  function(vec,
           set=c(".top", ".upper", ".mid_upper",
                 ".lower", ".mid_lower", ".bottom", ".spread"),
           spread_n=NULL,
           sort=FALSE) {

	set <- rlang::arg_match(set)
	n <- length(vec)
	if(sort) vec <- sort(vec)
	if(n %in% 0:1) {
		vec
	} else if(set==".top") {
		vec[n]
	} else if(set==".bottom") {
		vec[1]
	} else if(n %% 2 == 0L & set!=".spread") {
		if(set %in% c(".mid_upper", ".upper")) {
			vec[(n/2+1):n]
		} else if(set %in% c(".mid_lower", ".lower")) {
			vec[1:(n/2)]
		}
	} else {
		m <- stats::median(seq_len(n))
		if(set==".upper") {
			vec[(m+1):n]
		} else if(set==".lower") {
			vec[1:(m-1)]
		} else if(set==".mid_upper") {
			vec[m:n]
		} else if(set==".mid_lower") {
			vec[1:m]
		} else if(set==".spread") {
			if(n == spread_n) {
				vec
			} else {
				max_set <- c()
				if(n %% 2 != 0L) {
					if(spread_n == 1L) {
						m
					}
					if(spread_n %% 2 != 0L) {
						max_set <- c(max_set, m)
					}
					if(spread_n > 1L) {
						max_set <- c(max_set, 1L, n)
					}
					if(spread_n > 4L) {
						max_set <- c(max_set, 2L, n-1L)
					}
					if(spread_n > 5L | spread_n == 4) {
						max_set <- c(max_set, 3L, n-2L)
					}
					if(spread_n > 6L) {
						max_set <- c(max_set, 4L, n-3L)
					}
				} else if(n %% 2L == 0L) {
					if(spread_n > 1L) {
						max_set <- c(max_set, 1L, n)
					}
					if(spread_n > 3L & n <= 6) {
						max_set <- c(max_set, 2L, n-1L)
					}
					if(spread_n > 4L | (spread_n>3L & n > 6)) {
						max_set <- c(max_set, 3L, n-2L)
					}
					if(spread_n %% 2 != 0L) {
						m <- round(stats::median(seq_len(n)))
						max_set <- c(max_set, m)
					}
				}
				unique(vec[sort(max_set)])
			}
		}
	}
}



###  Check that all pairs of cols share at least one observed response category
check_category_pairs <-
  function(data, cols_pos, call = rlang::caller_env(), return_error=TRUE) {
    lapply(X = seq_along(cols_pos), FUN = function(i) {
      x <- unname(cols_pos)[[i]]
      y <- names(cols_pos)[[i]]

      cols_rest <-
        cols_pos[-c(1:match(y, names(cols_pos)))]
      lapply(X = seq_along(cols_rest), FUN = function(e) {
        x2 <- unname(cols_rest)[[e]]
        y2 <- names(cols_rest)[[e]]

                     val_y <- if(is.factor(data[[y]])) levels(data[[y]]) else unique(data[[y]])
                     val_y2 <- if(is.factor(data[[y2]])) levels(data[[y2]]) else unique(data[[y2]])
                     common <- dplyr::intersect(val_y, val_y2)
                     if(length(common) == 0L) {
                       cli::cli_abort(
                         c("Unequal variables.",
                           "!" = "All variables must share at least one common category.",
                           "i" = "Column {.var {y}} and column {.var {y2}} lack common categories."
                         ),
                         call = call)
                     }
                   })
    })
    TRUE
  }

trim_columns <- function(data, cols = c(".variable_label_prefix_dep", ".variable_label_prefix_dep",
                                        ".variable_label_prefix_indep", ".variable_label_suffix_indep")) {
  for(col in cols) {
    if(is.character(data[[col]])) {
      data[[col]] <- stringi::stri_trim_both(data[[col]])
      data[[col]] <- stringi::stri_replace_all_regex(data[[col]], pattern = "[[:space:]]+", replacement = " ")
    }
  }
  data
}

# get_main_question <-
#   function(data, cols_pos, label_separator) {
#   x <- unlist(lapply(data[, cols_pos], FUN = function(.x) attr(.x, "label")))
#   x <- unname(x)
#   x <-
#     stringi::stri_replace(string = x,
#                          regex = stringi::stri_c(ignore_null=TRUE, "(^.*)", label_separator, "(.*$)"),
#                          replacement = "$1")
#   x <- unique(x)
#   x <-
#     stringi::stri_c(ignore_null=TRUE, x, collapse="\n")
#   x
# }


create_text_collapse <-
  function(text = NULL,
           last_sep = NULL) {
    if(!is_string(last_sep)) last_sep <-
        eval(formals(draft_report)$translations)$last_sep
    cli::ansi_collapse(text, sep2 = last_sep, last = last_sep)
  }

# are all elements of list x identical to each other?
compare_many <- function(x) {
  all(unlist(lapply(as.list(x[-1]),
                    FUN = function(.x) identical(.x, x[[1]])))) ||
    nrow(x[[1]])==1
}




replace_label_groups_with_name_groups <- function(chapter_structure) {
  grouping_structure <- dplyr::group_vars(chapter_structure)
  if(is.null(grouping_structure)) cli::cli_warn("{.arg chapter_structure} should be grouped by a subset of columns.")
  grouping_structure[grouping_structure %in%
                       c(".variable_label_prefix_dep", ".variable_label_suffix_dep")] <- ".variable_name_dep"
  grouping_structure[grouping_structure %in%
                       c(".variable_label_prefix_indep", ".variable_label_suffix_indep")] <- ".variable_name_indep"
  grouping_structure <- unique(grouping_structure)
  chapter_structure <- dplyr::group_by(chapter_structure, dplyr::pick(tidyselect::all_of(grouping_structure)))
  chapter_structure
}
