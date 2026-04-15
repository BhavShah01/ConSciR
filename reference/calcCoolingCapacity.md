# Calculate Cooling Capacity

This function calculates the required cooling capacity based on power
consumption, power factor, safety factor, and efficiency.

Cooling capacity is the amount of energy transferred during a cooling
process.

## Usage

``` r
calcCoolingCapacity(
  Power,
  power_factor = 0.85,
  safety_factor = 1.2,
  efficiency = 0.7
)
```

## Arguments

- Power:

  Power consumption in Watts (W).

- power_factor:

  Power factor, default is 0.85.

- safety_factor:

  Safety factor, default is 1.2 (20% extra capacity).

- efficiency:

  Efficiency of the cooling system, default is 0.7 (70%).

## Value

Required cooling capacity in kilowatts (kW).

## Examples

``` r
calcCoolingCapacity(1000)
#> [1] 1.457143

calcCoolingCapacity(1500, power_factor = 0.9, safety_factor = 1.3, efficiency = 0.8)
#> [1] 2.19375

```
