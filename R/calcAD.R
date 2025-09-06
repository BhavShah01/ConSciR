#' Calculate Air Density
#'
#' @description
#' Function to calculate air density based on temperature (°C), relative humidity in (\%), and atmospheric pressure (hPa).
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param R_dry Specific gas constant for dry air = 287.058 (J/(kg·K))
#' @param R_vap Specific gas constant for water vapor = 461.495 (J/(kg·K))
#' @param ... Addtional arguments  to supply to \code{\link{calcPws}}
#'
#' @return Air density in kg/m³
#' @export
#'
#' @seealso \code{\link{calcMR}} for calculating mixing ratio
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#'
#' @examples
#' calcAD(20, 50)
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(AirDensity = calcAD(Temp, RH))
#'
#'
calcAD <- function(Temp, RH, P_atm = 1013.25, R_dry = 287.058, R_vap = 461.495, ...) {

  # Convert Temperature to Kelvin
  TempK <- Temp + 273.15

  # Partial pressure of water vapour (Pw) in hPa
  Pws <- calcPws(Temp, ...)        # Saturation vapour pressure (hPa)
  Pw <- Pws * RH / 100             # Actual vapour pressure (hPa)

  # Partial pressure of dry air (Pd) in hPa
  Pd <- P_atm - Pw

  # Convert hPa to Pa for calculation (1 hPa = 100 Pa)
  Pd_Pa <- Pd * 100
  Pw_Pa <- Pw * 100

  # Air density calculation in kg/m³
  AirDensity <- (Pd_Pa / (R_dry * TempK)) + (Pw_Pa / (R_vap * TempK))

  return(AirDensity)
}
