# Calculate Mould Growth Rate Limits (Zeng et al.)

This function calculates the Lowest Isoline for Mould (LIM) based on
temperature and relative humidity, using the model developed by Zeng et
al. (2023).

The LIM is the lowest envelope of the temperature and humidity isoline
at a certain mould growth rate (u). LIM0 is the critical value for mould
growth, if the humidity is kept below the critcal value, at a given
temperature, then there is no risk of mould growth.

## Usage

``` r
calcMould_Zeng(Temp, RH, LIM = 0, label = FALSE)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- LIM:

  The specific LIM value to calculate. Must be one of 0, 0.1, 0.5, 1, 2,
  3, or 4. Default is 0.

- label:

  Logical. If TRUE, returns a descriptive label instead of a numeric
  value. Default is FALSE.

## Value

If label is FALSE, returns the calculated LIM value as Relative Humidity
(0-100%). If label is TRUE, returns a character string describing the
mould growth rate category.

## Details

The function calculates LIM values for mould genera including
Cladosporium, Penicillium, and Aspergillus. LIM values represent
different mould growth rates:

- LIM0: Low limit of mould growth

- LIM0.1: 0.1 mm/day growth rate

- LIM0.5: 0.5 mm/day growth rate

- LIM1: 1 mm/day growth rate

- LIM2: 2 mm/day growth rate

- LIM3: 3 mm/day growth rate

- LIM4: 4 mm/day growth rate

- Above LIM4: Greater than 4 mm/day growth rate (9 mm/day theorectical
  maximum)

## References

Zeng L, Chen Y, Ma M, et al. Prediction of mould growth rate within
building envelopes: development and validation of an improved model.
Building Services Engineering Research and Technology. 2023;44(1):63-79.
doi:10.1177/01436244221137846

Sautour M, Dantigny P, Divies C, Bensoussan M. A temperature-type model
for describing the relationship between fungal growth and water
activity. Int J Food Microbiol. 2001 Jul 20;67(1-2):63-9. doi:
10.1016/s0168-1605(01)00471-8. PMID: 11482570.

## Examples

``` r
# Lowest Isoline for Mould at 20°C (Temp) and 75% relative humidity (RH)
calcMould_Zeng(20, 75)
#> [1] 75.61875
calcMould_Zeng(20, 75, LIM = 0)
#> [1] 75.61875
calcMould_Zeng(20, 75, label = TRUE)
#> [1] 0

calcMould_Zeng(20, 85)
#> [1] 75.61875
calcMould_Zeng(20, 85, LIM = 2)
#> [1] 86.58875
calcMould_Zeng(20, 85, label = TRUE)
#> [1] 2


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |>
   dplyr::mutate(
      RH_LIM0 = calcMould_Zeng(Temp, RH),
      RH_LIM1 = calcMould_Zeng(Temp, RH, LIM = 1),
      LIM = calcMould_Zeng(Temp, RH, label = TRUE)
   )
#> # A tibble: 5 × 8
#>   Site   Sensor Date                 Temp    RH RH_LIM0 RH_LIM1   LIM
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>   <dbl>   <dbl> <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8    75.1    83.1     0
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7    75.1    83.1     0
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6    75.1    83.1     0
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6    75.1    83.1     0
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5    75.1    83.1     0

```
