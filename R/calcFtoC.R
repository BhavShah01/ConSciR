#' Convert temperature (F) to temperature (C)
#'
#' @description
#' Convert temperature in Fahrenheit to temperature in Celsius
#'
#'
#' @param TempF Temperature (Fahrenheit )
#'
#' @return TempC Temperature (Celsius)
#' @export
#'
#' @examples
#' calcFtoC(32)
#' calcFtoC(68)
#'
#' head(mydata) |> dplyr::mutate(TempC = calcFtoC((Temp * 9/5) + 32))
#'
#'
calcFtoC <- function(TempF) {
  # Temperature Celcius to Fahrenheit
  TempC = (TempF - 32) * 5/9
  return(TempC)
}
