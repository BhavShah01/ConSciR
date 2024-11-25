#' Calculate Enthalpy
#'
#' @description
#' Function to calculate enthalpy from temperature (°C) and relative humidity (\%).
#'
#' Enthalpy is the amount of energy required to bring a gas to its current state
#' from a dry gas at 0°C.
#'
#'
#' @details
#' Example: The ambient temperature is 20°C and the relative humidity is 50\%.
#'
#' Pw = Pws(20°C) x 50/100 = 11.69 hPa
#'
#' X = 621.9907 x 11.69/(1013 - 11.69) = 7.26 g/kg
#'
#' h = 20 x (1.01 + 0.00189 x 7.26) + 2.5 x 7.26 = 38.62 kJ/kg
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param ... Additional arguments to supply to \code{\link{calcPws}}
#'
#' @return h Enthalpy (kJ/kg)
#' @export
#'
#' @examples
#' calcEnthalpy(20, 50)
#'
#' head(mydata) |> dplyr::mutate(Enthalpy = calcEnthalpy(Temp, RH))
#'
#'
calcEnthalpy <- function(Temp, RH, ...) {
  X = calcMR(Temp, RH, ...)
  h = Temp * (1.01 + 0.00189 * X) + 2.5 * X
  return(h)
}
