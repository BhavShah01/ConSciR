# inst/shiny/ConSciR-Mould/app.R
library(shiny)
library(bslib)

ui <- page_navbar(
  title = "ConSciR: Mould App",
  sidebar = sidebar(
    title = "",
    uiOutput("file_upload"),
    uiOutput("column_Date"),
    uiOutput("column_Temp"),
    uiOutput("column_RH"),

  ),
  card(
    card_header("Mould"),
    plotOutput("gg_Mould"),
    actionButton("toggle_log", "Log scale"),
  ),
)
