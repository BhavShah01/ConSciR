#' Shiny Module UI for Data Upload and Processing
#'
#' @description
#' Creates a Shiny UI module for uploading CSV or Excel files, and specifying
#' flexible time averaging interval and statistic via text inputs.
#' This UI includes the file upload control, a text box for entering the time averaging
#' interval (e.g., "hour", "day", "month"), a text box for specifying the averaging
#' statistic (e.g., "median", "mean"), and a download button for the tidied data.
#'
#' @param id Namespace ID for the module UI elements.
#'
#' @return A tagList containing UI output placeholders and inputs for averaging interval,
#' averaging statistic, and data download.
#'
#' @export
#'
#' @import shiny
#'
#' @examples
#' if(interactive()) {
#'   ui <- fluidPage(
#'     shiny_dataUploadUI("dataUpload")
#'   )
#'   server <- function(input, output, session) {
#'     data <- shiny_dataUploadServer("dataUpload")
#'   }
#' }
#'
shiny_dataUploadUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("file_upload")),
    textInput(
      ns("avg_interval"),
      label = "Time averaging interval (e.g. 'hour', 'day', 'month'):",
      value = "none"
    ),
    textInput(
      ns("avg_statistic"),
      label = "Averaging statistic (e.g. 'median', 'mean'):",
      value = "median"
    ),
    downloadButton(ns("download_csv"), "Download Tidied CSV")
  )
}
