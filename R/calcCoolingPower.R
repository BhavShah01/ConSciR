#' Calculate Cooling Power
#'
#' @description
#' This function calculates the cooling power based on initial and final air
#' conditions and volume flow rate.
#'
#' Cooling power is the rate of energy transferred during a cooling process.
#'
#'
#'
#' @param Temp1 Initial Temperature (°Celsius)
#' @param Temp2 Final Temperature (°Celsius)
#' @param RH1 Initial Relative Humidity (0-100\%)
#' @param RH2 Final Relative Humidity (0-100\%)
#' @param volumeFlowRate Volume flow rate of air (m\³/s)
#'
#' @return Cooling power in watts (W)
#' @export
#'
#' @seealso \code{\link{calcEnthalpy}}, \code{\link{calcAD}}
#'
#' @references ASHRAE Handbook Fundamentals
#'
#' @examples
#' calcCoolingPower(Temp1 = 25, RH1 = 70, Temp2 = 20, RH2 = 50, volumeFlowRate = 0.5)
#'
#' calcCoolingPower(30, 70, 22, 55, 0.8)
#'
#'
calcCoolingPower <- function(Temp1, Temp2, RH1, RH2, volumeFlowRate) {

  # Calculate enthalpies
  h1 = calcEnthalpy(Temp1, RH1)
  h2 = calcEnthalpy(Temp2, RH2)

  # Calculate air density at initial conditions
  rho = calcAD(Temp1, RH1)

  # Calculate mass flow rate
  massFlowRate = volumeFlowRate * rho

  # Calculate cooling power in watts
  coolingPowerWatts = massFlowRate * (h1 - h2)

  # Convert watts to kilowatts
  coolingPowerKW = coolingPowerWatts / 1000

  return(coolingPowerKW)
}
