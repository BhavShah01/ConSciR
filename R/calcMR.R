#' Calculate mixing ratio from temperature (C) and relative humidity (\%)
#'
#' @description
#' Function to calculate mixing ratio from temperature in Celsius and relative humidity in \% (0-100).
#'
#' If using a dataframe, columns should ideally be named "Temp" and "RH".
#'
#' X Mixing ratio (mass of water vapour / mass of dry gas)
#'
#' Pw = Pws(40C) = 73.75 hPa
#'
#' X = 621.9907 B7 73.75/(998-73.75) = 49.63 g/kg
#'
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_tot Total pressure = 1013.3 (hPa)
#' @param B B = 621.9907 g/kg is valid for air
#'
#' @return X Mixing ratio (mass of water vapour / mass of dry gas)
#' @export
#'
#' @examples
#' calcMR(20, 50)
#'
#' head(mydata) |> dplyr::mutate(MixingRatio = calcMR(Temp, RH))
#'
#'
calcMR <- function(Temp, RH, P_tot = 1013.3, B = 621.9907) {
  Pw = calcPw(Temp, RH)
  X = (B * Pw) / (P_tot - Pw)
  return(X)
}
