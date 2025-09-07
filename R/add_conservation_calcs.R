#' Add Conservation calculations to temperature and humidity data
#'
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
#' - Mould_LIM: Mould risk threshold humidity (numeric, from Zeng equation).
#' - Mould_rate: Mould growth rate index (from Zeng equation, labelled output).
#' - Mould_index: Mould risk index (continuous scale, VTT model).
#' - PreservationIndex: Preservation Index for collection longevity.
#' - Lifetime: Lifetime Multiplier for object material degradation risk.
#' - EMC_wood: Wood equilibrium moisture content (%) under current climate conditions.
#'
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
      Mould_rate = calcMould_Zeng(!!TempSym, !!RHSym, label = TRUE),
      Mould_index = calcMould_VTT(!!TempSym, !!RHSym, ...),
      PreservationIndex = calcPI(!!TempSym, !!RHSym, ...),
      Lifetime = calcLM(!!TempSym, !!RHSym, ...),
      EMC_wood = calcEMC_wood(!!TempSym, !!RHSym)
    )
}
