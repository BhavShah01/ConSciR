#' Create a Psychrometric Chart from a dataframe
#'
#' @description
#' This function generates a psychrometric chart based on input temperature,
#' relative humidity, and y-axis data.
#'
#' Various psychrometric functions can be used for the y-axis if supplied in the data frame:
#'
#' \itemize{
#'    \item calcHR: Humidity Ratio (g/kg)
#'    \item calcMR: Mixing Ratio (g/kg)
#'    \item calcAH: Absolute Humidity (g/m^3)
#'    \item calcSH: Specific Humidity (g/kg)
#'    \item calcAD: Air Density (kg/m^3)
#'    \item calcDP: Dew Point (C)
#'    \item calcEnthalpy: Enthalpy (kJ/kg)
#'    \item calcPws: Saturation vapor pressure (hPa)
#'    \item calcPw: Water Vapour Pressure (hPa)
#'    \item calcPI: Preservation Index
#'    \item calcIPI: Years to Degradation of reference material
#'    \item calcLM: Lifetime
#' }
#'
#'
#' @param mydata A data frame containing temperature, relative humidity, and y-axis data.
#' @param Temp Column name in mydata for temperature values.
#' @param RH Column name in mydata for relative humidity values.
#' @param y_Axis Column name in mydata for y-axis values.
#' @param y_func Function to calculate y-axis values. See above for options and must be
#'  supplied if different from the default: calcMR (mixing ratio).
#' @param LowT Numeric value for lower temperature limit of the target range. Default is 16C.
#' @param HighT Numeric value for upper temperature limit of the target range. Default is 25C.
#' @param LowRH Numeric value for lower relative humidity limit of the target range. Default is 40\%.
#' @param HighRH Numeric value for upper relative humidity limit of the target range. Default is 60\%.
#' @param Temp_range Numeric vector of length 2 specifying the overall temperature range for the chart.
#'  Default is c(0, 40).
#' @param y_axis_label Character string for y-axis label. Default is "Y-axis".
#'
#' @return A ggplot object representing the psychrometric chart.
#'
#' @importFrom stats quantile
#' @importFrom ggplot2 ggplot geom_line geom_text geom_segment geom_point lims labs guides aes
#' @importFrom dplyr rename mutate group_by filter
#' @importFrom rlang ensym as_name
#'
#' @export
#'
#' @examples
#' # Basic use, don't need to specify y_func as calcMR is default
#' head(mydata) |> mutate(MixingRatio = calcMR(Temp, RH)) |> graph_psychrometric_df(y_Axis = MixingRatio)
#'
#' # Assuming mydata has Temp and RH columns then use a calculation to mutate the y-axis
#' # Must supply the y_func argument to ensure this function works
#' head(mydata) |> mutate(AbsHum = calcAH(Temp, RH)) |> graph_psychrometric_df(y_Axis = AbsHum, y_func = calcAH, y_axis_label = "Absolute Humidity (g/m^3)")
#'
#'
#'
#'
graph_psychrometric_df <- function(mydata,
                                   Temp = Temp, RH = RH,
                                   y_Axis, y_func = calcMR,
                                   LowT = 16, HighT = 25,
                                   LowRH = 40, HighRH = 60,
                                   Temp_range = c(0, 40),
                                   y_axis_label = "Y-axis", ...) {

  # Check if required packages are installed
  if (!requireNamespace("ggplot2", quietly = TRUE) || !requireNamespace("dplyr", quietly = TRUE)) {
    stop("Packages 'ggplot2' and 'dplyr' are required to produce graph.
         Run `install.packages(c('ggplot2', 'dplyr'))` ")
  }

  # Ensure column names are treated as symbols
  Temp = rlang::ensym(Temp)
  RH = rlang::ensym(RH)
  y_Axis = rlang::ensym(y_Axis)

  # Create background grid 10-100%RH with 10RH% resolution
  ref_Temp = seq(from = Temp_range[1], to = Temp_range[2], by = 1)
  ref_RH = seq(from = 10, to = 100, by = 10)

  background_df <-
    expand.grid(ref_Temp, ref_RH) |>
    dplyr::rename("ref_Temp" = "Var1", "ref_RH" = "Var2") |>
    dplyr::mutate(y_Axis = y_func(ref_Temp, ref_RH, ...))

  # Background labels
  background_labels =
    background_df |>
    dplyr::group_by(ref_RH) |>
    dplyr::filter(ref_Temp == stats::quantile(ref_Temp, 0.10)) # label lines near start of Temp

  # Create a data frame for the envelope
  envelope_df =
    data.frame(Temp = seq(from = LowT, to = HighT, by = 1)) |>
    dplyr::mutate(
      y_Low = y_func(Temp, LowRH, ...),
      y_High = y_func(Temp, HighRH, ...)
    )

  # Calculate the bounds of the TRH envelope and the y-axis
  y_limit_left_low <- y_func(LowT, LowRH, ...)
  y_limit_left_high <- y_func(LowT, HighRH, ...)
  y_limit_right_low <- y_func(HighT, LowRH, ...)
  y_limit_right_high <- y_func(HighT, HighRH, ...)
  y_limit_low <- y_func(Temp_range[1], 10, ...)
  y_limit_high <- y_func(Temp_range[2], 50, ...) # Places 50%RH line at top right corner

  # Create the plot
  p <- ggplot2::ggplot(mydata) +

    # Add reference lines
    ggplot2::geom_line(ggplot2::aes(x = ref_Temp, y = y_Axis, group = ref_RH, alpha = ref_RH),
                       col = 'grey', data = background_df) +

    # Label reference lines
    ggplot2::geom_text(ggplot2::aes(x = ref_Temp, y = y_Axis, label = ref_RH), vjust = -0.5,
                       check_overlap = TRUE, size = 2, data = background_labels) +

    # Temperature left bounds of envelope
    ggplot2::geom_segment(alpha = 0.5, col = "red", size = 1,
                          ggplot2::aes(x = LowT, xend = LowT,
                                       y = y_limit_left_low, yend = y_limit_left_high)) +

    # Temperature right bounds of envelope
    ggplot2::geom_segment(alpha = 0.5, col = "red", size = 1,
                          ggplot2::aes(x = HighT, xend = HighT,
                                       y = y_limit_right_low, yend = y_limit_right_high)) +

    # Humidity lower bounds of envelope
    ggplot2::geom_line(ggplot2::aes(x = Temp, y = y_Low),
                       col = 'blue', alpha = 0.5, size = 1, data = envelope_df) +

    # Humidity upper bounds of envelope
    ggplot2::geom_line(ggplot2::aes(x = Temp, y = y_High),
                       col = 'blue', alpha = 0.5, size = 1, data = envelope_df) +

    # Overlay your TRH data
    ggplot2::geom_point(ggplot2::aes(x = !!Temp, y = !!y_Axis, col = !!RH), alpha = 0.5) +

    # Add limits to x and y axis
    ggplot2::lims(x = c(Temp_range[1], Temp_range[2]), y = c(y_limit_low, y_limit_high)) +

    # Add labels to the chart
    ggplot2::labs(x = "Temperature (C)", y = y_axis_label) +

    # Turn off the legend
    ggplot2::guides(alpha = "none")

  return(p)
}
