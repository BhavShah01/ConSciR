#' Tidy Meaco sensor data
#'
#' @description
#' This function takes raw Meaco sensor data and performs several cleaning and processing steps:
#'
#' \itemize{
#'    \item Filters out rows with missing dates
#'    \item Renames columns for consistency
#'    \item Converts temperature and relative humidity to numeric
#'    \item Rounds dates down to the nearest hour
#'    \item Calculates hourly averages for temperature and relative humidity
#'    \item Pads the data to ensure hourly intervals
#'    \item Filters out implausible temperature and humidity values
#' }
#'
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
#' \dontrun{
#' raw_data <- read.csv("meaco_data.csv")
#' clean_data <- tidy_Meaco(raw_data)
#' }
#'
#'
#'
tidy_Meaco <- function(mydata,
                       Site_col = "RECEIVER",
                       Sensor_col = "TRANSMITTER",
                       Date_col = "DATE",
                       Temp_col = "TEMPERATURE",
                       RH_col = "HUMIDITY") {

  # Call tidy_TRHdata to process Meaco data
  tidy_data <- tidy_TRHdata(mydata,
                            Site_col = Site_col,
                            Sensor_col = Sensor_col,
                            Date_col = Date_col,
                            Temp_col = Temp_col,
                            RH_col = RH_col)

  return(tidy_data)
}
