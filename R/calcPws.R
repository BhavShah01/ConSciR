#' Calculate Water Vapour Saturation Pressure
#'
#' @description
#' Function to calculate water vapour saturation pressure (hPa) from temperature (°C)
#' using the International Association for the Properties of Water and Steam (IAPWS as default),
#' Arden Buck equation (Buck), August-Roche-Magnus approximation (Magnus) or VAISALA conversion formula.
#'
#' Water vapour saturation pressure is the maximum partial pressure of water vapour that
#' can be present in gas at a given temperature.
#'
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
#'
#'
#' @seealso \code{\link{calcMR}} for calculating mixing ratio
#' @seealso \code{\link{calcAD}} for calculating air density
#' @seealso \code{\link{calcPw}} for calculating water vapour pressure
#' @seealso \code{\link{calcPws}} for calculating water vapour saturation pressure
#'
#' @note
#' See Wikipedia for a discussion of the accuarcy of each approach:
#' https://en.wikipedia.org/wiki/Vapour_pressure_of_water
#'
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
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param method Character. Method to use for calculation. Options are "Buck" (default), "IAPWS", "Magnus" or "VAISALA".
#'
#' @return Pws, Saturation vapor pressure (hPa)
#' @export
#'
#' @examples
#' # Saturation vapour pressure at 20°C
#' calcPws(20)
#' calcPws(20, method = "Buck")
#' calcPws(20, method = "IAPWS")
#' calcPws(20, method = "Magnus")
#' calcPws(20, method = "VAISALA")
#'
#' # Check of calculations of relative humidity at 50%RH
#' calcPw(20, 50, method = "Buck") / calcPws(20, method = "Buck") * 100
#' calcPw(20, 50, method = "IAPWS") / calcPws(20, method = "IAPWS") * 100
#' calcPw(20, 50, method = "Magnus") / calcPws(20, method = "Magnus") * 100
#' calcPw(20, 50, method = "VAISALA") / calcPws(20, method = "VAISALA") * 100
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(Pws = calcPws(Temp))
#'
#' mydata |> dplyr::mutate(Buck = calcPws(Temp, method = "Buck"),
#'                               IAPWS = calcPws(Temp, method = "IAPWS"),
#'                               Magnus = calcPws(Temp, method = "Magnus"),
#'                               VAISALA = calcPws(Temp, method = "VAISALA"))
#'
calcPws <- function(Temp, P_atm = 1013.25, method = c("Buck", "IAPWS", "Magnus", "VAISALA")) {
  method <- match.arg(method)

  TempK = Temp + 273.15

  if (method == "Buck") {

    # Saturation vapor pressure over water in hPa
    Pws_water = 6.1121 * exp((18.678 - (Temp / 234.5)) * (Temp / (257.14 + Temp)))
    # Saturation vapor pressure over ice in hPa
    Pws_ice = 6.1115 * exp((23.036 - (Temp / 333.7)) * (Temp / (279.82 + Temp)))

    Pws = ifelse(Temp < 0, Pws_ice, Pws_water)

  } else if (method == "IAPWS") {

    # IAPWS formulation
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


  } else if (method == "Magnus") {

    # August-Roche-Magnus approximation
    Pws = 6.1094 * exp((17.625 * Temp) / (243.04 + Temp))

    # Pressure correction factor
    Pws = Pws * (P_atm / 1013.25)


  } else if (method == "VAISALA") {

    a0_w = 1 # Pa
    a1_w = -6096.9385 # K
    a2_w = 21.2409642 #
    a3_w = -0.02711193 # K-1
    a4_w = 1.673952e-05 # K-2
    a5_w = 2.433502
    a6_w = 1 # K-1

    a0_i = 1 # Pa
    a1_i = -6024.5282 # K
    a2_i = 29.32707 #
    a3_i = 0.010613868 # K-1
    a4_i = -1.3198825e-05 # K-2
    a5_i = -0.4938258
    a6_i = 1 # K-1

    # Saturation vapor pressure over water in Pa
    Pws_water = a0_w * exp((a1_w / TempK) + a2_w + (a3_w * TempK) +
                             (a4_w * TempK^2) + (a5_w * log(a6_w * TempK)))
    # Saturation vapor pressure over ice in Pa
    Pws_ice = a0_i * exp((a1_i / TempK) + a2_i + (a3_i * TempK) +
                                       (a4_i * TempK^2) + (a5_i * log(a6_i * TempK)))

    Pws = ifelse(Temp < 0, Pws_ice, Pws_water) / 100 # return in hPa

  } else {
    stop("Invalid method. Choose 'IAPWS', 'Buck' or 'Magnus'.")
  }

  # If lower accuracy or a limited temperature range can be tolerated a simpler formula can be used for the water vapour saturation pressure over water (and over ice):
  # A = 6.116441
  # m = 7.591386
  # Tn = 240.7263
  # Pws = A * 10 ^ ( (m * Temp) / (Temp + Tn) )

  return(Pws)
}

