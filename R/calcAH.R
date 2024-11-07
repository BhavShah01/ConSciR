#' Calculate absolute humidity from temperature (C) and relative humidity (\%)
#'
#' @description
#' Function to calculate absolute humidity (g/m^3) from temperature (C) and relative humidity (\%)
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#'
#' @return AH Absolute Humidity (g/m^3)
#' @export
#'
#'
#' @examples
#' calcAH(20, 50)
#'
#' head(mydata) |> dplyr::mutate(Abs = calcAH(Temp, RH))
#'
#'
calcAH <- function(Temp, RH) {
  AH = ((RH * (1.10461E-15 * Temp^10 +
                -1.187682E-13 * Temp^9 +
                3.089754E-12 * Temp^8 +
                7.150535E-11 * Temp^7 +
                -3.770916E-9 * Temp^6 +
                4.760219E-9 * Temp^5 +
                1.725056E-6 * Temp^4 +
                1.746817E-5 * Temp^3 +
                0.001223148 * Temp^2 +
                0.04660427 * Temp +
                0.6072509) * 1000) / 100 / (Temp + 273.15)) * (18.01528 / 8.31441)
  return(AH)
}
