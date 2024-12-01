# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(bslib)



ui <- page_navbar(
  title = "ConSciR: Data Tidy",
  sidebar = sidebar(
    title = "",
    shiny_DataUploaderUI("dataUpload"),
  ),
  card(
    card_header("Data Tidy"),

    actionButton("tidy_data", "Tidy Data"),
    verbatimTextOutput("tidydata_head"),
    downloadButton("downloadData", "Download Tidied Data"),
  ),
)


