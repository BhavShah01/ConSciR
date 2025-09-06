#' Tidy Meaco sensor data
#'
#' @description
#' This function takes raw Meaco sensor data and performs several cleaning and processing steps:
#'
#' \itemize{
#'    \item Filters out rows with missing dates
#'    \item Renames column names for consistency
#'    \item Converts temperature and relative humidity to numeric
#'    \item Rounds dates down to the nearest hour
#'    \item Calculates hourly averages for temperature and relative humidity
#'    \item Pads the data to ensure hourly intervals using padr package
#'    \item Filters out unrealistic temperature and humidity values
#'          (outside -50°C to 50°C and 0 to 100\%RH)
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
#' \donttest{
#' # Example usage: meaco_data <- tidy_Meaco("path/to/your/meaco_data.csv")
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


  tidy_data <-
    mydata |>
    dplyr::rename_with(
      ~ dplyr::case_when(
        . == "RECEIVER" ~ "Site",
        . == "TRANSMITTER" ~ "Sensor",
        . == "DATE" ~ "Date",
        . == "TEMPERATURE" ~ "Temp",
        . == "HUMIDITY" ~ "RH",
        TRUE ~ .
      )
    ) |>
    dplyr::mutate(
      Date = lubridate::parse_date_time(
        Date,
        orders = c("ymd HMS", "ymd HM", "ymd",
                   "dmy HMS","dmy HM", "dmy",
                   "mdy HMS", "mdy HM", "mdy"),
        quiet = TRUE),
      RH = as.numeric(RH)
    ) |>
    dplyr::mutate(
      Date = lubridate::floor_date(Date, unit = "hour")
    ) |>
    dplyr::group_by(Date, across(c("Sensor", "Site"), .names = "{.col}")) |>
    dplyr::summarise(
      Temp = mean(Temp, na.rm = TRUE),
      RH = mean(RH, na.rm = TRUE)
    ) |>
    dplyr::ungroup() |>
    padr::pad(by = "Date", interval = "hour") |>
    dplyr::group_by(Site, Sensor) |>
    dplyr::arrange(Sensor, Date) |>
    dplyr::filter(between(Temp, -50, 50)) |>
    dplyr::filter(between(RH, 0, 100))

  return(tidy_data)
}
