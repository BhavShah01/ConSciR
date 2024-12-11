# inst/shiny/ConSciR-TRHbivriate/app.R
#' Run ConSciR Temperature and Humidity Application
#'
#' @description
#' Shiny application to plot temperature and humidity data on a bivariate chart.
#' A summary of the data is also produced by specifying a temperature and humidity box.
#'
#' CSV or Excel formatted data with "Temp" and "RH" columns can be uploaded to the application.
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
run_TRHbivariate_app <- function() {
  app_dir <- system.file("shiny", "ConSciR-TRHbivariate", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
