# Convert temperature (F) to temperature (C)

Convert temperature in Fahrenheit to temperature in Celsius

## Usage

``` r
calcFtoC(TempF)
```

## Arguments

- TempF:

  Temperature (Fahrenheit )

## Value

TempC Temperature (Celsius)

## Examples

``` r
# Fahrenheit to Celsius
calcFtoC(32)
#> [1] 0
calcFtoC(68)
#> [1] 20

# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(TempC = calcFtoC((Temp * 9/5) + 32))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH TempC
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  21.8
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  21.8
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  21.8
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  21.7
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  21.7

```
