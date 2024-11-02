#' Calculate dew point from temperature (C) and relative humidity (\%)
#'
#' @description
#' Function to calculate dew point in Celsius from temperature in Celsius and relative humidity in \% (0-100).
#' Dataframe columns should ideally be named "Temp" and "RH".
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative humidity (0-100\%)
#'
#' @return Dew point (Celsius)
#' @export
#'
#' @examples
#' calcDewPoint(20, 50)
#'
calcDewPoint <- function(Temp = Temp, RH = RH) {
  AT = Temp
  Ps = (1.10461E-15*AT^10+-1.187682E-13*AT^9+3.089754E-12*AT^8+7.150535E-11*AT^7+-3.770916E-9*AT^6+4.760219E-9*AT^5+1.725056E-6*AT^4+1.746817E-5*AT^3+0.001223148*AT^2+0.04660427*AT+0.6072509)*1000
  Pp = (RH*Ps)/100
  DPT = -3.873E-4*(Pp/1000)^10+0.0149418*(Pp/1000)^9+-0.24786*(Pp/1000)^8+2.31356*(Pp/1000)^7+-13.3556*(Pp/1000)^6+49.4022*(Pp/1000)^5+-117.598*(Pp/1000)^4+177.263*(Pp/1000)^3+-165.629*(Pp/1000)^2+103.018*(Pp/1000)+-28.44915
  return(DPT)
}
