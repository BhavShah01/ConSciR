#' Calculate Specific Humidity
#'
#' @description
#' Function to calculate the specific humidity (g/kg) from temperature (°C) and relative humidity (\%).
#'
#' Specific humidity is the ratio of the mass of water vapor to the mass of air.
#'
#' @references
#' Wallace, J.M. and Hobbs, P.V. (2006). Atmospheric Science: An Introductory Survey.
#' Academic Press, 2nd edition.
#'
#'
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcAH}} for calculating absolute humidity
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param ... Additional arguments to supply to \code{\link{calcPws}}
#'
#' @return SH Specific Humidity (g/kg)
#' @export
#'
#' @examples
#' calcSH(20, 50)
#'
#' head(mydata) |> dplyr::mutate(SpecificHumidity = calcSH(Temp, RH))
#'
#'
#'
calcSH <- function(Temp, RH, P_atm = 1013.25, ...) {

  # Calculate saturation vapor pressure
  Pws = calcPws(Temp, ...)

  # Calculate actual vapor pressure
  Pw = calcPws(Temp, ...) * RH / 100

  # Calculate absolute humidity
  AH = calcAH(Temp, RH)

  # Calculate density of moist air
  rho_moist = calcAD(Temp, RH, P_atm)

  # Calculate specific humidity
  SH = AH / rho_moist  # Convert g/m³ to g/kg

  return(SH)
}
