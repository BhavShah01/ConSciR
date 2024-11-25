# inst/shiny/ConSciR-Mould/app.R
#' Run ConSciR Mould Application
#'
#' @description
#' Shiny application to calculate mould growth likelihoods.
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
#' # run_Mould_app()
#'
run_Mould_app <- function() {
  app_dir <- system.file("shiny", "ConSciR-Mould", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
