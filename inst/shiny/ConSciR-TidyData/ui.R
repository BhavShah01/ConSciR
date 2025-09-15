# inst/shiny/ConSciR-Tidy/app.R
library(shiny)
library(bslib)



ui <- page_sidebar(
  title = "ConSciR: Tidy data",
  theme = bs_theme(bootswatch = "bootstrap"),

  sidebar = sidebar(
    title = tagList(
      a(href = "https://bhavshah01.github.io/ConSciR/index.html", # target = "_blank",
        img(src = "https://github.com/BhavShah01/ConSciR/blob/master/pkgdown/favicon/web-app-manifest-192x192.png?raw=true",
            height = "100px", width = "100px"))
    ),
    shiny_dataUploadUI("dataupload")
  ),

  navset_card_tab(
    title = "ConSciR Tools",
    nav_panel(
      "'tidy_TRHdata'",
      card(
        full_screen = TRUE,
        plotOutput("gg_TRHplot")
      )),
    nav_panel(
      "Download",
      card(
        full_screen = TRUE,
        downloadButton("download_full_csv", "Download Full CSV"),
        DT::DTOutput("tidydata_table"))
      ))
)


