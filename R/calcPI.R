#' Calculate Preservation Index
#'
#' @description
#' Calculates the Preservation Index (PI) to estimate the natural decay speed of objects.
#' Uses acetate film as a reference for early warning of chemical deterioration in
#' organic and synthetic objects. Results are in years for each data point, showing
#' periods of higher and lower risk. Model based on acetate films or similarly
#' unstable objects under specific temperature and relative humidity conditions.
#' The model is less reliable at high and low RH values.
#'
#' @details
#' The formula is based on Arrhenius equation (for molecular energy) and an
#' equivalent for E (best fit to the cellulose triacetate deterioration data).
#' The other parameters are integrated to mimic the results from the experiments.
#' The result is an average chemical lifetime at one point in time of chemically
#' unstable object (based on experiments on acetate film). This means it is the
#' expected lifetime for a specific T, RH and theoretical object if this remains
#' stable (no fluctuations).
#' The chosen activation energy (Ea) has a larger impact at low temperature.
#'
#' Developed by the Image Permance Institute, the model is based on the
#' chemical degradation of cellulose acetate (Reilly et al., 1995):
#'
#' -  Rate, k = [RH\%] × 5.9 × 10^12 × exp(-90300 / (8.314 × TempK))
#'
#' -  Preservation Index, PI = 1/k
#'
#' @note
#' This metric is an early version of a lifetime multiplier based on chemical
#' deterioration of acetate film. This last object is naturally relatively unstable
#' and there lies the biggest difference with other chemical metrics together with
#' the fact that it is not relative to the lifetime of the object.
#' All lifetime multipliers give similar results between 20\% and 60\% RH.
#' The results at very low and high RH can be unreliable.
#'
#'
#' @references
#' Reilly, James M. New Tools for Preservation: Assessing Long-Term Environmental
#' Effects on Library and Archives Collections. Commission on Preservation and Access,
#' 1400 16th Street, NW, Suite 740, Washington, DC 20036-2217, 1995.
#'
#' Padfield, T. 2004. The Preservation Index and The Time Weighted Preservation Index.
#' https://www.conservationphysics.org/twpi/twpi_01.html
#'
#' Activation Energy: ASHRAE, 2011.
#'
#' Image Permanence Institute, eClimateNotebook
#'
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param EA Activation Energy (J/mol). Default is 90300 J/mol for cellulose acetate film
#'
#' @return PI Preservation Index, the expected lifetime (1/rate,k)
#' @export
#'
#' @examples
#' calcPI(20, 50)
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(PI = calcPI(Temp, RH))
#'
#'
calcPI <- function(Temp, RH, EA = 90300) {

  # k is expressed as the fraction of expected lifetime per year of the degradation
  k = RH * 5.9e12 * exp(-EA / (8.314 * (Temp + 273.15) ))

  # The expected lifetime, PI, is 1/k
  PI = 1/k

  return(PI)
}
