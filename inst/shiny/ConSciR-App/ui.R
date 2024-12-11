# inst/shiny/ConSciR-App/app.R
library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "ConSciR: Tools for Conservation",
  sidebar = sidebar(
    title = "",
    "Upload tidy data",
    shiny_dataUploadUI("dataupload")
  ),
  card(
    card_header("Tools"),
    plotOutput("gg_TRHplot"),
    plotOutput("gg_Psy")
  ),
)
