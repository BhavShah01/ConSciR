# Shiny Module Server for Data Upload and Processing

This function creates a Shiny module server for uploading CSV or Excel
files, processing the data, optional time averaging as specified by the
user, and returning a tidied dataset.

## Usage

``` r
shiny_dataUploadServer(id)
```

## Arguments

- id:

  A character string that corresponds to the ID used in the UI function
  for this module.

## Value

The returned reactive expression is a tidied data frame containing
columns including Site and Sensor identifiers, a Date column rounded
down (floored) to the user-selected averaging interval, median or chosen
average temperature and relative humidity for each group, and any other
numeric variables that were averaged if present in the input data.

## Examples

``` r
if(interactive()) {
  ui <- fluidPage(
    shiny_dataUploadUI("dataUpload")
  )
  server <- function(input, output, session) {
    data <- shiny_dataUploadServer("dataUpload")
  }
}

```
