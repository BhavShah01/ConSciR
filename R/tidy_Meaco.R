#' Tidy Meaco sensor data
#'
#' @description
#' This function takes raw Meaco sensor data and performs several cleaning and processing steps:
#'
#' - Filters out rows with missing dates
#' - Renames columns for consistency
#' - Converts temperature and relative humidity to numeric
#' - Rounds dates down to the nearest hour
#' - Calculates hourly averages for temperature and relative humidity
#' - Pads the data to ensure hourly intervals
#' - Filters out implausible temperature and humidity values
#'
#'
#'
#' @param mydata A data frame containing raw Meaco sensor data with columns
#' RECEIVER, TRANSMITTER, DATE, TEMPERATURE, and HUMIDITY
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
tidy_Meaco <- function(mydata) {

  tidy_data <-
    mydata |>
    dplyr::filter(!is.na(DATE)) |>
    dplyr::rename(
      "Site" = RECEIVER,
      "Sensor" = TRANSMITTER,
      "Date" = DATE,
      "Temp" = TEMPERATURE,
      "RH" = HUMIDITY
    ) |>
    dplyr::mutate(
      # Date = ifelse(
      #   is.character(Date),
      #   lubridate::parse_date_time(Date, orders = "dmYHM", tz = "UTC", quiet = TRUE),
      #   Date
      # ),
      Temp = as.numeric(Temp),
      RH = as.numeric(RH)
    ) |>
    dplyr::mutate(
      Date = lubridate::floor_date(Date, unit = "hour"),
    ) |>
    dplyr::group_by(Site, Sensor, Date) |>
    dplyr::summarise(
      Temp = mean(Temp, na.rm = TRUE),
      RH = mean(RH, na.rm = TRUE)
    ) |>
    padr::pad(by = "Date", interval = "hour") |>
    dplyr::ungroup() |>
    dplyr::group_by(Site, Sensor) |>
    dplyr::arrange(Sensor, Date) |>
    dplyr::filter(between(Temp, -50, 50)) |>
    dplyr::filter(between(RH, 0, 100))


    return(tidy_data)

}
