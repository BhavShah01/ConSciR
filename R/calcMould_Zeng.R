#' Calculate Mould Growth Rate Limits (Zeng et al.)
#'
#' @description
#' This function calculates the Lowest Isoline for Mould (LIM) based on temperature
#' and relative humidity, using the model developed by Zeng et al. (2023).
#'
#' The LIM is the lowest envelope of the temperature and humidity isoline at a certain
#' mould growth rate (u). LIM0 is the critical value for mould growth, if the humidity
#' is kept below the critcal value, at a given temperature, then there is no risk of mould growth.
#'
#'
#' @details
#' The function calculates LIM values for mould genera including Cladosporium, Penicillium, and Aspergillus.
#' LIM values represent different mould growth rates:
#'
#' \itemize{
#'   \item LIM0: Low limit of mould growth
#'   \item LIM0.1: 0.1 mm/day growth rate
#'   \item LIM0.5: 0.5 mm/day growth rate
#'   \item LIM1: 1 mm/day growth rate
#'   \item LIM2: 2 mm/day growth rate
#'   \item LIM3: 3 mm/day growth rate
#'   \item LIM4: 4 mm/day growth rate
#'   \item Above LIM4: Greater than 4 mm/day growth rate (9 mm/day theorectical maximum)
#' }
#'
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param LIM The specific LIM value to calculate. Must be one of
#'            0, 0.1, 0.5, 1, 2, 3, or 4. Default is 0.
#' @param label Logical. If TRUE, returns a descriptive label instead of a numeric value.
#'              Default is FALSE.
#'
#' @return If label is FALSE, returns the calculated LIM value as Relative Humidity (0-100\%).
#'         If label is TRUE, returns a character string describing the mould growth rate category.
#' @export
#'
#' @importFrom dplyr mutate
#'
#' @references
#' Zeng L, Chen Y, Ma M, et al. Prediction of mould growth rate within building envelopes:
#' development and validation of an improved model.
#' Building Services Engineering Research and Technology. 2023;44(1):63-79.
#' doi:10.1177/01436244221137846
#'
#' Sautour M, Dantigny P, Divies C, Bensoussan M. A temperature-type model for
#' describing the relationship between fungal growth and water activity.
#' Int J Food Microbiol. 2001 Jul 20;67(1-2):63-9.
#' doi: 10.1016/s0168-1605(01)00471-8. PMID: 11482570.
#'
#'
#' @examples
#' calcMould_Zeng(20, 75)
#' calcMould_Zeng(20, 75, LIM = 0)
#' calcMould_Zeng(20, 75, label = TRUE)
#'
#' calcMould_Zeng(20, 85)
#' calcMould_Zeng(20, 85, LIM = 2)
#' calcMould_Zeng(20, 85, label = TRUE)
#'
#' head(mydata) |>
#'    dplyr::mutate(
#'       RH_LIM0 = calcMould_Zeng(Temp, RH),
#'       RH_LIM1 = calcMould_Zeng(Temp, RH, LIM = 1),
#'       LIM = calcMould_Zeng(Temp, RH, label = TRUE)
#'    )
#'
#'
calcMould_Zeng <- function(Temp, RH, LIM = 0, label = FALSE) {

  Temp_crit = 30

  LIM0    = 0.02633 * cosh(0.10083 * (Temp - Temp_crit)) + 0.7153 # Low limit of mould growth
  LIM0.1  = 0.02633 * cosh(0.10083 * (Temp - Temp_crit)) + 0.7300 # 0.1 mm/day growth rate (u)
  LIM0.5  = 0.02633 * cosh(0.10083 * (Temp - Temp_crit)) + 0.7675 # 0.5 mm/day growth rate (u)
  LIM1    = 0.02633 * cosh(0.10083 * (Temp - Temp_crit)) + 0.7950 # 1 mm/day growth rate (u)
  LIM2    = 0.02633 * cosh(0.10083 * (Temp - Temp_crit)) + 0.8250 # 2 mm/day growth rate (u)
  LIM3    = 0.02633 * cosh(0.10083 * (Temp - Temp_crit)) + 0.8502 # 3 mm/day growth rate (u)
  LIM4    = 0.02633 * cosh(0.10083 * (Temp - Temp_crit)) + 0.8701 # 4 mm/day growth rate (u)


  LIM = switch(
    as.character(LIM),
    "0" = LIM0,
    "0.1" = LIM0.1,
    "0.5" = LIM0.5,
    "1" = LIM1,
    "2" = LIM2,
    "3" = LIM3,
    "4" = LIM4,
    {
      warning("Invalid LIM value. Please select from the following options: 0, 0.1, 0.5, 1, 2, 3, 4")
      return(NA)
    }
  )


  RH = RH / 100 # convert to decimal

  # Sautour relationship between the mould growth rate (mm/day) and relative humidity
  # Mould growth rate (u) = (9.016 * (RH - 0.975) * (RH - 0.742)^2) / (0.231 * (0.231 * (RH - 0.973)) - (-0.002) * (1.715 - 2 * RH))

  if (label) {
    result <- ifelse(RH < LIM0, "Below LIM0",
               ifelse(RH < LIM0.1, "0.1 mm/day growth rate",
               ifelse(RH < LIM0.5, "0.5 mm/day growth rate",
               ifelse(RH < LIM1, "1 mm/day growth rate",
               ifelse(RH < LIM2, "2 mm/day growth rate",
               ifelse(RH < LIM3, "3 mm/day growth rate",
               ifelse(RH < LIM4, "4 mm/day growth rate",
               "Above LIM4")))))))

    return(result)

  } else {

    return(LIM * 100)
  }


}
