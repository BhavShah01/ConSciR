#' UI module for the data uploader module
#'
#' @description
#' This function creates the user interface components for uploading data files
#' (CSV or Excel) and selecting relevant columns for Date, Temperature, and
#' Relative Humidity. It is intended to be used within a Shiny application.
#'
#'
#' @param id A string representing the module ID. This ID is used to namespace
#' the inputs and outputs of the module, ensuring that they do not conflict
#' with other modules or UI elements in the application.
#'
#' @return A tagList containing UI elements for file upload and column selection.
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # In ui.R or app.R
#' shiny_DataUploaderUI("dataUpload")
#' }
#'
#'
#'
shiny_DataUploaderUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("file_upload")),
    uiOutput(ns("column_Date")),
    uiOutput(ns("column_Temp")),
    uiOutput(ns("column_RH"))
  )
}
