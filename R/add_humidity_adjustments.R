#' Adjust Humidity with temperature and/or absolute humidity, RH zones and Energy costs
#'
#' @description
#' This function processes a dataframe with temperature and relative humidity data,
#' computes humidity-related variables, and classifies the data into climate control zones.
#' It generates adjusted temperature and humidity values based on specified thresholds.
#'
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
#' \describe{
#'   \item{AH}{Absolute Humidity (g/m³): The mass of water vapor per unit volume of air.}
#'   \item{DP}{Dew Point (°C): The temperature at which air becomes saturated and water vapor condenses.}
#'   \item{zone}{
#'      Categorical variable defining climate control actions based on temperature and RH:
#'      'Heating only', 'Dehum or heating', 'Cooling and hum', etc.}
#'   \item{TRH_zone}{Temperature-relative humidity category:
#'      'Hot', 'Cold', 'Dry', 'Hot and humid', etc.}
#'   \item{T_zone}{
#'      Temperature zone classification: 'Cold', 'Within', or 'Hot'.}
#'   \item{RH_zone}{Relative humidity zone classification: 'Dry', 'Within', or 'Humid'.}
#'   \item{dTemp}{
#'      Temperature difference from specified thresholds (°C),
#'      indicating required heating or cooling.}
#'   \item{dRH}{
#'      Relative humidity difference from specified thresholds (\%),
#'      indicating humidification or dehumidification.}
#'   \item{newTemp_TRHadj}{
#'      Adjusted temperature (°C) after applying temperature and relative humidity
#'      correction based on zone.}
#'   \item{newAH_TRHadj}{
#'      Adjusted absolute humidity (g/m³).}
#'   \item{newRH_TRHadj}{
#'      Adjusted relative humidity (\%) reflecting new temperature and absolute humidity.}
#'   \item{dTemp_TRHadj, dAH_TRHadj, dRH_TRHadj}{
#'      Differences between adjusted and original temperature, absolute humidity,
#'      and relative humidity respectively.}
#'   \item{newTemp_AHadj, newAH_AHadj, newRH_AHadj}{
#'      Adjustments based on absolute humidity only (i.e. dehumidification or humidification).}
#'   \item{newTemp_Tadj, newRH_Tadj, newAH_Tadj}{
#'      Adjustments based on temperature only (i.e. heating or cooling).}
#' }
#'
#' @importFrom dplyr mutate case_when select
#' @export
#'
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
    mydata,
    Temp = "Temp",
    RH = "RH",
    LowT = 16,
    HighT = 25,
    LowRH = 40,
    HighRH = 60,
    P_atm = 1013.25, ...) {

  # TempSym <- rlang::sym(Temp)
  # RHSym <- rlang::sym(RH)

  df <-
    mydata |>
    mutate(
      # Temp = !!TempSym,
      # RH = !!RHSym,
      AH = calcAH(Temp, RH, ...),
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
        TRH_zone %in% c("Cold and humid", "Hot and humid", "Humid") ~ RH - HighRH,
        TRH_zone %in% c("Cold and dry", "Hot and dry", "Dry") ~ RH - LowRH,
        TRUE ~ NA_real_
      ),

      # AH and Temp values to different adjustment points
      New_AHrhmin = calcAH(Temp, LowRH),
      New_AHrhmax = calcAH(Temp, HighRH),
      AH_toCurvemin = calcAH(Temp, RH_lowcurve),
      AH_toCurvemax = calcAH(Temp, RH_highcurve),
      Temp_toRHmin = calcTemp(LowRH, calcDP(Temp, RH)),
      Temp_toRHmax = calcTemp(HighRH, calcDP(Temp, RH)),
      Temp_toCurvemin = calcTemp(LowRH, calcDP(Temp, calcRH_AH(Temp, AH_toCurvemin))),
      Temp_toCurvemax = calcTemp(HighRH, calcDP(Temp, calcRH_AH(Temp, AH_toCurvemax))),

      # TRH both adjusted: new temperature (based on zone)
      newTemp_TRHadj = case_when(
        zone == "Heating only" & calcRH_AH(LowT, AH) > HighRH ~ Temp_toRHmax,
        zone == "Heating only" & calcRH_AH(LowT, AH) <= HighRH ~ LowT,
        zone == "Dehum or heating" ~ Temp_toRHmax,
        zone == "Dehum only" ~ Temp,
        zone == "Cooling and dehum" ~ HighT,
        zone == "Heating and dehum" ~ LowT,
        zone == "Heating and hum" ~ LowT,
        zone == "Hum only" ~ Temp,
        zone == "Hum or cooling" ~ Temp,
        zone == "Cooling only" & calcRH_AH(HighT, AH) < LowRH ~ Temp_toRHmin,
        zone == "Cooling only" & calcRH_AH(HighT, AH) >= LowRH ~ HighT,
        zone == "Cooling and hum" ~ LowT,
        zone == "Within" ~ Temp,
        is.na(zone) ~ Temp
      ),

      # TRH both adjusted: new absolute humidity (based on zone)
      newAH_TRHadj = case_when(
        zone == "Heating only" ~ AH,
        zone == "Dehum or heating" ~ AH,
        zone == "Dehum only" ~ New_AHrhmax,
        zone == "Cooling and dehum" ~ AH_toCurvemax,
        zone == "Heating and dehum" ~ AH_toCurvemax,
        zone == "Heating and hum" ~ AH_toCurvemin,
        zone == "Hum only" ~ New_AHrhmin,
        zone == "Hum or cooling" ~ New_AHrhmin,
        zone == "Cooling only" ~ AH,
        zone == "Cooling and hum" ~ AH_toCurvemin,
        zone == "Within" ~ AH,
        TRUE ~ AH
      ),

      # TRH both adjusted: new and differences in Temp, RH and AH
      dTemp_TRHadj = newTemp_TRHadj - Temp, # should match dTemp
      dAH_TRHadj = newAH_TRHadj - AH,
      newRH_TRHadj = calcRH_AH(newTemp_TRHadj, newAH_TRHadj),
      dRH_TRHadj = newRH_TRHadj - RH,

      # RH adjusted by AH (absolute humidity)
      newAH_AHadj = case_when(
        RH_zone == "Dry" ~ New_AHrhmin,
        RH_zone == "Humid" ~ New_AHrhmax,
        RH_zone == "Within" ~ AH,
        TRUE ~ AH
      ),
      dAH_AHadj = newAH_AHadj - AH,
      newRH_AHadj = calcRH_AH(Temp, newAH_AHadj),
      dRH_AHadj = newRH_AHadj - RH,
      newTemp_AHadj = Temp,
      dTemp_AHadj = newTemp_AHadj - Temp,

      # Temperature adjustments for RH only
      newTemp_Tadj = case_when(
        RH_zone == "Dry" ~ Temp_toRHmin,
        RH_zone == "Humid" ~ Temp_toRHmax,
        RH_zone == "Within" ~ Temp,
        TRUE ~ Temp
      ),
      dTemp_Tadj = newTemp_Tadj - Temp,
      newRH_Tadj = calcRH_AH(newTemp_Tadj, AH),
      dRH_Tadj = newRH_Tadj - RH,
      newAH_Tadj = calcAH(newTemp_Tadj, RH),
      dAH_Tadj = newAH_Tadj - AH
    )

  df <-
    df |>
    select(
      -T_within_range, -RH_within_range,
      -RH_lowcurve, -RH_highcurve,
      -RH_withincurve, -RH_abovecurve, -RH_belowcurve,
      -New_AHrhmin, -New_AHrhmax,
      -AH_toCurvemin, -AH_toCurvemax,
      -Temp_toRHmin, -Temp_toRHmax,
      -Temp_toCurvemin, -Temp_toCurvemax
      )


  return(df)
}
