# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(readxl)
library(readr)
library(tools)
library(ggplot2)
library(DT)

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

  output$download_full_csv <- downloadHandler(
    filename = function() paste0("tidied_data_", Sys.Date(), ".csv"),
    content = function(file) {
      write_excel_csv(tidied_data(), file, row.names = FALSE)
    }
  )

  output$tidydata_table <- DT::renderDT({
    req(tidy_data())
    DT::datatable(tidy_data(), extensions = c('Buttons'),
      options = list(dom = 'Bfrtip', buttons = list('csv', 'excel')),
      rownames = FALSE)
  })

  output$gg_TRHplot <- renderPlot({
    req(tidy_data())
    tidy_data() |>
      graph_TRH() +
      theme_bw()
  })

}
