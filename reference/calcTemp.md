# Calculate Temperature from relative humidity and dew point

This function calculates the temperature (°C) from relative humidity (%)
and dew point temperature (°C).

## Usage

``` r
calcTemp(RH, DewP, method = c("Magnus", "Buck"))
```

## Arguments

- RH:

  Relative Humidity (0-100%)

- DewP:

  Td (DP), Dew Point (°Celsius)

- method:

  Calculation method: either `"Magnus"` or `"Buck"`. Defaults to
  `"Magnus"`.

## Value

Temp, Temperature (°Celsius)

## Details

This function supports two methods for temperature calculation:

- `"Magnus"` (default): Uses the August-Roche-Magnus approximation,
  valid for 0°C \< Temp \< 60°C and 1% \< RH \< 100%.

- `"Buck"`: Uses the Arden Buck equation with Bögel modification, valid
  for -30°C \< Temp \< 60°C and 1% \< RH \< 100%.

The methods calculate temperature based on vapor pressure and saturation
vapour pressure relationships. The Magnus method is chosen as the
default because it is more stable when used with the
[`calcDP`](https://bhavshah01.github.io/ConSciR/reference/calcDP.md) and
[`calcRH_DP`](https://bhavshah01.github.io/ConSciR/reference/calcRH_DP.md)
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

`calcTemp` for calculating temperature

[`calcDP`](https://bhavshah01.github.io/ConSciR/reference/calcDP.md) for
calculating dew point

[`calcRH_DP`](https://bhavshah01.github.io/ConSciR/reference/calcRH_DP.md)
for calculating relative humidity from dew point

[`calcRH_AH`](https://bhavshah01.github.io/ConSciR/reference/calcRH_AH.md)
for calculating relative humidity from absolute humidity

## Examples

``` r
# Calculate temperature (Temp) at 50% relative humidity (RH) and dew point 15°C (DewP)
# Using Magnus method
calcTemp(50, 15)
#> [1] 26.24387

# Using Buck method
calcTemp(50, 15, method = "Buck")
#> [1] 26.29922

calcTemp(50, calcDP(20, 50))
#> [1] 20


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |>
  dplyr::mutate(
    DewPoint = calcDP(Temp, RH),
    Temp_default = calcTemp(RH, DewPoint),
    Temp_Buck = calcTemp(RH, DewPoint))
#> # A tibble: 5 × 8
#>   Site   Sensor Date                 Temp    RH DewPoint Temp_default Temp_Buck
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>    <dbl>        <dbl>     <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8     6.38         21.8      21.8
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7     6.34         21.8      21.8
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6     6.30         21.8      21.8
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6     6.22         21.7      21.7
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5     6.18         21.7      21.7

```
