#' Calculate Dew Point
#'
#' @description
#' Function to calculate dew point (°C) from temperature (°C) and relative humidity (\%).
#'
#' The dew point is the temperature at which air becomes saturated with moisture
#' and water vapour begins to condense.
#'
#'
#' @details
#' This function supports two methods for dew point calculation:
#' \itemize{
#'   \item \code{"Magnus"} (default): Uses the August-Roche-Magnus approximation,
#'   valid for 0°C < Temp < 60°C and 1\% < RH < 100\%.
#'   \item \code{"Buck"}: Uses the Arden Buck equation with Bögel modification,
#'   valid for -30°C < Temp < 60°C and 1\% < RH < 100\%.
#' }
#'
#' Both methods compute saturation vapour pressure and convert relative humidity
#' to dew point temperature.
#' The Magnus method is chosen as the default because it
#' is more stable when used with the \code{\link{calcTemp}} and \code{\link{calcRH_DP}} functions.
#'
#'
#' @note More details of the equations are also available in the source R code.
#'
#' @references
#' Alduchov, O. A., and R. E. Eskridge, 1996: Improved Magnus' form approximation of saturation
#' vapor pressure. J. Appl. Meteor., 35, 601–609
#'
#' Buck, A. L., 1981: New Equations for Computing Vapor Pressure and Enhancement Factor.
#' J. Appl. Meteor. Climatol., 20, 1527–1532,
#' https://doi.org/10.1175/1520-0450(1981)020<1527:NEFCVP>2.0.CO;2.
#'
#' Buck (1996), Buck (1996), Buck Research CR-1A User's Manual, Appendix 1.
#'
#' https://bmcnoldy.earth.miami.edu/Humidity.html
#'
#'
#'
#' @seealso \code{\link{calcTemp}} for calculating temperature
#' @seealso \code{\link{calcRH_DP}} for calculating relative humidity from dew point
#' @seealso \code{\link{calcDP}} for calculating dew point
#' @seealso \code{\link{calcRH_AH}} for calculating relative humidity from absolute humidity
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param method Character; formula to use, either \code{"Magnus"} or \code{"Buck"}.
#' Defaults to \code{"Magnus"}.
#'
#' @return Td (DP), Dew Point (°Celsius)
#' @export
#'
#' @importFrom dplyr mutate
#'
#' @examples
#' # Default Magnus method
#' calcDP(20, 50)
#'
#' # Using Buck method
#' calcDP(20, 50, method = "Buck")
#'
#' # Validation check
#' calcDP(20, calcRH_DP(20, calcDP(20, 50)))
#' calcDP(20, calcRH_DP(20, calcDP(20, 50, method = "Buck"), method = "Buck"), method = "Buck")
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |>
#'   dplyr::mutate(
#'     DewPoint = calcDP(Temp, RH),
#'     DewPoint_Buck = calcDP(Temp, RH, method = "Buck"))
#'
#'
calcDP <- function(Temp, RH, method = c("Magnus", "Buck")) {
  method <- match.arg(method)

  if (method == "Magnus") {
    # August-Roche-Magnus approximation
    a <- 17.625
    b <- 243.04
    DP <- (b * (log(RH / 100) + ((a * Temp) / (b + Temp)))) /
      (a - log(RH / 100) - ((a * Temp) / (b + Temp)))

  } else if (method == "Buck") {
    # Arden Buck equation with Bögel modification
    a <- 6.1121  # in mbar, not used directly here
    b <- 18.678
    c <- 257.14  # °C
    d <- 234.5   # °C

    # Calculate modified saturation vapor pressure factor
    Ef <- log((RH / 100) * exp((b - (Temp / d)) * (Temp / (c + Temp))))
    DP <- (c * Ef) / (b - Ef)
  }

  return(DP)

  ## Dew Point August-Roche-Magnus
  ## Source: https://bmcnoldy.earth.miami.edu/Humidity.html
  ## Based on the August-Roche-Magnus approximation, valid for:
  ## 0C < T < 60C, 1% < RH < 100%, 0C < DP < 50C
  # a = 17.625
  # b = 243.04
  # DP =
  #   (b * (log(RH / 100) + ((a * Temp) / (b + Temp)))) /
  #   (a - (log(RH / 100)) - ((a * Temp) / (b + Temp)))
  # DP = 243.04 * (log(RH / 100) + ((17.625 * Temp) / (243.04 + Temp))) /
  #   (17.625 - log(RH / 100) - ((17.625 * Temp) / (243.04 + Temp)))
  # return(DP)

  ## Arden Buck equation
  ## Ps(T) (and therefore γ(T, RH)) can be enhanced, using part of the Bögel modification, also known as the Arden Buck equation:
  ## -30C < T < 60C, 1% < RH < 100%
  # a = 6.1121 # mbar
  # b = 18.678
  # c = 257.14 # °C
  # d = 234.5 # °C
  # # Modified vapour pressure (mbar)
  # Ps = a * exp((b - (Temp / d)) * (Temp / (c + Temp)))
  # # Enhancement factor γ(T, RH)
  # Ef = log((RH / 100) * exp((b - (Temp / d)) * (Temp / (c + Temp))))
  # Td = (c * Ef) / (b - Ef)
  # return(Td)

  ## Coefficients, source Wikipedia
  ## a = 6.112 mbar, b = 17.67, c = 243.5 °C # 1980 paper by David Bolton in the Monthly Weather Review
  ## a = 6.112 mbar, b = 17.62, c = 243.12 °C; for −45 °C ≤ T ≤ 60 °C (error ±0.35 °C) # Sonntag 1990
  ## a = 6.105 mbar, b = 17.27, c = 237.7 °C; for 0 °C ≤ T ≤ 60 °C (error ±0.4 °C) # 1974 Psychrometry and Psychrometric Charts
  ## Journal of Applied Meteorology and Climatology, Arden Buck, for different temperature ranges:
  ## a = 6.1121 mbar, b = 17.368, c = 238.88 °C; for 0 °C ≤ T ≤ 50 °C (error ≤ 0.05%)
  ## a = 6.1121 mbar, b = 17.966, c = 247.15 °C; for −40 °C ≤ T ≤ 0 °C (error ≤ 0.06%)

}
