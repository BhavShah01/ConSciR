# inst/shiny/ConSciR-Psychrometric/app.R
library(shiny)
library(bslib)

ui <- page_navbar(
  title = "ConSciR: Psychrometric Chart",
  sidebar = sidebar(
    title = "",
    "Upload tidy data with 'Temp' and 'RH' columns",
    shiny_dataUploadUI("dataupload"),
    uiOutput("select_temp_range"),
    uiOutput("select_temp"),
    uiOutput("select_rh")
  ),
  navset_card_tab(
    full_screen = TRUE,
    height = 550,
    title = "Mould",
    nav_panel(
      "Psychrometric Chart",
      fluidRow(
        uiOutput("select_y_func"),
        # uiOutput("select_data_colour"),
        uiOutput("select_alpha")),
      plotOutput("gg_Psychrometric")
    ),
    nav_panel(
      "TRH plot",
      plotOutput("mdata_TRHplot"),
    ),
    nav_panel(
      "Bivariate plot",
      plotOutput("mdata_Bivariate"),
    )
  )
)
