# inst/shiny/ConSciR-App/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)
library(readxl)
library(readr)

options(shiny.maxRequestSize = 100 * 1024^2)

server <- function(input, output) {

  uploaded_data <- shiny_dataUploadServer("dataupload")

  mydata <- reactive({
    if (is.null(uploaded_data())) {
      data_file_path("mydata.xlsx")
    } else {
      uploaded_data()
    }
  })

  output$gg_TRHplot <- renderPlot({
    req(mydata())
    mydata() |>
      graph_TRH(y_func = input$func_name) +
      theme_minimal(base_size = 14)
  })

  output$gg_Psy <- renderPlot({
    req(mydata())
    mydata() |>
      graph_psychrometric(y_func = input$func_name) +
      theme_minimal(base_size = 14)
  })

  output$gg_Bivar <- renderPlot({
    req(mydata())
    mydata() |>
      graph_TRHbivariate(z_func = input$func_name) +
      theme_minimal(base_size = 14)
  })

  func_choices <- c(
    "None" = "none",
    "Dew Point (C)" = "calcDP",
    "Absolute Humidity (g/m^3)" = "calcAH",
    "Mixing Ratio (g/kg)" = "calcMR",
    "Humidity Ratio (g/kg)" = "calcHR",
    "Specific Humidity (g/kg)" = "calcSH",
    "Air Density (kg/m^3)" = "calcAD",
    "Frost Point (C)" = "calcFP",
    "Enthalpy (kJ/kg)" = "calcEnthalpy",
    "Saturation vapor pressure (hPa)" = "calcPws",
    "Water Vapour Pressure (hPa)" = "calcPw",
    "Preservation Index" = "calcPI",
    "Lifetime" = "calcLM",
    "Equilibrium Moisture Content (wood)" = "calcEMC_wood"
  )

  output$func_name <- renderUI({
    selectInput(
      inputId = "func_name",
      label = "Select function to add:",
      choices = func_choices,
      selected = "calcAH")
  })


  ## Mould ----

  output$mdata_Mouldplot_VTT <- renderPlot({
    p = mydata() |>
      ggplot() +
      geom_area(aes(Date, calcMould_VTT(Temp, RH), group = Sensor), fill = "violetred3", alpha = 0.9) +
      geom_hline(yintercept = 0.01, col = "darkred") +
      labs(x = NULL, y = "M Mould Growth Index value", title = "VTT model") +
      hrbrthemes::theme_ipsum(
        base_size = 14, axis_title_size = 14,
        strip_text_size = 14, axis_title_just = "mc") +
      facet_wrap(~Sensor)

    return(p)
  })

  output$mdata_Mouldplot_Zeng <- renderPlot({
    p = mydata() |>
      mutate(
        Mould_Zeng = calcMould_Zeng(Temp, RH),
        Mould_lim = ifelse(Mould_Zeng > RH, 0, RH - Mould_Zeng)
      ) |>
      ggplot() +
      # geom_area(aes(Date, Mould_Zeng, group = Sensor, fill = Mould_label), alpha = 0.9) +
      geom_area(aes(Date, Mould_lim, group = Sensor),
                fill = "deeppink4", alpha = 0.9) +
      labs(x = NULL, y = "Mould Predicted (RH)", title = "Zeng model") +
      hrbrthemes::theme_ipsum(
        base_size = 14, axis_title_size = 14,
        strip_text_size = 14, axis_title_just = "mc") +
      facet_wrap(~Sensor)

    return(p)
  })


  output$mdata_Mouldplot_limit <- renderPlot({
    p = mydata() |>
      ggplot() +
      geom_area(aes(Date, calcMould_Zeng(Temp, RH, label = TRUE), group = Sensor),
                fill = "darkorchid4", alpha = 0.9) +
      labs(x = NULL, y = "Mould Growth Rate (mm/day)", title = "Zeng model") +
      hrbrthemes::theme_ipsum(
        base_size = 14, axis_title_size = 14,
        strip_text_size = 14, axis_title_just = "mc") +
      facet_wrap(~Sensor)

    return(p)
  })


  # Download button for results
  output$downloadCalcData <- downloadHandler(
    filename = function() {
      paste("ConSciR-calcs-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      req(mydata())

      mydata <- mydata() |>
        add_humidity_calcs() |>
        add_conservation_calcs()

      readr::write_excel_csv(mydata, file, row.names = FALSE)
    }
  )

 ## Silica gel calculator ----

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
  output$case_vol_text <- renderText({
    paste0("Case volume (m^3): ", round(case_vol(), 1))
  })

  output$case_Prosorb_text <- renderText({
    paste0("Rule of thumb Prosorb (kg): ", round(case_vol() * 8))
  })

  case_loading <- reactive({
    input$select_silica / case_vol()
  })

  case_half_life <- reactive({
    (4 * 24 * case_loading() * input$select_silicaMvalue) / input$select_aer
  })

  output$half_life_text <- renderText({
    paste0("Case half life: ", round(case_half_life()), " hours")
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
  output$downloadSilicaData <- downloadHandler(
    filename = function() {
      paste("silica-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      req(mdata())  # Ensure there is tidied data to download
      readr::write_excel_csv(mdata(), file, row.names = FALSE)
    }
  )


}
