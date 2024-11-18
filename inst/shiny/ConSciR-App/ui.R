library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "ConSciR example",
  sidebar = sidebar(
    title = "Select",
    uiOutput("sel_var")
  ),
  card(
    card_header("Histogram"),
    plotOutput("gg_TRHplot"),
    plotOutput("gg_histogram")
  ),

  card(
    card_header("Mould"),
    plotOutput("gg_mould")
  )
)
