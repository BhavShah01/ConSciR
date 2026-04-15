# Calculate Enthalpy

Function to calculate enthalpy from temperature (°C) and relative
humidity (%).

Enthalpy is the total heat content of air, combining sensible (related
to temperature) and latent heat (related to moisture content), used in
HVAC calculations. Enthalpy is the amount of energy required to bring a
gas to its current state from a dry gas at 0°C.

## Usage

``` r
calcEnthalpy(Temp, RH, ...)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- ...:

  Additional arguments to supply to
  [`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)
  and
  [`calcMR`](https://bhavshah01.github.io/ConSciR/reference/calcMR.md)

## Value

h Enthalpy (kJ/kg)

## Examples

``` r
# Enthalpy at at 20°C (Temp) and 50% relative humidity (RH)
calcEnthalpy(20, 50)
#> [1] 38.62649


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(Enthalpy = calcEnthalpy(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH Enthalpy
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>    <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8     37.2
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7     37.1
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6     37.1
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6     36.9
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5     36.8

```
