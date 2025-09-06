#' Calculate Water Vapour Pressure
#'
#' @description
#' Function to calculate water vapour pressure (hPa) from temperature (°C) and relative humidity (\%).
#'
#' Water vapour pressure is the pressure exerted by water vapour in a gas.
#'
#' @details
#' Different formulations for calculating water vapour pressure are available:
#' \itemize{
#'   \item Arden Buck equation ("Buck")
#'   \item International Association for the Properties of Water and Steam ("IAPWS")
#'   \item August-Roche-Magnus approximation ("Magnus")
#'   \item VAISALA humidity conversion formula ("VAISALA")
#' }
#'
#' The water vapor pressure (P_w) is calculated using the following equation:
#'
#' \deqn{P_w=\frac{P_{ws}\left(Temp\right)\times RH}{100}}
#'
#' Where:
#'
#' \itemize{
#'    \item P_ws is the saturation vapor pressure using \code{\link{calcPws}}.
#'    \item RH is the relative humidity in percent.
#'    \item Temp is the temperature in degrees Celsius.
#' }
#'
#' @note
#' See Wikipedia for a discussion of the accuarcy of each approach:
#' https://en.wikipedia.org/wiki/Vapour_pressure_of_water
#'
#'
#' @seealso \code{\link{calcMR}} for calculating mixing ratio
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#'
#' @references
#' Wagner, W., & Pru\ß, A. (2002). The IAPWS formulation 1995 for the thermodynamic
#' properties of ordinary water substance for general and scientific use. Journal of
#' Physical and Chemical Reference Data, 31(2), 387-535.
#'
#' Alduchov, O. A., and R. E. Eskridge, 1996: Improved Magnus' form approximation of
#' saturation vapor pressure. J. Appl. Meteor., 35, 601-609.
#'
#' Buck, A. L., 1981: New Equations for Computing Vapor Pressure and Enhancement Factor.
#' J. Appl. Meteor. Climatol., 20, 1527–1532,
#' https://doi.org/10.1175/1520-0450(1981)020<1527:NEFCVP>2.0.CO;2.
#'
#' Buck (1996), Buck (1996), Buck Research CR-1A User's Manual, Appendix 1.
#'
#' VAISALA. Humidity Conversions:
#' Formulas and methods for calculating humidity parameters. Ref. B210973EN-O
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param ... Additional arguments to supply to \code{\link{calcPws}}
#'
#' @return Pw, Water Vapour Pressure (hPa)
#' @export
#'
#' @examples
#' calcPw(20, 50)
#'
#' # Calculate relative humidity at 50%RH
#' calcPw(20, 50) / calcPws(20) * 100
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(Pw = calcPw(Temp, RH))
#'
#' mydata |> dplyr::mutate(Buck = calcPw(Temp, RH, method = "Buck"),
#'                               IAPWS = calcPw(Temp, RH, method = "IAPWS"),
#'                               Magnus = calcPw(Temp, RH, method = "Magnus"),
#'                               VAISALA = calcPw(Temp, RH, method = "VAISALA"))
#'
#'
calcPw <- function(Temp, RH, ...) {
  Pw = calcPws(Temp, ...) * RH / 100
  return(Pw)
}
