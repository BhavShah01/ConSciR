#' Create a Psychrometric Chart
#'
#' @description
#' This function generates a psychrometric chart based on input temperature and relative humidity data.
#'
#' Various psychrometric functions can be used for the y-axis.
#'
#' \itemize{
#'    \item calcHR: Humidity Ratio (g/kg)
#'    \item calcMR: Mixing Ratio (g/kg)
#'    \item calcAH: Absolute Humidity (g/m^3)
#'    \item calcSH: Specific Humidity (g/kg)
#'    \item calcAD: Air Density (kg/m^3)
#'    \item calcDP: Dew Point (°C)
#'    \item calcEnthalpy: Enthalpy (kJ/kg)
#'    \item calcPws: Saturation vapor pressure (hPa)
#'    \item calcPw: Water Vapour Pressure (hPa)
#'    \item calcPI: Preservation Index
#'    \item calcLM: Lifetime
#'    \item calcEMC_wood: Equilibrium Moisture Content (wood)
#' }
#'
#'
#' @param mydata A data frame containing temperature and relative humidity data.
#' @param Temp Column name in mydata for temperature values.
#' @param RH Column name in mydata for relative humidity values.
#' @param data_colour Column name to use to colour the data points. Default is "RH".
#' @param data_alpha Value to supply for make points more or less transparent. Default is 0.5.
#' @param LowT Numeric value for lower temperature limit of the target range. Default is 16°C.
#' @param HighT Numeric value for upper temperature limit of the target range. Default is 25°C.
#' @param LowRH Numeric value for lower relative humidity limit of the target range. Default is 40\%.
#' @param HighRH Numeric value for upper relative humidity limit of the target range. Default is 60\%.
#' @param Temp_range Numeric vector of length 2 specifying the overall temperature range for the chart. Default is c(0, 40).
#' @param y_func Function to calculate y-axis values. See above for options, default is calcMR (mixing ratio).
#' @param ... Additional arguments passed to y_func.
#'
#' @return A ggplot object representing the psychrometric chart.
#'
#' @importFrom stats quantile
#' @importFrom ggplot2 ggplot geom_line geom_text geom_segment geom_point lims labs
#' guides aes coord_cartesian annotate
#' @importFrom dplyr rename mutate group_by filter
#'
#' @export
#'
#' @examples
#'
#' # Basic usage with default settings
#' graph_psychrometric(head(mydata, 100), Temp, RH)
#'
#' # Custom temperature and humidity ranges
#' graph_psychrometric(head(mydata, 100), Temp, RH, LowT = 8, HighT = 28, LowRH = 30, HighRH = 70)
#'
#' # Using a different psychrometric function (e.g., Absolute Humidity)
#' graph_psychrometric(head(mydata, 100), Temp, RH, y_func = calcAH)
#'
#' # Adjusting the overall temperature range of the chart
#' graph_psychrometric(head(mydata, 100), Temp, RH, Temp_range = c(12, 30))
#'
#' # Change the colour of the points to a variable
#' graph_psychrometric(head(mydata, 100), Temp, RH, data_colour = "Sensor", y_func = calcDP)
#'
#'
graph_psychrometric <- function(mydata,
                                Temp = "Temp", RH = "RH",
                                data_colour = "RH",
                                data_alpha = 0.5,
                                LowT = 16, HighT = 25,
                                LowRH = 40, HighRH = 60,
                                Temp_range = c(0, 40),
                                y_func = calcMR,
                                 ...) {

  # Check if required packages are installed
  if (!requireNamespace("ggplot2", quietly = TRUE) || !requireNamespace("dplyr", quietly = TRUE)) {
    stop("Packages 'ggplot2' and 'dplyr' are required to produce graph.
         Run `install.packages(c('ggplot2', 'dplyr'))` ")
  }

  # Convert y_func to a function if it's a string
  if (is.character(y_func)) {
    y_func = match.fun(y_func)
  }
  y_func_name = deparse(substitute(y_func)) # function name as string

  # Column names are converted to symbols from the data
  Temp = rlang::ensym(Temp)
  RH = rlang::ensym(RH)
  data_colour = rlang::ensym(data_colour)

  # Calculate the variable for the y-axis
  mydata = mydata |>
    dplyr::filter(!is.na(!!Temp) & !is.na(!!RH)) |>
    dplyr::mutate(y_Axis = y_func(!!Temp, !!RH, ...))


  # Create background grid 10-100RH with 10RH resolution
  ref_Temp = seq(from = Temp_range[1], to = Temp_range[2], by = 1)
  ref_RH = seq(from = 0, to = 100, by = 10)

  background_df =
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
  y_limit_left_low = y_func(LowT, LowRH, ...)
  y_limit_left_high = y_func(LowT, HighRH, ...)
  y_limit_right_low = y_func(HighT, LowRH, ...)
  y_limit_right_high = y_func(HighT, HighRH, ...)
  y_limit_low = y_func(Temp_range[1], 10, ...)
  y_limit_high = y_func(Temp_range[2], 50, ...) # Places 50\%RH line at top right corner

  # Description of the envelope (for caption)
  limit_description =
    paste0("Envelope: ", LowT, " to ", HighT, "C and ", LowRH, " to ", HighRH, "%RH")

  # y-axis label
  y_axis_label =
    switch(y_func_name,
           "calcHR" = "Humidity Ratio (g/kg)",
           "calcMR" = "Mixing Ratio (g/kg)",
           "calcAH" = "Absolute Humidity (g/m^3)",
           "calcSH" = "Specific Humidity (g/kg)",
           "calcAD" = "Air Density (kg/m^3)",
           "calcDP" = "Dew Point (C)",
           "calcEnthalpy" = "Enthalpy (kJ/kg)",
           "calcPws" = "Saturation vapor pressure (hPa)",
           "calcPw" = "Water Vapour Pressure (hPa)",
           "calcPI" = "Preservation Index",
           "calcLM" = "Lifetime",
           "calcEMC_wood" = "Equilibrium Moisture Content (wood)",
           NULL)

  # Create the plot
  p <-
    ggplot2::ggplot(mydata) +

    # Add reference lines
    ggplot2::geom_line(aes(x = ref_Temp, y = y_Axis, group = ref_RH, alpha = ref_RH),
                       col = 'grey', data = background_df) +

    # Label reference lines
    ggplot2::geom_text(aes(x = ref_Temp, y = y_Axis, label = ref_RH), vjust = -0.5,
                       check_overlap = TRUE, size = 2, data = background_labels) +

    # Temperature left bounds of envelope
    ggplot2::annotate("segment",
                      x = LowT, xend = LowT,
                      y = y_limit_left_low, yend = y_limit_left_high,
                      alpha = 0.5, col = "red", size = 1) +

    # Temperature right bounds of envelope
    ggplot2::annotate("segment",
                      x = HighT, xend = HighT,
                      y = y_limit_right_low, yend = y_limit_right_high,
                      alpha = 0.5, col = "red", size = 1) +

    # Humidity lower bounds of envelope
    ggplot2::geom_line(aes(x = Temp, y = y_Low),
                       col = 'blue', alpha = 0.5, size = 1, data = envelope_df) +
    # Humidity upper bounds of envelope
    ggplot2::geom_line(aes(x = Temp, y = y_High),
                       col = 'blue', alpha = 0.5, size = 1, data = envelope_df) +

    # Overlay your TRH data
    ggplot2::geom_point(aes(x = !!Temp, y = y_Axis, col = !!data_colour),
                        alpha = data_alpha) +

    # Add limits to x and y axis
    ggplot2::coord_cartesian(xlim = c(Temp_range[1], Temp_range[2]),
                             ylim = c(y_limit_low, y_limit_high)) +

    # Add labels to the chart
    ggplot2::labs(x = "Temperature (C)", y = y_axis_label, caption = limit_description) +

    # Turn off the legend
    guides(alpha = "none")  # col = "none")

  return(p)
}
