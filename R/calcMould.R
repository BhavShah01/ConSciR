#' Calculate Mould Growth Probability
#'
#' This function calculates the probability of mould growth based on temperature and relative humidity data.
#'
#' @param mydata A data frame containing temperature and relative humidity data.
#' @param Date The name of the column in the data containing date data. Default is "Date".
#' @param Temp The name of the column in the data containing temperature data. Default is "Temp".
#' @param RH The name of the column in the data containing relative humidity data. Default is "RH".
#'
#' @return A data frame with additional columns:
#'   \item{time_diff}{Time difference between consecutive measurements}
#'   \item{mould_prob}{Probability of mould growth for each time step}
#'   \item{mould}{Cumulative mould growth probability}
#'
#'
#' @import ggplot2
#' @importFrom dplyr left_join mutate lag
#' @importFrom runner runner
#'
#' @export
#'
#' @examples
#' head(mydata) |> calcMould(Date = "Date", Temp = "Temp", RH = "RH")
#'
#'
#'
calcMould <- function(mydata, Date = "Date", Temp = "Temp", RH = "RH") {
  # Check if runner package is available
  if (!requireNamespace("runner", quietly = TRUE)) {
    stop("Package \"runner\" needed for this function to work.", call. = FALSE)
  }

  # Load mouldtable
  data("mouldtable", envir = environment())

  # Ensure Temp and RH are symbols
  Date <- rlang::sym(Date)
  Temp <- rlang::sym(Temp)
  RH <- rlang::sym(RH)

  mydata |>
    dplyr::mutate(
      TempMould = round(!!Temp),
      RHMould = round(!!RH)
    ) |>
    dplyr::left_join(mouldtable, by = c("TempMould", "RHMould")) |>
    dplyr::mutate(
      time_diff = !!Date - dplyr::lag(!!Date),
      mould_prob = 1 / (days_mould * 24 * (3600 / as.numeric(time_diff))),
      mould = runner::runner(
        x = mould_prob, k = "day", idx = Date, f = function(x) sum(x, na.rm = TRUE))
    )
}
