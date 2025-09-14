#' Tidy Meaco sensor data
#'
#' @description
#' This function takes raw Meaco sensor data and returns data with renamed columns.
#'
#'
#' @param mydata A data frame containing raw Meaco sensor data with columns
#' RECEIVER, TRANSMITTER, DATE, TEMPERATURE, and HUMIDITY
#' @param Site_col A string specifying the name of the column in `mydata` that contains
#' location information. Default is "RECEIVER".
#' @param Sensor_col A string specifying the name of the column in `mydata` that contains
#' sensor information. Default is "TRANSMITTER".
#' @param Date_col A string specifying the name of the column in `mydata` that contains
#' date information. Default is "DATE".
#' @param Temp_col A string specifying the name of the column in `mydata` that contains
#' temperature data. Default is "TEMPERATURE".
#' @param RH_col A string specifying the name of the column in `mydata` that contains
#' relative humidity data. Default is "HUMIDITY".
#'
#' @return A tidied data frame with columns Site, Sensor, Date, Temp, and RH
#' @export
#'
#'
#' @importFrom dplyr filter rename mutate group_by summarise ungroup arrange between
#' @importFrom lubridate floor_date
#' @importFrom padr pad
#'
#' @examples
#'
#' \donttest{
#' # Example usage: meaco_data <- tidy_Meaco("path/to/your/meaco_data.csv")
#' }
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "Meaco")
#'
#' head(mydata)
#'
#' mydata |> tidy_Meaco()
#'
#' mydata |> tidy_Meaco() |> tidy_TRHdata(avg_time = "hour")
#'
#'
#'
tidy_Meaco <- function(mydata,
                       Site_col = "RECEIVER",
                       Sensor_col = "TRANSMITTER",
                       Date_col = "DATE",
                       Temp_col = "TEMPERATURE",
                       RH_col = "HUMIDITY") {

    dat <- mydata

    dat <- dat |>
      dplyr::rename(
        Site = !!rlang::sym(Site_col),
        Sensor = !!rlang::sym(Sensor_col),
        Date = !!rlang::sym(Date_col),
        Temp = !!rlang::sym(Temp_col),
        RH = !!rlang::sym(RH_col)
      )

  return(dat)
}
