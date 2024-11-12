#' Calculate Relative Humidity from temperature and dew point
#'
#' @description
#' Function to calculate relative humidity (\%) from air temperature (C) and dew point (C)
#'
#' @details
#' The relative humidity is calculated using the following equation:
#'
#' \eqn{RH = 100 \times \frac{\exp(\frac{17.625 \times DewP}{243.04 + DewP})}{\exp(\frac{17.625 \times Temp}{243.04 + Temp})}}
#'
#' Where:
#' \itemize{
#'   \item \eqn{RH} is the relative humidity in percent
#'   \item \eqn{Temp} is the air temperature in °C
#'   \item \eqn{DewP} is the dew point temperature in °C
#' }
#'
#' @source https://bmcnoldy.earth.miami.edu/Humidity.html
#'
#' @param Temp Temperature (Celsius)
#' @param DewP Td, Dew Point (Celsius)
#'
#' @return Relative Humidity (0-100\%)
#' @export
#'
#' @examples
#' # RH at air tempertaure of 20C and dew point of 15C
#' calcRH_DP(20, 15)
#'
#' calcRH_DP(20, calcDP(20, 50))
#'
#'
calcRH_DP <- function(Temp, DewP) {

  RH = 100 * (exp((17.625 * DewP)/(243.04 + DewP)) /
                exp((17.625 * Temp) / (243.04 + Temp)))

  return(RH)
}
