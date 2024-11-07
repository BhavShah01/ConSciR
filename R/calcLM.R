#' Life-time multiplier (Michalski, 2002) for chemical degradation
#'
#' @description
#' Function to calculate life-time multiplier in J/mol from temperature in Celsius and relative humidity in \% (0-100).
#'
#' If using a dataframe, columns should ideally be named "Temp" and "RH".
#'
#' @source
#' Michalski, 2002
#'
#' @references Michalski, S., ‘Double the life for each five-degree drop,
#' more than double the life for each halving of relative humidity’,
#' in Preprints of the 13th IcOM-cc Triennial Meeting in rio de Janeiro (22–27 September 2002),
#' ed. r. Vontobel, James & James, London (2002) Vol. I 66–72.
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param EA Activation Energy (J/mol) 100 for cellulosic (paper) or 70 yellowing varnish
#'
#' @return Lifetime multiplier
#' @export
#'
#' @examples
#' calcLM(20, 50)
#'
#' head(mydata) |> dplyr::mutate(LifeTime = calcLM(Temp, RH))
#'
#'
calcLM = function(Temp, RH, EA = 100) {
  # EA = Activation energy J/mol, R = 8.314 J/Kmol
  # EA 100 for cellulosic (paper) # EA 70 varnish yellowing

  LM = (50 / RH) ^ (1/3) * exp((EA / 8.314) * (1 / Temp - 1 / 293.15))
  return(LM)
}
