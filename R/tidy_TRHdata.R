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
#' it uses \code{dplyr} and \code{lubridate} functions to floor datetimes and calculate averages,
#' the default is median average.
#' See \code{lubridate::floor_date()} for rounding intervals.
#'
#' \itemize{
#'   \item Filters out rows with missing dates.
#'   \item Renames columns for consistency.
#'   \item Converts temperature and relative humidity to numeric.
#'   \item Adds default columns "Site" and "Sensor" when missing or not supplied in args.
#'   \item Rounds dates down to the nearest hour, day, or month as per \code{avg_time}.
#'   \item Calculates averages for temperature and relative humidity according to \code{avg_statistic}.
#'   \item Filters out implausible temperature and humidity values (outside -50-80°C and 0-100\%RH).
#' }
#'
#' @param mydata A data frame containing TRH data. Ideally, this should have
#' columns for "Site", "Sensor", "Date", "Temp" (temperature), and "RH" (relative humidity).
#' The function requires at least the date, temperature, and relative humidity columns to be present.
#' Site and sensor columns are optional; if missing, the function will add default
#' columns named "Site" and "Sensor" respectively with values below.
#' @param Site A string specifying the name of the column in \code{mydata} that contains
#' location information. If missing, defaults to "Site".
#' @param Sensor A string specifying the name of the column in \code{mydata} that contains
#' sensor information. If missing, defaults to "Sensor".
#' @param Date A string specifying the name of the column in \code{mydata} that contains
#' date information. Default is "Date". The column should ideally contain ISO 8601
#' date-time formatted strings (e.g. "2025-01-01 00:00:00"), but the function will try to
#' parse a variety of common datetime formats.
#' @param Temp A string specifying the name of the column in \code{mydata} that contains
#' temperature data. Default is "Temp".
#' @param RH A string specifying the name of the column in \code{mydata} that contains
#' relative humidity data. Default is "RH".
#' @param avg_time Character string specifying the averaging interval.
#' One of "none" (no averaging), "hour", "day", or "month", etc.
#' See \code{lubridate::floor_date()} for rounding intervals.
#' @param avg_statistic Statistic for averaging; default is "median".
#' @param avg_groups Character vector specifying grouping columns for time-averaging.
#' These are then returned as factors. Default is c("Site", "Sensor").
#' @param ... Additional arguments (currently unused).
#'
#' @return A tidy data frame with processed TRH data. When averaging,
#' date times are floored, temperature and humidity are averaged,
#' groups are factored, and implausible values filtered.
#' @export
#'
#' @importFrom dplyr filter rename mutate select group_by across summarise
#' @importFrom lubridate parse_date_time floor_date
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
                         avg_groups = c("Site", "Sensor"),
                         ...) {
  dat <- mydata


  # Meaco columns map
  meaco_col_map <- c(
    "RECEIVER" = "Site",
    "TRANSMITTER" = "Sensor",
    "DATE" = "Date",
    "TEMPERATURE" = "Temp",
    "HUMIDITY" = "RH"
  )

  # Check if all Meaco columns present (case insensitive)
  dat_col_upper <- toupper(names(dat))
  if (all(names(meaco_col_map) %in% dat_col_upper)) {
    dat <- tidy_Meaco(dat)
  } else {
    # Generic column map for other common names; only rename if column exists
    generic_col_map <- c(
      Date = "Date",
      Temp = "Temp",
      RH = "RH",
      Site = "Site",
      Sensor = "Sensor"
    )
    # Only rename columns present and where name != standard
    for (old_name in names(generic_col_map)) {
      new_name <- generic_col_map[[old_name]]
      if (old_name %in% names(dat) && old_name != new_name) {
        colnames(dat)[colnames(dat) == old_name] <- new_name
      }
    }
    # Add Site and Sensor columns if missing, using provided Site and Sensor values
    if (!"Site" %in% names(dat)) dat$Site <- Site
    if (!"Sensor" %in% names(dat)) dat$Sensor <- Sensor
  }

  safe_rename <- function(dat, old_name, new_name) {
    if (old_name %in% names(dat)) {
      if (new_name %in% names(dat) && old_name != new_name) {
        tmp_name <- paste0(new_name, "_tmp")
        colnames(dat)[which(names(dat) == old_name)] <- tmp_name
        dat[[new_name]] <- NULL
        colnames(dat)[which(names(dat) == tmp_name)] <- new_name
      } else {
        colnames(dat)[which(names(dat) == old_name)] <- new_name
      }
    }
    dat
  }

  # Site column handling
  if (!"Site" %in% names(dat)) {
    if (length(Site) == 1 && !(Site %in% names(dat))) {
      dat$Site <- Site
    } else {
      stop("Site column missing and Site argument not found.")
    }
  } else {
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

  # Date column handling
  if (!Date %in% names(dat) && "Date" %in% names(dat)) {
    Date <- "Date"
  } else if (Date %in% names(dat) && Date != "Date") {
    dat <- safe_rename(dat, Date, "Date")
    Date <- "Date"
  } else if (!("Date" %in% names(dat))) {
    stop("Date column is missing.")
  }

  # Temp column handling
  if (!Temp %in% names(dat) && "Temp" %in% names(dat)) {
    Temp <- "Temp"
  } else if (Temp %in% names(dat) && Temp != "Temp") {
    dat <- safe_rename(dat, Temp, "Temp")
    Temp <- "Temp"
  } else if (!("Temp" %in% names(dat))) {
    stop("Temp column is missing.")
  }

  # RH column handling
  if (!RH %in% names(dat) && "RH" %in% names(dat)) {
    RH <- "RH"
  } else if (RH %in% names(dat) && RH != "RH") {
    dat <- safe_rename(dat, RH, "RH")
    RH <- "RH"
  } else if (!("RH" %in% names(dat))) {
    stop("RH column is missing.")
  }

  # Convert Temp and RH to numeric for calculations
  dat[[RH]] <- as.numeric(dat[[RH]])
  dat[[Temp]] <- as.numeric(dat[[Temp]])

  # Remove rows with missing dates
  dat <- dat[!is.na(dat[[Date]]), ]

  # Parse Date-time column with multiple possible formats
  dat[[Date]] <-
    lubridate::parse_date_time(
      dat[[Date]], quiet = TRUE,
      orders = c("ymd HMS", "ymd HM", "ymd",
                 "dmy HMS", "dmy HM", "dmy",
                 "mdy HMS", "mdy HM", "mdy")
    )

  if (avg_time != "none") {
    # Floor dates to appropriate interval
    dat <- dat |> dplyr::mutate(
      Date_floor = lubridate::floor_date(.data[[Date]], unit = avg_time)
    )

    # Identify grouping columns for averaging including user-chosen groups
    grouping_vars <- c("Date_floor", avg_groups)

    # If grouping columns not in data, ignore them (especially for Site, Sensor)
    grouping_vars <- grouping_vars[grouping_vars %in% names(dat)]

    # Columns to average: numeric columns except grouping columns
    avg_cols <- names(dat)[sapply(dat, is.numeric)]
    avg_cols <- setdiff(avg_cols, match(grouping_vars, names(dat), nomatch = 0))

    # For each numeric column, apply summarise function
    dat <- dat |> dplyr::group_by(across(all_of(grouping_vars))) |>
      dplyr::summarise(across(all_of(avg_cols),
                              ~ match.fun(avg_statistic)(., na.rm = TRUE)),
                       .groups = "drop")
    # Rename Date_floor back to Date
    dat <- dat |> dplyr::rename(Date = Date_floor)
  }

  # Filter out implausible Temp / RH values
  dat <- dat |>
    dplyr::filter(.data[[Temp]] > -50 & .data[[Temp]] < 80) |>
    dplyr::filter(.data[[RH]] >= 0 & .data[[RH]] <= 100)

  # if (avg_time != "none") {
  #   dat <- dat |>
  #     dplyr::group_by(across(all_of(avg_groups))) |>
  #     padr::pad("Date") |>
  #     dplyr::ungroup()
  # }

  return(dat)
}
