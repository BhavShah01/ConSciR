#' Calculate Temperature from relative humidity and dew point
#'
#' @description
#' This function calculates the temperature (°C) from relative humidity (\%)
#' and dew point temperature (°C).
#'
#' @details
#' This function supports two methods for temperature calculation:
#' \itemize{
#'   \item \code{"Magnus"} (default): Uses the August-Roche-Magnus approximation,
#'   valid for 0°C < Temp < 60°C and 1\% < RH < 100\%.
#'   \item \code{"Buck"}: Uses the Arden Buck equation with Bögel modification,
#'   valid for -30°C < Temp < 60°C and 1\% < RH < 100\%.
#' }
#' The methods calculate temperature based on vapor pressure and saturation vapour
#' pressure relationships.
#' The Magnus method is chosen as the default because it is more stable
#' when used with the \code{\link{calcDP}} and \code{\link{calcRH_DP}} functions.
#'
#'
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
#' @seealso \code{\link{calcTemp}} for calculating temperature
#' @seealso \code{\link{calcDP}} for calculating dew point
#' @seealso \code{\link{calcRH_DP}} for calculating relative humidity from dew point
#' @seealso \code{\link{calcRH_AH}} for calculating relative humidity from absolute humidity
#'
#'
#' @param RH Relative Humidity (0-100\%)
#' @param DewP Td (DP), Dew Point (°Celsius)
#' @param method Calculation method: either \code{"Magnus"} or \code{"Buck"}.
#' Defaults to \code{"Magnus"}.
#'
#' @return Temp, Temperature (°Celsius)
#' @export
#' @importFrom stats uniroot
#'
#' @examples
#' # Calculate temperature (Temp) at 50% relative humidity (RH) and dew point 15°C (DewP)
#' # Using Magnus method
#' calcTemp(50, 15)
#'
#' # Using Buck method
#' calcTemp(50, 15, method = "Buck")
#'
#' calcTemp(50, calcDP(20, 50))
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |>
#'   dplyr::mutate(
#'     DewPoint = calcDP(Temp, RH),
#'     Temp_default = calcTemp(RH, DewPoint),
#'     Temp_Buck = calcTemp(RH, DewPoint))
#'
#'
calcTemp <- function(RH, DewP, method = c("Magnus", "Buck")) {
  method = match.arg(method)

  if (method == "Magnus") {
    a = 17.625
    b = 243.04
    Temp = (b * (( (a * DewP) / (b + DewP)) - log(RH / 100))) /
      (a + log(RH / 100) - ((a * DewP) / (b + DewP)))

  } else if (method == "Buck") {
    a = 6.1121  # mbar
    b = 18.678
    c = 257.14  # °C
    d = 234.5   # °C

    # Vapor pressure at dew point
    lnPw = (DewP * b) / (c + DewP)
    Pw = a * exp(lnPw)

    # Function to find root: difference between calculated and given RH
    Temp_fun = function(Temp) {
      Ef = exp((b - (Temp / d)) * (Temp / (c + Temp)))
      RH_calc = 100 * (Pw / (a * Ef))
      return(RH_calc - RH)
    }

    # Numerically solve for Temp between -40 and 60 °C
    res = stats::uniroot(Temp_fun, lower = -40, upper = 60)
    Temp = res$root
  }

  return(Temp)
}
