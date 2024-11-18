library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(magrittr)
library(ConSciR)


server <- function(input, output) {

  mydata <- reactive({
    mydata %>%
      mutate(
        AbsHum = calcAH(Temp, RH),
        DewPoint = calcDP(Temp, RH),
        MR = calcMR(Temp, RH),
        Pw = calcPw(Temp, RH),
        Pws = calcPws(Temp),
        LifeTime = calcLM(Temp, RH),
        PI = calcPI(Temp,)
      )
  })

  output$sel_var <- renderUI({
    varSelectInput(
      "sel_var", "Select variable",
      dplyr::select_if(mydata(), is.numeric)
    )
  })

  output$gg_TRHplot <- renderPlot({
    mydata() %>%
      ggplot() +
      geom_line(aes(Date, Temp), col = "red", alpha = 0.7) +
      geom_line(aes(Date, RH), col = "blue", alpha = 0.7) +
      theme_bw()
  })
  output$gg_histogram <- renderPlot({
    mydata() %>%
      ggplot() +
      geom_histogram(aes(!!input$sel_var)) +
      theme_bw(base_size = 20)
  })

  output$gg_mould <- renderPlot({
    mydata() %>%
      calcMould(Temp = "Temp", RH = "RH") |>
      graph_TRH() +
      geom_area(aes(Date, mould_prob * 1000), col = "darkgreen") +
      theme_minimal()
  })

}
