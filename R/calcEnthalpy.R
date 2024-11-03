#' Calculate enthalpy from temperature (C) and relative humidity (\%)
#'
#' @description
#' Function to calculate enthalpy from temperature in Celsius and relative humidity in \% (0-100).
#'
#' If using a dataframe, columns should ideally be named "Temp" and "RH".
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#'
#' @return Enthalpy (kJ/kg)
#' @export
#'
#' @examples
#' calcEnthalpy(20, 50)
#'
#'
calcEnthalpy <- function(Temp, RH) {
  # h Enthalpy (kJ/kg)
  # Example: The ambient temperature is 20B0C and the relative humidity is 50%.
  # Pw = Pws(20B0C) B7 50/100 = 11.69 hPa
  # X = 621.9907 B7 11.69/(1013-11.69) = 7.26 g/kg
  # h = 20 B7 (1.01 + 0.00189 B7 7.26) + 2.5 B7 7.26 = 38.62 kJ/kg

  X = calcMR(Temp, RH)
  h = Temp * (1.01 + 0.00189 * X) + 2.5 * X
  return(h)
}
