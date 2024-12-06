# inst/shiny/ConSciR-Psychrometric/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)

options(shiny.maxRequestSize = 100 * 1024^2)


server <- function(input, output) {

  # Reactive value to store the data
  data <- reactiveVal(mydata)

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
        data(uploaded_data)
        showNotification("Data uploaded successfully!", type = "message")
      },
      error = function(e) {
        showNotification(paste(
          "Error reading file:", e$message,
          ". CSV or Excel formatted data with 'Temp', 'RH' and 'Sensor' columns can be uploaded to the application."),
          type = "error")
      }
    )
  })

  output$column_Date = renderUI({
    textInput("column_Date", "Date column", value = "Date")
  })
  output$column_Temp = renderUI({
    textInput("column_Temp", "Temperature column", value = "Temp")
  })
  output$column_RH = renderUI({
    textInput("column_RH", "RH column", value = "RH")
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
                 min = 0, max = 1, value = 0.5, step = 0.02)
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
        y_func = get(input$select_y_func), # Humidity function
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
