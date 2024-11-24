# inst/shiny/ConSciR-Psychrometric/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)


server <- function(input, output) {

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
    "Years to Degradation" = "calcIPI",
    "Lifetime Multiplier" = "calcLM"
  )

  output$select_y_func <- renderUI({
    selectInput("select_y_func", "", selected = func_list_text[1],
                choices = func_list_text)
  })

  output$select_temp_range <- renderUI({
    sliderInput("select_temp_range", "Temperature x-axis",
                min = 0, max = 50, value = c(0, 40))
  })

  output$select_temp <- renderUI({
    sliderInput("select_temp", "Temperature ",
                min = 0, max = 50, value = c(12, 25))
  })

  output$select_rh <- renderUI({
    sliderInput("select_rh", "Humidity",
                min = 0, max = 100, value = c(40, 60))
  })

  output$gg_Psychrometric <- renderPlot({
    req(input$select_y_func)

    mydata |>
      graph_psychrometric(
        y_func = get(input$select_y_func), # return function
        Temp_range = c(input$select_temp_range[1], input$select_temp_range[2]),
        LowT = input$select_temp[1],
        HighT = input$select_temp[2],
        LowRH = input$select_rh[1],
        HighRH = input$select_rh[2]) +
      theme_bw()
  })

}
