# Calculate Relative Humidity from temperature and dew point

Function to calculate relative humidity (%) from temperature (°C) and
dew point (°C)

## Usage

``` r
calcRH_DP(Temp, DewP, method = c("Magnus", "Buck"))
```

## Arguments

- Temp:

  Temperature (°Celsius)

- DewP:

  Td (DP), Dew Point (°Celsius)

- method:

  Calculation method: either `"Magnus"` or `"Buck"`. Defaults to
  `"Magnus"`.

## Value

Relative Humidity (0-100%)

## Details

This function supports two methods for relative humidity calculation:

- `"Magnus"` (default): Uses the August-Roche-Magnus approximation,
  valid for 0°C \< Temp \< 60°C and 1% \< RH \< 100%.

- `"Buck"`: Uses the Arden Buck equation with Bögel modification, valid
  for -30°C \< Temp \< 60°C and 1% \< RH \< 100%.

The methods calculate temperature based on vapor pressure and saturation
vapour pressure relationships. The Magnus method is chosen as the
default because it is more stable when used with the
[`calcDP`](https://bhavshah01.github.io/ConSciR/reference/calcDP.md) and
[`calcTemp`](https://bhavshah01.github.io/ConSciR/reference/calcTemp.md)
functions.

## References

Alduchov, O. A., and R. E. Eskridge, 1996: Improved Magnus' form
approximation of saturation vapor pressure. J. Appl. Meteor., 35,
601–609

Buck, A. L., 1981: New Equations for Computing Vapor Pressure and
Enhancement Factor. J. Appl. Meteor. Climatol., 20, 1527–1532,
https://doi.org/10.1175/1520-0450(1981)020\<1527:NEFCVP\>2.0.CO;2.

Buck (1996), Buck (1996), Buck Research CR-1A User's Manual, Appendix 1.

https://bmcnoldy.earth.miami.edu/Humidity.html

## See also

[`calcTemp`](https://bhavshah01.github.io/ConSciR/reference/calcTemp.md)
for calculating temperature

[`calcDP`](https://bhavshah01.github.io/ConSciR/reference/calcDP.md) for
calculating dew point

[`calcRH_AH`](https://bhavshah01.github.io/ConSciR/reference/calcRH_AH.md)
for calculating relative humidity from absolute humidity

`calcRH_DP` for calculating relative humidity from dew point

## Examples

``` r
# Relative humidity (RH) at tempertaure of 20°C (Temp) and dew point of 15°C (DewP)
calcRH_DP(20, 15)
#> [1] 72.93877
calcRH_DP(20, 15, method = "Buck")
#> [1] 73.17992

calcRH_DP(20, calcDP(20, 50))
#> [1] 50

calcRH_DP(20, calcDP(20, 50, method = "Buck"), method = "Buck")
#> [1] 50

# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |>
  dplyr::mutate(
    DewPoint = calcDP(Temp, RH),
    RH_default = calcRH_DP(Temp, DewPoint),
    RH_Buck = calcRH_DP(Temp, DewPoint, method = "Buck"))
#> # A tibble: 5 × 8
#>   Site   Sensor Date                 Temp    RH DewPoint RH_default RH_Buck
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>    <dbl>      <dbl>   <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8     6.38       36.8    36.8
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7     6.34       36.7    36.7
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6     6.30       36.6    36.6
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6     6.22       36.6    36.6
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5     6.18       36.5    36.5


```
