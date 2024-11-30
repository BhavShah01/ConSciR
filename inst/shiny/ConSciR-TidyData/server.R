# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(readxl)
library(tools)

options(shiny.maxRequestSize = 100 * 1024^2)


# Main server function
server <- function(input, output, session) {
  data_upload <- shiny_DataUploaderServer("dataUpload")

  output$data_summary <- renderPrint({
    req(data_upload$data())
    summary(data_upload$data())
  })
}
