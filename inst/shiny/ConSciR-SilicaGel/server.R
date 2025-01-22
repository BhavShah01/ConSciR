# inst/shiny/ConSciR-SilicaGel/app.R
library(shiny)
library(readxl)
library(tools)
library(tidyverse)

options(shiny.maxRequestSize = 100 * 1024^2)


calculate_RH1 <- function(mydata, initialRH, RH, half_life) {
  mydata |>
    mutate(
      RH_gel = case_when(
        row_number() == 1 ~ ifelse(is.na(RH), initialRH, initialRH + (RH - initialRH) * (1 - exp(-log(2) / half_life))),
        is.na(RH) ~ lag(RH_gel),
        TRUE ~ lag(RH_gel) + (RH - lag(RH_gel)) * (1 - exp(-log(2) / half_life))
      )
    )
}

calculate_RH <- function(data, initialRH, RH, half_life) {
  RH <- data$RH
  # Initialize the result vector
  RH_gel <- numeric(length(RH))
  # Calculate the result for each value of RH
  for (i in 1:length(RH)) {
    if (i == 1) {
      RH_gel[i] <- ifelse(is.na(RH[i]), initialRH, initialRH + (RH[i] - initialRH) * (1 - exp(-log(2) / half_life)))
    } else {
      if (is.na(RH[i])) {
        RH_gel[i] <- RH_gel[i-1]  # Roll over previous value if current RH is NA
      } else {
        RH_gel[i] <- RH_gel[i-1] + (RH[i] - RH_gel[i-1]) * (1 - exp(-log(2) / half_life))
      }
    }
  }
  data$RH_gel <- RH_gel
  return(data)
}

# Main server function
server <- function(input, output, session) {

  uploaded_data <- shiny_dataUploadServer("dataupload")

  mydata <- reactive({
    if (is.null(uploaded_data())) {
      mydata
    } else {
      uploaded_data()
    }
  })

  output$select_aer <- renderUI({
    numericInput("select_aer", "AER", value = 1, min = 0, step = 0.1, width = 150)
  })

  output$select_length <- renderUI({
    numericInput("select_length", "Length", value = 1, min = 0, step = 0.1, width = 100)
  })

  output$select_height <- renderUI({
    numericInput("select_height", "Height", value = 1, min = 0, step = 0.1, width = 100)
  })

  output$select_width <- renderUI({
    numericInput("select_width", "Width", value = 1, min = 0, step = 0.1, width = 100)
  })

  output$select_silica <- renderUI({
    numericInput("select_silica", "Silica (kg)", value = 1, min = 0, step = 0.5, width = 150)
  })

  output$select_specifiedRH <- renderUI({
    numericInput("select_specifiedRH", "RH Limit", value = 30, min = 0, step = 1, width = 120)
  })

  output$select_initialRH <- renderUI({
    numericInput("select_initialRH", "Intial RH", value = 5, min = 0, step = 1, width = 120)
  })

  output$select_silicaMvalue <- renderUI({
    numericInput("select_silicaMvalue", "Silica M value", value = 4, min = 0, step = 0.5, width = 120)
  })



  case_vol <- reactive({
    input$select_length * input$select_height * input$select_width
  })

  case_loading <- reactive({
    input$select_silica / case_vol()
  })

  case_half_life <- reactive({
    (4 * 24 * case_loading() * input$select_silicaMvalue) / input$select_aer
  })

  output$half_life_text <- renderText({
    paste0("Case half life: ", case_half_life(), " hours")
  })



  mdata <- reactive({
    mydata() |>
      mutate(
        "Case volume (m3)" = case_vol(),
        "Silica gel (kg)" = input$select_silica,
        "Case loading" = case_loading(),
        initialRH = input$select_initialRH,
        half_life = case_half_life(),
      ) |>
      calculate_RH(input$select_initialRH, RH, case_half_life())
  })


  output$mdata_plot <- renderPlot({
    mdata() |>
      ggplot() +
      geom_line(aes(Date, RH), alpha = 0.5, col = "blue") +
      geom_point(aes(Date, RH_gel), alpha = 0.5, col = "purple") +
      geom_hline(yintercept = input$select_specifiedRH, col = "red") +
      theme_bw()
  })

  # Download button for results
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("silica-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      req(mdata())  # Ensure there is tidied data to download
      write.csv(mdata(), file, row.names = FALSE)
    }
  )


}
