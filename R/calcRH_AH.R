#' Calculate Relative Humidity from temperature and absolute humidity
#'
#' @description
#' Function to calculate relative humidity (\%) from temperature (°C) and absolute humidity (g/m^3)
#'
#'
#'
#'
#' @references
#' Buck, A. L. (1981). New equations for computing vapor pressure and enhancement factor.
#' Journal of Applied Meteorology, 20(12), 1527-1532.
#'
#'
#' @seealso \code{\link{calcAH}} for calculating absolute humidity
#' @seealso \code{\link{calcTemp}} for calculating temperature
#' @seealso \code{\link{calcRH_DP}} for calculating relative humidity from dew point
#' @seealso \code{\link{calcDP}} for calculating dew point
#'
#'
#' @param Abs Absolute Humidity (g/m³)
#' @param Temp Temperature (°Celsius)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#'
#' @return Relative Humidity (0-100\%)
#' @export
#'
#' @examples
#' # Calculate RH for temperature of 20°C and absolute humidity of 8.645471 g/m³
#' calcRH_AH(20, 8.630534)
#'
#' calcRH_AH(20, calcAH(20, 50))
#'
#' head(mydata) |> dplyr::mutate(Abs = calcAH(Temp, RH), RH2 = calcRH_AH(Temp, Abs))
#'
#'
calcRH_AH <- function(Temp, Abs, P_atm = 1013.25) {

  # Constants
  T0 <- 373.15  # Reference temperature in Kelvin

  # Convert temperature to Kelvin
  TempK <- Temp + 273.15

  # Convert atmospheric pressure from hPa to Pa
  P0 <- P_atm * 100  # Convert hPa to Pa

  # Calculate the ratio of T0 to T
  T_ratio <- T0 / TempK

  # Calculate the exponent for vapor pressure equation
  exponent <- ((-0.1299 * (1 - T_ratio) - 0.6445) * (1 - T_ratio) - 1.976) * (1 - T_ratio) + 13.3185

  # Calculate vapor pressure
  vapor_pressure <- P0 * exp(exponent * (1 - T_ratio))

  # Convert vapor pressure from Pa to kPa
  vapor_pressure_kPa <- vapor_pressure / 1000

  # Calculate saturation vapor density
  saturation_vapor_density <- 2165 * (vapor_pressure_kPa / 100) / TempK

  # Calculate relative humidity
  RH <- 1 / (saturation_vapor_density / Abs)

  return(RH)

  ## Alternative function (NOAA)
  # RH = (1/(2165*(((101325*exp((((-0.1299*(1 - (373.15/(273.16 + Temp))) - 0.6445)*(1 - (373.15/(273.15 + Temp))) - 1.976)*(1 - (373.15/(273.15 + Temp))) + 13.3185)*(1 - (373.15/(273.15 + Temp)))))/1000)/100)/(Temp + 273.15)/Abs) ) # * 1000
  # return(RH)

}
