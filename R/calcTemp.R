#' Calculate Temperature from relative humidity and dew point
#'
#' @description
#' This function calculates the temperature (°C) from relative humidity (\%) and dew point temperature (°C).
#'
#' @details
#' The temperature is calculated using the following equation derived from the August-Roche-Magnus approximation:
#'
#' \deqn{TempC=\frac{243.04\times\left(\frac{17.625\times DewP}{243.04+DewP}-\log\left(\frac{RH}{100}\right)\right)}{17.625+\log\left(\frac{RH}{100}\right)-\frac{17.625\times DewP}{243.04+DewP}}}
#'
#' Where:
#'
#' \itemize{
#'   \item Temp is the calculated temperature in Celsius
#'   \item RH is the relative humidity in percent
#'   \item DewP is the dew point temperature in Celsius
#' }
#'
#' @seealso \code{\link{calcTemp}} for calculating temperature
#' @seealso \code{\link{calcDP}} for calculating dew point
#' @seealso \code{\link{calcRH_DP}} for calculating relative humidity from dew point
#' @seealso \code{\link{calcRH_AH}} for calculating relative humidity from absolute humidity
#'
#'
#' @param RH Relative Humidity (0-100\%)
#' @param DewP Td, Dew Point (°Celsius)
#'
#' @return Temp, Temperature (°Celsius)
#' @export
#'
#' @examples
#' # Calculate temperature for RH of 50% and dew point of 15°C
#' calcTemp(50, 15)
#'
#' calcTemp(50, calcDP(20, 50))
#'
#' head(mydata) |> dplyr::mutate(DewPoint = calcDP(Temp, RH), Temp2 = calcTemp(RH, DewPoint))
#'
#'
calcTemp <- function(RH, DewP) {
  Temp <- 243.04 * (((17.625 * DewP) / (243.04 + DewP)) - log(RH / 100)) /
    (17.625 + log(RH / 100) - ((17.625 * DewP) / (243.04 + DewP)))

  return(Temp)
}
