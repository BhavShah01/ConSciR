# inst/shiny/ConSciR-Psychrometric/app.R
library(shiny)
library(bslib)

ui <- page_navbar(
  title = "ConSciR: Psychrometric Chart",
  sidebar = sidebar(
    title = "mydata",
    uiOutput("file_upload"),
    uiOutput("select_temp_range"),
    uiOutput("select_temp"),
    uiOutput("select_rh"),
    uiOutput("column_Date"),
    uiOutput("column_Temp"),
    uiOutput("column_RH"),
  ),
  card(
    card_header("Psychrometric Chart"),
    fluidRow(
      uiOutput("select_y_func"),
      uiOutput("select_data_colour"),
      uiOutput("select_alpha")),
    plotOutput("gg_Psychrometric")
  ),
)
