# inst/shiny/ConSciR-Psychrometric/app.R
library(shiny)
library(bslib)

ui <- page_navbar(
  title = "ConSciR: Psychrometric Chart",
  sidebar = sidebar(
    title = "mydata",
    uiOutput("select_y_func"),
    uiOutput("select_temp_range"),
    uiOutput("select_temp"),
    uiOutput("select_rh"),
  ),
  card(
    card_header("Graph"),
    plotOutput("gg_Psychrometric")
  ),
)
