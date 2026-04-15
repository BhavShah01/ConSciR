# Calculate Cooling Power

This function calculates the cooling power based on initial and final
air conditions and volume flow rate.

Cooling power is the rate of energy transferred during a cooling
process.

## Usage

``` r
calcCoolingPower(Temp1, Temp2, RH1, RH2, volumeFlowRate)
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

  Volume flow rate of air (m³/s)

## Value

Cooling power in kilowatts (kW)

## References

ASHRAE Handbook Fundamentals

## See also

[`calcEnthalpy`](https://bhavshah01.github.io/ConSciR/reference/calcEnthalpy.md),
[`calcAD`](https://bhavshah01.github.io/ConSciR/reference/calcAD.md)

## Examples

``` r
calcCoolingPower(30, 22, 70, 55, 0.8)
#> [1] 0.03049663

calcCoolingPower(Temp1 = 25, Temp2 = 20, RH1 = 70, RH2 = 50, volumeFlowRate = 0.5)
#> [1] 0.01296257



```
