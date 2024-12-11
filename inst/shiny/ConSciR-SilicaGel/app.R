# inst/shiny/ConSciR-SilicaGel/app.R
library(shiny)
library(bslib)
library(ConSciR)


# Load UI and server files
source("ui.R")
source("server.R")

# Run the application
shinyApp(ui = ui, server = server)
