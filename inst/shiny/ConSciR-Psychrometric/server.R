# inst/shiny/ConSciR-Psychrometric/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)


server <- function(input, output) {

  # Add reactive value to store the data
  data <- reactiveVal(mydata)

  # Add file input and upload button to UI
  output$file_upload <- renderUI({
    tagList(
      fileInput("file", "Choose CSV or Excel File",
                accept = c(".csv", ".xls", ".xlsx")),
      actionButton("upload", "Upload Data")
    )
  })

  # Handle file upload
  observeEvent(input$upload, {
    req(input$file)
    file_ext <- tools::file_ext(input$file$name)
    tryCatch(
      {
        uploaded_data <- switch(
          file_ext,
          "csv" = read.csv(input$file$datapath),
          "xls" = readxl::read_excel(input$file$datapath, sheet = 1),
          "xlsx" = readxl::read_excel(input$file$datapath, sheet = 1),
          stop("Unsupported file type")
        )
        data(uploaded_data)
        showNotification("Data uploaded successfully!", type = "message")
      },
      error = function(e) {
        showNotification(paste("Error reading file:", e$message), type = "error")
      }
    )
  })

  func_list_text <- c(
    "Mixing Ratio (g/kg)" = "calcMR",
    "Humidity Ratio (g/kg)" = "calcHR",
    "Absolute Humidity (g/m³)" = "calcAH",
    "Specific Humidity (g/kg)" = "calcSH",
    "Air Density (kg/m³)" = "calcAD",
    "Dew Point (°C)" = "calcDP",
    "Enthalpy (kJ/kg)" = "calcEnthalpy",
    "Saturation Vapour Pressure (hPa)" = "calcPws",
    "Water Vapour Pressure (hPa)" = "calcPw",
    "Preservation Index" = "calcPI",
    "Years to Degradation" = "calcIPI",
    "Lifetime Multiplier" = "calcLM"
  )

  output$select_y_func <- renderUI({
    selectInput("select_y_func", "Function", selected = func_list_text[1],
                choices = func_list_text)
  })

  output$select_data_colour <- renderUI({
    selectInput("select_data_colour", "Colour by", selected = names(data())[2],
                choices = names(data()))
  })

  output$select_alpha <- renderUI({
    numericInput("select_alpha", "Transparency",
                 min = 0, max = 1, value = 0.5)
  })

  output$select_temp_range <- renderUI({
    sliderInput("select_temp_range", "Temperature x-axis",
                min = 0, max = 50, value = c(0, 40))
  })

  output$select_temp <- renderUI({
    sliderInput("select_temp", "Temperature",
                min = 0, max = 50, value = c(12, 25))
  })

  output$select_rh <- renderUI({
    sliderInput("select_rh", "Humidity",
                min = 0, max = 100, value = c(40, 60))
  })

  output$gg_Psychrometric <- renderPlot({
    req(input$select_y_func)

    data() |>
      graph_psychrometric(
        y_func = get(input$select_y_func), # return function
        Temp_range = c(input$select_temp_range[1], input$select_temp_range[2]),
        LowT = input$select_temp[1],
        HighT = input$select_temp[2],
        LowRH = input$select_rh[1],
        HighRH = input$select_rh[2],
        data_colour = !!input$select_data_colour,
        data_alpha = input$select_alpha
      ) +
      theme_bw()
  })

}
