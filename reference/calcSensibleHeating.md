# Calculate Sensible Heating

This function calculates sensible heating power.

Sensible heat is the energy that causes an object's temperature to
change without altering its phase, also known as "dry" heat which you
can feel.

## Usage

``` r
calcSensibleHeating(Temp1, Temp2, RH = 50, volumeFlowRate)
```

## Arguments

- Temp1:

  Initial Temperature (°Celsius)

- Temp2:

  Final Temperature (°Celsius)

- RH:

  Initial Relative Humidity (0-100%). Optional, default is 50%.

- volumeFlowRate:

  Volume flow rate of air in cubic meters per second (m³/s)

## Value

Sensible heat in kilowatts (kW)

## See also

[`calcAD`](https://bhavshah01.github.io/ConSciR/reference/calcAD.md)

## Examples

``` r
calcSensibleHeating(20, 25, 50, 0.5)
#> [1] 3.015065

calcSensibleHeating(20, 25, 60, 0.5)
#> [1] 3.012424

```
