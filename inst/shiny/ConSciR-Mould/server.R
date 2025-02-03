# inst/shiny/ConSciR-Mould/app.R
library(shiny)
library(readxl)
library(tools)
library(tidyverse)

options(shiny.maxRequestSize = 100 * 1024^2)



# Main server function
server <- function(input, output, session) {

  uploaded_data <- shiny_dataUploadServer("dataupload")

  mydata <- reactive({
    if (is.null(uploaded_data())) {
      mydata
    } else {
      uploaded_data()
    }
  })



  mdata <- reactive({
    mydata() |>
      mutate(
        Mould_Zeng = calcMould_Zeng(Temp, RH),
        Mould_lim = ifelse(Mould_Zeng > RH, 0, RH - Mould_Zeng),
        Mould_label = calcMould_Zeng(Temp, RH, label = TRUE),
        Mould_VTT = calcMould_VTT(Temp, RH),
        DewPoint = calcDP(Temp, RH),
        AbsHum = calcAH(Temp, RH),
      )
  })


  output$mdata_TRHplot <- renderPlot({
    p = mdata() |>
      ggplot() +
      geom_line(aes(Date, Temp, group = Sensor), col = "red", alpha = 0.9) +
      geom_line(aes(Date, RH, group = Sensor), col = "blue", alpha = 0.9) +
      geom_line(aes(Date, DewPoint, group = Sensor), col = "darkgreen", alpha = 0.9) +
      labs(x = NULL, y = "Temperature, Humidity and Dew Point") +
      lims(y = c(0, 100)) +
      hrbrthemes::theme_ipsum(
        base_size = 14, axis_title_size = 14,
        strip_text_size = 14, axis_title_just = "mc") +
      facet_wrap(~Sensor)

    return(p)
  })

  output$mdata_Mouldplot_VTT <- renderPlot({
    p = mdata() |>
      ggplot() +
      geom_area(aes(Date, Mould_VTT, group = Sensor), fill = "darkorange", alpha = 0.9) +
      geom_hline(yintercept = 0.01, col = "darkred") +
      labs(x = NULL, y = "M Mould Growth Index value", title = "VTT model") +
      hrbrthemes::theme_ipsum(
        base_size = 14, axis_title_size = 14,
        strip_text_size = 14, axis_title_just = "mc") +
      facet_wrap(~Sensor)

    return(p)
  })

  output$mdata_Mouldplot_Zeng <- renderPlot({
    p = mdata() |>
      ggplot() +
      # geom_area(aes(Date, Mould_Zeng, group = Sensor, fill = Mould_label), alpha = 0.9) +
      geom_area(aes(Date, Mould_lim, group = Sensor), fill = "violet", alpha = 0.9) +
      labs(x = NULL, y = "Mould Predicted (RH)", title = "Zeng model") +
      hrbrthemes::theme_ipsum(
        base_size = 14, axis_title_size = 14,
        strip_text_size = 14, axis_title_just = "mc") +
      facet_wrap(~Sensor)

    return(p)
  })


  output$mdata_Mouldplot_limit <- renderPlot({
    p = mdata() |>
      ggplot() +
      geom_area(aes(Date, Mould_label, group = Sensor), fill = "purple", alpha = 0.9) +
      labs(x = NULL, y = "Mould Growth Rate (mm/day)", title = "Zeng model") +
      hrbrthemes::theme_ipsum(
        base_size = 14, axis_title_size = 14,
        strip_text_size = 14, axis_title_just = "mc") +
      facet_wrap(~Sensor)

    return(p)
  })


  # Download button for results
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("mould-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      req(mdata())  # Ensure there is tidied data to download
      write.csv(mdata(), file, row.names = FALSE)
    }
  )


}
