library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)


server <- function(input, output) {

  mydata_ <- reactive({
    mydata |>
      mutate(
        AbsHum = calcAH(Temp, RH),
        DewPoint = calcDP(Temp, RH),
        MR = calcMR(Temp, RH),
        Pw = calcPw(Temp, RH),
        Pws = calcPws(Temp),
        LifeTime = calcLM(Temp, RH),
        PI = calcPI(Temp, RH)
      )
  })

  output$gg_TRHplot <- renderPlot({
    mydata |>
      graph_TRH() +
      theme_bw()
  })

  output$gg_mould <- renderPlot({
    mydata |>
      calcMould(Temp = "Temp", RH = "RH") |>
      ggplot() +
      geom_line(aes(Date, mould), col = "darkgreen") +
      labs(title = "Mould risk") +
      theme_minimal()
  })

  output$gg_Psy <- renderPlot({
    mydata |>
      graph_psychrometric() +
      theme_minimal()
  })


}
