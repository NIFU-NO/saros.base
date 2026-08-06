ungroup_data <- function(data) {
  if (inherits(data, "survey")) {
    rlang::check_installed("srvyr", reason = "to ungroup survey objects.")
    srvyr::ungroup(data)
  } else {
    dplyr::ungroup(data)
  }
}
