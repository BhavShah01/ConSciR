#' Graph a bivariate plot of temperature and humidity data
#'
#' @description
#' Plots temperature vs relative humidity points coloured by a selected environmental metric
#' calculated from temperature and humidity variables using ConSciR functions.
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
#' @param mydata A data frame containing temperature (Temp) and relative humidity (RH) columns.
#' @param Temp The name of the column in mydata containing temperature data ("Temp").
#' @param RH The name of the column in mydata containing relative humidity data ("RH").
#' @param z_func A character string specifying which environmental metric function to use. See details for options (default `none`).
#' @param facet_by Name of categorical column to facet by; defaults to "Sensor".
#' @param LowT Numeric value for lower temperature limit of the target range. Default is 16°C.
#' @param HighT Numeric value for upper temperature limit of the target range. Default is 25°C.
#' @param LowRH Numeric value for lower relative humidity limit of the target range. Default is 40\%.
#' @param HighRH Numeric value for upper relative humidity limit of the target range. Default is 60\%.
#' @param Temp_range Numeric vector of length two defining x-axis plot limits for temperature.
#' @param RH_range Numeric vector of length two defining y-axis plot limits for relative humidity.
#' @param alpha Numeric transparency level for points.
#' @param limit_caption Character string caption describing plot limits.
#'
#' @return A ggplot2 plot object showing temperature vs relative humidity colored by the selected metric,
#' with annotated boundary segments.
#'
#' @importFrom dplyr mutate case_when
#' @importFrom ggplot2 ggplot annotate geom_point lims labs theme_bw scale_colour_viridis_c theme element_text unit
#' @importFrom stats as.formula
#' @importFrom dplyr mutate case_when
#' @export
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 100)
#'
#' graph_TRHbivariate(
#'   mydata,
#'   z_func = "calcAH",
#'   LowT = 16, HighT = 25,
#'   LowRH = 40, HighRH = 60,
#'   Temp_range = c(0, 40),
#'   RH_range = c(0, 100),
#'   alpha = 0.7,
#'   limit_caption = "Example limit box"
#' )
#'
graph_TRHbivariate <- function(mydata,
                               Temp = "Temp",
                               RH = "RH",
                               z_func = "none",
                               facet_by = "Sensor",
                               LowT = 16, HighT = 25,
                               LowRH = 40, HighRH = 60,
                               Temp_range = c(0, 40),
                               RH_range = c(0, 100),
                               alpha = 0.5,
                               limit_caption = "") {

  mydata <-
    mydata |>
    dplyr::mutate(
      ColorValue = dplyr::case_when(
        z_func == "none" ~ NA_real_,
        z_func == "calcMR" ~ calcMR(.data[[Temp]], .data[[RH]]),
        z_func == "calcHR" ~ calcHR(.data[[Temp]], .data[[RH]]),
        z_func == "calcAH" ~ calcAH(.data[[Temp]], .data[[RH]]),
        z_func == "calcSH" ~ calcSH(.data[[Temp]], .data[[RH]]),
        z_func == "calcAD" ~ calcAD(.data[[Temp]], .data[[RH]]),
        z_func == "calcDP" ~ calcDP(.data[[Temp]], .data[[RH]]),
        z_func == "calcEnthalpy" ~ calcEnthalpy(.data[[Temp]], .data[[RH]]),
        z_func == "calcPws" ~ calcPws(.data[[Temp]], .data[[RH]]),
        z_func == "calcPw" ~ calcPw(.data[[Temp]], .data[[RH]]),
        z_func == "calcPI" ~ calcPI(.data[[Temp]], .data[[RH]]),
        z_func == "calcLM" ~ calcLM(.data[[Temp]], .data[[RH]]),
        z_func == "calcEMC_wood" ~ calcEMC_wood(.data[[Temp]], .data[[RH]]),
        TRUE ~ NA_real_
      )
    )

  p <-
    ggplot2::ggplot(mydata) +
    ggplot2::geom_point(ggplot2::aes_string(x = Temp, y = RH, col = "ColorValue"), alpha = alpha) +
    ggplot2::annotate("segment",
                      x = LowT, xend = LowT,
                      y = LowRH, yend = HighRH,
                      alpha = 0.7, col = "darkred", size = 1) +
    ggplot2::annotate("segment",
                      x = HighT, xend = HighT,
                      y = LowRH, yend = HighRH,
                      alpha = 0.7, col = "darkred", size = 1) +
    ggplot2::annotate("segment",
                      x = LowT, xend = HighT,
                      y = LowRH, yend = LowRH,
                      alpha = 0.7, col = "darkblue", size = 1) +
    ggplot2::annotate("segment",
                      x = LowT, xend = HighT,
                      y = HighRH, yend = HighRH,
                      alpha = 0.7, col = "darkblue", size = 1) +

    ggplot2::lims(x = Temp_range, y = RH_range) +
    ggplot2::labs(x = "Temperature (C)", y = "Humidity (%)", col = z_func, caption = limit_caption) +
    ggplot2::theme_bw() +
    ggplot2::scale_colour_viridis_c()

  # Facet by Sensor (default) if the column is present
  if (!is.null(facet_by) && facet_by %in% names(mydata)) {
    p <- p + ggplot2::facet_wrap(as.formula(paste("~", facet_by)))
  }

  return(p)
}
