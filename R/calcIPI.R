#' Calculate IPI from temperature (C) and relative humidity (\%)
#'
#' @description
#'
#' IPI formulation of the reaction kinetics: years to a defined state of deterioration
#'
#' exp((E - 134.9 × [RH%])/(8.314 × T) + 0.0284 × [RH%] - 28.023)/365
#'
#' @source Tim Padfield, 2004
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param EA Activation energy E, 95220 J/mol to give the best fit to the cellulose triacetate deterioration data
#'
#' @return IPI formulation of the reaction kinetics, years to a defined state of deterioration
#' @export
#'
#' @examples
#' calcIPI(20, 50)
#'
#' head(mydata) |> dplyr::mutate(IPI = calcIPI(Temp, RH))
#'
#'
calcIPI <- function(Temp, RH, EA = 95220) {

  # IPI formulation of the reaction kinetics: years to a defined state of deterioration
  IPI = exp((EA - 134.9 * RH)/(8.314 * Temp) + 0.0284 * RH - 28.023) / 365

  return(IPI)
}
