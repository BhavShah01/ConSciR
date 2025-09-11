#' Calculate Frost Point
#'
#' @description
#' Function to calculate frost point (°C) from temperature (°C) and relative humidity (\%).
#'
#' This function is under development.
#'
#' @details
#' Formula coefficients from Arden Buck equation (1981, 1996) saturation vapor pressure over ice.
#'
#' \itemize{
#'   \item a = 6.1115
#'   \item b = 23.036
#'   \item c = 279.82
#'   \item d = 333.7
#' }
#'
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#'
#' @returns Tf, Frost Point (°Celsius)
#' @export
#'
#' @examples
#' # Frost point at 20°C (Temp) and 50% relative humidity (RH)
#' calcFP(20, 50)
#' calcFP(0, 50)
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(FrostPoint = calcFP(Temp, RH))
#'
#'
calcFP <- function(Temp, RH) {

  ## Arden Buck equation (1981, 1996) saturation vapor pressure over ice
  a_ice = 6.1115
  b_ice = 23.036
  c_ice = 279.82
  d_ice = 333.7

  Pws_ice = a_ice * exp((b_ice - (Temp / d_ice)) * (Temp / (c_ice + Temp)))
  Pw = Pws_ice * RH / 100

  ## Enhancement factor γ(T, RH)
  Ef = log((RH / 100) * exp((b_ice - (Temp / d_ice)) * (Temp / (c_ice + Temp))))
  Tf = (c_ice * Ef) / (b_ice - Ef)
  return(Tf)

}
