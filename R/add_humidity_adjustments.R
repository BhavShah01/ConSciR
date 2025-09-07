#' Adjust Humidity with temperature and/or absolute humidity, RH zones and Energy costs
#'
#' This function calculates and adjusts humidity and temperature-related variables
#' in a dataframe. It classifies data into zones based on temperature (Temp)
#' and relative humidity (RH) thresholds and computes related derived variables
#' such as dew point, absolute humidity, temperature and humidity deviations.
#'
#' @param mydata A dataframe containing temperature and relative humidity data.
#' @param Temp Character string name of the temperature column (default "Temp").
#' @param RH Character string name of the relative humidity column (default "RH").
#' @param LowT Numeric lower temperature threshold (default 16).
#' @param HighT Numeric higher temperature threshold (default 25).
#' @param LowRH Numeric lower relative humidity threshold (default 40).
#' @param HighRH Numeric higher relative humidity threshold (default 60).
#' @param P_atm Atmospheric pressure in kPa or hPa (currently unused, default 1013.25).
#' @param ... Additional arguments passed to internal calculation functions.
#'
#' @return The input dataframe augmented with multiple humidity and temperature adjustment columns.
#'
#' @importFrom dplyr mutate case_when
#' @export
#'
#' @details
#' The function adds:
#' \itemize{
#'   \item Direct calculations: absolute humidity, dew point.
#'   \item Logical zone classifications based on thresholds.
#'   \item Reference curves for relative humidity adjusted by temperature.
#'   \item Adjusted temperature and absolute humidity values per zone conditions.
#'   \item Differences between new and original temperature, humidity variables.
#' }
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> add_humidity_adjustments() |> dplyr::glimpse()
#'
add_humidity_adjustments <- function(
    mydata, Temp = "Temp", RH = "RH", LowT = 16, HighT = 25, LowRH = 40, HighRH = 60, P_atm = 1013.25, ...) {

  df <-
    mydata |>
    mutate(
      Abs = calcAH(Temp, RH, ...),
      DP = calcDP(Temp, RH, ...),

      # Logical flags for temperature and relative humidity ranges
      T_within_range = Temp >= LowT & Temp <= HighT,
      RH_within_range = RH >= LowRH & RH <= HighRH,
      TRH_within = T_within_range & RH_within_range,
      T_lower = Temp < LowT,
      T_higher = Temp > HighT,
      RH_lower = RH < LowRH,
      RH_higher = RH > HighRH,

      # Calculate reference RH curves
      RH_lowcurve = calcRH_AH(Temp, calcAH(LowT, LowRH)),
      RH_highcurve = calcRH_AH(Temp, calcAH(HighT, HighRH)),

      # Flags for RH relative to curves
      RH_withincurve = RH >= RH_lowcurve & RH <= RH_highcurve,
      RH_abovecurve = RH > RH_highcurve,
      RH_belowcurve = RH < RH_lowcurve,

      # Zone definitions based on combined flags (priority order)
      zone = case_when(
        TRH_within ~ "Within",
        T_lower & RH_withincurve ~ "Heating only",
        RH_higher & T_within_range & RH_withincurve ~ "Dehum or heating",
        RH_higher & T_within_range & RH_abovecurve ~ "Dehum only",
        RH_lower & T_within_range & RH_belowcurve ~ "Hum only",
        T_higher & RH_abovecurve ~ "Cooling and dehum",
        T_lower & RH_belowcurve ~ "Heating and hum",
        T_lower & RH_abovecurve ~ "Heating and dehum",
        RH_lower & T_within_range & RH_withincurve ~ "Hum or cooling",
        T_higher & RH_withincurve ~ "Cooling only",
        T_higher & RH_belowcurve ~ "Cooling and hum",
        TRUE ~ NA_character_
      ),

      # Simplified temperature-humidity categories
      TRH_zone = case_when(
        TRH_within ~ "Within",
        T_lower & RH_within_range ~ "Cold",
        T_lower & RH_higher ~ "Cold and humid",
        T_lower & RH_lower ~ "Cold and dry",
        T_higher & RH_within_range ~ "Hot",
        T_higher & RH_higher ~ "Hot and humid",
        T_higher & RH_lower ~ "Hot and dry",
        RH_higher & T_within_range ~ "Humid",
        RH_lower & T_within_range ~ "Dry",
        TRUE ~ NA_character_
      ),

      # Temperature zone classification
      T_zone = case_when(
        T_within_range ~ "Within",
        T_lower ~ "Cold",
        T_higher ~ "Hot",
        TRUE ~ NA_character_
      ),

      # Relative Humidity zone classification
      RH_zone = case_when(
        RH_within_range ~ "Within",
        RH_lower ~ "Dry",
        RH_higher ~ "Humid",
        TRUE ~ NA_character_
      ),

      # Temperature difference based on TRH_zone
      dTemp = case_when(
        TRH_zone %in% c("Within", "Dry", "Humid") ~ 0,
        TRH_zone %in% c("Cold", "Cold and humid", "Cold and dry") ~ Temp - LowT,
        TRH_zone %in% c("Hot", "Hot and humid", "Hot and dry") ~ Temp - HighT,
        TRUE ~ NA_real_
      ),

      # Relative Humidity difference based on TRH_zone
      dRH = case_when(
        TRH_zone %in% c("Within", "Cold", "Hot") ~ 0,
        TRH_zone == "Cold and humid" ~ RH - HighRH,
        TRH_zone == "Cold and dry" ~ RH - LowRH,
        TRH_zone == "Hot and humid" ~ RH - HighRH,
        TRH_zone == "Hot and dry" ~ RH - LowRH,
        TRH_zone == "Humid" ~ RH - HighRH,
        TRH_zone == "Dry" ~ RH - LowRH,
        TRUE ~ NA_real_
      ),

      # Additional derived absolute humidity variables
      New_Absrhmin = calcAH(Temp, LowRH),
      New_Absrhmax = calcAH(Temp, HighRH),
      Abs_toCurvemin = calcAH(Temp, RH_lowcurve),
      Abs_toCurvemax = calcAH(Temp, RH_highcurve),
      Temp_toRHmin = calcTemp(LowRH, calcDP(Temp, RH)),
      Temp_toRHmax = calcTemp(HighRH, calcDP(Temp, RH)),
      Temp_toCurvemin = calcTemp(LowRH, calcDP(Temp, calcRH_AH(Temp, Abs_toCurvemin))),
      Temp_toCurvemax = calcTemp(HighRH, calcDP(Temp, calcRH_AH(Temp, Abs_toCurvemax))),

      # New temperature based on zone and Abs
      New_Temp = case_when(
        zone == "Heating only" & calcRH_AH(LowT, Abs) > HighRH ~ Temp_toRHmax,
        zone == "Heating only" & calcRH_AH(LowT, Abs) <= HighRH ~ LowT,
        zone == "Dehum or heating" ~ Temp_toRHmax,
        zone == "Dehum only" ~ Temp,
        zone == "Cooling and dehum" ~ HighT,
        zone == "Heating and dehum" ~ LowT,
        zone == "Heating and hum" ~ LowT,
        zone == "Hum only" ~ Temp,
        zone == "Hum or cooling" ~ Temp,
        zone == "Cooling only" & calcRH_AH(HighT, Abs) < LowRH ~ Temp_toRHmin,
        zone == "Cooling only" & calcRH_AH(HighT, Abs) >= LowRH ~ HighT,
        zone == "Cooling and hum" ~ LowT,
        zone == "Within" ~ Temp,
        is.na(zone) ~ Temp
      ),

      # New Absolute Humidity based on zone
      New_Abs = case_when(
        zone == "Heating only" ~ Abs,
        zone == "Dehum or heating" ~ Abs,
        zone == "Dehum only" ~ New_Absrhmax,
        zone == "Cooling and dehum" ~ Abs_toCurvemax,
        zone == "Heating and dehum" ~ Abs_toCurvemax,
        zone == "Heating and hum" ~ Abs_toCurvemin,
        zone == "Hum only" ~ New_Absrhmin,
        zone == "Hum or cooling" ~ New_Absrhmin,
        zone == "Cooling only" ~ Abs,
        zone == "Cooling and hum" ~ Abs_toCurvemin,
        zone == "Within" ~ Abs,
        TRUE ~ Abs
      ),

      # New Absolute Humidity with Temperature adjustment (similar to New_Abs)
      New_AbsT = case_when(
        zone == "Heating only" ~ Abs,
        zone == "Dehum or heating" ~ Abs,
        zone == "Dehum only" ~ New_Absrhmax,
        zone == "Cooling and dehum" ~ Abs_toCurvemax,
        zone == "Heating and dehum" ~ Abs_toCurvemax,
        zone == "Heating and hum" ~ Abs_toCurvemin,
        zone == "Hum only" ~ New_Absrhmin,
        zone == "Hum or cooling" ~ New_Absrhmin,
        zone == "Cooling only" ~ Abs,
        zone == "Cooling and hum" ~ Abs_toCurvemin,
        zone == "Within" ~ Abs,
        TRUE ~ Abs
      ),

      # Difference calculations for temperature and absolute humidity
      Temp_diff = New_Temp - Temp,
      Abs_diff = New_Abs - Abs,

      # New Relative Humidity from updated Abs and Temp
      New_RH = calcRH_AH(New_Temp, New_Abs),
      RH_diff = New_RH - RH,

      # Absolute humidity adjustments for RH only zones
      New_Abs_RHonly = case_when(
        RH_zone == "Dry" ~ New_Absrhmin,
        RH_zone == "Humid" ~ New_Absrhmax,
        RH_zone == "Within" ~ Abs,
        TRUE ~ Abs
      ),
      Abs_diff_RHonly = New_Abs_RHonly - Abs,
      New_RH_AbsRHonly = calcRH_AH(Temp, New_Abs_RHonly),
      RH_diff_AbsRHonly = New_RH_AbsRHonly - RH,

      # Temperature adjustments for RH only zones
      New_Temp_RHonly = case_when(
        RH_zone == "Dry" ~ Temp_toRHmin,
        RH_zone == "Humid" ~ Temp_toRHmax,
        RH_zone == "Within" ~ Temp,
        TRUE ~ Temp
      ),
      Temp_diff_RHonly = New_Temp_RHonly - Temp,
      New_RH_TempRHonly = calcRH_AH(New_Temp_RHonly, Abs),
      RH_diff_TempRHonly = New_RH_TempRHonly - RH,
      New_Abs_TempRHonly = calcAH(New_Temp_RHonly, RH)
    )


  return(df)
}
