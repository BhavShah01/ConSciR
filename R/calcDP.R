#' Calculate dew point
#'
#' @description
#' Function to calculate dew point in Celsius from temperature in Celsius and relative humidity in \% (0-100).
#'
#'
#' @details
#' Calculation is based on the August-Roche-Magnus approximation, valid for:
#'
#' \itemize{
#'    \item 0C < T < 60C
#'    \item 1% < RH < 100%
#'    \item 0C < Td < 50C
#' }
#'
#' Where:
#' \itemize{
#'   \item \eqn{T_d} is the dew point temperature in degrees Celsius.
#'   \item \eqn{T} is the air temperature in degrees Celsius.
#'   \item \eqn{RH} is the relative humidity in percent 0-100.
#' }
#'
#' \deqn{T_d = \frac{243.04 \times (\log(\frac{RH}{100}) + \frac{17.625 \times T}{243.04 + T})}{17.625 - \log(\frac{RH}{100}) - \frac{17.625 \times T}{243.04 + T}}}
#'
#'
#' @note The Arden Buck equation is also available in the source R code. Similar results are obtained over -50-100C.
#'
#' @source https://bmcnoldy.earth.miami.edu/Humidity.html
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#'
#' @return Td, Dew Point (Celsius)
#' @export
#'
#' @importFrom dplyr mutate
#'
#' @examples
#' calcDP(20, 50)
#'
#' calcDP(20, calcRH(20, calcAH(20, 50)))
#'
#' head(mydata) |> dplyr::mutate(DewPoint = calcDP(Temp, RH))
#'
calcDP <- function(Temp, RH) {

  # Dew Point August-Roche-Magnus
  # https://bmcnoldy.earth.miami.edu/Humidity.html
  # Based on the August-Roche-Magnus approximation, valid for:
  # 0C < T < 60C
  # 1% < RH < 100%
  # 0C < Td < 50C
  # a = 17.625
  # b = 243.04
  # Td =
  #   (b * (log(RH / 100) + ((a * Temp) / (b + Temp)))) /
  #   (a - (log(RH / 100)) - ((a * Temp) / (b + Temp)))

  Td = 243.04 * (log(RH / 100) + ((17.625 * Temp) / (243.04 + Temp))) /
    (17.625 - log(RH / 100) - ((17.625 * Temp) / (243.04 + Temp)))

  return(Td)

  ## Arden Buck equation
  ## source: https://en.wikipedia.org/wiki/Dew_point
  ## Ps(T) (and therefore γ(T, RH)) can be enhanced, using part of the Bögel modification, also known as the Arden Buck equation:
  ## -30C < T < 60C
  ## 1% < RH < 100%
  # a = 6.1121 # mbar
  # b = 18.678
  # c = 257.14 # °C
  # d = 234.5 # °C

  ## a = 6.112 mbar, b = 17.67, c = 243.5 °C # 1980 paper by David Bolton in the Monthly Weather Review
  ## a = 6.112 mbar, b = 17.62, c = 243.12 °C; for −45 °C ≤ T ≤ 60 °C (error ±0.35 °C) # Sonntag 1990
  ## a = 6.105 mbar, b = 17.27, c = 237.7 °C; for 0 °C ≤ T ≤ 60 °C (error ±0.4 °C) # 1974 Psychrometry and Psychrometric Charts

  ## Journal of Applied Meteorology and Climatology, Arden Buck, for different temperature ranges:
  ## a = 6.1121 mbar, b = 17.368, c = 238.88 °C; for 0 °C ≤ T ≤ 50 °C (error ≤ 0.05%)
  ## a = 6.1121 mbar, b = 17.966, c = 247.15 °C; for −40 °C ≤ T ≤ 0 °C (error ≤ 0.06%)

  ## Modified vapor pressure (millibars)
  # Ps = a * exp((b - (Temp / d)) * (Temp / (c + Temp)))

  ## Enhancement factor γ(T, RH)
  # Ef = log((RH / 100) * exp((b - (Temp / d)) * (Temp / (c + Temp))))

  # Td = (c * Ef) / (b - Ef)

  # return(Td)


}
