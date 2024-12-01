# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(readxl)
library(tools)

options(shiny.maxRequestSize = 100 * 1024^2)


# Main server function
server <- function(input, output, session) {

  # Call the data uploader module
  data_upload <- shiny_DataUploaderServer("dataUpload")

  # Reactive value to store tidied data
  tidy_data <- reactiveVal(NULL)

  observeEvent(data_upload$data(), {
    if (!is.null(data_upload$data())) {
      tidy_data(data_upload$data())  # Store uploaded data in tidy_data reactive value
    }
  })

# Download handler for tidied data
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("tidy_data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      req(tidy_data())  # Ensure there is tidied data to download
      write.csv(tidy_data(), file, row.names = FALSE)
    }
  )


  output$data_summary <- renderPrint({
    req(data_upload)
    summary(data_upload)
  })

  output$tidydata_head <- renderPrint({
    req(tidy_data())
    head(tidy_data())
  })


}
