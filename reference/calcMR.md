# Calculate Mixing Ratio

Function to calculate mixing ratio (g/kg) from temperature (°C) and
relative humidity (%).

Mixing Ratio is the mass of water vapor present in a given volume of air
relative to the mass of dry air.

## Usage

``` r
calcMR(Temp, RH, P_atm = 1013.25, B = 621.9907, ...)
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

## Value

X Mixing ratio, mass of water vapour / mass of dry gas (g/kg)

## Details

X Mixing ratio (mass of water vapour / mass of dry gas)

Pw = Pws(40°C) = 73.75 hPa

X = 621.9907 x 73.75 / (998 - 73.75) = 49.63 g/kg

## See also

`calcMR` for calculating mixing ratio

[`calcAD`](https://bhavshah01.github.io/ConSciR/reference/calcAD.md) for
calculating air density

[`calcPw`](https://bhavshah01.github.io/ConSciR/reference/calcPw.md) for
calculating water vapour pressure

[`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)
for calculating water vapour saturation pressure

## Examples

``` r
# Mixing ratio at 20°C (Temp) and 50% relative humidity (RH)
calcMR(20, 50)
#> [1] 7.260814

# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(MixingRatio = calcMR(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH MixingRatio
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>       <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8        5.96
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7        5.94
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6        5.92
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6        5.89
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5        5.87

```
