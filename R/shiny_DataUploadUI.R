#' UI Module for Data Upload in Shiny with Averaging Option
#'
#' @description
#' This function creates a Shiny UI module for uploading data files and optionally
#' selecting hourly averaging. It provides a file input interface and averaging
#' selection that can be integrated into a larger Shiny application.
#'
#' @param id A character string that defines the namespace for the module's UI elements.
#'
#' @return A `tagList` containing UI elements for file upload and averaging option.
#'
#' @export
#'
#' @import shiny
#'
#' @examples
#' if(interactive()) {
#'
#' # In a Shiny app:
#' ui <- fluidPage(
#'   shiny_dataUploadUI("dataUpload")
#' )
#'
#' server <- function(input, output, session) {
#'   data <- shiny_dataUploadServer("dataUpload")
#' }
#'
#' }
#'
shiny_dataUploadUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("file_upload")),
    radioButtons(
      ns("avg_option"),
      label = "Averaging:",
      choices = c(
        "None (raw records)" = "raw",
        "Hourly median average" = "hourly"
      ),
      selected = "hourly"
    )
  )
}
