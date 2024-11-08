#' Calculate Preservation Index from temperature (C) and relative humidity (\%)
#'
#' @description
#' Chemical degradation of cellulose acetate – the Preservation Index of the
#' Image Permanence Institute (IPI) (Reilly et al., 1995)
#'
#' k = [RH%] × 5.9 × 1012 × e(-90300/(8.314 × T))
#'
#' PI = 1/k
#'
#' @source Tim Padfield, 2004
#'
#' @references
#' Reilly et al., 1995
#'
#' Padfield, T. 2004. The Preservation Index and The Time Weighted Preservation Index.
#' https://www.conservationphysics.org/twpi/twpi_01.html
#'
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#'
#' @return PI Preservation Index, the expected lifetime 1/k
#' @export
#'
#' @examples
#' calcPI(20, 50)
#'
#' head(mydata) |> dplyr::mutate(PI = calcPI(Temp, RH))
#'
#'
calcPI <- function(Temp, RH) {

  # k is expressed as the fraction of expected lifetime per year of the degradation
  k = RH * 5.9e12 * exp(-90300 / (8.314 * (Temp + 273.15) ))

  # The expected lifetime, PI, is 1/k
  PI = 1/k

  return(PI)
}
