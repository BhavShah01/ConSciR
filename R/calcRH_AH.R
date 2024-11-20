#' Calculate Relative Humidity from temperature and absolute humidity
#'
#' @description
#' Function to calculate relative humidity (\%) from temperature (°C) and absolute humidity (g/m^3)
#'
#'
#'
#' @seealso \code{\link{calcTemp}} for calculating temperature
#' @seealso \code{\link{calcRH_DP}} for calculating relative humidity from dew point
#' @seealso \code{\link{calcDP}} for calculating dew point
#' @seealso \code{\link{calcRH}} for calculating relative humidity from absolute humidity
#'
#'
#' @param Abs Absolute Humidity (g/m³)
#' @param Temp Temperature (°Celsius)
#'
#' @return Relative Humidity (0-100\%). Error increases at extreme temperature and relative humidity.
#' @export
#'
#' @examples
#' # Calculate RH for temperature of 20°C and absolute humidity of 8.645471 g/m³
#' calcRH_AH(20, 8.645471)
#'
#' calcRH_AH(20, calcAH(20, 50))
#'
#'
#'
calcRH_AH <- function(Temp, Abs) {
  RH = (1/(2165*(((101325*exp((((-0.1299*(1 - (373.15/(273.16 + Temp))) - 0.6445)*(1 - (373.15/(273.15 + Temp))) - 1.976)*(1 - (373.15/(273.15 + Temp))) + 13.3185)*(1 - (373.15/(273.15 + Temp)))))/1000)/100)/(Temp + 273.15)/Abs) ) # * 1000
  return(RH)
}
