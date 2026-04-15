# Add Humidity calculations

This function adds several humidity variables to a dataframe with
temperature and relative humidity columns. It uses the humidity
functions (e.g., calcPws, calcPw).

## Usage

``` r
add_humidity_calcs(mydata, Temp = "Temp", RH = "RH", P_atm = 1013.25, ...)
```

## Arguments

- mydata:

  A dataframe containing temperature and relative humidity data.

- Temp:

  Character string name of the temperature column (default "Temp").

- RH:

  Character string name of the relative humidity column (default "RH").

- P_atm:

  Atmospheric pressure (hPa), default 1013.25.

- ...:

  Additional parameters passed to humidity calculation functions.

## Value

The input dataframe augmented with columns for vapor pressure, dew
point, absolute humidity, air density, mixing ratio, specific humidity,
and enthalpy.

- Pws:

  Saturated vapour pressure at given temperature (hPa).

- Pw:

  Partial pressure of water vapour present (hPa).

- DP:

  Dew Point, condensation temperature based on RH (°C).

- AH:

  Mass of water vapour per air volume (g/m³).

- AD:

  Moist air density (kg/m³).

- MR:

  Ratio of water vapour to dry air mass (g/kg).

- SH:

  Ratio of water vapour to total air mass (g/kg).

- Enthalpy:

  Total enthalpy, h, of air-vapour mixture (kJ/kg).

## See also

[`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)
for \`Pws\`

[`calcPw`](https://bhavshah01.github.io/ConSciR/reference/calcPw.md) for
\`Pw\`

[`calcDP`](https://bhavshah01.github.io/ConSciR/reference/calcDP.md) for
\`DP\`

[`calcAH`](https://bhavshah01.github.io/ConSciR/reference/calcAH.md) for
\`AH\`

[`calcAD`](https://bhavshah01.github.io/ConSciR/reference/calcAD.md) for
\`AD\`

[`calcMR`](https://bhavshah01.github.io/ConSciR/reference/calcMR.md) for
\`MR\`

[`calcSH`](https://bhavshah01.github.io/ConSciR/reference/calcSH.md) for
\`SH\`

[`calcEnthalpy`](https://bhavshah01.github.io/ConSciR/reference/calcEnthalpy.md)
for \`Enthalpy\`

## Examples

``` r
# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> add_humidity_calcs() |> dplyr::glimpse()
#> Rows: 5
#> Columns: 13
#> $ Site     <chr> "London", "London", "London", "London", "London"
#> $ Sensor   <chr> "Room 1", "Room 1", "Room 1", "Room 1", "Room 1"
#> $ Date     <dttm> 2024-01-01 00:00:00, 2024-01-01 00:15:00, 2024-01-01 00:29:59…
#> $ Temp     <dbl> 21.8, 21.8, 21.8, 21.7, 21.7
#> $ RH       <dbl> 36.8, 36.7, 36.6, 36.6, 36.5
#> $ Pws      <dbl> 26.12119, 26.12119, 26.12119, 25.96205, 25.96205
#> $ Pw       <dbl> 9.612598, 9.586477, 9.560356, 9.502110, 9.476148
#> $ DP       <dbl> 6.383970, 6.344456, 6.304848, 6.216205, 6.176529
#> $ AH       <dbl> 7.052415, 7.033251, 7.014087, 6.973723, 6.954670
#> $ AD       <dbl> 1.192445, 1.192457, 1.192469, 1.192899, 1.192911
#> $ MR       <dbl> 5.957278, 5.940935, 5.924593, 5.888156, 5.871916
#> $ SH       <dbl> 0.8562656, 0.8559272, 0.8555872, 0.8548233, 0.8544802
#> $ Enthalpy <dbl> 37.15665, 37.11512, 37.07359, 36.87888, 36.83762

```
