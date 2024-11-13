#' Calculate water vapour pressure (hPa)
#'
#' @description
#' Function to calculate water vapour pressure in hPa from temperature (°C) and relative humidity (\%).
#'
#'
#' @details
#' The water vapor pressure (P_w) is calculated using the following equation:
#'
#' \deqn{P_w=\frac{P_{ws}\left(Temp\right)\times RH}{100}}
#'
#' Where:
#'
#' \itemize{
#'    \item $P_{ws}$ is the saturation vapor pressure.
#'    \item $RH$ is the relative humidity in percent.
#'    \item $Temp$ is the temperature in degrees Celsius.
#' }
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
#' #' #' # Calculate relative humidity at 50%RH
#' calcPw(20, 50) / calcPws(20) * 100
#'
#' head(mydata) |> dplyr::mutate(Pw = calcPw(Temp, RH))
#'
#'
calcPw <- function(Temp, RH) {
  Pw = calcPws(Temp) * RH / 100
  return(Pw)
}
