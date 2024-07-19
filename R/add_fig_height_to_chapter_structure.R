#' Estimate figure height for a horizontal barchart
#'
#' This function estimates the height of a figure for a horizontal barchart based on several parameters including the number of dependent and independent variables, number of categories, maximum characters in the labels, and legend properties.
#'
#' @param n_y Integer. Number of dependent variables.
#' @param n_cats_y Integer. Number of categories across the dependent variables.
#' @param max_chars_y Integer. Maximum number of characters across the dependent variables.
#' @param n_x Integer. Number of independent variables.
#' @param n_cats_x Integer. Number of categories across the independent variables.
#' @param max_chars_x Integer. Maximum number of characters across the independent variables.
#' @param freq Logical. If TRUE, frequency plot with categories next to each other. If FALSE (default), proportion plot with stacked categories.
#' @param x_axis_label_width Numeric. Width allocated for x-axis labels.
#' @param strip_angle Integer. Angle of the strip text.
#' @param main_font_size Numeric. Font size for the main text.
#' @param legend_location Character. Location of the legend ("panel" or "plot").
#' @param n_legend_lines Integer. Number of lines in the legend.
#' @param legend_key_chars_equivalence Integer. Approximate number of characters the legend key equals.
#' @param max_chars_per_figure_width Integer. Maximum number of characters per figure width.
#' @param multiplier_per_horizontal_line Numeric. Multiplier per horizontal line.
#' @param multiplier_per_vertical_letter Numeric. Multiplier per vertical letter.
#' @param multiplier_per_facet Numeric. Multiplier per facet.
#' @param multiplier_per_legend_line Numeric. Multiplier per legend line.
#' @param fixed_constant Numeric. Fixed constant to be added to the height.
#' @param figure_width_in_cm Numeric. Width of the figure in centimeters.
#' @param margin_in_cm Numeric. Margin in centimeters.
#' @param max Numeric. Maximum height.
#' @param min Numeric. Minimum height.
#'
#' @return Numeric value representing the estimated height of the figure.
#' @export
#'
#' @examples
#' fig_height_h_barchart(n_y = 5,
#'                       n_cats_y = 3,
#'                       max_chars_y = 10,
#'                       n_x = 2,
#'                       n_cats_x = 4,
#'                       max_chars_x = 12,
#'                       freq = FALSE,
#'                       x_axis_label_width = 20,
#'                       strip_angle = 0,
#'                       main_font_size = 8,
#'                       legend_location = "panel",
#'                       n_legend_lines = 2,
#'                       legend_key_chars_equivalence = 5,
#'                       max_chars_per_figure_width = 100,
#'                       multiplier_per_horizontal_line = NULL,
#'                       multiplier_per_vertical_letter = .15,
#'                       multiplier_per_facet = .95,
#'                       multiplier_per_legend_line = 1.5,
#'                       fixed_constant = 0,
#'                       figure_width_in_cm = 16,
#'                       margin_in_cm = 0,
#'                       max = 8,
#'                       min = 1)
fig_height_h_barchart <- # Returns a numeric value
  function(n_y,
           n_cats_y,
           max_chars_y = NULL,
           n_x = NULL,
           n_cats_x = NULL,
           max_chars_x = NULL,
           freq = FALSE,
           x_axis_label_width = 20,
           strip_angle = 0,
           main_font_size = 8,
           legend_location = c("panel", "plot"),
           n_legend_lines = 2,
           legend_key_chars_equivalence = 5,
           max_chars_per_figure_width = 100,
           multiplier_per_horizontal_line = NULL,
           multiplier_per_vertical_letter = .15,
           multiplier_per_facet = .95,
           multiplier_per_legend_line = 1.5,
           fixed_constant = 0,
           figure_width_in_cm = 16,
           margin_in_cm = 0,
           max = 8,
           min = 1) {

    check_integerish(n_y)
    check_integerish(n_cats_y)
    check_integerish(max_chars_y)
    check_integerish(n_x, null_allowed=TRUE)
    check_integerish(n_cats_x, null_allowed=TRUE)
    check_integerish(max_chars_x, null_allowed=TRUE)
    check_bool(freq)
    check_double(strip_angle)
    check_double(main_font_size)
    check_double(multiplier_per_horizontal_line, null_allowed=TRUE)
    check_double(multiplier_per_vertical_letter)
    check_double(multiplier_per_legend_line)
    check_integerish(legend_key_chars_equivalence)
    check_integerish(max_chars_per_figure_width)

    check_integerish(n_legend_lines, null_allowed= TRUE)
    check_integerish(fixed_constant)
    check_integerish(margin_in_cm)
    check_integerish(figure_width_in_cm)
    check_integerish(strip_angle)
    check_integerish(max)
    check_integerish(min)
    legend_location <- rlang::arg_match(legend_location, multiple = FALSE)

    if(is.null(multiplier_per_horizontal_line)) {
      multiplier_per_horizontal_line <- main_font_size/72.27
    }

    get_max_lines <- function(max_cat_char, width) {
      ceiling(max_cat_char / width)
    }

    # Function to estimate the number of categories that can fit on one line of a legend
    estimate_categories_per_line <- function(figure_width_cm = 12,
                                             max_chars_cats = 20, # Maximum characters across the categories
                                             font_size = 8,
                                             legend_key_chars = 5,
                                             margin_cm = 0) {
      # Calculate the width of one character in cm, assuming a monospace font approximation
      char_width_cm <- font_size * 0.035

      # Estimate the width per category in cm
      width_per_category_cm <- (legend_key_chars + max_chars_cats) * char_width_cm

      # Calculate the total available width for the legend in cm
      available_width_cm <- figure_width_cm - margin_cm * 2

      # Calculate the number of categories that can fit in one line
      categories_per_line <- available_width_cm / width_per_category_cm

      # Return the estimated number of categories per line
      floor(categories_per_line)
    }

    calculate_height <- function(strip_height,
                                 x_axis_height,
                                 n_facets = 1,
                                 n_legend_lines,
                                 multiplier_per_facet,
                                 multiplier_per_legend_line,
                                 fixed_constant) {

      max(c(strip_height, x_axis_height), na.rm=TRUE) * n_facets * multiplier_per_facet +
        n_legend_lines * multiplier_per_legend_line +
        fixed_constant
    }

    if(is.null(n_legend_lines)) {
      categories_per_line <-
        estimate_categories_per_line(figure_width_cm = figure_width_in_cm,
                                     max_chars_cats = max_chars_y, # Maximum characters across the categories
                                     font_size = main_font_size,
                                     legend_key_chars = legend_key_chars_equivalence,
                                     margin_cm = margin_in_cm)
      n_legend_lines <- ceiling(n_y / categories_per_line)
    }



    max_lines_y <- get_max_lines(max_cat_char = max_chars_y,
                                 width = x_axis_label_width)
    if(n_cats_y==0) unique_y_cats <- 1

    if(isFALSE(freq)) {
      n_cats_y <- 1
    }



    if(!is.null(n_x) && n_x > 0) {

      max_lines_x <- get_max_lines(max_cat_char = max_chars_x,
                                   width = x_axis_label_width)

      x_axis_height <-
        max(c(max_lines_x, n_cats_y), na.rm=TRUE) * multiplier_per_horizontal_line * n_cats_x
      n_facets <- n_y

      if (strip_angle >= 45 && strip_angle <= 135) { # vertical strip
        strip_height <-
          max_chars_y * multiplier_per_vertical_letter

      } else { # horizontal strip
        strip_height <-
          max_lines_y * multiplier_per_horizontal_line
      }

    } else { # Univariates
      x_axis_height <-
        max(c(max_lines_y, n_cats_y), na.rm=TRUE) *
        multiplier_per_horizontal_line * n_y
      strip_height <- NA
      n_facets <- 1

    }
    estimate <- calculate_height(strip_height = strip_height,
                                 x_axis_height = x_axis_height,
                                 n_facets = n_facets,
                                 n_legend_lines = n_legend_lines,
                                 multiplier_per_facet = multiplier_per_facet,
                                 multiplier_per_legend_line = multiplier_per_legend_line,
                                 fixed_constant = fixed_constant)
    plot_height <- max(c(min(c(estimate, max)), min))
    round(plot_height, digits=2)
  }

