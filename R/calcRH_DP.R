#' Calculate Relative Humidity from temperature and dew point
#'
#' @description
#' Function to calculate relative humidity (\%) from temperature (°C) and dew point (°C)
#'
#'
#' @details
#' This function supports two methods for relative humidity calculation:
#' \itemize{
#'   \item \code{"Magnus"} (default): Uses the August-Roche-Magnus approximation,
#'   valid for 0°C < Temp < 60°C and 1\% < RH < 100\%.
#'   \item \code{"Buck"}: Uses the Arden Buck equation with Bögel modification,
#'   valid for -30°C < Temp < 60°C and 1\% < RH < 100\%.
#' }
#' The methods calculate temperature based on vapor pressure and saturation vapour
#' pressure relationships.
#' The Magnus method is chosen as the default because it is more stable
#' when used with the \code{\link{calcDP}} and \code{\link{calcTemp}} functions.
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
#'
#' @seealso \code{\link{calcTemp}} for calculating temperature
#' @seealso \code{\link{calcDP}} for calculating dew point
#' @seealso \code{\link{calcRH_AH}} for calculating relative humidity from absolute humidity
#' @seealso \code{\link{calcRH_DP}} for calculating relative humidity from dew point
#'
#' @param Temp Temperature (°Celsius)
#' @param DewP Td (DP), Dew Point (°Celsius)
#' @param method Calculation method: either \code{"Magnus"} or \code{"Buck"}.
#' Defaults to \code{"Magnus"}.
#'
#' @return Relative Humidity (0-100\%)
#' @export
#'
#' @examples
#' # Relative humidity (RH) at tempertaure of 20°C (Temp) and dew point of 15°C (DewP)
#' calcRH_DP(20, 15)
#' calcRH_DP(20, 15, method = "Buck")
#'
#' calcRH_DP(20, calcDP(20, 50))
#'
#' calcRH_DP(20, calcDP(20, 50, method = "Buck"), method = "Buck")
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |>
#'   dplyr::mutate(
#'     DewPoint = calcDP(Temp, RH),
#'     RH_default = calcRH_DP(Temp, DewPoint),
#'     RH_Buck = calcRH_DP(Temp, DewPoint, method = "Buck"))
#'
#'
#'
calcRH_DP <- function(Temp, DewP, method = c("Magnus", "Buck")) {
  method = match.arg(method)

  if (method == "Magnus") {
    a = 17.625
    b = 243.04
    RH = 100 * (exp((a * DewP)/(b + DewP)) /
                  exp((a * Temp) / (b + Temp)))

  } else if (method == "Buck") {
    a = 6.1121  # mbar
    b = 18.678
    c = 257.14  # °C
    d = 234.5   # °C
    # Enhancement factor γ(T, RH)
    Ef = exp((b - (Temp / d)) * (Temp / (c + Temp)))
    # Scaled natural logarithm of the saturation vapour pressure at dew point
    lnPw = (DewP * b) / (c + DewP)
    RH = 100 * exp(lnPw) / Ef
  }

  return(RH)
}
