#' Tidy Hanwell EMS Data
#'
#' @description
#' This function tidies Hanwell Environmental Monitoring System (EMS) data from either
#' Excel sheets or CSV files.
#'
#' - Default mode (MinMax = FALSE): Reads raw date, temperature, and humidity data.
#' - Min-Max mode (MinMax = TRUE): Under development to read min-max average data (CSV only).
#'
#' @param EMS_datapath Character string specifying the
#' file path to the Hanwell EMS data file.
#' @param Site Character string specifying site name to add as a column.
#'   Default is "Site".
#' @param MinMax Logical flag; if TRUE, reads Min-Max format,
#'   otherwise reads raw data. Default is FALSE.
#' @param sheet Optional, Excel sheet name for reading Excel files. The default is "Hanwell"
#' @param ... Additional arguments passed to \code{readxl::read_excel} for Excel reading.
#'
#' @return A tibble containing tidied Hanwell EMS data, with columns including:
#' \describe{
#'   \item{Site}{Character, site name as specified by \code{Site} argument.}
#'   \item{Sensor}{Character, sensor identifier extracted from the file or metadata.}
#'   \item{Date}{POSIXct datetime of the measurement.}
#'   \item{Temp}{Numeric temperature measurement in °C (average for MinMax).}
#'   \item{RH}{Numeric relative humidity measurement in \% (average for MinMax).}
#'   \item{TempMin, TempMax, RHMin, RHMax}{(Only for MinMax reports) Numeric min/max values of Temp and RH.}
#' }
#' @export
#'
#' @importFrom readxl read_excel
#' @importFrom readr read_csv cols
#' @importFrom tools file_ext
#' @importFrom dplyr mutate across select relocate
#' @importFrom tidyr separate pivot_longer pivot_wider
#' @importFrom lubridate parse_date_time dmy_hm
#' @importFrom stringr str_remove_all str_trim str_replace str_detect fixed regex
#'
#' @examples
#'
#' \donttest{
#' # Example usage: hanwell_data <- tidy_Hanwell("path/to/your/hanwell_data.csv")
#' }
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#'
#' tidy_Hanwell(filepath, sheet = "Hanwell", Site = "London") |> head()
#'
#'
tidy_Hanwell <- function(EMS_datapath,
                         Site = "Site",
                         MinMax = FALSE,
                         sheet = "Hanwell", ...) {

  ext <- tolower(file_ext(EMS_datapath))

  if (MinMax) {
    # MinMax mode - only CSV supported
    if (ext != "csv") stop("MinMax format processing currently supports only CSV files")

    ems <- readr::read_csv(EMS_datapath, na = c("", "-", "NA"), skip = 7)
    ems_data_end <- which(grepl("Alarm Limits", ems$`Date Time`)) - 2
    ems <- ems[1:ems_data_end, ]

    ems_tidy <- ems |>
      mutate(`Date Time` = parse_date_time(`Date Time`, orders = "%d/%m/%Y %H:%M:%S")) |>
      mutate(across(-`Date Time`, as.numeric)) |>
      pivot_longer(cols = -`Date Time`) |>
      separate(name, sep = " Chan: ", into = c("Sensor", "Channel")) |>
      mutate(
        Channel = str_replace(Channel, "C Min", "TempMin"),
        Channel = str_replace(Channel, "C Max", "TempMax"),
        Channel = str_replace(Channel, "C Average", "Temp"),
        Channel = str_replace(Channel, "%RH Min", "RHMin"),
        Channel = str_replace(Channel, "%RH Max", "RHMax"),
        Channel = str_replace(Channel, "%RH Average", "RH"),
        Channel = str_replace(Channel, "1 ", ""),
        Channel = str_replace(Channel, "2 ", "")
      ) |>
      pivot_wider(names_from = Channel, values_from = value) |>
      mutate(Date = `Date Time`) |>
      select(-`Date Time`) |>
      mutate(Site = Site) |>
      relocate(Site, Sensor, Date)

    return(ems_tidy)
  }

  # Non-MinMax (raw) mode - Excel or CSV
  if (ext %in% c("xls", "xlsx")) {
    raw_df <- readxl::read_excel(EMS_datapath, sheet = sheet, col_names = FALSE, ...)
    # Find header row
    header_mask <- apply(raw_df, 1, function(row) {
      all(c("Date Time", "Temperature (C)", "Humidity (%RH)") %in% as.character(row))
    })
    header_row <- which(header_mask)[1]
    if (is.na(header_row)) stop("Header row not found in Excel sheet")

    sensor_row <- max(which(!is.na(raw_df[1:(header_row-1),1]) & raw_df[1:(header_row-1),1] != ""))
    sensor_name_raw <- as.character(raw_df[sensor_row, 1])
    sensor_name <- sensor_name_raw |>
      str_remove_all('["]') |>
      str_remove_all(",+$") |>
      str_trim()

    colnames(raw_df) <- as.character(raw_df[header_row, ])
    data_sub <- raw_df[(header_row + 1):nrow(raw_df), ]
    first_summary_row <- which(
      is.na(data_sub[[1]]) |
        str_detect(as.character(data_sub[[1]]),
                   regex("Name:|Average|Minimum|Maximum|Standard Deviation|Exported Sensor Data",
                         ignore_case = TRUE))
    )
    if (length(first_summary_row) > 0) {
      data_sub <- data_sub[1:(min(first_summary_row) - 1), ]
    }
    df <- data_sub |>
      select(`Date Time`, `Temperature (C)`, `Humidity (%RH)`)
    date_col <- df$`Date Time`

    if (all(!is.na(as.numeric(as.character(date_col))))) {
      datevals <- as.POSIXct((as.numeric(as.character(date_col)) - 25569) * 86400,
                             origin = "1970-01-01", tz = "UTC")
    } else {
      datevals <- lubridate::dmy_hm(date_col)
    }

    df <- df |>
      mutate(Date = datevals,
             Temp = as.numeric(`Temperature (C)`),
             RH = as.numeric(`Humidity (%RH)`),
             Site = Site,
             Sensor = sensor_name) |>
      select(Site, Sensor, Date, Temp, RH)

    return(df)
  }

  else if (ext == "csv") {
    lines <- readLines(EMS_datapath)
    header_idx <- which(
      str_detect(lines, fixed("Date Time")) &
        str_detect(lines, fixed("Temperature (C)")) &
        str_detect(lines, fixed("Humidity (%RH)"))
    )
    if (length(header_idx) == 0) stop("Header line not found in CSV file")
    header_line <- header_idx[1]
    non_empty_before_header <- which(str_trim(lines[1:(header_line - 1)]) != "")
    sensor_line <- max(non_empty_before_header)
    sensor_name_raw <- str_trim(lines[sensor_line])
    sensor_name <- sensor_name_raw |>
      str_remove_all('["]') |>
      str_remove_all(",+$") |>
      str_trim()
    data_start <- header_line + 1
    blank_lines_after_data <- which(str_trim(lines) == "")
    blank_lines_after_data <- blank_lines_after_data[blank_lines_after_data > data_start]
    data_end <- ifelse(length(blank_lines_after_data) > 0, min(blank_lines_after_data) - 1, length(lines))
    data_lines <- lines[data_start:data_end]
    tmp_file <- tempfile(fileext = ".csv")
    writeLines(data_lines, tmp_file)
    df <- readr::read_csv(tmp_file,
                          col_names = c("Date", "Temp", "RH"),
                          col_types = readr::cols(
                            Date = readr::col_character(),
                            Temp = readr::col_double(),
                            RH = readr::col_double()
                          ),
                          trim_ws = TRUE) |>
      mutate(Date = lubridate::parse_date_time(Date, orders = c("dmy HMS", "dmy HM", "ymd HMS", "ymd HM")),
             Site = Site,
             Sensor = sensor_name) |>
      select(Site, Sensor, Date, Temp, RH)
    unlink(tmp_file)
    return(df)
  }

  else {
    stop("Unsupported file extension: ", ext)
  }
}
