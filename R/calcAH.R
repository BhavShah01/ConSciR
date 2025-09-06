#' Calculate Absolute Humidity
#'
#' @description
#' Function to calculate the absolute humidity (g/m³) from temperature (°C) and relative humidity (\%).
#'
#' Absolute humidity is the mass of water in a unit volume of air at a given temperature and pressure.
#'
#'
#' @references
#' Buck, A. L. (1981). New equations for computing vapor pressure and enhancement factor. Journal of Applied Meteorology, 20(12), 1527-1532.
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#'
#' @return AH Absolute Humidity (g/m³)
#' @export
#'
#' @examples
#' calcAH(20, 50)
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(Abs = calcAH(Temp, RH))
#'
#'
calcAH <- function(Temp, RH, P_atm = 1013.25) {

  ## Buck, Vapour pressure and enhancement factor
  # Constants
  A <- 2165  # Constant for water vapor
  P_atm <- P_atm * 100  # Atmospheric pressure in Pa

  # Temperature ratio
  T_ratio <- 1 - (373.15 / (273.15 + Temp))

  # Exponent calculation
  exponent <- (-0.1299 * T_ratio - 0.6445) * T_ratio - 1.976

  # Vapor pressure calculation
  Pv <- P_atm * exp((exponent * T_ratio + 13.3185) * T_ratio)

  # Absolute humidity calculation
  AH <- (A * (RH * (Pv / 1000) / 100)) / (Temp + 273.15)


  # VAISALA
  # AH0 = ((RH * (1.10461E-15 * Temp^10 +
  #               -1.187682E-13 * Temp^9 +
  #               3.089754E-12 * Temp^8 +
  #               7.150535E-11 * Temp^7 +
  #               -3.770916E-9 * Temp^6 +
  #               4.760219E-9 * Temp^5 +
  #               1.725056E-6 * Temp^4 +
  #               1.746817E-5 * Temp^3 +
  #               0.001223148 * Temp^2 +
  #               0.04660427 * Temp +
  #               0.6072509) * 1000) / 100 / (Temp + 273.15)) * (18.01528 / 8.31441)

  return(AH)
}
