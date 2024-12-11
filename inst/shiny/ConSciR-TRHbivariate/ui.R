# inst/shiny/ConSciR-TRHbivriate/app.R
library(shiny)
library(bslib)

ui <- page_navbar(
  title = "ConSciR: Temperature and Humidity",
  sidebar = sidebar(
    title = "",
    "Upload tidy data 'Sensor', 'Temp' and 'RH'",
    shiny_dataUploadUI("dataupload"),
    uiOutput("select_temp_box"),
    uiOutput("select_rh_box"),
    uiOutput("select_temp_limits"),
    uiOutput("select_rh_limits"),
  ),
  card(
    card_header("Bivariate Chart"),
    fluidRow(
      uiOutput("select_z_func"),
      uiOutput("select_alpha")),
    plotOutput("gg_Bivariate")
  ),
  card(
    card_header("Summary"),
    tableOutput("DTsummary_table")
  )
)
