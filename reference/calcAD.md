# Calculate Air Density

Function to calculate air density based on temperature (°C), relative
humidity in (%), and atmospheric pressure (hPa).

## Usage

``` r
calcAD(Temp, RH, P_atm = 1013.25, R_dry = 287.058, R_vap = 461.495, ...)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- P_atm:

  Atmospheric pressure = 1013.25 (hPa)

- R_dry:

  Specific gas constant for dry air = 287.058 (J/(kg·K))

- R_vap:

  Specific gas constant for water vapor = 461.495 (J/(kg·K))

- ...:

  Addtional arguments to supply to
  [`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)

## Value

Air density in kg/m³

## See also

[`calcMR`](https://bhavshah01.github.io/ConSciR/reference/calcMR.md) for
calculating mixing ratio

`calcAD` for calculating air density

[`calcPw`](https://bhavshah01.github.io/ConSciR/reference/calcPw.md) for
calculating water vapour pressure

[`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)
for calculating water vapour saturation pressure

## Examples

``` r
# Air density at 20°C (Temp) and 50% relative humidity (RH)
calcAD(20, 50)
#> [1] 1.198833


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(AirDensity = calcAD(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH AirDensity
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>      <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8       1.19
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7       1.19
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6       1.19
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6       1.19
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5       1.19

```
