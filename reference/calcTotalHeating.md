# Calculate Total Heating

This function calculates total heating power.

Total heating power is the sum of sensible (felt) heat and latent
(hidden) heat.

## Usage

``` r
calcTotalHeating(Temp1, Temp2, RH1, RH2, volumeFlowRate)
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

Total Heating in kilowatts (kW)

## See also

[`calcAD`](https://bhavshah01.github.io/ConSciR/reference/calcAD.md),
[`calcEnthalpy`](https://bhavshah01.github.io/ConSciR/reference/calcEnthalpy.md)

## Examples

``` r
calcTotalHeating(20, 25, 50, 30, 0.5)
#> [1] 0.9756482


```
