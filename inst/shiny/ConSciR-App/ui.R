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
    uiOutput("func_name")
  ),

  navset_card_tab(
    title = "ConSciR Tools",
    nav_panel(
      "`graph_TRH`",
      card_title("Temperature and Humidity plot"),
      card(
        full_screen = TRUE, plotOutput("gg_TRHplot"))
    ),
    nav_panel(
      "`graph_psychrometric`",
      full_screen = TRUE,
      card_title("Psychrometric plot"),
      card(
        full_screen = TRUE, plotOutput("gg_Psy"))
    ),
    nav_panel(
      "`graph_TRHbivariate`",
      full_screen = TRUE,
      card_title("Bivariate plot"),
      card(
        full_screen = TRUE, plotOutput("gg_Bivar"))
    ))
)
