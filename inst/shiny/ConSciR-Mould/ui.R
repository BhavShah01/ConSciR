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
  navset_card_tab(
    full_screen = TRUE,
    height = 550,
    title = "Mould",
    nav_panel(
      "TRH data",
      plotOutput("mdata_TRHplot"),
    ),
    nav_panel(
      "VTT model",
      "M Mould growth index: 0-6",
      plotOutput("mdata_Mouldplot_VTT")
    ),
    nav_panel(
      "Zeng prediction",
      plotOutput("mdata_Mouldplot_Zeng")
    ),
    nav_panel(
      "Zeng Mould Growth",
      "Zeng model: Growth limit mm/day",
      plotOutput("mdata_Mouldplot_limit")
    )
    )
)
