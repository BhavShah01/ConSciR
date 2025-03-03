# inst/shiny/ConSciR-Psychrometric/app.R
#' Run ConSciR Psychrometric and Graphing Application
#'
#' @description
#' Shiny application to upload data to a psychrometric chart. Also includes graphs
#' for temperature and humidity - line plot with limits shaded and a bivariate
#' plot with box showing limits.
#'
#' CSV or Excel formatted data with "Temp" and "RH" columns can be uploaded to the application.
#'
#' Use the sliders and functions to set the limits and parameters to be used.
#'
#' Functions available:
#'
#' \itemize{
#'    \item calcHR: Humidity Ratio (g/kg)
#'    \item calcMR: Mixing Ratio (g/kg)
#'    \item calcAH: Absolute Humidity (g/m^3)
#'    \item calcSH: Specific Humidity (g/kg)
#'    \item calcAD: Air Density (kg/m^3)
#'    \item calcDP: Dew Point (°C)
#'    \item calcEnthalpy: Enthalpy (kJ/kg)
#'    \item calcPws: Saturation vapor pressure (hPa)
#'    \item calcPw: Water Vapour Pressure (hPa)
#'    \item calcPI: Preservation Index
#'    \item calcLM: Lifetime
#'    \item calcEMC_wood: Equilibrium Moisture Content (wood)
#' }
#'
#'
#' @return Shiny object
#' @export
#'
#' @importFrom shiny runApp
#'
#' @examples
#' # run_Psychrometric_app()
#'
run_Psychrometric_app <- function() {
  app_dir <- system.file("shiny", "ConSciR-Psychrometric", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
