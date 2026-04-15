# Tidy and Process Temperature and Relative Humidity data

This function tidies and processes temperature, relative humidity, and
date data from a given dataset. Dataset should minimally have "Date",
"Temp" and "RH" columns.

It filters out rows with missing dates, attempts to parse dates,
converts temperature and humidity to numeric types, and groups the data
by Site, Sensor, and Date based on the averaging interval.

If the site or sensor columns are not present in the data, the function
defaults to adding columns named "Site" and "Sensor". This can be
changed in the arguments.

When an averaging option of "hour", "day", "month" is selected, it uses
`dplyr` and `lubridate` functions to floor datetimes and calculate
averages, the default is median average. See
[`lubridate::floor_date()`](https://lubridate.tidyverse.org/reference/round_date.html)
for rounding intervals.

- Filters out rows with missing dates.

- Renames columns for consistency.

- Converts temperature and relative humidity to numeric.

- Adds default columns "Site" and "Sensor" when missing or not supplied
  in args.

- Rounds dates down to the nearest hour, day, or month as per
  `avg_time`.

- Calculates averages for temperature and relative humidity according to
  `avg_statistic`.

- Filters out implausible temperature and humidity values (outside
  -50-80°C and 0-100%RH).

## Usage

``` r
tidy_TRHdata(
  mydata,
  Site = "Site",
  Sensor = "Sensor",
  Date = "Date",
  Temp = "Temp",
  RH = "RH",
  avg_time = "none",
  avg_statistic = "median",
  avg_groups = c("Site", "Sensor"),
  ...
)
```

## Arguments

- mydata:

  A data frame containing TRH data. Ideally, this should have columns
  for "Site", "Sensor", "Date", "Temp" (temperature), and "RH" (relative
  humidity). The function requires at least the date, temperature, and
  relative humidity columns to be present. Site and sensor columns are
  optional; if missing, the function will add default columns named
  "Site" and "Sensor" respectively with values below.

- Site:

  A string specifying the name of the column in `mydata` that contains
  location information. If missing, defaults to "Site".

- Sensor:

  A string specifying the name of the column in `mydata` that contains
  sensor information. If missing, defaults to "Sensor".

- Date:

  A string specifying the name of the column in `mydata` that contains
  date information. Default is "Date". The column should ideally contain
  ISO 8601 date-time formatted strings (e.g. "2025-01-01 00:00:00"), but
  the function will try to parse a variety of common datetime formats.

- Temp:

  A string specifying the name of the column in `mydata` that contains
  temperature data. Default is "Temp".

- RH:

  A string specifying the name of the column in `mydata` that contains
  relative humidity data. Default is "RH".

- avg_time:

  Character string specifying the averaging interval. One of "none" (no
  averaging), "hour", "day", or "month", etc. See
  [`lubridate::floor_date()`](https://lubridate.tidyverse.org/reference/round_date.html)
  for rounding intervals.

- avg_statistic:

  Statistic for averaging; default is "median".

- avg_groups:

  Character vector specifying grouping columns for time-averaging. These
  are then returned as factors. Default is c("Site", "Sensor").

- ...:

  Additional arguments (currently unused).

## Value

A tidy data frame with processed TRH data. When averaging, date times
are floored, temperature and humidity are averaged, groups are factored,
and implausible values filtered.

## Examples

``` r
# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 10)

tidy_TRHdata(mydata)
#> # A tibble: 10 × 5
#>    Site   Sensor Date                 Temp    RH
#>    <chr>  <chr>  <dttm>              <dbl> <dbl>
#>  1 London Room 1 2024-01-01 00:00:00  21.8  36.8
#>  2 London Room 1 2024-01-01 00:15:00  21.8  36.7
#>  3 London Room 1 2024-01-01 00:29:59  21.8  36.6
#>  4 London Room 1 2024-01-01 00:44:59  21.7  36.6
#>  5 London Room 1 2024-01-01 00:59:59  21.7  36.5
#>  6 London Room 1 2024-01-01 01:14:59  21.7  36.2
#>  7 London Room 1 2024-01-01 01:29:59  21.7  36.3
#>  8 London Room 1 2024-01-01 01:44:59  21.7  36.4
#>  9 London Room 1 2024-01-01 01:59:59  21.7  36  
#> 10 London Room 1 2024-01-01 02:14:59  21.6  36  

tidy_TRHdata(mydata, avg_time = "hour")
#> # A tibble: 3 × 5
#>   Date                Site   Sensor  Temp    RH
#>   <dttm>              <chr>  <chr>  <dbl> <dbl>
#> 1 2024-01-01 00:00:00 London Room 1  21.8  36.6
#> 2 2024-01-01 01:00:00 London Room 1  21.7  36.2
#> 3 2024-01-01 02:00:00 London Room 1  21.6  36  

mydata |> add_humidity_calcs() |> tidy_TRHdata(avg_time = "hour")
#> # A tibble: 3 × 13
#>   Date                Site   Sensor  Temp    RH   Pws    Pw    DP    AH    AD
#>   <dttm>              <chr>  <chr>  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 2024-01-01 00:00:00 London Room 1  21.8  36.6  26.1  9.56  6.30  7.01  1.19
#> 2 2024-01-01 01:00:00 London Room 1  21.7  36.2  26.0  9.41  6.08  6.91  1.19
#> 3 2024-01-01 02:00:00 London Room 1  21.6  36    25.8  9.29  5.89  6.82  1.19
#> # ℹ 3 more variables: MR <dbl>, SH <dbl>, Enthalpy <dbl>

# \donttest{
# Example usage: TRH_data <- tidy_TRHdata("path/to/your/TRHdata.csv")
# }

```
