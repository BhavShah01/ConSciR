shiny_dataUploadServer <- function(id) {
  moduleServer(id, function(input, output, session) {

    # Reactive value to store the raw data
    raw_data <- reactiveVal(NULL)

    # File input and upload button to UI
    output$file_upload <- renderUI({
      tagList(
        fileInput(session$ns("file"), "Choose CSV or Excel File",
                  accept = c(".csv", ".xls", ".xlsx")),
        uiOutput(session$ns("sheet_selector")),  # UI for selecting Excel sheet
        actionButton(session$ns("upload"), "Upload Data")
      )
    })

    # Observe file input to update sheet choices if Excel
    observeEvent(input$file, {
      req(input$file)
      file_ext <- tools::file_ext(input$file$name)

      if (file_ext %in% c("xls", "xlsx")) {
        sheets <- excel_sheets(input$file$datapath)
        output$sheet_selector <- renderUI({
          selectInput(session$ns("sheet"), "Select Sheet", choices = sheets)
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
          raw_data(uploaded_data)
          showNotification("Data uploaded successfully!", type = "message")
        },
        error = function(e) {
          showNotification(paste(
            "Error reading file:", e$message,
            ". CSV or Excel formatted data with 'Date', 'RH', and other relevant columns can be uploaded to the application."),
            type = "error")
        }
      )
    })

    # Reactive expression for tidied data
    tidied_data <- reactive({
      req(raw_data())

      raw_data() |>
        dplyr::rename_with(
          ~ dplyr::case_when(
            . == "DATE" ~ "Date",
            . == "TEMPERATURE" ~ "Temp",
            . == "HUMIDITY" ~ "RH",
            . == "RECEIVER" ~ "Site",
            . == "TRANSMITTER" ~ "Sensor",
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
        group_by(Date, across(c("Sensor", "Site"), .names = "{.col}")) |>
        summarise(
          Temp = mean(Temp, na.rm = TRUE),
          RH = mean(RH, na.rm = TRUE)
        )
    })

    # Return the tidied data
    return(tidied_data)
  })
}

