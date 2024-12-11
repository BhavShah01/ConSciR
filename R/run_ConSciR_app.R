# R/run_ConSciR_app.R
#' Run ConSciR Shiny Application
#'
#' @return Shiny object
#' @export
#'
#' @importFrom shiny runApp
#'
#' @examples
#' # run_ConSciR_app()
#'
run_ConSciR_app <- function() {
  app_dir <- system.file("shiny", "ConSciR-App", package = "ConSciR")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing ConSciR.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
