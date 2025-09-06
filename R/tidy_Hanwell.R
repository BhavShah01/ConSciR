#' Tidy Hanwell EMS Data (Min-Max report)
#'
#' @description
#' This function reads and processes Hanwell Environmental Monitoring System (EMS) data,
#' transforming it into a tidy format suitable for analysis.
#'
#'
#' @param EMS_MinMax_datapath EMS_MinMax_datapath Character string specifying the
#' file path to the Hanwell EMS data file.
#'
#' @return A tibble containing the tidied Hanwell EMS data with the following columns:
#'
#' \itemize{
#'   \item Date Time POSIXct datetime of the measurement
#'   \item Sensor Character string identifying the sensor
#'   \item TempMin Numeric minimum temperature (°C)
#'   \item TempMax Numeric maximum temperature (°C)
#'   \item Temp Numeric average temperature (°C)
#'   \item RHMin Numeric minimum relative humidity (%)
#'   \item RHMax Numeric maximum relative humidity (%)
#'   \item RH Numeric average relative humidity (%)
#'   \item Date Date of the measurement (duplicate of Date Time)
#' }
#'
#'
#' @export
#'
#'
#' @importFrom lubridate parse_date_time
#' @importFrom tools file_ext
#' @importFrom readr read_csv
#' @importFrom dplyr mutate across
#' @importFrom tidyr pivot_longer pivot_wider separate
#' @importFrom stringr str_replace
#'
#' @examples
#'
#' \donttest{
#' # Example usage: hanwell_data <- tidy_Hanwell("path/to/your/EMS_MinMax_data.csv")
#' }
#'
#'
#'
tidy_Hanwell <- function(EMS_MinMax_datapath) {

  ext = tools::file_ext(EMS_MinMax_datapath)

  ems =
    readr::read_csv(EMS_MinMax_datapath, na = c("", "-", "NA"), skip = 7)

  ems_data_end = which(grepl("Alarm Limits", ems$`Date Time`)) - 2

  ems = ems[1: ems_data_end, ]

  ems =
    ems |>
    dplyr::mutate(`Date Time` = lubridate::parse_date_time(`Date Time`, format = "%d/%m/%Y %H:%M:%S")) |>
    dplyr::mutate(across(-c(`Date Time`), as.numeric)) |>
    tidyr::pivot_longer(cols = -`Date Time`) |>
    tidyr::separate(name, sep = " Chan: ", into = c("Sensor", "Channel")) |>
    dplyr::mutate(
      across("Channel", \(x) str_replace(x, "C Min", "TempMin")),
      across("Channel", \(x) str_replace(x, "C Max", "TempMax")),
      across("Channel", \(x) str_replace(x, "C Average", "Temp")),
      across("Channel", \(x) str_replace(x, "%RH Min", "RHMin")),
      across("Channel", \(x) str_replace(x, "%RH Max", "RHMax")),
      across("Channel", \(x) str_replace(x, "%RH Average", "RH")),
      across("Channel", \(x) str_replace(x, "1 ", "")),
      across("Channel", \(x) str_replace(x, "2 ", ""))) |>
    tidyr::pivot_wider(names_from = Channel, values_from = value) |>
    dplyr::mutate(Date = `Date Time`)

  return(ems)
}
