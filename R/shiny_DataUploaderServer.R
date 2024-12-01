#' Server module to read TRH data from an Excel or CSV file into Shiny application
#'
#' @description
#' Server module to create a user interface for uploading Excel (.xlsx or .xls) or CSV files
#' into a Shiny application. It allows users to select specific columns for Date, Temperature,
#' and Relative Humidity from the uploaded data.
#'
#'
#' @param id The module ID
#' @param mydata A data frame containing initial data (if any). Default is NULL.
#' @param Date A string specifying the default name of the Date column. Default is "Date".
#' @param Temp_col Temp_col A string specifying the default name of the Temperature column. Default is "Temp".
#' @param RH_col A string specifying the default name of the Relative Humidity column. Default is "RH".
#'
#' @return A list containing two reactive elements:
#'
#'   \item{data}{A reactive value containing the uploaded data}
#'   \item{selected_columns}{A reactive expression that returns a list of the selected column names for Date, Temperature, and RH}
#'
#'
#' @export
#'
#' @import shiny
#' @importFrom readxl excel_sheets
#' @importFrom readxl read_excel
#'
#' @examples
#' \dontrun{
#'
#' # In ui.R
#' uiOutput("file_upload")
#' uiOutput("column_Date")
#' uiOutput("column_Temp")
#' uiOutput("column_RH")
#'
#' # In server.R
#' data_upload <- shiny_DataUploader()
#'
#' # Access the uploaded data
#' uploaded_data <- data_upload$data()
#'
#' # Access the selected column names
#' selected_cols <- data_upload$selected_columns()
#' }
#'
#'
#'
shiny_DataUploaderServer <- function(id, mydata = NULL, Date = "Date", Temp_col = "Temp", RH_col = "RH") {

  moduleServer(id, function(input, output, session) {

    data <- reactiveVal(mydata)
    column_names <- reactiveVal(NULL)
    tidy_data <- reactiveVal(NULL)  # Reactive value for tidy data

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
      file_ext <- tools::file_ext(input$file$name)

      if (file_ext %in% c("xls", "xlsx")) {
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
      file_ext <- tools::file_ext(input$file$name)

      tryCatch({
        uploaded_data <- switch(
          file_ext,
          "csv" = read.csv(input$file$datapath),
          "xls" = readxl::read_excel(input$file$datapath, sheet = input$sheet),
          "xlsx" = readxl::read_excel(input$file$datapath, sheet = input$sheet),
          stop("Unsupported file type")
        )
        data(uploaded_data)  # Update the reactive value with uploaded data
        column_names(names(uploaded_data))
        showNotification("Data uploaded successfully!", type = "message")
      },
      error = function(e) {
        showNotification(paste(
          "Error reading file:", e$message,
          ". CSV or Excel formatted data with Date, Temp, and RH columns can be uploaded to the application."),
          type = "error")
      })
    })

    # UI for Site column: Select or Type
    output$column_Site <- renderUI({
      req(column_names())
      tagList(
        textInput(session$ns("input_Site"), "Enter Site (or select from below):"),
        selectInput(session$ns("column_Site"), "Select Site column",
                    choices = c("", column_names()),  # Allow empty selection for optionality
                    selected = "")
      )
    })

    # UI for Sensor column: Select or Type
    output$column_Sensor <- renderUI({
      req(column_names())
      tagList(
        textInput(session$ns("input_Sensor"), "Enter Sensor (or select from below):"),
        selectInput(session$ns("column_Sensor"), "Select Sensor column",
                    choices = c("", column_names()),  # Allow empty selection for optionality
                    selected = "")
      )
    })

    output$column_Date <- renderUI({
      req(column_names())
      selectInput(session$ns("column_Date"), "Select Date column",
                  choices = column_names(),
                  selected = if(Date %in% column_names()) Date else "")
    })

    output$column_Temp <- renderUI({
      req(column_names())
      selectInput(session$ns("column_Temp"), "Select Temperature column",
                  choices = column_names(),
                  selected = if(Temp_col %in% column_names()) Temp_col else "")
    })

    output$column_RH <- renderUI({
      req(column_names())
      selectInput(session$ns("column_RH"), "Select RH column",
                  choices = column_names(),
                  selected = if(RH_col %in% column_names()) RH_col else "")
    })

    # Action button to tidy data using tidy_TRHdata
    output$tidy_data_button <- renderUI({
      actionButton(session$ns("tidy_data"), "Tidy Data")
    })

    observeEvent(input$tidy_data, {
      req(data())

      # Call tidy_TRHdata with selected columns from the uploader
      tidy_result <- tidy_TRHdata(
        data(),
        Site_col = if (input$input_Site != "") input$input_Site else input$column_Site,
        Sensor_col = if (input$input_Sensor != "") input$input_Sensor else input$column_Sensor,
        Date_col = input$column_Date,
        Temp_col = input$column_Temp,
        RH_col = input$column_RH)

      tidy_data(tidy_result)  # Update reactive value with tidied data

      showNotification("Data tidied successfully!", type = "message")
    })

    return(list(
      data = data,
      tidy_data = tidy_data,
      selected_columns = reactive({
        list(
          Site = if (input$input_Site != "") input$input_Site else input$column_Site,
          Sensor = if (input$input_Sensor != "") input$input_Sensor else input$column_Sensor,
          Date = input$column_Date,
          Temp = input$column_Temp,
          RH = input$column_RH
        )
      })
    ))
  })
}
