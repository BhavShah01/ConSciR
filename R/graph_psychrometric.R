#' Psychrometric chart from temperature and humidity
#'
#' @description
#' Produces a psychrometric chart from temperature and humidity data.
#'
#'
#' @param mydata A data frame containing temperature and humidity data.
#' @param Temp Column name in mydata for temperature values.
#' @param RH Column name in mydata for relative humidity values.
#' @param LowT Numeric value for low temperature limit.
#' @param HighT Numeric value for high temperature limit.
#' @param LowRH Numeric value for low relative humidity limit.
#' @param HighRH Numeric value for high relative humidity limit.
#'
#' @return A ggplot object representing the psychrometric chart.
#' @export
#'
#' @importFrom ggplot2 ggplot geom_segment geom_line geom_point scale_color_viridis_d scale_fill_viridis_d labs lims theme_bw aes
#'
#' @importFrom dplyr mutate filter %>%
#'
#' @examples
#' data <- data.frame(Temp = c(20, 25, 30), RH = c(50, 60, 70))
#' graph_psychrometric(data, Temp, RH, LowT = 15, HighT = 25, LowRH = 40, HighRH = 60)
#'
#' graph_psychrometric(head(mydata), Temp, RH, LowT = 15, HighT = 25, LowRH = 40, HighRH = 60)
#'
#'
graph_psychrometric <- function(mydata, Temp, RH, LowT, HighT, LowRH, HighRH) {

  # Check if required packages are installed
  if (!requireNamespace("ggplot2", quietly = TRUE) || !requireNamespace("dplyr", quietly = TRUE)) {
    stop("Packages 'ggplot2' and 'dplyr' are required for this function.")
  }

  # Create reference data frame
  mydf <- data.frame(Temp = seq(from = -5, to = 45, by = 0.5)) |>
    dplyr::mutate(
      AbsLow = calcAH(Temp, LowRH),
      AbsHigh = calcAH(Temp, HighRH),
      AbsUpper = calcAH(Temp, 100)
    )

  # Calculate absolute humidity for input data
  mydata <- mydata |>
    dplyr::mutate(Abs = calcAH(Temp, RH))

  # Create the plot
  ggplot2::ggplot(mydata) +
    ggplot2::geom_segment(alpha = 0.5, col = "red", size = 1,
                          aes(x = LowT, xend = LowT, y = 0, yend = 20)) +
    ggplot2::geom_segment(alpha = 0.5, col = "red", size = 1,
                          aes(x = HighT, xend = HighT, y = 0, yend = 20)) +
    ggplot2::geom_line(aes(x = Temp, y = AbsLow), data = mydf,
                       col = 'blue', alpha = 0.5, size = 1) +
    ggplot2::geom_line(aes(x = Temp, y = AbsHigh), data = mydf,
                       col = 'blue', alpha = 0.5, size = 1) +
    ggplot2::geom_line(aes(x = Temp, y = AbsUpper), data = mydf,
                       col = 'grey', alpha = 0.5, size = 1) +
    ggplot2::geom_point(aes(x = Temp, y = Abs), alpha = 0.5, col = "purple") +
    # ggplot2::scale_color_viridis_d(option = "D") +
    # ggplot2::scale_fill_viridis_d(option = "D") +
    ggplot2::labs(x = "Temperature (C)", y = "Absolute humidity (g/m^3)") +
    ggplot2::lims(x = c(-5, 45), y = c(0, 20))
}
