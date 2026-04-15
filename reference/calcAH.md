# Calculate Absolute Humidity

Function to calculate the absolute humidity (g/m³) from temperature (°C)
and relative humidity (%). Supports multiple methods: the Buck equation
(default), Buck formula with enhancement factor, and others.

## Usage

``` r
calcAH(
  Temp,
  RH,
  P_atm = 1013.25,
  method = c("Buck_EF", "Buck", "IAPWS", "Magnus", "VAISALA")
)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- P_atm:

  Atmospheric pressure = 1013.25 (hPa)

- method:

  Character. Calculation method: - "Buck": uses `calcPws` Buck equation
  (default) - "Buck_EF": Buck formula with enhancement factor - "IAPWS",
  "Magnus", "VAISALA": use `calcPws` methods for saturation vapor
  pressure

## Value

AH Absolute Humidity (g/m³)

## Examples

``` r
# Absolute humidity at 20°C (Temp) and 50% relative humidity (RH)
calcAH(20, 50)
#> [1] 8.630534
calcAH(20, 50, method = "Buck_EF") # Buck formula with enhancement factor (default)
#> [1] 8.630534
calcAH(20, 50, method = "Buck") # Buck method via calcPws
#> [1] 8.642036
calcAH(20, 50, method = "IAPWS") # IAPWS
#> [1] 8.645191

# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(Abs = calcAH(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH   Abs
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  7.05
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  7.03
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  7.01
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  6.97
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  6.95
```
