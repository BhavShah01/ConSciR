# Calculate Frost Point

Function to calculate frost point (°C) from temperature (°C) and
relative humidity (%).

## Usage

``` r
calcFP(Temp, RH)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

## Value

Tf, Frost Point (°Celsius)

## Details

Formula coefficients from Arden Buck equation (1981, 1996) saturation
vapor pressure over ice.

- a = 6.1115

- b = 23.036

- c = 279.82

- d = 333.7

## Note

This function is unstable and is under development.

## Examples

``` r
# calcFP is unstable and is under development
# Frost point at 20°C (Temp) and 50% relative humidity (RH)
calcFP(20, 50)
#> [1] 10.58328
calcFP(0, 50)
#> [1] -8.173764


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(FrostPoint = calcFP(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH FrostPoint
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>      <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8       8.26
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7       8.23
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6       8.19
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6       8.10
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5       8.06

```
