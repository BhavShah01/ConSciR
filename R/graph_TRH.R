#' Function for graphing temperature and humidity data
#'
#' @description
#' Use this tool to produce a simple temperature and humidity plot
#'
#'
#' @param mydata A data frame containing the date, temperature, and relative humidity data.
#' @param Date The name of the column in mydata containing date information.
#' @param Temp  The name of the column in mydata containing temperature data.
#' @param RH The name of the column in mydata containing relative humidity data.
#'
#' @return A ggplot graph of temperature and relative humidity.
#' @export
#'
#' @importFrom rlang .data check_installed
#' @importFrom ggplot2 ggplot aes geom_line labs lims scale_y_continuous sec_axis theme_bw theme element_text
#'
#' @examples
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 1000)
#'
#' graph_TRH(mydata)
#'
#'
#'
graph_TRH <- function(mydata, Date = "Date", Temp = "Temp", RH = "RH") {
  rlang::check_installed("ggplot2", reason = "to produce graphs")

  mydata |>
    ggplot2::ggplot(ggplot2::aes(x = .data[[Date]], y = .data[[Temp]])) +
    ggplot2::geom_line(col = "red", alpha = 0.9) +
    ggplot2::labs(x = "", y = "Temperature") +
    ggplot2::geom_line(ggplot2::aes(y = .data[[RH]]), col = "blue", alpha = 0.9) +
    ggplot2::lims(y = c(0, 100)) +
    ggplot2::scale_y_continuous(
      sec.axis = ggplot2::sec_axis(~., name = "Humidity"),
      limits = c(0, 100), n.breaks = 10
    ) +
    ggplot2::theme(
      axis.title.y = ggplot2::element_text(color = "red"),
      axis.title.y.right = ggplot2::element_text(color = "blue", angle = -90)
    )
}
