# inst/shiny/ConSciR-App/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)
library(readxl)

options(shiny.maxRequestSize = 100 * 1024^2)


server <- function(input, output) {

  uploaded_data <- shiny_dataUploadServer("dataupload")

  mydata <- reactive({
    if (is.null(uploaded_data())) {
      mydata
    } else {
      uploaded_data()
    }
  })

  output$gg_TRHplot <- renderPlot({
    req(mydata())
    mydata() |>
      graph_TRH() +
      theme_bw()
  })

  output$gg_Psy <- renderPlot({
    req(mydata())
    mydata() |>
      graph_psychrometric() +
      theme_minimal()
  })

}
