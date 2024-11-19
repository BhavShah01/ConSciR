library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "ConSciR: Tools for Conservation",
  sidebar = sidebar(
    title = "mydata",
  ),
  card(
    card_header("Graph"),
    plotOutput("gg_TRHplot")
  ),

  card(
    card_header("Conservation tools"),
    plotOutput("gg_mould"),
    plotOutput("gg_LM"),
    plotOutput("gg_PI")
  ),
)
