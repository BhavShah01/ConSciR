# Calculate Sensible Heat Ratio (SHR)

This function calculates the Sensible Heat Ratio (SHR) using the
sensible and total heating values.

Sensible heat ratio is the ratio of sensible heat to total heat.

## Usage

``` r
calcSensibleHeatRatio(Temp1, Temp2, RH1, RH2, volumeFlowRate)
```

## Arguments

- Temp1:

  Initial Temperature (°Celsius)

- Temp2:

  Final Temperature (°Celsius)

- RH1:

  Initial Relative Humidity (0-100%)

- RH2:

  Final Relative Humidity (0-100%)

- volumeFlowRate:

  Volume flow rate of air in cubic meters per second (m³/s)

## Value

SHR Sensible Heat Ratio (0-100%)

## See also

[`calcSensibleHeating`](https://bhavshah01.github.io/ConSciR/reference/calcSensibleHeating.md),
[`calcTotalHeating`](https://bhavshah01.github.io/ConSciR/reference/calcTotalHeating.md)

## Examples

``` r
calcSensibleHeatRatio(20, 25, 50, 30, 0.5)
#> [1] 27.91313

```
