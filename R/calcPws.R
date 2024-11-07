#' Calculate water vapour pressure (hPa) from temperature (C)
#'
#' @description
#' Function to calculate water vapour saturation pressure in hPa between 0C and 373C.
#'
#' If using a dataframe, columns should ideally be named "Temp".
#'
#' If lower accuracy or a limited temperature range can be tolerated a simpler formula
#' can be used for the water vapour saturation pressure over water (and over ice):
#' Pws = A \* 10 \^ ( (m \* Temp) / (Temp + Tn) )
#'
#' @references
#' W. Wagner and A. Pruß:" The IAPWS Formulation 1995 for the Thermodynamic Properties of
#' Ordinary Water Substance for General and Scientific Use ", Journal of Physical and
#' Chemical Reference Data, June 2002 ,Volume 31, Issue 2, pp.387535
#'
#'
#' @param Temp Temperature (Celsius)
#'
#' @return Pws, Saturation vapor pressure (hPa). 0.083\% error for T range -20 to +50°C
#' @export
#'
#' @examples
#' calcPws(20)
#'
#'
calcPws <- function(Temp) {

  # Temperature in K
  TempK = Temp + 273.15

  # Critical temperature, K
  Tc = 647.096

  # Critical pressure, hPa
  Pc = 220640

  # Ci = Coefficients
  C1 = -7.85951783; C2 = 1.84408259; C3 = -11.7866497
  C4 = 22.6807411; C5 = -15.9618719; C6 = 1.80122502
  A = 6.116441; m = 7.591386; Tn = 240.7263

  veta = 1 - (TempK / Tc)
  lnPwsPc = (Tc / TempK) *
    (C1 * veta + C2 * (veta^1.5) + C3 * (veta ^ 3) + C4 * (veta ^ 3.5) +
       C5 * (veta ^ 4) + C6 * (veta^7.5))

  Pws = Pc * exp(lnPwsPc)

  # If lower accuracy or a limited temperature range can be tolerated a simpler formula can be used for the water vapour saturation pressure over water (and over ice):
  # Pws = A * 10 ^ ( (m * Temp) / (Temp + Tn) )

  return(Pws)
}
