# Calculate Dew Point

Function to calculate dew point (°C) from temperature (°C) and relative
humidity (%).

The dew point is the temperature at which air becomes saturated with
moisture and water vapour begins to condense.

## Usage

``` r
calcDP(Temp, RH, method = c("Magnus", "Buck"))
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- method:

  Character; formula to use, either `"Magnus"` or `"Buck"`. Defaults to
  `"Magnus"`.

## Value

Td (DP), Dew Point (°Celsius)

## Details

This function supports two methods for dew point calculation:

- `"Magnus"` (default): Uses the August-Roche-Magnus approximation,
  valid for 0°C \< Temp \< 60°C and 1% \< RH \< 100%.

- `"Buck"`: Uses the Arden Buck equation with Bögel modification, valid
  for -30°C \< Temp \< 60°C and 1% \< RH \< 100%.

Both methods compute saturation vapour pressure and convert relative
humidity to dew point temperature. The Magnus method is chosen as the
default because it is more stable when used with the
[`calcTemp`](https://bhavshah01.github.io/ConSciR/reference/calcTemp.md)
and
[`calcRH_DP`](https://bhavshah01.github.io/ConSciR/reference/calcRH_DP.md)
functions.

## Note

More details of the equations are also available in the source R code.

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

[`calcRH_DP`](https://bhavshah01.github.io/ConSciR/reference/calcRH_DP.md)
for calculating relative humidity from dew point

`calcDP` for calculating dew point

[`calcRH_AH`](https://bhavshah01.github.io/ConSciR/reference/calcRH_AH.md)
for calculating relative humidity from absolute humidity

## Examples

``` r
# Dew point at 20°C and 50% relative humidity (RH)
# Default Magnus method
calcDP(20, 50)
#> [1] 9.261107

# Using Buck method
calcDP(20, 50, method = "Buck")
#> [1] 9.250632

# Validation check
calcDP(20, calcRH_DP(20, calcDP(20, 50)))
#> [1] 9.261107
calcDP(20, calcRH_DP(20, calcDP(20, 50, method = "Buck"), method = "Buck"), method = "Buck")
#> [1] 9.250632


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |>
  dplyr::mutate(
    DewPoint = calcDP(Temp, RH),
    DewPoint_Buck = calcDP(Temp, RH, method = "Buck"))
#> # A tibble: 5 × 7
#>   Site   Sensor Date                 Temp    RH DewPoint DewPoint_Buck
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>    <dbl>         <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8     6.38          6.39
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7     6.34          6.35
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6     6.30          6.31
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6     6.22          6.22
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5     6.18          6.18

```
