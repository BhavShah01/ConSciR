#' Shiny Module Server for Data Upload and Processing
#'
#' @description
#' This function creates a Shiny module server for uploading CSV or Excel files,
#' processing the data, optional time averaging as specified by the user,
#' and returning a tidied dataset.
#'
#' @param id A character string that corresponds to the ID used in the UI function
#'  for this module.
#'
#' @return The returned reactive expression is a tidied data frame containing columns including Site and Sensor identifiers,
#' a Date column rounded down (floored) to the user-selected averaging interval,
#' median or chosen average temperature and relative humidity for each group,
#' and any other numeric variables that were averaged if present in the input data.

#'
#' @export
#'
#' @import shiny
#' @importFrom readxl read_excel excel_sheets
#' @importFrom readr write_excel_csv
#' @importFrom tools file_ext
#' @importFrom dplyr rename_with case_when mutate group_by across summarise
#' @importFrom lubridate parse_date_time floor_date
#' @importFrom stats median
#'
#' @examples
#' if(interactive()) {
#'   ui <- fluidPage(
#'     shiny_dataUploadUI("dataUpload")
#'   )
#'   server <- function(input, output, session) {
#'     data <- shiny_dataUploadServer("dataUpload")
#'   }
#' }
#'
#'
shiny_dataUploadServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    raw_data <- reactiveVal(NULL)
    csv_cache <- reactiveVal(NULL)

    output$file_upload <- renderUI({
      tagList(
        fileInput(session$ns("file"), "Choose CSV or Excel File",
                  accept = c(".csv", ".xls", ".xlsx")),
        uiOutput(session$ns("sheet_selector")),
        actionButton(session$ns("upload"), "Upload Data")
      )
    })

    observeEvent(input$file, {
      req(input$file)
      ext <- tools::file_ext(input$file$name)
      if (ext %in% c("xls", "xlsx")) {
        sheets <- readxl::excel_sheets(input$file$datapath)
        output$sheet_selector <- renderUI({
          selectInput(session$ns("sheet"), "Select Sheet", choices = sheets)
        })
      } else {
        output$sheet_selector <- renderUI(NULL)
      }
    })

    observeEvent(input$upload, {
      req(input$file)
      ext <- tools::file_ext(input$file$name)
      tryCatch({
        data <- switch(
          ext,
          "csv" = read.csv(input$file$datapath, stringsAsFactors = FALSE),
          "xls" = readxl::read_excel(input$file$datapath, sheet = input$sheet),
          "xlsx" = readxl::read_excel(input$file$datapath, sheet = input$sheet),
          stop("Unsupported file type")
        )
        raw_data(data)
        showNotification("Data uploaded successfully!", type = "message")
      }, error = function(e) {
        showNotification(paste("Error reading file:", e$message), type = "error")
      })
    })

    tidied_data <- reactive({
      req(raw_data())
      interval <- tolower(trimws(input$avg_interval %||% "none"))
      stat <- tolower(trimws(input$avg_statistic %||% "median"))
      tidy_TRHdata(
        raw_data(),
        avg_time = interval,
        avg_statistic = stat,
        avg_groups = c("Site", "Sensor")
      )
    })

    observeEvent(tidied_data(), {
      df <- tidied_data()
      if (is.null(df) || nrow(df) == 0) {
        csv_cache(NULL)
        return()
      }
      csv_file <- tempfile(fileext = ".csv")
      readr::write_excel_csv(df, csv_file)
      csv_cache(csv_file)
    }, ignoreInit = TRUE)

    # Download handler serves cached CSV file
    output$download_csv <- downloadHandler(
      filename = function() paste0("tidied_data_", Sys.Date(), ".csv"),
      content = function(file) {
        req(csv_cache())
        file.copy(csv_cache(), file)
      }
    )
    # Prevent suspension when hidden
    outputOptions(output, "download_csv", suspendWhenHidden = FALSE)

    return(tidied_data)
  })
}
