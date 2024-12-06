# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(readxl)
library(tools)

options(shiny.maxRequestSize = 100 * 1024^2)


# Main server function
server <- function(input, output, session) {

  # Call the data uploader module
  data_upload <- shiny_dataUploadServer("dataUpload")

  # Reactive expression for uploaded data
  uploaded_data <- reactive({
    req(data_upload$data())
    data_upload$data()
  })

  # Reactive expression for tidied data
  tidy_data <- reactive({
    req(uploaded_data())
    uploaded_data() |> tidy_Meaco()
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
    req(uploaded_data())
    summary(uploaded_data())
  })

  output$tidydata_head <- renderPrint({
    req(tidy_data())
    head(tidy_data())
  })


}
