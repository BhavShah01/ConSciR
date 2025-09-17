# inst/shiny/ConSciR-App/app.R
library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "ConSciR: Tools for Conservation",
  theme = bs_theme(bootswatch = "bootstrap"),

  sidebar = sidebar(
    title = tagList(
      a(href = "https://bhavshah01.github.io/ConSciR/index.html", # target = "_blank",
        img(src = "https://github.com/BhavShah01/ConSciR/blob/master/pkgdown/favicon/web-app-manifest-192x192.png?raw=true",
            height = "100px", width = "100px"))
    ),
    shiny_dataUploadUI("dataupload"),
    uiOutput("func_name"),
    downloadButton("downloadCalcData", "Download Results")
  ),

  navset_card_tab(
    title = "ConSciR Tools",
    nav_panel(
      "TRH plot",
      card_title("Temperature and Humidity plot"),
      card(
        full_screen = TRUE, plotOutput("gg_TRHplot"))
    ),
    nav_panel(
      "Psychrometric",
      full_screen = TRUE,
      card_title("Psychrometric plot"),
      card(
        full_screen = TRUE, plotOutput("gg_Psy"))
    ),
    nav_panel(
      "Bivariate",
      full_screen = TRUE,
      card_title("Bivariate plot"),
      card(
        full_screen = TRUE, plotOutput("gg_Bivar"))
    ),
    nav_panel(
      full_screen = TRUE,
      "Mould VTT",
      "M Mould growth index: 0-6",
      plotOutput("mdata_Mouldplot_VTT")
    ),
    nav_panel(
      full_screen = TRUE,
      "Mould LIM",
      "Zeng model: Mould Predicted (RH > LIM0)",
      plotOutput("mdata_Mouldplot_Zeng")
    ),
    nav_panel(
      full_screen = TRUE,
      "Mould Growth",
      "Zeng model: Growth limit mm/day",
      plotOutput("mdata_Mouldplot_limit")
    ),
    nav_panel(
      full_screen = TRUE,
      "Silica gel calc",
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
      plotOutput("mdata_plot"),
      downloadButton("downloadSilicaData", "Download Results")
    )
    )
)
