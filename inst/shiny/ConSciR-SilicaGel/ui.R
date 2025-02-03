# inst/shiny/ConSciR-SilicaGel/app.R
library(shiny)
library(bslib)



ui <- page_navbar(
  title = "ConSciR: Silica Gel Calculator",
  sidebar = sidebar(
    title = "",
    "Upload tidy data with 'Date' and 'RH' columns",
    shiny_dataUploadUI("dataupload"),
    downloadButton("downloadData", "Download Results")
  ),
  card(
    card_header("Silica Gel (kg)"),
    fluidRow(
      column(6,
             h4("Case Details"),
             fluidRow(
               uiOutput("select_aer"),
               uiOutput("select_length"),
               uiOutput("select_height"),
               uiOutput("select_width"),
             ),
             textOutput("case_vol_text"),
             textOutput("case_Prosorb_text")),
      column(6,
             h4("Silica Gel requirements"),
             fluidRow(
               uiOutput("select_silica"),
               uiOutput("select_initialRH"),
               uiOutput("select_specifiedRH"),
               uiOutput("select_silicaMvalue")
             ),
             textOutput("half_life_text", inline = TRUE))
    ),
    plotOutput("mdata_plot")
  ),
)
