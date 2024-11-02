#' Calculate dew point from temperature (C) and relative humidity (\%)
#'
#' @description
#' Function to calculate dew point in Celsius from temperature in Celsius and relative humidity in \% (0-100).
#'
#' If using a dataframe, columns should ideally be named "Temp" and "RH".
#'
#' Calculations based on NOAA.
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#'
#' @return Dew Point (Celsius)
#' @export
#'
#' @examples
#' calc_dew_point(20, 50)
#'
#' mydata |> mutate(DewPoint = calcDP(Temp, RH))

calcDP <- function(Temp = Temp, RH = RH) {
  240.7263/(7.591386/(log10(220640*(exp((647.096/(Temp + 273.16))*((-7.85951783*(1 - ((Temp + 273.16)/647.096))) + (1.84408259*(1 - ((Temp + 273.16)/647.096))^1.5) + (-11.7866497*(1 - ((Temp + 273.16)/647.096))^3) + (22.6807411*(1 - ((Temp + 273.16)/647.096))^3.5) + (-15.9618719*(1 - ((Temp + 273.16)/647.096))^4) + (1.80122502*(1 - ((Temp + 273.16)/647.096))^7.5))))*(RH/100)/6.116441)) - 1)
}
