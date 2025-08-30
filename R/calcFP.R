#' Calculate Frost Point
#'
#' @description
#' Function to calculate frost point (°C) from temperature (°C) and relative humidity (\%).
#'
#'
#' @details
#' Formula coefficients
#'
#' \itemize{
#'   \item a_ice = 22.452
#'   \item b_ice = 272.55
#' }
#'
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param ... Additional arguments to supply to \code{\link{calcPws}}
#'
#' @returns Tf, Frost Point (°Celsius)
#' @export
#'
#' @examples
#' calcFP(20, 50)
#' calcFP(0, 50)
#'
#' head(mydata) |> dplyr::mutate(FrostPoint = calcFP(Temp, RH))
#'
#'
calcFP <- function(Temp, RH, ...) {
  # Calculate actual vapor pressure in hPa
  Pw = calcPw(Temp, RH)

  # Constants for vapor pressure over ice (Magnus type formula coefficients)
  a_ice = 22.452
  b_ice = 272.55
  c_ice = 0.0

  # Calculate frost point T_f (C) using inversion of Magnus-form for ice
  FrostPoint <- (b_ice * log(Pw/6.112)) / (a_ice - log(Pw/6.112))

  return(FrostPoint)
}
