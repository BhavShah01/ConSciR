#' Calculate Frost Point
#'
#' @description
#' Function to calculate frost point (°C) from temperature (°C) and relative humidity (\%).
#'
#'
#' @details
#' Formula coefficients from Arden Buck equation (1981, 1996) saturation vapor pressure over ice.
#'
#' \itemize{
#'   \item a = 6.1115
#'   \item b = 23.036
#'   \item c = 279.82
#'   \item d = 333.7
#' }
#'
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
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
calcFP <- function(Temp, RH) {

  ## Arden Buck equation (1981, 1996) saturation vapor pressure over ice
  a = 6.1115
  b = 23.036
  c = 279.82
  d = 333.7

  Pws_ice = a * exp((b - (Temp / d)) * (Temp / (c + Temp)))
  Pw = Pws_ice * RH / 100

  ## Enhancement factor γ(T, RH)
  Ef = log((RH / 100) * exp((b - (Temp / d)) * (Temp / (c + Temp))))
  Tf = (c * Ef) / (b - Ef)
  return(Tf)

}
