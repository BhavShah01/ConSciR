#' Return the file path to data files
#'
#' @description
#' Access mydata.xlsx and other files in inst/extdata folder
#'
#'
#' @param path Name of file in quotes with extension, e.g. "mydata.xlsx"
#'
#' @returns String of the path to the specified file
#' @export
#'
#'
#' @examples
#' data_file_path()
#'
#' data_file_path("mydata.xlsx")
#'
data_file_path <- function(path = NULL) {
  if (is.null(path)) {
    dir(system.file("extdata", package = "ConSciR"))
  } else {
    system.file("extdata", path, package = "ConSciR", mustWork = TRUE)
  }
}
