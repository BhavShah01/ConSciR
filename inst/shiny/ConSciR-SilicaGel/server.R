# inst/shiny/ConSciR-SilicaGel/app.R
library(shiny)
library(readxl)
library(tools)
library(tidyverse)

options(shiny.maxRequestSize = 100 * 1024^2)


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

  # Reactive value to store the data
  mydata <- reactiveVal(NULL)

  # File input and upload button to UI
  output$file_upload <- renderUI({
    tagList(
      fileInput("file", "Choose CSV or Excel File",
                accept = c(".csv", ".xls", ".xlsx")),
      uiOutput("sheet_selector"),  # UI for selecting Excel sheet
      actionButton("upload", "Upload Data")
    )
  })

  # Observe file input to update sheet choices if Excel
  observeEvent(input$file, {
    req(input$file)
    file_ext <- tools::file_ext(input$file$name)

    if (file_ext %in% c("xls", "xlsx")) {
      sheets <- excel_sheets(input$file$datapath)
      output$sheet_selector <- renderUI({
        selectInput("sheet", "Select Sheet", choices = sheets)
      })
    } else {
      output$sheet_selector <- renderUI(NULL)  # No sheet selection for CSV
    }
  })

  # Wait till file upload
  observeEvent(input$upload, {
    req(input$file)
    file_ext <- tools::file_ext(input$file$name)

    tryCatch(
      {
        uploaded_data <- switch(
          file_ext,
          "csv" = read.csv(input$file$datapath),
          "xls" = read_excel(input$file$datapath, sheet = input$sheet),
          "xlsx" = read_excel(input$file$datapath, sheet = input$sheet),
          stop("Unsupported file type")
        )
        mydata(uploaded_data)
        showNotification("Data uploaded successfully!", type = "message")
      },
      error = function(e) {
        showNotification(paste(
          "Error reading file:", e$message,
          ". CSV or Excel formatted data with 'Temp', 'RH' and 'Sensor' columns
          can be uploaded to the application."),
          type = "error")
      }
    )
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

  output$select_aer <- renderUI({
    numericInput("select_aer", "AER", value = 1, min = 0, step = 0.1, width = 150)
  })

  output$select_silica <- renderUI({
    numericInput("select_silica", "Silica (kg)", value = 1, min = 0, step = 0.5, width = 150)
  })

  output$select_specifiedRH <- renderUI({
    numericInput("select_specifiedRH", "RH Limit", value = 30, min = 0, step = 1, width = 150)
  })

  output$select_initialRH <- renderUI({
    numericInput("select_initialRH", "Intial RH", value = 5, min = 0, step = 1, width = 150)
  })

  # output$select_temp_range <- renderUI({
  #   sliderInput("select_temp_range", "Temperature x-axis",
  #               min = 0, max = 50, value = c(0, 40))
  # })




  case_vol <- reactive({
    input$select_length * input$select_height * input$select_width
  })

  case_loading <- reactive({
    input$select_silica / case_vol()
  })

  case_half_life <- reactive({
    (4 * 24 * case_loading() * 4) / input$select_aer
  })



  mdata <- reactive({
    mydata() |>
      dplyr::rename_with(
        ~ dplyr::case_when(
          . == "DATE" ~ "Date",
          . == "HUMIDITY" ~ "RH",
          TRUE ~ .
        )
      ) |>
      dplyr::mutate(
        Date = lubridate::parse_date_time(
          Date,
          orders = c("ymd HMS", "ymd HM", "ymd", "dmy HMS","dmy HM", "dmy", "mdy HMS", "mdy HM", "mdy"),
          quiet = TRUE),
        RH = as.numeric(RH)
      ) |>
      dplyr::mutate(
        Date = lubridate::floor_date(Date, unit = "hour")
      ) |>
      group_by(Date) |>
      summarise(
        RH = mean(RH, na.rm = TRUE)
      ) |>
      mutate(
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


}
