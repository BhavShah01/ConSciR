#' Calculate relative humidity from temperature (C) and absolute humidity (g/m^3)
#'
#' @description
#' Function to calculate relative humidity (\%) from temperature (C) and absolute humidity (g/m^3)
#'
#'
#' @param Abs Absolute Humidity (g/m^3)
#' @param Temp Temperature (Celsius)
#'
#' @return Relative Humidity (0-100\%). At extreme high and low humidity the error increases.
#' @export
#'
#' @examples
#' calcRH(20, 8.645471)
#'
#' calcRH(20, calcAH(20, 50))
#'
#'
calcRH <- function(Temp, Abs) {
  RH = (1/(2165*(((101325*exp((((-0.1299*(1 - (373.15/(273.16 + Temp))) - 0.6445)*(1 - (373.15/(273.15 + Temp))) - 1.976)*(1 - (373.15/(273.15 + Temp))) + 13.3185)*(1 - (373.15/(273.15 + Temp)))))/1000)/100)/(Temp + 273.15)/Abs) ) # * 1000
  return(RH)
}
