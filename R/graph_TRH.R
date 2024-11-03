#' Function for graphing temperature and humidity data
#'
#' @description
#' Use this tool to produce a simple temperature and humidity plot
#'
#'
#' @param mydata Dataframe with Date, Temp and RH columns
#'
#' @return Graph of temperature and humidity data
#' @export
#'
#' @import ggplot2
#'
#' @examples
#' graph_TRH(mydata)
#'
graph_TRH <- function(data, x_var, y_var, y2_var) {
  rlang::check_installed("ggplot", reason = "to produce graphs")

    ggplot(data, aes(x = .data[[x_var]], y = .data[[y_var]])) +
    geom_line(col = "red", alpha = 0.9) +
    labs(x = "", y = "Temperature") +
    geom_line(aes(.data[[x_var]], .data[[y2_var]]),
              col = "blue", alpha = 0.9) +
    lims(y = c(0, 100)) +
    scale_y_continuous(
      sec.axis = sec_axis(~., name = "Humidity"),
      limits = c(0,100), n.breaks = 10) +
    theme_bw() +
    theme(
      axis.title.y = element_text(color = "red"),
      axis.title.y.right = element_text(color = "blue", angle = -90)
    )
}
