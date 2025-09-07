#' Add Time Variables to a dataframe
#'
#' This function adds multiple time-related variables to a dataframe with a Date column.
#' It creates standard factors such as season, month-year, day-hour, and determines summer/winter seasonality.
#' It also allows flexible specification of summer and winter start/end dates, and a custom time period.
#'
#' @param mydata A dataframe containing a date/time column labelled "Date" and "Sensor" column.
#' @param Date The name of the date/time column in `mydata` (default "Date").
#' @param openair_vars Variables from `openair::cutData()` to add (default includes seasonyear, season, monthyear, daylight).
#' @param summer_start Start date for summer season in "MM-DD" format or full date (default "04-15").
#' @param summer_end End date for summer season in "MM-DD" format or full date (default "10-15").
#' @param period_start Start date of custom period in "MM-DD" format or full date (optional).
#' @param period_end End date of custom period in "MM-DD" format or full date (optional).
#' @param period_label Label to assign for dates within the custom period, e.g. if there is an Exhibition or a property is open/closed to the public (default "Period").
#' @param latitude Latitude for daylight calculations (default 51).
#' @param longitude Longitude for daylight calculations (default -0.5).
#' @param ... Additional arguments passed to `openair::cutData()`.
#'
#' @return Dataframe with appended columns:
#'   \describe{
#'     \item{seasonyear, season, monthyear, daylight}{Standard time factors as used in \code{openair::cutData()}.}
#'     \item{day, hour, dayhour, daymonth, month, year}{Time breakdowns for aggregation and analysis.}
#'     \item{Season}{Categorises row as "Summer" or "Winter" using user-specified thresholds.}
#'     \item{Period}{Flags whether each date falls within custom period (e.g. exhibition), with assigned label.}
#'   }
#'
#'
#' @importFrom lubridate floor_date hour month year day minute make_datetime make_date now as_date
#' @importFrom dplyr mutate if_else
#' @import openair
#' @export
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |>
#'   add_time_vars(period_start = "05-01", period_end = "06-30", period_label = "Exhibition") |>
#'   dplyr::glimpse()
#'
add_time_vars <- function(
    mydata,
    Date = "Date",
    openair_vars = c("seasonyear", "season", "monthyear", "daylight"),
    summer_start = "04-15", summer_end = "10-15",
    period_start = NULL, period_end = NULL,
    period_label = "Period",
    latitude = 51, longitude = -0.5,
    ...
){

  # Ensure Date column is POSIXct
  mydata[[Date]] <- as.POSIXct(mydata[[Date]])

  # Rename Date column to 'date' to match openair expectation
  # save original name for later restoration if needed
  if (Date != "date") {
    mydata <- dplyr::rename(mydata, date = !!rlang::sym(Date))
  }

  df <- mydata |>
    openair::cutData(
      type = openair_vars,
      site = "Sensor",
      latitude = latitude,
      longitude = longitude,
      ...
    ) |>
    mutate(
      day = floor_date(date, unit = "day"),
      hour = hour(date),
      dayhour = floor_date(date, unit = "hour"),
      daymonth = day(date),
      month = month(date, label = TRUE, abbr = TRUE),
      year = year(date),
      DayYear = make_date(
        year = year(now()),
        month = month(date),
        day = day(date)
      ),
      Season = if_else(
        DayYear >= as_date(paste(year(now()), summer_start, sep = "-")) &
          DayYear < as_date(paste(year(now()), summer_end, sep = "-")),
        "Summer", "Winter"
      ),
      Period = if (!is.null(period_start) & !is.null(period_end)) {
        if_else(
          DayYear >= as_date(paste(year(now()), period_start, sep = "-")) &
            DayYear <= as_date(paste(year(now()), period_end, sep = "-")),
          period_label, paste0("Outside ", period_label)
        )
      } else {
        NA_character_
      }
    )

  return(df)
}
