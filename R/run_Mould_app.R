# inst/shiny/ConSciR-Mould/app.R
#' Run ConSciR Mould Application
#'
#' @description
#' Shiny application to upload data to estimate mould growth predictions.
#'
#' CSV or Excel formatted data with "Temp" and "RH" columns can be uploaded to the application.
#'
#' Functions available:
#'
#' \itemize{
#'  \item calcMould_Zeng: Mould Growth Rate Limits
#'  \item calcMould_VTT: Mould Growth Index (VTT model)
#'  }
#'
#'
#' @returns Shiny object
#' @export
#'
#' @importFrom shiny runApp
#'
#' @examples
#' # run_Mould_app()
#'
#'
run_Mould_app <- function() {
  app_dir <- system.file("shiny", "ConSciR-Mould", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
