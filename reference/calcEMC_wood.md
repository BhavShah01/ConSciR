# Calculate Equilibrium Moisture Content for wood (EMC)

This function calculates the Equilibrium Moisture Content (EMC) of wood
based on relative humidity and temperature.

## Usage

``` r
calcEMC_wood(Temp, RH)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

## Value

EMC, Equilibrium Moisture Content (0-100%)

## Details

Equilibrium Moisture Content (EMC) is the moisture content at which a
material, such as wood or other hygroscopic substanceshas reached an
equilibrium with its environment and is no longer gaining or losing
moisture under specific temperature and relative humidity.

A safe EMC range for wood is typically between 6% and 20%. This range
helps to prevent issues such as warping, cracking, and mold growth,
which can occur if the moisture content falls below or exceeds these
levels.

## References

Simpson, W. T. (1998). Equilibrium moisture content of wood in outdoor
locations in the United States and worldwide. Res. Note FPL-RN-0268.
Madison, WI: U.S. Department of Agriculture, Forest Service, Forest
Products Laboratory.

Hailwood, A. J., and Horrobin, S. (1946). Absorption of water by
polymers: Analysis in terms of a simple model. Transactions of the
Faraday Society 42, B084-B092. DOI:10.1039/TF946420B084

## Examples

``` r
# Equilibrium moisture content for wood at 20°C and 50% relative humidity (RH)
calcEMC_wood(20, 50)
#> [1] 9.271141


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(EMC = calcEMC_wood(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH   EMC
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  7.20
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  7.19
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  7.17
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  7.17
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  7.16

```
