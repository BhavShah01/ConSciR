#' Tidy and Process Temperature and Relative Humidity data
#'
#' @description
#' This function tidies and processes temperature, relative humidity, and date data
#' from a given dataset. Dataset should minimally have "Date", "Temp" and "RH" columns.
#'
#' It filters out rows with missing dates, attempts to parse dates,
#' converts temperature and humidity to numeric types, and groups the data by Site,
#' Sensor, and Date based on the averaging interval.
#'
#' If the site or sensor columns are not present in the data, the function
#' defaults to adding columns named "Site" and "Sensor".
#' This can be changed in the arguments.
#'
#' When an averaging option of "hour", "day", "month" is selected,
#' it uses \code{openair::timeAverage()} to floor datetimes and calculate averages,
#' the default is median average.
#' See \code{openair::timeAverage()} for more options for averaging windows and statistics.
#' Missing time points are padded with NA.
#'
#'
#' \itemize{
#'   \item Filters out rows with missing dates.
#'   \item Renames columns for consistency.
#'   \item Converts temperature and relative humidity to numeric.
#'   \item Adds default columns "Site" and "Sensor" when missing or not supplied in args.
#'   \item Rounds dates down to the nearest hour, day, or month as per `avg_time`.
#'          See \code{openair::timeAverage()} for more options. Default is "none".
#'   \item Calculates averages for temperature and relative humidity according to `avg_statistic`.
#'          See \code{openair::timeAverage()} for more options. Default is "median".
#'   \item Pads data with missing datetime rows having NA values for other columns if `avg_time` is chosen.
#'   \item Filters out implausible temperature and humidity values (outside -50-80°C and 0-100\%RH).
#' }
#'
#'
#' @param mydata A data frame containing TRH data. Ideally, this should have
#' columns for "Site", "Sensor", "Date", "Temp" (temperature), and "RH" (relative humidity).
#' The function requires at least the date, temperature, and relative humidity columns to be present.
#' Site and sensor columns are optional; if missing, the function will add default
#' columns named "Site" and "Sensor" respectively with values below.
#' @param Site A string specifying the name of the column in `mydata` that contains
#' location information. If missing, defaults to "Site".
#' @param Sensor A string specifying the name of the column in `mydata` that contains
#' sensor information. If missing, defaults to "Sensor".
#' @param Date A string specifying the name of the column in `mydata` that contains
#' date information. Default is "Date". The column should ideally contain ISO 8601
#' date-time formatted strings (e.g. "2025-01-01 00:00:00"), but the function will try to
#' parse a variety of common datetime formats.
#' @param Temp A string specifying the name of the column in `mydata` that contains
#' temperature data. Default is "Temp".
#' @param RH A string specifying the name of the column in `mydata` that contains
#' relative humidity data. Default is "RH".
#' @param avg_time Character string specifying the averaging interval.
#'  One of "none" (no averaging), "hour", "day", or "month", etc.
#'  See \code{openair::timeAverage()} for more options.
#' @param avg_statistic Statistic for averaging; default is "median".
#'  See \code{openair::timeAverage()} for more options.
#' @param avg_groups Character vector specifying grouping columns for time-averaging.
#'  These are then returned as factors. Default is c("Site", "Sensor").
#' @param ... Additional arguments to supply to \code{openair::timeAverage()}.
#'
#'
#' @return A tidy data frame with processed TRH data. When averaging,
#'   date times are floored, Temp and RH are averaged, groups are factored,
#'   and missing date times are padded with NA rows.
#' @export
#'
#' @importFrom dplyr filter rename mutate select
#' @importFrom lubridate parse_date_time
#' @importFrom openair timeAverage
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 10)
#'
#' tidy_TRHdata(mydata)
#'
#' tidy_TRHdata(mydata, avg_time = "hour")
#'
#' mydata |> add_humidity_calcs() |> tidy_TRHdata(avg_time = "hour")
#'
#' \donttest{
#' # Example usage: TRH_data <- tidy_TRHdata("path/to/your/TRHdata.csv")
#' }
#'
#'
tidy_TRHdata <- function(mydata,
                         Site = "Site",
                         Sensor = "Sensor",
                         Date = "Date",
                         Temp = "Temp",
                         RH = "RH",
                         avg_time = "none",
                         avg_statistic = "median",
                         avg_groups = c("Site", "Sensor"), ...) {

  dat <- mydata

  # Helper function to rename a column only if needed and safe
  safe_rename <- function(dat, old_name, new_name) {
    if (old_name %in% names(dat)) {
      if (new_name %in% names(dat) && old_name != new_name) {
        # Rename old_name to a temporary name first to avoid clash
        tmp_name <- paste0(new_name, "_tmp")
        # Rename old_name column to tmp_name safely
        colnames(dat)[which(names(dat) == old_name)] <- tmp_name
        # Remove any existing new_name column to avoid conflict
        dat[[new_name]] <- NULL
        # Rename tmp_name column to new_name
        colnames(dat)[which(names(dat) == tmp_name)] <- new_name
      } else {
        # Rename old_name column to new_name directly
        colnames(dat)[which(names(dat) == old_name)] <- new_name
      }
    }
    dat
  }

  # Site column handling
  if (!"Site" %in% names(dat)) {
    # Site column missing in data
    if (length(Site) == 1 && !(Site %in% names(dat))) {
      # Site is a constant string, add new column with that constant
      dat$Site <- Site
    } else {
      stop("Site column missing and Site argument not found.")
    }
  } else {
    # Site exists, rename user column to Site if needed
    if (!is.null(Site) && Site != "Site" && Site %in% names(dat)) {
      dat <- dat |> dplyr::rename(Site = !!rlang::sym(Site))
    }
  }

  # Sensor column handling
  if (!"Sensor" %in% names(dat)) {
    if (length(Sensor) == 1 && !(Sensor %in% names(dat))) {
      dat$Sensor <- Sensor
    } else {
      stop("Sensor column missing and Sensor argument not found.")
    }
  } else {
    if (!is.null(Sensor) && Sensor != "Sensor" && Sensor %in% names(dat)) {
      dat <- dat |> dplyr::rename(Sensor = !!rlang::sym(Sensor))
    }
  }

  # # Add Site, Sensor columns if not present
  # if (!"Site" %in% names(dat)) {
  #   dat$Site <- "Site"
  #   Site <- "Site"
  # } else {
  #   Site <- Site %||% "Site"
  # }
  #
  # if (!"Sensor" %in% names(dat)) {
  #   dat$Sensor <- "Sensor"
  #   Sensor <- "Sensor"
  # } else {
  #   Sensor <- Sensor %||% "Sensor"
  # }

  # Date
  if (!Date %in% names(dat) && "Date" %in% names(dat)) {
    Date <- "Date"
  } else if (Date %in% names(dat) && Date != "Date") {
    dat <- safe_rename(dat, Date, "Date")
    Date <- "Date"
  } else if (!("Date" %in% names(dat))) {
    stop("Date column is missing.")
  }

  # Temp
  if (!Temp %in% names(dat) && "Temp" %in% names(dat)) {
    Temp <- "Temp"
  } else if (Temp %in% names(dat) && Temp != "Temp") {
    dat <- safe_rename(dat, Temp, "Temp")
    Temp <- "Temp"
  } else if (!("Temp" %in% names(dat))) {
    stop("Temp column is missing.")
  }

  # RH
  if (!RH %in% names(dat) && "RH" %in% names(dat)) {
    RH <- "RH"
  } else if (RH %in% names(dat) && RH != "RH") {
    dat <- safe_rename(dat, RH, "RH")
    RH <- "RH"
  } else if (!("RH" %in% names(dat))) {
    stop("RH column is missing.")
  }


  # Convert Temp RH to numeric
  dat[[RH]] <- as.numeric(dat[[RH]])
  dat[[Temp]] <- as.numeric(dat[[Temp]])

  # Remove rows with missing time-stamps
  dat <- dat[!is.na(dat[[Date]]), ]

  # Parse date-times
  dat[[Date]] <-
    lubridate::parse_date_time(
      dat[[Date]], quiet = TRUE,
      orders = c("ymd HMS", "ymd HM", "ymd",
                 "dmy HMS", "dmy HM", "dmy",
                 "mdy HMS", "mdy HM", "mdy"))

  if (avg_time != "none") {
    dat <- dat |>
      dplyr::mutate(date = .data[[Date]]) |>
      select(-Date)

    dat <- openair::timeAverage(dat,
                                avg.time = avg_time,
                                statistic = avg_statistic,
                                type = avg_groups,
                                data.thresh = 0,
                                fill = TRUE, ...)

    dat <- dat |> rename(Date = date)
  }

  # Filter Temp and RH values
  dat <- dat |>
    dplyr::filter(.data[[Temp]] > -50 & .data[[Temp]] < 80) |>
    dplyr::filter(.data[[RH]] >= 0 & .data[[RH]] <= 100)

  return(dat)
}
