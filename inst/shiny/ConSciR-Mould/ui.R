# inst/shiny/ConSciR-Mould/app.R
library(shiny)
library(bslib)



ui <- page_navbar(
  title = "ConSciR: Mould",
  sidebar = sidebar(
    title = "",
    "Upload tidy data with 'Date', 'Temp, and 'RH' columns",
    shiny_dataUploadUI("dataupload"),
    downloadButton("downloadData", "Download Results")
  ),
  card(
    full_screen = TRUE,
    card_header("Mould estimates"),
    plotOutput("mdata_TRHplot"),
    plotOutput("mdata_Mouldplot_VTT"),
    plotOutput("mdata_Mouldplot_limit")
  )
)
