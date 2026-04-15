# Tidy Hanwell EMS Data

This function tidies Hanwell Environmental Monitoring System (EMS) data
from either Excel sheets or CSV files.

\- Default mode (MinMax = FALSE): Reads raw date, temperature, and
humidity data. - Min-Max mode (MinMax = TRUE): Under development to read
min-max average data (CSV only).

## Usage

``` r
tidy_Hanwell(
  EMS_datapath,
  Site = "Site",
  MinMax = FALSE,
  sheet = "Hanwell",
  ...
)
```

## Arguments

- EMS_datapath:

  Character string specifying the file path to the Hanwell EMS data
  file.

- Site:

  Character string specifying site name to add as a column. Default is
  "Site".

- MinMax:

  Logical flag; if TRUE, reads Min-Max format, otherwise reads raw data.
  Default is FALSE.

- sheet:

  Optional, Excel sheet name for reading Excel files. The default is
  "Hanwell"

- ...:

  Additional arguments passed to
  [`readxl::read_excel`](https://readxl.tidyverse.org/reference/read_excel.html)
  for Excel reading.

## Value

A tibble containing tidied Hanwell EMS data, with columns including:

- Site:

  Character, site name as specified by `Site` argument.

- Sensor:

  Character, sensor identifier extracted from the file or metadata.

- Date:

  POSIXct datetime of the measurement.

- Temp:

  Numeric temperature measurement in °C (average for MinMax).

- RH:

  Numeric relative humidity measurement in % (average for MinMax).

- TempMin, TempMax, RHMin, RHMax:

  (Only for MinMax reports) Numeric min/max values of Temp and RH.

## Examples

``` r
# \donttest{
# Example usage: hanwell_data <- tidy_Hanwell("path/to/your/hanwell_data.csv")
# }

# mydata file
filepath <- data_file_path("mydata.xlsx")

tidy_Hanwell(filepath, sheet = "Hanwell", Site = "London") |> head()
#> Warning: Expecting logical in D7090 / R7090C4: got 'Maximum'
#> Warning: Expecting logical in E7090 / R7090C5: got 'Standard Deviation'
#> New names:
#> • `` -> `...1`
#> • `` -> `...2`
#> • `` -> `...3`
#> • `` -> `...4`
#> • `` -> `...5`
#> # A tibble: 6 × 5
#>   Site   Sensor   Date                 Temp    RH
#>   <chr>  <chr>    <dttm>              <dbl> <dbl>
#> 1 London External 2025-08-12 00:06:03  22.8  60.2
#> 2 London External 2025-08-12 00:11:00  22.6  60.2
#> 3 London External 2025-08-12 00:16:04  22.6  61.6
#> 4 London External 2025-08-12 00:21:05  22.6  62.4
#> 5 London External 2025-08-12 00:26:03  22.6  62.8
#> 6 London External 2025-08-12 00:31:07  22.4  63.5

```
