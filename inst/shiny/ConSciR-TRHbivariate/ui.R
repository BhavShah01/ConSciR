# inst/shiny/ConSciR-TRHbivriate/app.R
library(shiny)
library(bslib)

ui <- page_navbar(
  title = "ConSciR: Temperature and Humidity",
  sidebar = sidebar(
    title = "",
    "Upload tidy data with 'Temp' and 'RH' columns",
    shiny_dataUploadUI("dataupload"),
  ),
  card(
    card_header("Bivariate Chart"),
  ),
  card(
    card_header("Summary"),
  )
)
