#' Calculate Temperature from relative humidity and dew point
#'
#' @description
#' This function calculates the temperature (Celsius) from relative humidity (\%) and dew point temperature (C).
#'
#' @details
#' The temperature is calculated using the following equation derived from the August-Roche-Magnus approximation:
#'
#' \deqn{Temp = \frac{243.04 \times (\frac{17.625 \times DewP}{243.04 + DewP} - \log(\frac{RH}{100}))}{17.625 + \log(\frac{RH}{100}) - \frac{17.625 \times DewP}{243.04 + DewP}}}
#'
#' Where:
#' \itemize{
#'   \item \eqn{Temp} is the calculated temperature in Celsius
#'   \item \eqn{RH} is the relative humidity in percent
#'   \item \eqn{DewP} is the dew point temperature in Celsius
#' }
#'
#'
#' @param RH Relative Humidity (0-100\%)
#' @param DewP Td, Dew Point (Celsius)
#'
#' @return Temp, Temperature (Celsius)
#' @export
#'
#' @examples
#' # Calculate temperature for RH of 50% and dew point of 15C
#' calcTemp(50, 15)
#'
#' calcTemp(50, calcDP(20, 50) )
#'
calcTemp <- function(RH, DewP) {
  Temp <- 243.04 * (((17.625 * DewP) / (243.04 + DewP)) - log(RH / 100)) /
    (17.625 + log(RH / 100) - ((17.625 * DewP) / (243.04 + DewP)))

  return(Temp)
}
