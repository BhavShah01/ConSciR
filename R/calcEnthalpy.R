#' Calculate Enthalpy
#'
#' @description
#' Function to calculate enthalpy from temperature (°C) and relative humidity (\%).
#'
#' Enthalpy is the total heat content of air, combining sensible (related to temperature)
#' and latent heat (related to moisture content), used in HVAC calculations.
#' Enthalpy is the amount of energy required to bring a gas to its current state
#' from a dry gas at 0°C.
#'
#'
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param ... Additional arguments to supply to \code{\link{calcPws}} and \code{\link{calcMR}}
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
  MR = calcMR(Temp, RH, ...)
  h = Temp * (1.01 + 0.00189 * MR) + 2.5 * MR
  return(h)

  # # Standard Enthalpy Formula
  # MR = calcMR(Temp, RH, ...)
  # MR_kg <- MR / 1000  # Convert to kg/kg
  # # Standard psychrometric enthalpy equation
  # h <- 1.006 * Temp + MR_kg * (2501 + 1.86 * Temp)
  # return(h)
}
