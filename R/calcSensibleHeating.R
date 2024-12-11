#' Calculate Sensible Heating
#'
#' @description
#' This function calculates sensible heating power.
#'
#' Sensible heat is the energy that causes an object's temperature to change
#' without altering its phase, also known as "dry" heat which you can feel.
#'
#'
#'
#' @param Temp1 Initial Temperature (°Celsius)
#' @param Temp2 Final Temperature (°Celsius)
#' @param volumeFlowRate Volume flow rate of air in cubic meters per second (m³/s)
#' @param RH Initial Relative Humidity (0-100\%). Optional, default is 50\%.
#'
#' @return Sensible heat in kilowatts (kW)
#'
#' @export
#'
#' @seealso \code{\link{calcAD}}
#'
#' @examples
#' calcSensibleHeating(20, 25, 50, 0.5)
#'
#' calcSensibleHeating(20, 25, 60, 0.5)
#'
#'
calcSensibleHeating <- function(Temp1, Temp2, RH = 50, volumeFlowRate) {
  # Constants
  Cp_air <- 1.006  # Specific heat capacity of air in kJ/(kg·K)

  # Calculate air density using calcAD function
  rho_air <- calcAD(Temp1, RH)

  # Calculate temperature difference
  deltaT <- Temp2 - Temp1

  # Calculate sensible heat in kW
  sensibleHeat <- rho_air * Cp_air * volumeFlowRate * deltaT

  return(sensibleHeat)
}
