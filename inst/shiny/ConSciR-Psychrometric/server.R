# inst/shiny/ConSciR-Psychrometric/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)

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

  func_list_text <- c(
    "Mixing Ratio (g/kg)" = "calcMR",
    "Humidity Ratio (g/kg)" = "calcHR",
    "Absolute Humidity (g/m³)" = "calcAH",
    "Specific Humidity (g/kg)" = "calcSH",
    "Air Density (kg/m³)" = "calcAD",
    "Dew Point (°C)" = "calcDP",
    "Enthalpy (kJ/kg)" = "calcEnthalpy",
    "Saturation Vapour Pressure (hPa)" = "calcPws",
    "Water Vapour Pressure (hPa)" = "calcPw",
    "Preservation Index" = "calcPI",
    "Lifetime Multiplier" = "calcLM",
    "Equilibrium Moisture Content (wood)" = "calcEMC_wood"
  )

  output$select_y_func <- renderUI({
    selectInput("select_y_func", "Function", selected = func_list_text[1],
                choices = func_list_text)
  })

  output$select_data_colour <- renderUI({
    selectInput("select_data_colour", "Colour by", selected = names(data())[2],
                choices = names(data()))
  })

  output$select_alpha <- renderUI({
    numericInput("select_alpha", "Transparency",
                 min = 0, max = 1, value = 0.5, step = 0.02)
  })

  output$select_temp_range <- renderUI({
    sliderInput("select_temp_range", "Temperature x-axis",
                min = 0, max = 50, value = c(0, 40))
  })

  output$select_temp <- renderUI({
    sliderInput("select_temp", "Temperature",
                min = 0, max = 50, value = c(12, 25))
  })

  output$select_rh <- renderUI({
    sliderInput("select_rh", "Humidity",
                min = 0, max = 100, value = c(40, 60))
  })


  output$gg_Psychrometric <- renderPlot({
    req(mydata())

    mydata() |>

      graph_psychrometric(
        y_func = get(input$select_y_func), # Humidity function
        Temp_range = c(input$select_temp_range[1], input$select_temp_range[2]),
        LowT = input$select_temp[1],
        HighT = input$select_temp[2],
        LowRH = input$select_rh[1],
        HighRH = input$select_rh[2],
        # data_colour = !!input$select_data_colour,
        data_alpha = input$select_alpha
      ) +

      theme_bw()
  })

}
