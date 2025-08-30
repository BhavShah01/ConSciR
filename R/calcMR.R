#' Calculate Mixing Ratio
#'
#' @description
#' Function to calculate mixing ratio (g/kg) from temperature (°C) and relative humidity (\%).
#'
#' Mixing Ratio is the mass of water vapor present in a given volume of air relative to the mass of dry air.
#'
#'
#' @details
#' X Mixing ratio (mass of water vapour / mass of dry gas)
#'
#' Pw = Pws(40°C) = 73.75 hPa
#'
#' X = 621.9907 x 73.75 / (998 - 73.75) = 49.63 g/kg
#'
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param B B = 621.9907 g/kg for air
#' @param ... Additional arguments to supply to \code{\link{calcPws}}
#'
#' @return X Mixing ratio, mass of water vapour / mass of dry gas (g/kg)
#' @export
#'
#' @seealso \code{\link{calcMR}} for calculating mixing ratio
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#'
#' @examples
#' calcMR(20, 50)
#'
#' head(mydata) |> dplyr::mutate(MixingRatio = calcMR(Temp, RH))
#'
#'
calcMR <- function(Temp, RH, P_atm = 1013.25, B = 621.9907, ...) {
  Pw = calcPws(Temp, ...) * RH / 100
  X = (B * Pw) / (P_atm - Pw)
  return(X)
}
