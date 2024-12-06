library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "ConSciR: Tools for Conservation",
  sidebar = sidebar(
    title = "",
    "Upload data",
    shiny_dataUploadUI("dataupload")
  ),
  card(
    card_header("Tools"),
    plotOutput("gg_TRHplot"),
    plotOutput("gg_mould"),
    plotOutput("gg_Psy")
  ),
)
