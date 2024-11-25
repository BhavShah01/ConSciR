#' Calculate Air Density
#'
#' @description
#' Function to calculate air density based on temperature (°C), relative humidity in (\%), and atmospheric pressure (hPa).
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param R_dry Specific gas constant for dry air = 287.058 (J/(kg·K))
#' @param R_vap Specific gas constant for water vapor = 461.495 (J/(kg·K))
#' @param ... Addtional arguments  to supply to \code{\link{calcPws}}
#'
#' @return Air density in kg/m³
#' @export
#'
#' @seealso \code{\link{calcMR}} for calculating mixing ratio
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#'
#' @examples
#' calcAD(20, 50)
#'
#' head(mydata) |> dplyr::mutate(AirDensity = calcAD(Temp, RH))
#'
#'
calcAD <- function(Temp, RH, P_atm = 1013.25, R_dry = 287.058, R_vap = 461.495, ...) {

  # Temperature in Kelvin
  TempK = Temp + 273.15

  # Pressure in Pa
  P_atm_Pa = P_atm * 100

  # Saturation water vapour pressure
  Pws = calcPws(Temp, ...)

  # Actual water vapour pressure
  Pw = calcPws(Temp, ...) * RH / 100

  # Partial pressure of dry air
  Pd = P_atm_Pa - Pw

  AirDensity = (Pd / (R_dry * TempK)) + (Pw / (R_vap * TempK))

  return(AirDensity)
}
