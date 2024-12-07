# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(readxl)
library(tools)

options(shiny.maxRequestSize = 100 * 1024^2)


# Main server function
server <- function(input, output, session) {

  # Data uploader module
  uploaded_data <- shiny_dataUploadServer("dataupload")

  tidy_data <- reactive({
    if (is.null(uploaded_data())) {
      mydata
    } else {
      uploaded_data()
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

  output$tidydata_head <- renderPrint({
    req(tidy_data())
    head(tidy_data())
  })

  output$gg_TRHplot <- renderPlot({
    req(tidy_data())
    tidy_data() |>
      graph_TRH() +
      theme_bw()
  })


}
