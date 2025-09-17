#' Add Time Variables
#'
#' This function adds multiple time-related variables to a dataframe with a Date column.
#' It creates standard factors such as season, month-year, day-hour, and determines summer/winter.
#' It also allows flexible specification of summer and winter start/end dates,
#' and a custom time period.
#'
#' @details
#' The variables \code{seasonyear}, \code{season}, \code{monthyear}, and \code{daylight}
#' are created using the \code{openair::cutData()}
#' function internally and rely on geographic coordinates (latitude, longitude)
#' to calculate daylight status.
#' Be sure \code{openair} is installed and loaded for these variables.
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
#' @return A data frame with additional time-related columns appended:
#' \describe{
#'   \item{seasonyear}{Combined year and season factor created by \code{openair::cutData()};
#'          useful for seasonal analyses.}
#'   \item{season}{Season factor (e.g., Spring, Summer) from \code{openair::cutData()}.}
#'   \item{monthyear}{Factor combining month and year, created by \code{openair::cutData()}
#'          to assist month-based grouping.}
#'   \item{daylight}{Boolean or factor indicating daylight presence/absence,
#'          derived using \code{openair::cutData()} with latitude and longitude inputs.}
#'   \item{day}{Date part of the timestamp, rounded down to day boundary, useful for daily aggregation.}
#'   \item{hour}{Hour of the day extracted from the datetime.}
#'   \item{dayhour}{Datetime floored to the hour; useful for hourly time series analysis.}
#'   \item{weekday}{Weekday name/factor, abbreviated, extracted from the date.}
#'   \item{month}{Month number and its labelled factor version; useful for calendar-based grouping.}
#'   \item{year}{Year extracted from the datetime for annual analyses.}
#'   \item{DayYear}{Date with the current year but month and day taken from the
#'          original date; used to assign seasons and periods relative to current year.}
#'   \item{Summer}{A factor ("Summer" or "Winter") determined by comparison of \code{DayYear}
#'          with user-defined \code{summer_start} and \code{summer_end} dates,
#'          for custom seasonality modelling.}
#'   \item{Period}{Character flag identifying whether the date falls within a user-defined
#'          custom period (e.g., an exhibition), labelled by \code{period_label}.
#'          Returns \code{NA} if no period defined.}
#' }
#'
#'
#' @importFrom lubridate floor_date hour month year day make_date now as_date wday
#' @importFrom dplyr mutate if_else rename
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
      weekday = wday(date, label = TRUE, abbr = TRUE),
      Month = month(date),
      month = month(date, label = TRUE, abbr = TRUE),
      year = year(date),
      DayYear = make_date(
        year = year(now()),
        month = month(date),
        day = day(date)
      ),
      Summer = if_else(
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
