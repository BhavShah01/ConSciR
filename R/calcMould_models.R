#' Calculate Mould Growth Probability Using Various Models
#'
#' This function calculates the probability or critical conditions for mould growth
#' based on temperature and relative humidity, using one of four different models.
#'
#' The results are very different so take care in interpretation.
#'
#' @param Temp Numeric. Temperature in Celsius.
#' @param RH Numeric. Relative Humidity as a percentage (0-100).
#' @param model Character. The model to use for calculation.
#'              Options are "Sedlbauer", "VIR", "DP", or "Isaksson".
#'
#' @return Numeric. The result depends on the chosen model:
#'   \itemize{
#'     \item Sedlbauer and VIR: Critical RH for mould growth from temperature
#'     \item DP: Days to mould growth
#'     \item Isaksson: Daily dose (1/t(ms)) / D(rel/day)
#'   }
#'
#' @export
#'
#' @examples
#' calcMould_models(20, 80, "Sedlbauer")
#' calcMould_models(25, 70, "VIR")
#' calcMould_models(30, 75, "DP")
#' calcMould_models(22, 85, "Isaksson")
#'
#' head(mydata) |>
#'   mutate(
#'     RH_crit = calcMould_models(Temp, RH, "Sedlbauer"),
#'     Days_to_mould = calcMould_models(Temp, RH, "DP")
#'     )
#'
calcMould_models <- function(Temp, RH, model = c("Sedlbauer", "VIR", "DP", "Isaksson")) {

  calcMould_Sedlbauer <- function(Temp) {
    # Returns: Critical RH for mould growth at Temp
    RH = 0.03 * Temp^2 - 1.78 * Temp + 98
    return(RH)
  }

  calcMould_VIR <- function(Temp) {
    # Returns: Critical RH for Aspergilus versicolor growth at Temp
    RH = 0.033 * Temp^2 - 1.5 * Temp + 96
    return(RH)
  }

  calcMouldDPcalc <- function(Temp, RH) {
    # Returns: D, days to mould
    if(Temp > 45 | Temp < 2 | RH < 65) {D = 0} else {
      D = 8010 + (Temp - 2) * 36 + RH - 65
    }
    return(D)
  }

  calcMould_Isakkson <- function (Temp, RH) {
    # Returns: Daily dose (1/t(ms)) / D(rel/day)
    if(Temp < 0.1) {
      D = 1/(-2*exp((-0.74*log(20))-(15.53*log(90))+75.736))
    } else if(RH < 60) {
      D = 1/(-2*exp((-0.74*log(Temp))-(15.53*log(90))+75.736))
    } else if(RH < 75) {
      D = 1/((15^-1*(exp(15.53*log(75/90))+0.5) * (RH-60)-0.5)^-1*exp((-0.74*log(Temp)) - (15.53*log(90))+75.736))
    } else {
      D = 1/(exp((-0.74*log(Temp))-(15.53*log(RH))+75.736))
    }
    return(D)
  }

  model <- match.arg(model)

  switch(model,
         "Sedlbauer" = calcMould_Sedlbauer(Temp),
         "VIR" = calcMould_VIR(Temp),
         "DP" = calcMouldDPcalc(Temp, RH),
         "Isaksson" = calcMould_Isakkson(Temp, RH)
         )
}
