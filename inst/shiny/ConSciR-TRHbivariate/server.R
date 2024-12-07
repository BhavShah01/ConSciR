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

  output$gg_Bivariate <- renderPlot({
    mydata() |>
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


      geom_point(aes(Temp, RH, col = Sensor), alpha = 0.5) +

      lims(x = c(input$select_temp_limits[1], input$select_temp_limits[2]),
           y = c(input$select_rh_limits[1], input$select_rh_limits[2])) +

      labs(x = "Temperature", y = "Humidity", caption = limit_description()) +

      theme_bw()
  })


  output$DTsummary_table <- renderTable({

    mydata() |>
      ungroup() |>
      group_by(Sensor) |>
      summarise(
        TMin = min(Temp, na.rm = TRUE) |> round(2),
        TAvg = mean(Temp, na.rm = TRUE) |> round(2),
        TMax = max(Temp, na.rm = TRUE) |> round(2),
        TSpec = mean(Temp >= input$select_temp_box[1] &
                       Temp <= input$select_temp_box[2], na.rm = TRUE) |> percent(trim = TRUE),
        RHMin = min(RH, na.rm = TRUE) |> round(2),
        RHAvg = mean(RH, na.rm = TRUE) |> round(2),
        RHMax = max(RH, na.rm = TRUE) |> round(2),
        RHspec = mean(RH >= input$select_rh_box[1] &
                        RH <= input$select_rh_box[2], na.rm = TRUE) |> percent(trim = TRUE)
      )

  })


}

