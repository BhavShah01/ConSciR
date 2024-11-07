#' Calculate water vapour pressure (hPa) from temperature (C) and relative humidity (\%)
#'
#' @description
#' Function to calculate water vapour pressure in hPa between 0C and 373C.
#'
#' If using a dataframe, columns should ideally be named "Temp" and "RH".
#'
#'
#' @references
#' W. Wagner and A. Pru\ß:" The IAPWS Formulation 1995 for the Thermodynamic
#' Properties of Ordinary Water Substance for General and Scientific Use ",
#' Journal of Physical and Chemical Reference Data, June 2002 ,Volume 31, Issue 2, pp.387535
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#'
#' @return Pw, Water Vapour Pressure (hPa)
#' @export
#'
#' @examples
#' calcPw(20, 50)
#'
#'
calcPw <- function(Temp, RH) {
  Pw = calcPws(Temp) * RH / 100
  return(Pw)
}
