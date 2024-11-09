library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "A dashboard",
  sidebar = sidebar(
    title = "Histogram controls",
    uiOutput("var_select"),
    uiOutput("bins_select")
  ),
  card(
    card_header("Histogram"),
    plotOutput("p")
  ),
  card(
    card_header("Table"),
    tableOutput("table")
  )
)
