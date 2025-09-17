# R/run_ConSciR_app.R
#' Run the ConSciR Shiny Application
#'
#' @description
#' Launch the ConSciR Shiny app which includes tools for temperature and
#' relative humidity monitoring such as TRH charts, psychrometric charts,
#' bivariate plots, mould growth predictions, and a silica gel calculator.
#'
#' Users can upload CSV or Excel files formatted with "Date", "Temp",
#' and "RH" columns. The app provides data tidying functions and
#' downloadable cleaned CSV files.
#'
#' The silica gel calculator estimates the required amount of silica gel
#' based on temperature, humidity data, case dimensions, and
#' air exchange rate (AER) if known.
#'
#' @return
#' A Shiny application object that runs interactively.
#' @export
#'
#' @importFrom shiny runApp
#'
#' @examples
#' if(interactive()) {
#'     run_ConSciR_app()
#' }
#'
run_ConSciR_app <- function() {
  app_dir <- system.file("shiny", "ConSciR-App", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
