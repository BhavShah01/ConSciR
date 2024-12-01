# inst/shiny/ConSciR-Tidy/app.R
#' Run ConSciR Tidying Data Application
#'
#' @description
#' Shiny application to help with tidying data.
#'
#' CSV or Excel formatted data can be uploaded to the application.
#'
#'
#' @return Shiny object
#' @export
#'
#' @importFrom shiny runApp
#'
#' @examples
#' # run_TidyData_app()
#'
run_TidyData_app <- function() {
  app_dir <- system.file("shiny", "ConSciR-TidyData", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
