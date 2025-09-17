#' Add Conservation Risks
#'
#' @description
#' Appends columns for conservation-risks: mould risk, preservation indices, equilibrium moisture,
#' and moisture content for wood to a dataframe with temperature and relative humidity columns.
#'
#'
#' @param mydata A dataframe containing temperature and relative humidity data.
#' @param Temp Character string name of the temperature column (default "Temp").
#' @param RH Character string name of the relative humidity column (default "RH").
#' @param ... Additional parameters passed to humidity calculation functions.
#'
#' @return Dataframe augmented with conservation variables:
#'
#' \describe{
#'   \item{Mould_LIM}{Mould risk threshold humidity from Zeng equation (numeric).}
#'   \item{Mould_risk}{If there is a risk of mould from Zeng equation.
#'      Adds label: "Mould risk" or "No risk".}
#'   \item{Mould_rate}{Mould growth rate index from Zeng equation, labelled output.}
#'   \item{Mould_index}{Mould risk index from VTT model (continuous scale).}
#'   \item{PreservationIndex}{Preservation Index for collection longevity.}
#'   \item{Lifetime}{Lifetime Multiplier for object material degradation risk.}
#'   \item{EMC_wood}{Wood equilibrium moisture content (\%) under current climate conditions.}
#' }
#'
#' @seealso \code{\link{calcMould_Zeng}} for `Mould_LIM`, `Mould_risk`, `Mould_rate`
#' @seealso \code{\link{calcMould_VTT}} for `Mould_index`
#' @seealso \code{\link{calcPI}} for `PreservationIndex`
#' @seealso \code{\link{calcLM}} for `Lifetime`
#' @seealso \code{\link{calcEMC_wood}} for `EMC_wood`
#'
#' @importFrom dplyr mutate
#' @importFrom rlang sym
#' @export
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> add_conservation_calcs() |> dplyr::glimpse()
#'
#'
add_conservation_calcs <- function(mydata, Temp = "Temp", RH = "RH", ...) {
  TempSym <- rlang::sym(Temp)
  RHSym <- rlang::sym(RH)

  mydata |>
    dplyr::mutate(
      Mould_LIM = calcMould_Zeng(!!TempSym, !!RHSym, ...),
      Mould_risk = ifelse(!!RHSym > Mould_LIM, "Mould risk", "No risk"),
      Mould_rate = calcMould_Zeng(!!TempSym, !!RHSym, label = TRUE),
      Mould_index = calcMould_VTT(!!TempSym, !!RHSym, ...),
      PreservationIndex = calcPI(!!TempSym, !!RHSym, ...),
      Lifetime = calcLM(!!TempSym, !!RHSym, ...),
      EMC_wood = calcEMC_wood(!!TempSym, !!RHSym)
    )
}
