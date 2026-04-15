# Calculate Water Vapour Pressure

Function to calculate water vapour pressure (hPa) from temperature (°C)
and relative humidity (%).

Water vapour pressure is the pressure exerted by water vapour in a gas.

## Usage

``` r
calcPw(Temp, RH, ...)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- ...:

  Additional arguments to supply to
  [`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)

## Value

Pw, Water Vapour Pressure (hPa)

## Details

Different formulations for calculating water vapour pressure are
available:

- Arden Buck equation ("Buck")

- International Association for the Properties of Water and Steam
  ("IAPWS")

- August-Roche-Magnus approximation ("Magnus")

- VAISALA humidity conversion formula ("VAISALA")

The water vapor pressure (P_w) is calculated using the following
equation:

\$\$P_w=\frac{P\_{ws}\left(Temp\right)\times RH}{100}\$\$

Where:

- P_ws is the saturation vapor pressure using
  [`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md).

- RH is the relative humidity in percent.

- Temp is the temperature in degrees Celsius.

## Note

See Wikipedia for a discussion of the accuarcy of each approach:
https://en.wikipedia.org/wiki/Vapour_pressure_of_water

## References

Wagner, W., & Pru\ß, A. (2002). The IAPWS formulation 1995 for the
thermodynamic properties of ordinary water substance for general and
scientific use. Journal of Physical and Chemical Reference Data, 31(2),
387-535.

Alduchov, O. A., and R. E. Eskridge, 1996: Improved Magnus' form
approximation of saturation vapor pressure. J. Appl. Meteor., 35,
601-609.

Buck, A. L., 1981: New Equations for Computing Vapor Pressure and
Enhancement Factor. J. Appl. Meteor. Climatol., 20, 1527–1532,
https://doi.org/10.1175/1520-0450(1981)020\<1527:NEFCVP\>2.0.CO;2.

Buck (1996), Buck (1996), Buck Research CR-1A User's Manual, Appendix 1.

VAISALA. Humidity Conversions: Formulas and methods for calculating
humidity parameters. Ref. B210973EN-O

## See also

[`calcMR`](https://bhavshah01.github.io/ConSciR/reference/calcMR.md) for
calculating mixing ratio

[`calcAD`](https://bhavshah01.github.io/ConSciR/reference/calcAD.md) for
calculating air density

`calcPw` for calculating water vapour pressure

[`calcPws`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)
for calculating water vapour saturation pressure

## Examples

``` r
# Water vapour pressure at 20°C (Temp) and 50% relative humidity (RH)
calcPw(20, 50)
#> [1] 11.6917

# Calculate relative humidity at 50%RH
calcPw(20, 50) / calcPws(20) * 100
#> [1] 50


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(Pw = calcPw(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH    Pw
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  9.61
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  9.59
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  9.56
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  9.50
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  9.48

mydata |> dplyr::mutate(Buck = calcPw(Temp, RH, method = "Buck"),
                              IAPWS = calcPw(Temp, RH, method = "IAPWS"),
                              Magnus = calcPw(Temp, RH, method = "Magnus"),
                              VAISALA = calcPw(Temp, RH, method = "VAISALA"))
#> # A tibble: 5 × 9
#>   Site   Sensor Date                 Temp    RH  Buck IAPWS Magnus VAISALA
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <dbl>   <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  9.61  9.62   9.59    9.62
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  9.59  9.59   9.57    9.59
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  9.56  9.56   9.54    9.56
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  9.50  9.51   9.48    9.51
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  9.48  9.48   9.46    9.48

```
