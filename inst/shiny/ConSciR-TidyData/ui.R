# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(bslib)



ui <- page_sidebar(
  title = "ConSciR: Tidy data",
  sidebar = sidebar(
    title = "",
    "Upload data to be tidied",
    shiny_dataUploadUI("dataupload"),
    downloadButton("downloadData", "Download Tidied Data")
  ),
  card(
    card_header("Data Tidy - Check"),
    verbatimTextOutput("tidydata_head"),
    plotOutput("gg_TRHplot")
  ),
)


