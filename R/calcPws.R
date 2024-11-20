#' Calculate Water Vapour Saturation Pressure
#'
#' @description
#' Function to calculate water vapour saturation pressure (hPa) from temperature (°C)
#' using the International Association for the Properties of Water and Steam (IAPWS as default) or
#' August-Roche-Magnus approximation.
#'
#' Water vapour saturation pressure is the maximum partial pressure of water vapour that
#' can be present in gas at a given temperature.
#'
#'
#'
#' @seealso \code{\link{calcMR}} for calculating mixing ratio
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#' @note
#' If lower accuracy or a limited temperature range can be tolerated a simpler formula
#' can be used for the water vapour saturation pressure over water (and over ice):
#'
#' Pws = 6.116441 x 10^( (7.591386 x Temp) / (Temp + 240.7263) )
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
#'
#' @param Temp Temperature (°Celsius)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param method Character. Method to use for calculation. Options are "IAPWS" (default) or "Magnus".
#'
#' @return Pws, Saturation vapor pressure (hPa)
#' @export
#'
#' @examples
#' calcPws(20)
#'
#' calcPws(20, method = "IAPWS")
#' calcPws(20, method = "Magnus")
#'
#' # Calculate relative humidity at 50%RH
#' calcPw(20, 50) / calcPws(20, method = "IAPWS") * 100
#' calcPw(20, 50) / calcPws(20, method = "Magnus") * 100
#'
#' head(mydata) |> dplyr::mutate(Pws = calcPws(Temp))
#'
#'
calcPws <- function(Temp, P_atm = 1013.25, method = "IAPWS") {

  if (method == "Magnus") {

    # August-Roche-Magnus approximation
    Pws = 6.1094 * exp((17.625 * Temp) / (243.04 + Temp))

    # Pressure correction factor
    Pws = Pws * (P_atm / 1013.25)


  } else if (method == "IAPWS") {

    # IAPWS formulation
    TempK <- Temp + 273.15
    Tc = 647.096
    Pc = 220640  # Critical pressure
    C1 = -7.85951783
    C2 = 1.84408259
    C3 = -11.7866497
    C4 = 22.6807411
    C5 = -15.9618719
    C6 = 1.80122502

    veta = 1 - (TempK / Tc)

    lnPwsPc = (Tc / TempK) * (C1 * veta + C2 * (veta^1.5) + C3 * (veta^3) +
                                 C4 * (veta^3.5) + C5 * (veta^4) + C6 * (veta^7.5))

    Pws = Pc * exp(lnPwsPc)


  } else {
    stop("Invalid method. Choose 'Magnus' or 'IAPWS'.")
  }

  # If lower accuracy or a limited temperature range can be tolerated a simpler formula can be used for the water vapour saturation pressure over water (and over ice):
  # A = 6.116441
  # m = 7.591386
  # Tn = 240.7263
  # Pws = A * 10 ^ ( (m * Temp) / (Temp + Tn) )

  return(Pws)
}

