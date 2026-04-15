# Calculate Water Vapour Saturation Pressure

Function to calculate water vapour saturation pressure (hPa) from
temperature (°C) using the International Association for the Properties
of Water and Steam (IAPWS as default), Arden Buck equation (Buck),
August-Roche-Magnus approximation (Magnus) or VAISALA conversion
formula.

Water vapour saturation pressure is the maximum partial pressure of
water vapour that can be present in gas at a given temperature.

## Usage

``` r
calcPws(
  Temp,
  P_atm = 1013.25,
  method = c("Buck", "IAPWS", "Magnus", "VAISALA")
)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- P_atm:

  Atmospheric pressure = 1013.25 (hPa)

- method:

  Character. Method to use for calculation. Options are "Buck"
  (default), "IAPWS", "Magnus" or "VAISALA".

## Value

Pws, Saturation vapor pressure (hPa)

## Details

Different formulations for calculating water vapour pressure are
available:

- Arden Buck equation ("Buck")

- International Association for the Properties of Water and Steam
  ("IAPWS")

- August-Roche-Magnus approximation ("Magnus")

- VAISALA humidity conversion formula ("VAISALA")

## Note

See Wikipedia for a discussion of the accuarcy of each approach:
https://en.wikipedia.org/wiki/Vapour_pressure_of_water

If lower accuracy or a limited temperature range can be tolerated a
simpler formula can be used for the water vapour saturation pressure
over water (and over ice):

Pws = 6.116441 x 10^( (7.591386 x Temp) / (Temp + 240.7263) )

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

[`calcPw`](https://bhavshah01.github.io/ConSciR/reference/calcPw.md) for
calculating water vapour pressure

`calcPws` for calculating water vapour saturation pressure

## Examples

``` r
# Saturation vapour pressure at 20°C
calcPws(20)
#> [1] 23.3834
calcPws(20, method = "Buck")
#> [1] 23.3834
calcPws(20, method = "IAPWS")
#> [1] 23.39194
calcPws(20, method = "Magnus")
#> [1] 23.33441
calcPws(20, method = "VAISALA")
#> [1] 23.39249

# Check of calculations of relative humidity at 50%RH
calcPw(20, 50, method = "Buck") / calcPws(20, method = "Buck") * 100
#> [1] 50
calcPw(20, 50, method = "IAPWS") / calcPws(20, method = "IAPWS") * 100
#> [1] 50
calcPw(20, 50, method = "Magnus") / calcPws(20, method = "Magnus") * 100
#> [1] 50
calcPw(20, 50, method = "VAISALA") / calcPws(20, method = "VAISALA") * 100
#> [1] 50


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(Pws = calcPws(Temp))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH   Pws
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  26.1
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  26.1
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  26.1
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  26.0
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  26.0

mydata |> dplyr::mutate(Buck = calcPws(Temp, method = "Buck"),
                              IAPWS = calcPws(Temp, method = "IAPWS"),
                              Magnus = calcPws(Temp, method = "Magnus"),
                              VAISALA = calcPws(Temp, method = "VAISALA"))
#> # A tibble: 5 × 9
#>   Site   Sensor Date                 Temp    RH  Buck IAPWS Magnus VAISALA
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl> <dbl>  <dbl>   <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  26.1  26.1   26.1    26.1
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  26.1  26.1   26.1    26.1
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  26.1  26.1   26.1    26.1
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  26.0  26.0   25.9    26.0
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  26.0  26.0   25.9    26.0
```
