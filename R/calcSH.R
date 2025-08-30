#' Calculate Specific Humidity
#'
#' @description
#' Function to calculate the specific humidity (g/kg) from temperature (°C) and relative humidity (\%).
#'
#' Specific humidity is the ratio of the mass of water vapor to the mass of air.
#'
#' Function uses \code{\link{calcMR}}
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
#' @param B B = 621.9907 g/kg for air
#' @param ... Additional arguments to supply to \code{\link{calcPws}} and \code{\link{calcMR}}
#'
#' @return SH Specific Humidity (g/kg)
#' @export
#'
#' @note
#' This function requires the \code{\link{calcMR}} function to be available in the environment.
#'
#' @examples
#' calcSH(20, 50)
#'
#' head(mydata) |> dplyr::mutate(SpecificHumidity = calcSH(Temp, RH))
#'
#'
#'
calcSH <- function(Temp, RH, P_atm = 1013.25, B = 621.9907, ...) {
  MR = calcMR(Temp, RH, P_atm, B)
  SH = MR / (1 + MR)
  return(SH)
}
