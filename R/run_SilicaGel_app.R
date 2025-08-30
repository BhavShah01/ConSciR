# inst/shiny/ConSciR-SilicaGel/app.R
#' Run ConSciR Silica Gel Calculator Application
#'
#' @description
#' Shiny application to calculate the amount of silica gel required.
#' Temperature and humidity data from the proposed location, case dimensions,
#' and air exchange rate (AER) if known, as inputs.
#'
#' CSV or Excel data with "Date", "Temp" and "RH" columns can be uploaded to the application.
#'
#'
#' @return Shiny object
#' @export
#'
#' @importFrom shiny runApp
#'
#' @examples
#' if(interactive()) {
#'     run_SilicaGel_app()
#' }
#'
run_SilicaGel_app <- function() {

  app_dir <- system.file("shiny", "ConSciR-SilicaGel", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}

