#' Calculate Equilibrium Moisture Content for wood (EMC)
#'
#' @description
#' This function calculates the Equilibrium Moisture Content (EMC) of wood
#' based on relative humidity and temperature.
#'
#' Equilibrium Moisture Content (EMC) is the moisture content at which a material,
#' such as wood or other hygroscopic substanceshas reached an equilibrium with its
#' environment and is no longer gaining or losing moisture under specific
#' temperature and relative humidity.
#'
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#'
#' @return EMC, Equilibrium Moisture Content (0-100\%)
#' @export
#'
#' @references
#' Simpson, W. T. (1998). Equilibrium moisture content of wood in outdoor
#' locations in the United States and worldwide. Res. Note FPL-RN-0268.
#' Madison, WI: U.S. Department of Agriculture, Forest Service, Forest
#' Products Laboratory.
#'
#' Hailwood, A. J., and Horrobin, S. (1946). Absorption of water by polymers:
#' Analysis in terms of a simple model.
#' Transactions of the Faraday Society 42, B084-B092. DOI:10.1039/TF946420B084
#'
#' @importFrom dplyr mutate
#'
#'
#' @examples
#' calcEMC_wood(20, 50)
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(EMC = calcEMC_wood(Temp, RH))
#'
#'
calcEMC_wood <- function(Temp, RH) {

  RH_percent = RH / 100

  # Constants
  W = 349 + 1.29 * Temp + 0.0135 * Temp^2
  K = 0.805 + 0.000736 * Temp - 0.00000273 * Temp^2
  K1 = 6.27 - 0.00938 * Temp - 0.000303 * Temp^2
  K2 = 1.91 + 0.0407 * Temp - 0.000293 * Temp^2

  # Calculate EMC
  EMC = (1800 / W) * (
        ((K * RH_percent) / (1 - K * RH_percent)) +
        (K1 * K * RH_percent + 2 * K1 * K2 * K^2 * RH_percent^2) /
          (1 + K1 * K * RH_percent + K1 * K2 * K^2 * RH_percent^2)
        )

  return(EMC)

}
