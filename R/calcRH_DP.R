#' Calculate Relative Humidity from temperature and dew point
#'
#' @description
#' Function to calculate relative humidity (\%) from temperature (°C) and dew point (°C)
#'
#' @details
#' The relative humidity is calculated using the following equation derived from the August-Roche-Magnus approximation:
#'
#' \deqn{RH=100\times\frac{\exp\left(\frac{\left(17.625\times DewP\right)}{\left(243.04+DewP\right)}\right)}{\exp\left(\frac{\left(17.625\times Temp\right)}{\left(243.04+Temp\right)}\right)}}
#'
#' Where:
#'
#' \itemize{
#'   \item RH is the relative humidity in percent
#'   \item Temp is the air temperature in °C
#'   \item DewP is the dew point temperature in °C
#' }
#'
#' @source https://bmcnoldy.earth.miami.edu/Humidity.html
#'
#' @param Temp Temperature (°Celsius)
#' @param DewP Td, Dew Point (°Celsius)
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
#' head(mydata) |> dplyr::mutate(DewPoint = calcDP(Temp, RH), RH2 = calcRH_DP(Temp, DewPoint))
#'
#'
calcRH_DP <- function(Temp, DewP) {

  RH = 100 * (exp((17.625 * DewP)/(243.04 + DewP)) /
                exp((17.625 * Temp) / (243.04 + Temp)))

  return(RH)
}
