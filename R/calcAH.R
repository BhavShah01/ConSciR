#' Calculate Absolute Humidity
#'
#' @description
#' Function to calculate the absolute humidity (g/m³) from temperature (°C) and relative humidity (\%).
#' Supports multiple methods: the Buck equation (default), Buck formula with enhancement factor, and others.
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param P_atm Atmospheric pressure = 1013.25 (hPa)
#' @param method Character. Calculation method:
#'   - "Buck": uses \code{calcPws} Buck equation (default)
#'   - "Buck_EF": Buck formula with enhancement factor
#'   - "IAPWS", "Magnus", "VAISALA": use \code{calcPws} methods for saturation vapor pressure
#'
#' @return AH Absolute Humidity (g/m³)
#' @export
#'
#' @examples
#' # Absolute humidity at 20°C (Temp) and 50% relative humidity (RH)
#' calcAH(20, 50)
#' calcAH(20, 50, method = "Buck_EF") # Buck formula with enhancement factor (default)
#' calcAH(20, 50, method = "Buck") # Buck method via calcPws
#' calcAH(20, 50, method = "IAPWS") # IAPWS
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(Abs = calcAH(Temp, RH))
#'
calcAH <- function(Temp, RH, P_atm = 1013.25, method = c("Buck_EF", "Buck", "IAPWS", "Magnus", "VAISALA")) {
  method <- match.arg(method)

  if (method == "Buck_EF") {
    # Buck formula with enhancement factor
    A <- 2165  # Constant for water vapor
    P_atm_Pa <- P_atm * 100  # convert hPa to Pa
    T_ratio <- 1 - (373.15 / (273.15 + Temp))
    exponent <- (-0.1299 * T_ratio - 0.6445) * T_ratio - 1.976
    Pv <- P_atm_Pa * exp((exponent * T_ratio + 13.3185) * T_ratio)
    AH <- (A * (RH * (Pv / 1000) / 100)) / (Temp + 273.15)

  } else {
    # Use calcPws for saturation vapor pressure
    Pws <- calcPws(Temp, P_atm = P_atm, method = method)
    Pw <- RH / 100 * Pws  # actual vapor pressure (hPa)
    R_v <- 461.5  # J/(kg·K), specific gas constant for water vapor
    Temp_K <- Temp + 273.15
    AH <- (Pw * 100) / (R_v * Temp_K) * 1000  # g/m³

    # VAISALA
    # AH0 = ((RH * (1.10461E-15 * Temp^10 +
    #               -1.187682E-13 * Temp^9 +
    #               3.089754E-12 * Temp^8 +
    #               7.150535E-11 * Temp^7 +
    #               -3.770916E-9 * Temp^6 +
    #               4.760219E-9 * Temp^5 +
    #               1.725056E-6 * Temp^4 +
    #               1.746817E-5 * Temp^3 +
    #               0.001223148 * Temp^2 +
    #               0.04660427 * Temp +
    #               0.6072509) * 1000) / 100 / (Temp + 273.15)) * (18.01528 / 8.31441)
  }

  return(AH)
}
