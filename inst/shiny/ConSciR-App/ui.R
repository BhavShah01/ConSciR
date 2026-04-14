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
    downloadButton("downloadCalcData", "Download Results"),
    hr(),
    uiOutput("func_name"),
    h6("Envelope"),
    fluidRow(
      column(6, numericInput("envelope_TempLow",  "Temp Min (°C)",
                             value = 16, min = 0, max = 100, step = 1)),
      column(6, numericInput("envelope_TempHigh", "Temp Max (°C)",
                             value = 25, min = 0, max = 100, step = 1))
    ),
    fluidRow(
      column(6, numericInput("envelope_RHLow",    "RH Min (%)",
                             value = 40, min = 0, max = 100, step = 1)),
      column(6, numericInput("envelope_RHHigh",   "RH Max (%)",
                             value = 60, min = 0, max = 100, step = 1))
    )
  ),

  navset_card_tab(
    title = "ConSciR Tools",
    nav_panel(
      "Calculator",
      full_screen = TRUE,
      card_title("Temperature and Humidity Calculator"),
      card(
        full_screen = TRUE,
        layout_sidebar(
          sidebar = sidebar(
            width = 280,
            uiOutput("select_CalcTemp"),
            uiOutput("select_CalcRH"),
            hr(),
            h6("Adjustments"),
            uiOutput("select_CalcTempAdj"),
            uiOutput("select_CalcDewPAdj"),
            uiOutput("select_CalcAHAdj")
          ),
          tableOutput("tbl_CalcMetrics"),
          plotOutput("gg_PsyPoint", height = "600px")
        )
      )
    ),
    nav_panel(
      "TRH plot",
      full_screen = TRUE,
      card_title("Temperature and Humidity plot ('graph_TRH')"),
      card(
        full_screen = TRUE,
        plotOutput("gg_TRHplot"))
    ),
    nav_panel(
      "Psychrometric",
      full_screen = TRUE,
      card_title("Psychrometric plot ('graph_psychrometric')"),
      card(
        full_screen = TRUE,
        plotOutput("gg_Psy"))
    ),
    nav_panel(
      "Bivariate",
      full_screen = TRUE,
      card_title("Bivariate plot ('graph_TRHbivariate')"),
      card(
        full_screen = TRUE,
        plotOutput("gg_Bivar"))
    ),
    nav_panel(
      "Mould",
      full_screen = TRUE,
      fluidRow(
        column(12, plotOutput("mdata_Mouldplot_VTT")),
        column(12, plotOutput("mdata_Mouldplot_Zeng"))
      )
    ),
    nav_panel(
      "Silica gel calc",
      full_screen = TRUE,
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
