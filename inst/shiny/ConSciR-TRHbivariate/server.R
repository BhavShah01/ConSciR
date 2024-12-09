# inst/shiny/ConSciR-TRHbivriate/app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(ConSciR)

options(shiny.maxRequestSize = 100 * 1024^2)


server <- function(input, output) {

  uploaded_data <- shiny_dataUploadServer("dataupload")

  mydata <- reactive({
    if (is.null(uploaded_data())) {
      mydata
    } else {
      uploaded_data()
    }
  })

  output$select_temp_box <- renderUI({
    sliderInput("select_temp_box", "Temperature box",
                min = 0, max = 40, value = c(16, 25))
  })

  output$select_rh_box <- renderUI({
    sliderInput("select_rh_box", "Humidity box",
                min = 0, max = 100, value = c(40, 60))
  })

  output$select_temp_limits <- renderUI({
    sliderInput("select_temp_limits", "Temperature x-axis",
                min = -50, max = 50, value = c(0, 40))
  })

  output$select_rh_limits <- renderUI({
    sliderInput("select_rh_limits", "Humidity y-axis",
                min = 0, max = 100, value = c(0, 100))
  })

  limit_description = reactive({
    paste0("Box: ", input$select_temp_box[1], "-", input$select_temp_box[2], "C and ",
           input$select_rh_limits[1], "-", input$select_rh_limits[2], "%RH")
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
    "Lifetime Multiplier" = "calcLM",
    "Equilibrium Moisture Content (wood)" = "calcEMC_wood"
  )

  output$select_z_func <- renderUI({
    selectInput("select_z_func", "Function",
                selected = func_list_text[1],
                choices = func_list_text)
  })

  output$select_alpha <- renderUI({
    numericInput("select_alpha", "Transparency",
                 min = 0, max = 1, value = 1, step = 0.1)
  })



  output$gg_Bivariate <- renderPlot({

    selected_func <- input$select_z_func

    # Calculate the new variable based on the selected function
    mydata_transformed <-
      mydata() |>
      mutate(
        ColorValue = case_when(
          selected_func == "calcMR" ~ calcMR(Temp, RH),
          selected_func == "calcHR" ~ calcHR(Temp, RH),
          selected_func == "calcAH" ~ calcAH(Temp, RH),
          selected_func == "calcSH" ~ calcSH(Temp, RH),
          selected_func == "calcAD" ~ calcAD(Temp, RH),
          selected_func == "calcDP" ~ calcDP(Temp, RH),
          selected_func == "calcEnthalpy" ~ calcEnthalpy(Temp, RH),
          selected_func == "calcPws" ~ calcPws(Temp, RH),
          selected_func == "calcPw" ~ calcPw(Temp, RH),
          selected_func == "calcPI" ~ calcPI(Temp, RH),
          selected_func == "calcLM" ~ calcLM(Temp, RH),
          selected_func == "calcEMC_wood" ~ calcEMC_wood(Temp, RH),
          TRUE ~ NA_real_
        )
      )


    mydata_transformed |>

      ggplot() +

      annotate("segment",
               x = input$select_temp_box[1], xend = input$select_temp_box[1],
               y = input$select_rh_box[1], yend = input$select_rh_box[2],
               alpha = 0.5, col = "blue", size = 1) +

      annotate("segment",
               x = input$select_temp_box[2], xend = input$select_temp_box[2],
               y = input$select_rh_box[1], yend = input$select_rh_box[2],
               alpha = 0.5, col = "blue", size = 1) +

      annotate("segment",
               x = input$select_temp_box[1], xend = input$select_temp_box[2],
               y = input$select_rh_box[1], yend = input$select_rh_box[1],
               alpha = 0.5, col = "red", size = 1) +

      annotate("segment",
               x = input$select_temp_box[1], xend = input$select_temp_box[2],
               y = input$select_rh_box[2], yend = input$select_rh_box[2],
               alpha = 0.5, col = "red", size = 1) +


      geom_point(aes(Temp, RH, col = ColorValue), alpha = input$select_alpha) +

      lims(x = c(input$select_temp_limits[1], input$select_temp_limits[2]),
           y = c(input$select_rh_limits[1], input$select_rh_limits[2])) +

      labs(x = "Temperature", y = "Humidity", col = "value",
           caption = limit_description()) +

      theme_bw() +

      scale_colour_viridis_c() +

      theme(legend.key.size = unit(1, 'cm'), # legend size
            legend.key.height = unit(2, 'cm'), # legend height
            legend.key.width = unit(1, 'cm'), # legend  width
            legend.title = element_text(size=14), # legend title font size
            legend.text = element_text(size=10)) # legend text font size
  })


  output$DTsummary_table <- renderTable({

    mydata() |>
      ungroup() |>
      group_by(Sensor) |>
      summarise(
        TMin = min(Temp, na.rm = TRUE) |> round(2),
        TAvg = mean(Temp, na.rm = TRUE) |> round(2),
        TMax = max(Temp, na.rm = TRUE) |> round(2),
        TSpec =
          mean(Temp >= input$select_temp_box[1] &
                 Temp <= input$select_temp_box[2], na.rm = TRUE) |>
          percent(trim = TRUE),
        RHMin = min(RH, na.rm = TRUE) |> round(2),
        RHAvg = mean(RH, na.rm = TRUE) |> round(2),
        RHMax = max(RH, na.rm = TRUE) |> round(2),
        RHspec =
          mean(RH >= input$select_rh_box[1] &
                 RH <= input$select_rh_box[2], na.rm = TRUE) |>
          percent(trim = TRUE)
      )
  })

}

