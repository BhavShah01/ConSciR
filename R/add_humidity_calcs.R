#' Add Humidity calculations to temperature and humidity data
#'
#' This function adds several humidity variables
#' to a dataframe with temperature and relative humidity columns.
#' It uses the humidity functions (e.g., calcPws, calcPw).
#'
#' @param mydata A dataframe containing temperature and relative humidity data.
#' @param Temp Character string name of the temperature column (default "Temp").
#' @param RH Character string name of the relative humidity column (default "RH").
#' @param P_atm Atmospheric pressure (hPa), default 1013.25 (currently unused).
#' @param ... Additional parameters passed to humidity calculation functions.
#'
#' @return The input dataframe augmented with columns for vapor pressure, dew point, absolute humidity,
#'   air density, mixing ratio, specific humidity, frost point, and enthalpy.
#'
#' - Pws: Saturated vapour pressure at given temperature (hPa).
#' - Pw: Partial pressure of water vapour present (hPa).
#' - DP: Dew Point, condensation temperature based on RH (°C).
#' - AH: Mass of water vapour per air volume (g/m³).
#' - AD: Moist air density (kg/m³).
#' - MR: Ratio of water vapour to dry air mass (g/kg).
#' - SH: Ratio of water vapour to total air mass (g/kg).
#' - FP: Frost formation temperature (°C; experimental).
#' - Enthalpy: Total enthalpy, h, of air-vapour mixture (kJ/kg).
#'
#' @importFrom dplyr mutate
#' @importFrom rlang sym
#' @export
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> add_humidity_calcs() |> dplyr::glimpse()
#'
#'
add_humidity_calcs <- function(mydata, Temp = "Temp", RH = "RH", P_atm = 1013.25, ...) {
  TempSym <- rlang::sym(Temp)
  RHSym <- rlang::sym(RH)

  mydata |>
    dplyr::mutate(
      Pws = calcPws(!!TempSym, ...),
      Pw = calcPw(!!TempSym, !!RHSym, ...),
      DP = calcDP(!!TempSym, !!RHSym),
      AH = calcAH(!!TempSym, !!RHSym, ...),
      AD = calcAD(!!TempSym, !!RHSym, ...),
      MR = calcMR(!!TempSym, !!RHSym, ...),
      SH = calcSH(!!TempSym, !!RHSym, ...),
      FP = calcFP(!!TempSym, !!RHSym),
      Enthalpy = calcEnthalpy(!!TempSym, !!RHSym)
    )
}
