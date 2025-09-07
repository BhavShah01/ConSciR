#' Calculate Sensible Heat Ratio (SHR)
#'
#' @description
#' This function calculates the Sensible Heat Ratio (SHR) using the sensible and total heating values.
#'
#' Sensible heat ratio is the ratio of sensible heat to total heat.
#'
#'
#' @param Temp1 Initial Temperature (°Celsius)
#' @param Temp2 Final Temperature (°Celsius)
#' @param RH1 Initial Relative Humidity (0-100\%)
#' @param RH2 Final Relative Humidity (0-100\%)
#' @param volumeFlowRate Volume flow rate of air in cubic meters per second (m³/s)
#'
#' @return SHR Sensible Heat Ratio (0-100\%)
#' @export
#'
#' @seealso \code{\link{calcSensibleHeating}}, \code{\link{calcTotalHeating}}
#'
#' @examples
#' calcSensibleHeatRatio(20, 25, 50, 30, 0.5)
#'
#'
calcSensibleHeatRatio <- function(Temp1, Temp2, RH1, RH2, volumeFlowRate) {

  sensibleHeat <- calcSensibleHeating(Temp1, Temp2, volumeFlowRate, RH1)

  totalHeat <- calcTotalHeating(Temp1, Temp2, volumeFlowRate, RH1, RH2)

  SHR <- 100 * sensibleHeat / totalHeat

  # Return 0 if the sensible heat is negative
  if (SHR < 0) {
    return(0)
  } else {
    return(SHR)
  }
}
