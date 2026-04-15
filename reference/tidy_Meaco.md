# Tidy Meaco sensor data

This function takes raw Meaco sensor data and returns data with renamed
columns.

## Usage

``` r
tidy_Meaco(
  mydata,
  Site_col = "RECEIVER",
  Sensor_col = "TRANSMITTER",
  Date_col = "DATE",
  Temp_col = "TEMPERATURE",
  RH_col = "HUMIDITY"
)
```

## Arguments

- mydata:

  A data frame containing raw Meaco sensor data with columns RECEIVER,
  TRANSMITTER, DATE, TEMPERATURE, and HUMIDITY

- Site_col:

  A string specifying the name of the column in \`mydata\` that contains
  location information. Default is "RECEIVER".

- Sensor_col:

  A string specifying the name of the column in \`mydata\` that contains
  sensor information. Default is "TRANSMITTER".

- Date_col:

  A string specifying the name of the column in \`mydata\` that contains
  date information. Default is "DATE".

- Temp_col:

  A string specifying the name of the column in \`mydata\` that contains
  temperature data. Default is "TEMPERATURE".

- RH_col:

  A string specifying the name of the column in \`mydata\` that contains
  relative humidity data. Default is "HUMIDITY".

## Value

A tidied data frame with columns Site, Sensor, Date, Temp, and RH

## Examples

``` r
# \donttest{
# Example usage: meaco_data <- tidy_Meaco("path/to/your/meaco_data.csv")
# }

# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "Meaco")

head(mydata)
#> # A tibble: 6 × 5
#>   RECEIVER TRANSMITTER DATE                TEMPERATURE HUMIDITY
#>   <chr>    <chr>       <dttm>                    <dbl>    <dbl>
#> 1 York     Store       2024-01-01 00:03:00        18.2     54.6
#> 2 York     Store       2024-01-01 00:13:00        18.2     54.8
#> 3 York     Store       2024-01-01 00:24:00        18.1     54.8
#> 4 York     Store       2024-01-01 00:34:00        18.2     54.2
#> 5 York     Store       2024-01-01 00:45:00        18.1     53.9
#> 6 York     Store       2024-01-01 00:56:00        18.1     54.3

mydata |> tidy_Meaco()
#> # A tibble: 10 × 5
#>    Site  Sensor Date                 Temp    RH
#>    <chr> <chr>  <dttm>              <dbl> <dbl>
#>  1 York  Store  2024-01-01 00:03:00  18.2  54.6
#>  2 York  Store  2024-01-01 00:13:00  18.2  54.8
#>  3 York  Store  2024-01-01 00:24:00  18.1  54.8
#>  4 York  Store  2024-01-01 00:34:00  18.2  54.2
#>  5 York  Store  2024-01-01 00:45:00  18.1  53.9
#>  6 York  Store  2024-01-01 00:56:00  18.1  54.3
#>  7 York  Store  2024-01-01 01:06:00  18.1  54.2
#>  8 York  Store  2024-01-01 01:17:00  18.1  54.5
#>  9 York  Store  2024-01-01 01:27:00  18.1  54.4
#> 10 York  Store  2024-01-01 01:38:00  18.0  54.2

mydata |> tidy_Meaco() |> tidy_TRHdata(avg_time = "hour")
#> # A tibble: 2 × 5
#>   Date                Site  Sensor  Temp    RH
#>   <dttm>              <chr> <chr>  <dbl> <dbl>
#> 1 2024-01-01 00:00:00 York  Store   18.1  54.5
#> 2 2024-01-01 01:00:00 York  Store   18.1  54.3


```
