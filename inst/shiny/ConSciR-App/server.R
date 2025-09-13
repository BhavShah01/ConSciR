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
      data_file_path("mydata.xlsx")
    } else {
      uploaded_data()
    }
  })

  output$gg_TRHplot <- renderPlot({
    req(mydata())
    mydata() |>
      graph_TRH(y_func = input$func_name) +
      theme_minimal(base_size = 14)
  })

  output$gg_Psy <- renderPlot({
    req(mydata())
    mydata() |>
      graph_psychrometric(y_func = input$func_name) +
      theme_minimal(base_size = 14)
  })

  output$gg_Bivar <- renderPlot({
    req(mydata())
    mydata() |>
      graph_TRHbivariate(z_func = input$func_name) +
      theme_minimal(base_size = 14)
  })

  func_choices <- c(
    "None" = "none",
    "Dew Point (C)" = "calcDP",
    "Absolute Humidity (g/m^3)" = "calcAH",
    "Mixing Ratio (g/kg)" = "calcMR",
    "Humidity Ratio (g/kg)" = "calcHR",
    "Specific Humidity (g/kg)" = "calcSH",
    "Air Density (kg/m^3)" = "calcAD",
    "Frost Point (C)" = "calcFP",
    "Enthalpy (kJ/kg)" = "calcEnthalpy",
    "Saturation vapor pressure (hPa)" = "calcPws",
    "Water Vapour Pressure (hPa)" = "calcPw",
    "Preservation Index" = "calcPI",
    "Lifetime" = "calcLM",
    "Equilibrium Moisture Content (wood)" = "calcEMC_wood"
  )

  output$func_name <- renderUI({
    selectInput(
      inputId = "func_name",
      label = "Select function to add:",
      choices = func_choices,
      selected = "calcAH")
  })


}
