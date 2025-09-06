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
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(TempC = calcFtoC((Temp * 9/5) + 32))
#'
#'
calcFtoC <- function(TempF) {
  # Temperature Celcius to Fahrenheit
  TempC = (TempF - 32) * 5/9
  return(TempC)
}
