# inst/shiny/ConSciR-Mould/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)


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


  data_mould <- reactive({
    data() |>
      group_by(Sensor) |>
      calcMould(Date = input$column_Date,
                Temp = input$column_Temp,
                RH = input$column_RH)
  })

  # Reactive value for log scale
  log_scale = reactiveVal(FALSE)
  # Wait till button is clicked
  observeEvent(input$toggle_log, {
    log_scale(!log_scale())
  })

  output$gg_Mould <- renderPlot({
    req(data_mould())

    p =
      data_mould() |>
      ggplot() +
      geom_line(aes(x = Date, y = mould, col = Sensor), alpha = 0.7) +
      labs(y = "Mould Likelihood", caption = "Mould = 1 is likely limit") +
      theme_bw()

    # Apply log scale if log_scale is TRUE
    if (log_scale()) {
      p = p + scale_y_log10()
    }

    p
  })

}
