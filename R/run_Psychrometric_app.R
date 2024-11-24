# inst/shiny/ConSciR-Psychrometric/app.R
#' Run ConSciR Psychrometric Application
#'
#' @description
#' Shiny application is view the psychrometric chart.
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
run_Psychrometric_app <- function() {
  app_dir <- system.file("shiny", "ConSciR-Psychrometric", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
