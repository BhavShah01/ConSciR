library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)


server <- function(input, output) {

  output$var_select <- renderUI({
    varSelectInput(
      "var", "Select variable",
      dplyr::select_if(mydata, is.numeric)
    )
  })
  output$bins_select <- renderUI({
    numericInput("bins", "Number of bins", 30)
  })

  output$p <- renderPlot({
    ggplot(mydata) +
      geom_histogram(aes(!!input$var), bins = input$bins) +
      theme_bw(base_size = 20)
  })

  output$TRHtable <- renderTable({
    mydata |>
      summarise(
        Min = min(!!input$var, na.rm = TRUE),
        Mean = mean(!!input$var, na.rm = TRUE),
        Max = max(!!input$var, na.rm = TRUE)
      )
  })

}
