# inst/shiny/ConSciR-Psychrometric/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)


server <- function(input, output) {

  func_list_text <- c("calcMR", "calcHR", "calcAH", "calcSH", "calcAD", "calcDP",
                 "calcEnthalpy", "calcPws", "calcPw", "calcPI", "calcIPI", "calcLM")

  func_list <- c(calcMR, calcHR, calcAH, calcSH, calcAD, calcDP,
                 calcEnthalpy, calcPws, calcPw, calcPI, calcIPI, calcLM)

  output$select_y_func <- renderUI({
    selectInput("select_y_func", "Select y-axis", selected = func_list_text[1],
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
    mydata |>
      graph_psychrometric(
        Temp_range = c(input$select_temp_range[1], input$select_temp_range[2]),
        LowT = input$select_temp[1], HighT = input$select_temp[2],
        LowRH = input$select_rh[1], HighRH = input$select_rh[2]) +
      # graph_psychrometric(y_func = !!input$select_y_func) +
      theme_bw()
  })

}
