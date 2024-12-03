#' Calculate Total Heating
#'
#' @description
#' This function calculates total heating power.
#'
#' Total heating power is the sum of sensible (felt) heat and latent (hidden) heat.
#'
#'
#' @param Temp1 Initial Temperature (°Celsius)
#' @param Temp2 Final Temperature (°Celsius)
#' @param RH1 Initial Relative Humidity (0-100\%)
#' @param RH2 Final Relative Humidity (0-100\%)
#' @param volumeFlowRate Volume flow rate of air in cubic meters per second (m³/s)
#'
#' @return Total Heating in kilowatts (kW)
#' @export
#'
#' @seealso \code{\link{calcAD}}, \code{\link{calcEnthalpy}}
#'
#' @examples
#' calcTotalHeating(20, 25, 50, 30, 0.5)
#'
#'
#'
calcTotalHeating <- function(Temp1, Temp2, RH1, RH2, volumeFlowRate) {

  # Calculate air density using calcAD function
  rho_air <- calcAD(Temp1, RH1)

  # Calculate enthalpies
  h1 <- calcEnthalpy(Temp1, RH1)
  h2 <- calcEnthalpy(Temp2, RH2)

  # Calculate total heat in kW
  totalHeat <- rho_air * volumeFlowRate * (h2 - h1)

  return(totalHeat)
}
