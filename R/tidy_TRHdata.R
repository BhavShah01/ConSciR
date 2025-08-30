#' Tidy and Process Temperature and Relative Humidity data
#'
#' @description
#' This function tidies and processes temperature, relative humidity, and date data
#' from a given dataset.
#'
#' It filters out rows with missing date values, renames columns,
#' converts temperature and humidity to numeric types, and groups the data by site,
#' sensor, and date. The function also pads the data to ensure hourly intervals.
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
#' @param mydata A data frame containing the raw TRH data. This should include columns
#' for site, sensor, date, temperature, and relative humidity.
#' @param Site_col A string specifying the name of the column in `mydata` that contains
#' location information. Default is "Site".
#' @param Sensor_col A string specifying the name of the column in `mydata` that contains
#' sensor information. Default is "Sensor".
#' @param Date_col A string specifying the name of the column in `mydata` that contains
#' date information. Default is "Date".
#' @param Temp_col A string specifying the name of the column in `mydata` that contains
#' temperature data. Default is "Temp".
#' @param RH_col A string specifying the name of the column in `mydata` that contains
#' relative humidity data. Default is "RH".
#'
#'
#' @return A tidy data frame containing processed TRH data with columns for Site,
#' Sensor, Date (floored to the nearest hour), Temperature (mean values),
#' and Relative Humidity (mean values).
#' @export
#'
#' @importFrom dplyr filter rename mutate group_by summarise ungroup arrange between
#' @importFrom lubridate floor_date
#' @importFrom padr pad
#'
#' @examples
#' \dontrun{
#' # Example usage: mydata <- read.csv("path/to/your/data.csv")
#' tidy_data <- tidy_TRHdata(mydata,
#'                            Site_col = "RECEIVER",
#'                            Sensor_col = "TRANSMITTER",
#'                            Date_col = "DATE",
#'                            Temp_col = "TEMPERATURE",
#'                            RH_col = "HUMIDITY")
#'
#' # View the tidy data
#' head(tidy_data)
#' }
#'
#'
#'
tidy_TRHdata <- function(mydata,
                         Site_col = "Site",
                         Sensor_col = "Sensor",
                         Date_col = "Date",
                         Temp_col = "Temp",
                         RH_col = "RH") {

  tidy_data <-
    mydata |>
    tidy_Meaco()

  return(tidy_data)
}
