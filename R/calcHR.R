#' Calculate Humidity Ratio
#'
#' @description
#' Function to calculate humidity ratio (g/kg) from temperature (°C) and relative humidity (\%).
#'
#' Humidity ratio is the mass of water vapor present in a given volume of air relative to the mass of dry air.
#'
#' Function uses \code{\link{calcMR}}
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param B B = 621.9907 g/kg for air
#'
#' @return HR Humidity ratio (g/kg)
#' @export
#'
#' @details
#' The function uses the following steps:
#'
#' 1. Calculate the mixing ratio using the \code{\link{calcMR}} function.
#'
#' 2. Convert the mixing ratio to humidity ratio using the formula:
#'
#'    HR = MR / (1 + MR)
#'
#' Where MR is the mixing ratio and HR is the humidity ratio.
#'
#' Note: This function requires the \code{\link{calcMR}} function to be available in the environment.
#'
#' @seealso \code{\link{calcMR}} for calculating mixing ratio
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#'
#' @examples
#' calcHR(20, 50)
#'
#' head(mydata) |> dplyr::mutate(HumidityRatio = calcHR(Temp, RH))
#'
#'
calcHR <- function(Temp, RH, P_atm = 1013.25, B = 621.9907) {
  HR = calcMR(Temp, RH, P_atm, B) / (1 + calcMR(Temp, RH, P_atm, B))
  # HR = HR / 1000 # Convert to kg/kg
  return(HR)
}
