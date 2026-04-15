# Calculate Specific Humidity

Function to calculate the specific humidity (g/kg) from temperature (°C)
and relative humidity (%).

Specific humidity is the ratio of the mass of water vapor to the mass of
air.

Function uses
[`calcMR`](https://bhavshah01.github.io/ConSciR/reference/calcMR.md)

## Usage

``` r
calcSH(Temp, RH, P_atm = 1013.25, B = 621.9907, ...)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- P_atm:

  Atmospheric pressure = 1013.25 (hPa)

- B:

  B = 621.9907 g/kg for air

- ...:

  Additional arguments to supply to
  [`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)
  and
  [`calcMR`](https://bhavshah01.github.io/ConSciR/reference/calcMR.md)

## Value

SH Specific Humidity (g/kg)

## Note

This function requires the
[`calcMR`](https://bhavshah01.github.io/ConSciR/reference/calcMR.md)
function to be available in the environment.

## References

Wallace, J.M. and Hobbs, P.V. (2006). Atmospheric Science: An
Introductory Survey. Academic Press, 2nd edition.

## See also

[`calcAD`](https://bhavshah01.github.io/ConSciR/reference/calcAD.md) for
calculating air density

[`calcAH`](https://bhavshah01.github.io/ConSciR/reference/calcAH.md) for
calculating absolute humidity

[`calcPw`](https://bhavshah01.github.io/ConSciR/reference/calcPw.md) for
calculating water vapour pressure

[`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)
for calculating water vapour saturation pressure

## Examples

``` r
# Calculate specific humidity at 20°C (Temp) and 50% relative humidity (RH)
calcSH(20, 50)
#> [1] 0.8789466


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(SpecificHumidity = calcSH(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH SpecificHumidity
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>            <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8            0.856
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7            0.856
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6            0.856
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6            0.855
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5            0.854


```
