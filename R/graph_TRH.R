#' Graph temperature and humidity data
#'
#' @description
#' Use this tool to produce a simple temperature and humidity plot with optional
#' background bands showing target temperature and relative humidity ranges.
#' Optionally, add a function to graph, e.g. `calcDP`, `calcAH`, etc.
#'
#' @param mydata A data frame containing date (Date), temperature (Temp), and relative humidity (RH) columns.
#' @param Date The name of the column in mydata containing date information ("Date").
#' @param Temp  The name of the column in mydata containing temperature data ("Temp").
#' @param RH The name of the column in mydata containing relative humidity data ("RH").
#' @param facet_by Name of categorical column to facet by; defaults to "Sensor".
#' @param LowT Numeric lower bound of temperature range (default 16).
#' @param HighT Numeric upper bound of temperature range (default 25).
#' @param LowRH Numeric lower bound of relative humidity range (default 40).
#' @param HighRH Numeric upper bound of relative humidity range (default 60).
#' @param y_func Character string specifying a function to apply to temperature
#' and humidity columns (e.g. "calcAH"). Default is "none".
#' @param ... Additional arguments passed to y_func.
#'
#' @return A ggplot graph of temperature and relative humidity with optional background bands.
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_ribbon labs lims scale_y_continuous sec_axis theme_bw theme element_text
#' @importFrom stats as.formula
#' @export
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 1000)
#'
#' # Basic use with background ranges
#' graph_TRH(mydata)
#'
#' # Add dew point and customise
#' graph_TRH(mydata, y_func = "calcDP", LowT = 6, HighT = 28)
#'
graph_TRH <- function(mydata,
                      Date = "Date",
                      Temp = "Temp", RH = "RH",
                      facet_by = "Sensor",
                      LowT = 16, HighT = 25,
                      LowRH = 40, HighRH = 60,
                      y_func = "none",
                      ...) {
  # Copy original temperature and RH for plotting
  plot_data <- mydata

  # If a y_func other than "none" is selected, apply it to Temp and RH
  if (!is.null(y_func) && y_func != "none") {
    # Convert string to actual function
    y_func_fun <- match.fun(y_func)

    # Calculate new y variable e.g. "additional_func_val"
    plot_data$y_func_val <- y_func_fun(plot_data[[Temp]], plot_data[[RH]], ...)
  }

  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .data[[Date]], y = .data[[Temp]])) +
    # Add band for temperature and humidity range
    ggplot2::geom_ribbon(aes(x = .data[[Date]], ymin = LowT, ymax = HighT),
                         fill = "darkred", alpha = 0.1) +
    ggplot2::geom_ribbon(aes(x = .data[[Date]], ymin = LowRH, ymax = HighRH),
                         fill = "darkblue", alpha = 0.1) +
    ggplot2::geom_line(col = "red", alpha = 0.9) +
    ggplot2::geom_line(ggplot2::aes(y = .data[[RH]]), col = "blue", alpha = 0.9) +
    ggplot2::labs(x = NULL, y = "Temperature") +
    ggplot2::lims(y = c(0, 100)) +
    ggplot2::scale_y_continuous(
      sec.axis = ggplot2::sec_axis(~ ., name = "Humidity"),
      limits = c(0, 100), n.breaks = 10
    )

  # If y_func chosen, add the relevant graph layer or annotation as needed
  if (!is.null(y_func) && y_func != "none") {
    # Example: add as points or line on secondary axis or extra geom if desired
    p <- p +
      ggplot2::geom_line(aes(y = y_func_val), col = "cyan4", alpha = 0.7)
    # Or other aesthetic mapping as needed
  }

  # Facet by factor if present
  if (!is.null(facet_by) && facet_by %in% names(plot_data)) {
    p <- p + ggplot2::facet_wrap(as.formula(paste("~", facet_by)))
  }

  return(p)
}
