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
#'              Options are "Days", "Sedlbauer", "VIR", or "Isaksson".
#'
#' @return Numeric. The result depends on the chosen model:
#'   \itemize{
#'     \item Table: returns days to mould
#'     \item Sedlbauer and VIR: Critical RH for mould growth from temperature
#'     \item Isaksson: Daily dose (1/t(ms)) / D(rel/day)
#'   }
#'
#' @export
#'
#' @importFrom dplyr mutate
#'
#' @examples
#' calcMould_models(20, 80, "Days")
#' calcMould_models(20, 80, "Sedlbauer")
#' calcMould_models(25, 70, "VIR")
#' calcMould_models(22, 85, "Isaksson")
#'
#'
#' head(mydata) |>
#'   dplyr::mutate(
#'     # Days_mould = calcMould_models(Temp, RH, "Days"),
#'     RH_crit_Sedlbauer = calcMould_models(Temp, RH, "Sedlbauer"),
#'     RH_crit_VIR = calcMould_models(Temp, RH, "VIR"),
#'     Mould_daily_dose = calcMould_models(Temp, RH, "Isaksson")
#'     )
#'
#'
#'
calcMould_models <- function(Temp, RH, model = c("Days", "Sedlbauer", "VIR", "Isaksson")) {

  calcMould_Days <- function(Temp, RH) {
    data("mouldtable", envir = environment())

    # Round temperature and RH
    Temp_mould <- round(Temp)
    RH_mould <- round(RH)

    days_mould <- mouldtable$days_mould[
      mouldtable$TempMould == Temp_mould & mouldtable$RHMould == RH_mould]

    # Return NA if no match is found
    if (length(days_mould) == 0) {
      return(NA)
    } else {
      return(days_mould)
    }
  }

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

  calcMould_Isakkson <- function (Temp, RH) {
    # Returns: Daily dose (1/t(ms)) / D(rel/day)
    D = ifelse(
      Temp < 0.1,
      1/(-2*exp((-0.74*log(20))-(15.53*log(90))+75.736)),
      ifelse(
        RH < 60,
        1/(-2*exp((-0.74*log(Temp))-(15.53*log(90))+75.736)),
        ifelse(
          RH < 75,
          1/((15^-1*(exp(15.53*log(75/90))+0.5) * (RH-60)-0.5)^-1*exp((-0.74*log(Temp)) - (15.53*log(90))+75.736)),
          1/(exp((-0.74*log(Temp))-(15.53*log(RH))+75.736))
        )
      )
    )
    return(D)
  }

  model <- match.arg(model)

  switch(model,
         "Days" = calcMould_Days(Temp, RH),
         "Sedlbauer" = calcMould_Sedlbauer(Temp),
         "VIR" = calcMould_VIR(Temp),
         "Isaksson" = calcMould_Isakkson(Temp, RH)
         )
}
