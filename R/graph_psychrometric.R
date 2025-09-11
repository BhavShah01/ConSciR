#' Create a Psychrometric Chart
#'
#' @description
#' This function generates a psychrometric chart based on input temperature and relative humidity data.
#'
#' @details
#' Humidity and conservation functions can be used for the y-axis.
#'
#' \itemize{
#'    \item calcHR: Humidity Ratio (g/kg)
#'    \item calcMR: Mixing Ratio (g/kg)
#'    \item calcAH: Absolute Humidity (g/m^3)
#'    \item calcSH: Specific Humidity (g/kg)
#'    \item calcAD: Air Density (kg/m^3)
#'    \item calcDP: Dew Point (°C)
#'    \item calcFP: Frost Point (°C)
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
#' @param data_col Name of column to use for colouring points. Default is "Sensor" if present, otherwise "RH".
#' @param data_alpha Value to supply for make points more or less transparent. Default is 0.5.
#' @param LowT Numeric value for lower temperature limit of the target range. Default is 16°C.
#' @param HighT Numeric value for upper temperature limit of the target range. Default is 25°C.
#' @param LowRH Numeric value for lower relative humidity limit of the target range. Default is 40\%.
#' @param HighRH Numeric value for upper relative humidity limit of the target range. Default is 60\%.
#' @param Temp_range Numeric vector of length 2 specifying the overall temperature range for the chart. Default is c(0, 40).
#' @param y_func Function to calculate y-axis values. See above for options, default is mixing ratio (`calcMR`).
#' @param ... Additional arguments passed to y_func.
#'
#' @return A ggplot object representing the psychrometric chart.
#'
#' @importFrom stats quantile
#' @importFrom ggplot2 ggplot geom_line geom_text geom_segment geom_point lims labs
#' guides aes coord_cartesian annotate
#' @importFrom dplyr rename mutate group_by filter
#' @export
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 100)
#'
#' # Basic usage with default settings
#' graph_psychrometric(mydata, Temp, RH)
#'
#' # Custom temperature and humidity ranges
#' graph_psychrometric(mydata, Temp, RH, LowT = 8, HighT = 28, LowRH = 30, HighRH = 70)
#'
#' # Using a different psychrometric function (e.g., Absolute Humidity)
#' graph_psychrometric(mydata, Temp, RH, y_func = calcAH)
#'
#' # Adjusting the overall temperature range of the chart
#' graph_psychrometric(mydata, Temp, RH, Temp_range = c(12, 30))
#'
#'
#'
graph_psychrometric <- function(mydata,
                                Temp = "Temp", RH = "RH",
                                data_col = NULL,
                                data_alpha = 0.5,
                                LowT = 16, HighT = 25,
                                LowRH = 40, HighRH = 60,
                                Temp_range = c(0, 40),
                                y_func = "calcMR",
                                ...) {
  if (!requireNamespace("ggplot2", quietly = TRUE) || !requireNamespace("dplyr", quietly = TRUE)) {
    stop("Packages 'ggplot2' and 'dplyr' are required to produce graph.
         Run `install.packages(c('ggplot2', 'dplyr'))` ")
  }

  # Default colour column
  if (is.null(data_col)) {
    if ("Sensor" %in% names(mydata)) {
      data_col <- "Sensor"
    } else {
      data_col <- "RH"
    }
  }

  # Convert y_func string to function
  if (is.character(y_func)) {
    y_func_name <- y_func
    y_func <- match.fun(y_func)
  } else {
    # For safety if user passes function directly
    y_func_name <- deparse(substitute(y_func))
  }

  # Convert column names to symbols
  Temp <- rlang::ensym(Temp)
  RH <- rlang::ensym(RH)
  data_col <- rlang::ensym(data_col)

  # Calculate y axis values with selected function
  mydata <- mydata |>
    dplyr::filter(!is.na(!!Temp) & !is.na(!!RH)) |>
    dplyr::mutate(y_Axis = y_func(!!Temp, !!RH, ...))

  # Background grid and labels
  ref_Temp <- seq(Temp_range[1], Temp_range[2], by = 1)
  ref_RH <- seq(0, 100, by = 10)

  background_df <- expand.grid(ref_Temp, ref_RH) |>
    dplyr::rename("ref_Temp" = "Var1", "ref_RH" = "Var2") |>
    dplyr::mutate(y_Axis = y_func(ref_Temp, ref_RH, ...))

  background_labels <- background_df |>
    dplyr::group_by(ref_RH) |>
    dplyr::filter(ref_Temp == stats::quantile(ref_Temp, 0.10))

  envelope_df <- data.frame(Temp = seq(LowT, HighT, by = 1)) |>
    dplyr::mutate(
      y_Low = y_func(Temp, LowRH, ...),
      y_High = y_func(Temp, HighRH, ...)
    )

  # Y limits for plot
  y_limit_left_low <- y_func(LowT, LowRH, ...)
  y_limit_left_high <- y_func(LowT, HighRH, ...)
  y_limit_right_low <- y_func(HighT, LowRH, ...)
  y_limit_right_high <- y_func(HighT, HighRH, ...)
  y_limit_low <- y_func(Temp_range[1], 10, ...)
  y_limit_high <- y_func(Temp_range[2], 50, ...)

  limit_description <- paste0("Envelope: ", LowT, "-", HighT, "C and ", LowRH, "-", HighRH, "%RH")

  y_axis_label <- switch(
    y_func_name,
    "calcHR" = "Humidity Ratio (g/kg)",
    "calcMR" = "Mixing Ratio (g/kg)",
    "calcAH" = "Absolute Humidity (g/m^3)",
    "calcSH" = "Specific Humidity (g/kg)",
    "calcAD" = "Air Density (kg/m^3)",
    "calcDP" = "Dew Point (C)",
    "calcFP" = "Frost Point (C)",
    "calcEnthalpy" = "Enthalpy (kJ/kg)",
    "calcPws" = "Saturation vapor pressure (hPa)",
    "calcPw" = "Water Vapour Pressure (hPa)",
    "calcPI" = "Preservation Index",
    "calcLM" = "Lifetime",
    "calcEMC_wood" = "Equilibrium Moisture Content (wood)",
    NULL
  )

  p <-
    ggplot2::ggplot(mydata) +
    ggplot2::geom_point(aes(x = !!Temp, y = y_Axis, col = !!data_col),
                        alpha = data_alpha) +
    ggplot2::geom_line(aes(x = ref_Temp, y = y_Axis, group = ref_RH, alpha = ref_RH),
                       col = 'grey', data = background_df) +
    ggplot2::geom_text(aes(x = ref_Temp, y = y_Axis, label = ref_RH),
                       vjust = -0.5, check_overlap = TRUE, size = 2,
                       data = background_labels) +
    ggplot2::annotate("segment",
                      x = LowT, xend = LowT,
                      y = y_limit_left_low, yend = y_limit_left_high,
                      alpha = 0.7, col = "darkred", size = 0.8) +
    ggplot2::annotate("segment",
                      x = HighT, xend = HighT,
                      y = y_limit_right_low, yend = y_limit_right_high,
                      alpha = 0.7, col = "darkred", size = 0.8) +
    ggplot2::geom_line(aes(x = Temp, y = y_Low),
                       col = "darkblue", alpha = 0.7, size = 0.8, data = envelope_df) +
    ggplot2::geom_line(aes(x = Temp, y = y_High),
                       col = "darkblue", alpha = 0.7, size = 0.8, data = envelope_df) +
    ggplot2::coord_cartesian(xlim = c(Temp_range[1], Temp_range[2]),
                             ylim = c(y_limit_low, y_limit_high)) +
    ggplot2::labs(x = "Temperature (C)", y = y_axis_label, caption = limit_description) +
    ggplot2::guides(alpha = "none")

  return(p)
}
