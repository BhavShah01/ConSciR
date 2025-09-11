#' Calculate Humidity Ratio
#'
#' @description
#' Function to calculate humidity ratio (g/kg) from temperature (°C) and relative humidity (\%).
#'
#' Humidity ratio is the mass of water vapor present in a given volume of air
#' relative to the mass of dry air. Also known as "moisture content".
#'
#' Function uses \code{\link{calcMR}}
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param B B = 621.9907 g/kg for air
#' @param ... Additional arguments to supply to \code{\link{calcPws}} and \code{\link{calcMR}}
#'
#' @return HR Humidity ratio (g/kg)
#' @export
#'
#' @note
#' This function requires the \code{\link{calcMR}} function to be available in the environment.
#'
#' @seealso \code{\link{calcMR}} for calculating mixing ratio
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#'
#' @examples
#' # Humidity ratio at 20°C (Temp) and 50% relative humidity (RH)
#' calcHR(20, 50)
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(HumidityRatio = calcHR(Temp, RH))
#'
#'
calcHR <- function(Temp, RH, P_atm = 1013.25, B = 621.9907, ...) {
  HR = calcMR(Temp, RH, P_atm, B)
  return(HR)
}
