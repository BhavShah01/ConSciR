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

  raw_data <- reactive({
    if (is.null(uploaded_data())) {
      data_file_path("mydata.xlsx")
    } else {
      uploaded_data()
    }
  })

  mydata <- reactive({
    raw_data() |>
      mutate(
        AH = calcAH(Temp, RH),
        DP = calcDP(Temp, RH),
        NewTemp = Temp + input$select_CalcTempAdj,
        NewAH = AH + input$select_CalcAHAdj,
        NewRH = calcRH_AH(NewTemp, NewAH),
        NewDP = calcDP(Temp, NewRH) + input$select_CalcDewPAdj,
        NewRH = calcRH_DP(NewTemp, NewDP)
      )
  })

  output$gg_TRHplot <- renderPlot({
    req(mydata())
    mydata() |>
      graph_TRH(
        y_func = input$func_name,
        LowT    = input$envelope_TempLow,
        HighT   = input$envelope_TempHigh,
        LowRH   = input$envelope_RHLow,
        HighRH  = input$envelope_RHHigh) +
      geom_line(aes(Date, NewTemp), col = "darkred", alpha = 0.3) +
      geom_line(aes(Date, NewRH), col = "darkblue", alpha = 0.3) +
      theme_minimal(base_size = 14)
  })

  output$gg_Psy <- renderPlot({
    req(mydata())
    mydata() |>
      graph_psychrometric(
        y_func = input$func_name,
        LowT    = input$envelope_TempLow,
        HighT   = input$envelope_TempHigh,
        LowRH   = input$envelope_RHLow,
        HighRH  = input$envelope_RHHigh) +
      theme_minimal(base_size = 14)
  })

  output$gg_Bivar <- renderPlot({
    req(mydata())
    mydata() |>
      graph_TRHbivariate(
        z_func = input$func_name,
        LowT    = input$envelope_TempLow,
        HighT   = input$envelope_TempHigh,
        LowRH   = input$envelope_RHLow,
        HighRH  = input$envelope_RHHigh) +
      theme_minimal(base_size = 14)
  })


  ## Function select ----

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
    "Equilibrium Moisture Content (wood)" = "calcEMC_wood",
    "Mould VTT" = "calcMould_VTT",
    "Mould LIM" = "calcMould_Zeng"
  )

  output$func_name <- renderUI({
    selectInput(
      inputId = "func_name",
      label = "Select function to add:",
      choices = func_choices,
      selected = "calcAH")
  })


  ## Calculator ----
  output$select_CalcTemp <- renderUI({
    numericInput("select_CalcTemp", "Temperature (°C)",
                 value = 20, min = 0, max = 100, step = 0.1, width = 150)
  })

  output$select_CalcRH <- renderUI({
    numericInput("select_CalcRH", "Relative Humidity (%)",
                 value = 50, min = 0, max = 100, step = 0.1, width = 150)
  })

  output$select_CalcTempAdj <- renderUI({
    req(input$select_CalcTemp, input$select_CalcRH)

    base_Temp <- input$select_CalcTemp
    base_RH   <- input$select_CalcRH
    base_DewP <- calcDP(base_Temp, base_RH)

    temp_min <- round(base_DewP - base_Temp, 1)
    temp_max <- round(calcTemp(1, base_DewP) - base_Temp, 1)

    sliderInput("select_CalcTempAdj", "Temperature",
                value = isolate(input$select_CalcTempAdj) %||% 0,
                min = temp_min, max = temp_max, step = 0.1, width = 250)
  })

  output$select_CalcDewPAdj <- renderUI({
    req(input$select_CalcTemp, input$select_CalcRH)

    base_Temp <- input$select_CalcTemp
    base_RH   <- input$select_CalcRH
    base_DewP <- calcDP(base_Temp, base_RH)

    dewp_max <- round(base_Temp - base_DewP, 1)
    dewp_min <- round(calcDP(base_Temp, 1) - base_DewP, 1)

    sliderInput("select_CalcDewPAdj", "Dew Point",
                value = isolate(input$select_CalcDewPAdj) %||% 0,
                min = dewp_min, max = dewp_max, step = 0.1, width = 250)
  })

  output$select_CalcAHAdj <- renderUI({
    req(input$select_CalcTemp, input$select_CalcRH)

    base_Temp <- input$select_CalcTemp
    base_RH   <- input$select_CalcRH
    base_AH   <- calcAH(base_Temp, base_RH)

    ah_at_99 <- calcAH(base_Temp, 99)
    ah_at_1  <- calcAH(base_Temp, 1)

    ah_max <- round(ah_at_99 - base_AH, 1)
    ah_min <- round(ah_at_1   - base_AH, 1)

    sliderInput("select_CalcAHAdj", "Absolute Humidity",
                value = isolate(input$select_CalcAHAdj) %||% 0,
                min = ah_min, max = ah_max, step = 0.1, width = 250)
  })

  # Reactive: adjusted point
  r_calcTempRH <- reactive({
    req(input$select_CalcTemp, input$select_CalcRH,
        input$select_CalcTempAdj, input$select_CalcDewPAdj, input$select_CalcAHAdj)
    tibble(
      Temp = input$select_CalcTemp,
      RH   = input$select_CalcRH
    ) |>
      mutate(
        DewP = calcDP(Temp, RH),
        AH   = calcAH(Temp, RH),
        Temp = Temp + input$select_CalcTempAdj,
        RH   = calcRH_DP(Temp, DewP),
        DewP = DewP + input$select_CalcDewPAdj,
        RH   = calcRH_DP(Temp, DewP),
        AH   = calcAH(Temp, RH) + input$select_CalcAHAdj,
        RH   = calcRH_AH(Temp, AH)
      )
  })

  output$tbl_CalcMetrics <- renderTable({
    d <- r_calcTempRH()

    tibble(
      "Temp (°C)"    = round(d$Temp, 1),
      "RH (%)"       = round(d$RH,   1),
      "Dew Point (°C)" = round(d$DewP, 1),
      "Abs. Humidity (g/m³)" = round(d$AH, 1),
      "EMC Wood (%)" = round(calcEMC_wood(d$Temp, d$RH), 1),
      "PI (years)"   = round(calcPI(d$Temp, d$RH), 0),
      "Mould Risk (mm/day)"   = calcMould_Zeng(d$Temp, d$RH, label = TRUE)
    )
  }, striped = FALSE, hover = FALSE, bordered = TRUE,
  width = "100%", align = "c")

  output$gg_PsyPoint <- renderPlot({
    req(input$func_name)
    d <- r_calcTempRH()
    graph_psychrometric(
      mydata = d,
      y_func = input$func_name,
      LowT   = input$envelope_TempLow,
      HighT  = input$envelope_TempHigh,
      LowRH  = input$envelope_RHLow,
      HighRH = input$envelope_RHHigh
    ) +
      geom_label(
        data = d,
        aes(
          x     = Temp,
          y     = get(input$func_name)(Temp, RH),
          label = paste0(round(Temp, 1), "°C  |  ", round(RH, 1), "% RH")
        ),
        vjust = -0.8,
        size  = 4
      ) +
      theme_minimal(base_size = 14)
  })


  ## Mould ----

  output$mdata_Mouldplot_VTT <- renderPlot({
    mydata() |>
      ggplot() +
      geom_area(aes(Date, calcMould_VTT(Temp, RH), group = Sensor),
                fill = "violetred3", alpha = 0.9) +
      geom_hline(yintercept = 0.01, col = "darkred", linewidth = 0.8) +
      labs(x = NULL, y = "M Mould Growth Index value",
           title = "Mould growth index (M)",
           subtitle = "VTT model: calcMould_VTT") +
      ylim(0, 0.05) +
      facet_wrap(~Sensor) +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(size = 16, face = "bold", margin = margin(b = 8)),
        plot.subtitle = element_text(size = 12, colour = "grey40", margin = margin(b = 15)),
        axis.title.y = element_text(size = 14, margin = margin(r = 15)),
        axis.text = element_text(size = 12),
        strip.text = element_text(size = 14, face = "bold", hjust = 0.5),
        strip.background = element_rect(fill = "grey95", colour = NA),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(colour = "grey85", linewidth = 0.3),
        legend.position = "none",
        plot.margin = margin(20, 20, 20, 20)
      )
  })

  output$mdata_Mouldplot_Zeng <- renderPlot({
    df <- mydata() |>
      mutate(
        Mould_Zeng = calcMould_Zeng(Temp, RH),
        Mould_lim  = ifelse(Mould_Zeng > RH, 0, RH - Mould_Zeng),
        Mould_label = calcMould_Zeng(Temp, RH, label = TRUE)
      ) |>
      filter(!is.na(Mould_lim) & is.finite(Mould_lim) & !is.na(Mould_label)) |>
      mutate(Mould_label = droplevels(as.factor(Mould_label)))

    ggplot(df, aes(Date, Mould_lim, group = Sensor)) +
      geom_area(aes(fill = Mould_label), alpha = 0.85, colour = "white", size = 0.1) +
      facet_wrap(~Sensor) +
      scale_fill_brewer(type = "seq", palette = "BuPu", direction = 1,
                        name = "Mould growth\n(mm/day)") +
      labs(x = NULL, y = "Mould Predicted (RH above threshold)",
           title = "Lowest Isoline for Mould (LIM)",
           subtitle = "Zeng model: calcMould_Zeng") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(size = 16, face = "bold", margin = margin(b = 8)),
        plot.subtitle = element_text(size = 12, colour = "grey40", margin = margin(b = 15)),
        axis.title.y = element_text(size = 14, margin = margin(r = 15)),
        axis.text = element_text(size = 12),
        strip.text = element_text(size = 14, face = "bold", hjust = 0.5),
        strip.background = element_rect(fill = "grey95", colour = NA),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(colour = "grey85", linewidth = 0.3),
        legend.position = "right",
        legend.title = element_text(size = 12, face = "bold"),
        legend.text = element_text(size = 11),
        plot.margin = margin(20, 20, 20, 20)
      )
  })


  ## Download button for results ----

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
