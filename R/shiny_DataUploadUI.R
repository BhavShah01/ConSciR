#' UI Module for Data Upload in Shiny
#'
#' @description
#' This function creates a Shiny UI module for uploading data files. It provides
#' a file input interface that can be integrated into a larger Shiny application.
#'
#'
#' @param id A character string that defines the namespace for the module's UI elements.
#'
#' @return A `tagList` containing a `uiOutput` for file upload. The specific elements
#'   of this output (such as file input and upload button) are defined in the
#'   corresponding server function.
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
#'
shiny_dataUploadUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("file_upload"))
  )
}
