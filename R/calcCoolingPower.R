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
#' @param volumeFlowRate Volume flow rate of air (m³/s)
#'
#' @return Cooling power in kilowatts (kW)
#' @export
#'
#' @seealso \code{\link{calcEnthalpy}}, \code{\link{calcAD}}
#'
#' @references ASHRAE Handbook Fundamentals
#'
#' @examples
#' calcCoolingPower(30, 22, 70, 55, 0.8)
#'
#' calcCoolingPower(Temp1 = 25, Temp2 = 20, RH1 = 70, RH2 = 50, volumeFlowRate = 0.5)
#'
#'
#'
#'
calcCoolingPower <- function(Temp1, Temp2, RH1, RH2, volumeFlowRate) {
  h1 <- calcEnthalpy(Temp1, RH1)
  h2 <- calcEnthalpy(Temp2, RH2)
  rho <- calcAD(Temp1, RH1)
  massFlowRate <- volumeFlowRate * rho
  coolingPowerWatts <- massFlowRate * (h1 - h2)
  coolingPowerKW <- coolingPowerWatts / 1000
  coolingPowerKW <- pmax(coolingPowerKW, 0)
  return(coolingPowerKW)
}
