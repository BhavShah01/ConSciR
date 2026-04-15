# Calculate Relative Humidity from temperature and absolute humidity

Function to calculate relative humidity (%) from temperature (°C) and
absolute humidity (g/m^3)

## Usage

``` r
calcRH_AH(Temp, AH, P_atm = 1013.25)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- AH:

  Absolute Humidity (g/m³)

- P_atm:

  Atmospheric pressure = 1013.25 (hPa)

## Value

Relative Humidity (0-100%)

## References

Buck, A. L. (1981). New equations for computing vapor pressure and
enhancement factor. Journal of Applied Meteorology, 20(12), 1527-1532.

## See also

[`calcAH`](https://bhavshah01.github.io/ConSciR/reference/calcAH.md) for
calculating absolute humidity

[`calcTemp`](https://bhavshah01.github.io/ConSciR/reference/calcTemp.md)
for calculating temperature

[`calcRH_DP`](https://bhavshah01.github.io/ConSciR/reference/calcRH_DP.md)
for calculating relative humidity from dew point

[`calcDP`](https://bhavshah01.github.io/ConSciR/reference/calcDP.md) for
calculating dew point

## Examples

``` r
# Relative humidity (RH) at temperature of 20°C (Temp) and absolute humidity of 8.645471 g/m³ (AH)
calcRH_AH(20, 8.630534)
#> [1] 50

calcRH_AH(20, calcAH(20, 50))
#> [1] 50


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(Abs = calcAH(Temp, RH), RH2 = calcRH_AH(Temp, Abs))
#> # A tibble: 5 × 7
#>   Site   Sensor Date                 Temp    RH   Abs   RH2
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  7.05  36.8
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  7.03  36.7
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  7.01  36.6
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  6.97  36.6
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  6.95  36.5

```
