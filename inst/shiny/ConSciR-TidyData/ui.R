# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(bslib)



ui <- page_navbar(
  title = "ConSciR: Data Tidy",
  sidebar = sidebar(
    title = "",
    shiny_DataUploaderUI("dataUpload")
  ),
  card(
    card_header("Data Tidy"),
    verbatimTextOutput("data_summary")

  ),
)


