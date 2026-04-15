#' Parse datalogger files
#'
#' @description
#' Extracts temperature and humidity data from a directory of logfiles.
#'
#' @param directory A directory of files from a single brand, .csv or .xls only for Rotronic.
#' @param Site Character string specifying site name when not recoverable from the file.
#'   Default is "Site".
#' @param Sensor Character string specifying sensor name. Default is "Sensor".
#' @param brand The logger brand as a string.
#'
#' @returns dat, a data frame containing the raw TRH data, with columns
#' for site, sensor, date, temperature, and relative humidity.
#' @export
#'
#' @importFrom purrr keep
#'
#' @examples
#' \donttest{
#' # Example usage:
#' # parse_brand(dir("logfiles/tinytag", full.names = TRUE), "Anonymous Library", "tinytag")
#' }
#'
parse_brand <- function (directory,
                         Site = "Site",
                         Sensor = "Sensor",
                         brand = FALSE) {
  dirlist <- dir(directory, full.names = TRUE)

  if (brand %in% c(
    "hanwell",
    "meaco",
    "miniclima",
    "previous",
    "rotronic",
    "tandd",
    "tinytag",
    "trend"
  ))
  {
    datalist <-   switch(
      brand,
      "hanwell" = lapply(dirlist, parse_hanwell, Site = Site, Sensor = Sensor),
      "meaco" = lapply(dirlist, parse_meaco),
      "miniclima" = lapply(dirlist, parse_miniClima, Site = Site, Sensor = Sensor),
      "previous" = lapply(dirlist, parse_previous, Site = Site),
      "rotronic" = lapply(dirlist, parse_rotronic, Site = Site),
      "tandd" = lapply(dirlist, parse_tandd, Site = Site),
      "tinytag" = lapply(dirlist, parse_tinytag, Site = Site),
      "trend" = lapply(dirlist, parse_trendBMS, Site = Site)
    )
  } else {
    stop('Brand not supported')
  }
  datalist <- purrr::keep(datalist, is.data.frame)

  dat <- combine_data(datalist)

  dat
}
#' Parse Hanwell file
#'
#' @description
#' Extracts temperature and humidity data from non-summary Hanwell logfile.
#'
#' @param filepath path to logfile as a string
#' @param Site name of the site
#'
#' @returns dat, a data frame containing the raw TRH data, with columns
#' for site, sensor, date, temperature, and relative humidity.
#'

#' @noRd
parse_hanwell <- function(filepath, Site = "Site", Sensor = "Sensor") {
  message("Parsing as Hanwell")
  tryCatch({
    if (!stringr::str_detect(readr::read_lines(filepath, skip = 1, n_max = 1), "Database")) {
      message("Not a Hanwell file")
      return(NULL)
    }
    # Logger information not stored in file, try filename

    dat <- readr::read_csv(
      filepath,
      col_names = c(
        "Date", "Temp", "RH"
      ),
      skip = 13
    ) |>
      dplyr::mutate(
        Site = as.character(Site),
        Sensor = Sensor,
        Date = lubridate::parse_date_time(Date, orders = "HMS dmy"),
        Temp = Temp,
        RH = RH,
        .keep = "none"
      ) |>
      dplyr::relocate(Site, Sensor, Date, Temp, RH)

    if (all(is.na(dat$Date)) || all(is.na(dat$Temp))) {
      warning("May not be Hanwell file")
    }
    dat
  }, warning = function(w) {
    warning("Could not be read as Hanwell: ", w)
    return(NULL)
  }, error = function(e) {
    warning("Could not be read as Hanwell: ", e)
    return(NULL)
  }
  )
}

#' Parse Meaco file
#'
#' @description
#' Extracts temperature and humidity data from Meaco logfile.
#'
#' @param filepath path to logfile as a string
#'
#' @unherit parse_hanwell returns
#'

#' @noRd
parse_meaco <- function(filepath) {
  message("Parsing as Meaco")
  tryCatch({
    file_head <- readr::read_lines(filepath, n_max = 1)
    if (stringr::str_detect(file_head, "LUX")) {
      warning("Temperature and humidity logs only")
      return(NULL)
    }
    # Pre-Gingerbread export structure
    else if (stringr::str_detect(file_head, "RECEIVER")) {
      dat <- readr::read_csv(filepath) |>
        dplyr::mutate(
          Site = as.character(RECEIVER),
          Sensor = as.character(TRANSMITTER),
          Date = as.POSIXct(DATE),
          Temp = as.numeric(TEMPERATURE),
          RH = as.numeric(HUMIDITY),
          .keep = "none"
        )
    }
    else if (stringr::str_detect(file_head, ' - ID')) {
      # Logger info in first line in format "Site - Sensor - ID:00"
      Receiver <- stringr::str_extract(file_head, '^.*?(?= - )')
      Sensor <- stringr::str_extract(file_head, '(?<= - ).*?(?= - )')

      dat <- readr::read_csv(filepath, skip = 1) |>
        dplyr::mutate(
          Site = as.character(Receiver),
          Sensor = as.character(Sensor),
          Date = lubridate::parse_date_time(Timestamp, orders = c('dmy HM', 'dmy HMS')),
          Temp = as.numeric(Temperature),
          RH = as.numeric(Humidity),
          .keep = "none"
        ) |>
        dplyr::relocate(Site, Sensor, Date, Temp, RH)

    } else {
      message("Could not be read as Meaco")
      return(NULL)
    }
    if (all(is.na(dat$Date)) || all(is.na(dat$Temp))) {
      warning("May not be Meaco file")
    }
    dat
  }, warning = function(w) {
    warning("Could not be read as Meaco: ", w)
    return(NULL)
  }, error = function(e) {
    warning("Could not be read as Meaco: ", e)
    return(NULL)
  })
}

#' Parse miniClima file
#'
#' @description
#' Extracts temperature and humidity data from miniClima logfile.
#'
#' @param filepath path to logfile as a string
#' @param Site name of the site
#'
#' @returns dat, a data frame containing the raw TRH data, with columns
#' for site, sensor, date, temperature, and relative humidity.
#'

#' @noRd
parse_miniClima <- function(filepath, Site = "Site") {
  message("Parsing as miniClima")
  tryCatch({
    # Logger information not stored in file, try filename
    if (stringr::str_detect(filepath, " EBC")) {
      Sensor <- stringr::str_extract(filepath, "[A-Za-z0-9 ]+(?= EBC)") |>
        stringr::str_replace_na("Unknown")
    }

    dat <- readr::read_csv2(
      filepath,
      col_names = c(
        "Date",
        "Temp",
        "RH",
        "setpoint",
        "alarm_min",
        "alarm_max",
        "timediff"
      ),
      skip = 1
    ) |>
      dplyr::mutate(
        Site = as.character(Site),
        Sensor = Sensor,
        Date = lubridate::parse_date_time(Date, orders = "dmy HMS"),
        Temp = Temp,
        RH = RH,
        .keep = "none"
      ) |>
      dplyr::relocate(Site, Sensor, Date, Temp, RH)

    if (all(is.na(dat$Date)) || all(is.na(dat$Temp))) {
      warning("May not be miniClima file")
    }
    dat
  }, warning = function(w) {
    warning("Could not be read as miniClima: ", w)
    return(NULL)
    }, error = function(e) {
      warning("Could not be read as miniClima: ", e)
      return(NULL)
    }
  )
}

#' Parse Rotronic file
#'
#' @description
#' Extracts temperature and humidity data from Rotronic logfile.
#'
#' @unherit parse_hanwell params returns
#'
#' @noRd
parse_rotronic <- function(filepath, Site = "Site") {
  message("Parsing as Rotronic")
  tryCatch({
    # Extract first few rows containing logger information
    if (stringr::str_detect(filepath, ".xls$")) {
      file_head <- readr::read_delim(
        filepath,
        col_names = c("Date", "Time", "RH", "Temp"),
        delim = "\t",
        n_max = 5
      )
      file_data <- readr::read_delim(
        filepath,
        col_names = c("Date", "Time", "RH", "Temp"),
        delim = "\t",
        skip = 23
      )
    }

    if (stringr::str_detect(filepath, ".csv$")) {
      file_head <- readr::read_csv(filepath,
                                   col_names = c("Date"),
                                   n_max = 5)
      file_data <- readr::read_csv(filepath,
                                   col_names = c("Date", "Time", "RH", "Temp"),
                                   skip = 23)
    }
    if (all(is.na(file_data$Date)) || all(is.na(file_data$Temp))) {
      warning("May not be Rotronic file")
    }
    # Rest of file is observations
    dat <-  file_data |>
      dplyr::mutate(
        Site = as.character(Site),
        Sensor = as.character(file_head$Date[2]),
        Date = lubridate::parse_date_time(paste(Date, Time), orders = "dmy HMS"),
        Temp = as.numeric(
          stringr::str_extract_all(Temp, "[:digit:]+\\.?[:digit:]+")
        ),
        RH = as.numeric(
          stringr::str_extract_all(RH, "[:digit:]+\\.?[:digit:]+")
        ),
        .keep = "none"
      ) |>
      dplyr::relocate(Site, Sensor, Date, Temp, RH)
    dat
  }, warning = function(w) {
    warning("Could not be read as Rotronic: ", w)
    return(NULL)
  }, error = function(e) {
    warning("Could not be read as Rotronic: ", e)
    return(NULL)
  })
}

#' Parse T&D file
#'
#' @description
#' Extracts temperature and humidity data from T&D logfile.
#'
#' @unherit parse_hanwell params returns

#' @noRd
parse_tandd <- function(filepath, Site = "Site", Sensor = FALSE) {
  message("Parsing as T&D")
  message("Keeping TRH data only")

  tryCatch({
    # Assumes filename includes name and serial starting with F8 which may not be accurate
    if (stringr::str_detect(filepath, 'F8') && Sensor == FALSE) {
      message("Extracting sensor from filename")
      Sensor <- stringr::str_extract(filepath, "([A-Za-z0-9 ])+(?= F8)")
    }

    # Rest of file is observations
    dat <- readr::read_csv(
      filepath,
      col_names = c(
        "Date",
        "time",
        "lux",
        "UV",
        "Temp",
        "RH",
        "luxhours",
        "UVhours"
      ),
      col_types = "cccccccc",
      skip = 3
    ) |>
      dplyr::mutate(
        Site = as.character(Site),
        Sensor = as.character(Sensor),
        Date = lubridate::parse_date_time(Date, orders = "ymd HMS"),
        Temp = as.numeric(Temp),
        RH = as.numeric(RH),
        .keep = "none"
      ) |>
      dplyr::relocate(Site, Sensor, Date, Temp, RH)

    if (all(is.na(dat$Date)) || all(is.na(dat$Temp))) {
      warning("May not be T&D file")
    }
    dat
  }, warning = function(w) {
    warning("Could not be read as T&D: ", w)
    return(NULL)
  }, error = function(e) {
    warning("Could not be read as T&D: ", e)
    return(NULL)
  })
}

#' Parse TinyTag logfile
#'
#' @description
#' Extracts temperature and humidity data from TinyTag logfile.
#'
#' @unherit parse_hanwell params returns
#'
#' @noRd
parse_tinytag <- function(filepath, Site = "Site") {
  message("Parsing as TinyTag")
  tryCatch({
    file_head <- readr::read_csv(
      filepath,
      col_names = c("id", "Date", "Temp", "RH"),
      col_types = "cccc",
      n_max = 5
    )

    dat <- readr::read_csv(filepath,
                           col_names = c("id", "Date", "Temp", "RH"),
                           skip = 5) |>
      dplyr::mutate(
        Site = as.character(Site),
        Sensor = as.character(file_head$Temp[4]),
        Date = lubridate::parse_date_time(Date, orders = c("ymd HMS", "dmy HMS", "dmy HM")),
        Temp = as.numeric(
          stringr::str_extract_all(Temp, "[:digit:]+\\.?[:digit:]+")
        ),
        RH = as.numeric(
          stringr::str_extract_all(RH, "[:digit:]+\\.?[:digit:]+")
        ),
        .keep = "none"
      ) |>
      dplyr::relocate(Site, Sensor, Date, Temp, RH)

    if (all(is.na(dat$Date)) || all(is.na(dat$Temp))) {
      warning("May not be T&D file")
    }
    dat
  }, warning = function(w) {
    warning("Could not be read as TinyTag: ", w)
    return(NULL)
  }, error = function(e) {
    warning("Could not be read as TinyTag: ", e)
    return(NULL)
  })
}



#' Parse Trend BMS file
#'
#' @description
#' Extracts temperature and humidity data from a Trend BMS logfile.
#'
#' @unherit parse_hanwell params return
#'
#' @noRd
parse_trendBMS <- function(filepath, Site = "Site") {
  message("Parsing as Trend BMS")
  tryCatch({
    file_head <- readr::read_csv(filepath,
                                 col_names = c("Date", "obs"),
                                 n_max = 1)
    # Extract first few rows containing logger information
    # Chcek whether the file is temperature or humidity and set column name
    temp_or_RH <- dplyr::if_else(stringr::str_detect(file_head$obs[1], "Temp"), "Temp", "RH")
    Sensor <- stringr::str_extract(file_head$obs[1], "(?<=\\[).*?(?= Space)")
    #Rest of file is observations
    dat <- readr::read_csv(filepath,
                           col_names = c("Date", temp_or_RH),
                           skip = 1) |>

      dplyr::mutate(
        Site = as.character(Site),
        Sensor = Sensor,
        Date = lubridate::parse_date_time(Date, orders = "dmy HMS"),
        .before = Date
      )
    if (all(is.na(dat$Date)) || all(is.na(dat$Temp))) {
      warning("May not be Trend BMS file")
    }
    dat
  }, warning = function(w) {
    warning("Could not be read as Trend BMS: ", w)
    return(NULL)
  }, error = function(e) {
    warning("Could not be read as Trend BMS: ", e)
    return(NULL)
  })
}

#' Combine TRH data from a list
#'
#' @description
#' Combines a list of parsed logfiles and returns a
#'
#'
#' @param datalist A list of parsed dataframes
#'
#' @returns A dataframe containing all timestamped rows in `datalist`
#' @export
#'
#' @examples
#' \donttest{
#' ## Example usage: all_data <- combine_data(datalist)
#' }
#'
combine_data <- function(datalist) {
  message("Combining files")
  datalist <- purrr::keep(datalist, is.data.frame)
  dat <- dplyr::bind_rows(datalist) |> dplyr::distinct()

  dat <-  dplyr::mutate(
    dat,
    Site = Site,
    Sensor = Sensor,
    Date = Date,
    Temp = Temp,
    RH = RH,
    .keep = "none"
  ) |>
    dplyr::relocate(Site, Sensor, Date, Temp, RH) |>
    tidyr::drop_na(any_of("Date"))
  dat
}
