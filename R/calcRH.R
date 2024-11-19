#' Calculate relative humidity from temperature and absolute humidity
#'
#' @description
#' Function to calculate relative humidity (\%) from temperature (°C) and absolute humidity (g/m^3)
#'
#' @details
#' The relative humidity is calculated using the following equation:
#'
#' \deqn{RH=\frac{1}{2165\times\frac{P_{vs}}{(Temp + 273.15)\timesAbs}}}
#'
#' \deqn{RH=\frac{1}{2165}}
#'
#' Where:
#' \itemize{
#'   \item \eqn{RH} is the relative humidity (fraction)
#'   \item \eqn{P_{vs}} is the saturation vapor pressure (Pa)
#'   \item \eqn{Temp} is the temperature (°C)
#'   \item \eqn{Abs} is the absolute humidity (g/m^3)
#' }
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
#' # Calculate RH for temperature of 20°C and absolute humidity of 8.645471 g/m^3
#' calcRH(20, 8.645471)
#'
#' calcRH(20, calcAH(20, 50))
#'
#'
#'
calcRH <- function(Temp, Abs) {
  RH = (1/(2165*(((101325*exp((((-0.1299*(1 - (373.15/(273.16 + Temp))) - 0.6445)*(1 - (373.15/(273.15 + Temp))) - 1.976)*(1 - (373.15/(273.15 + Temp))) + 13.3185)*(1 - (373.15/(273.15 + Temp)))))/1000)/100)/(Temp + 273.15)/Abs) ) # * 1000
  return(RH)
}
