# Calculate Mould Growth Index (VTT model)

This function calculates the mould growth index on wooden materials
based on temperature, relative humidity, and other factors. It
implements the mathematical model developed by Hukka and Viitanen, which
predicts mould growth under varying environmental conditions.

## Usage

``` r
calcMould_VTT(
  Temp,
  RH,
  M_prev = 0,
  sensitivity = "very",
  wood = 0,
  surface = 0
)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- M_prev:

  The previous mould index value (default is 0).

- sensitivity:

  The sensitivity level of the material to mould growth. Options are
  'very', 'sensitive', 'medium', or 'resistant'. Default is 'very'.

- wood:

  The wood species; 0 for pine and 1 for spruce. Default is 0.

- surface:

  The surface quality; 0 for resawn kiln dried timber and 1 for timber
  dried under normal kiln drying process. Default is 0 (worst case).

## Value

M Mould growth index

- 0 = No mould growth

- 1 = Small amounts of mould growth on surface visible under microscope

- 2 = Several local mould growth colonies on surface visible under
  microscope

- 3 = Visual findings of mould on surface \<10% coverage or 50% coverage
  under microsocpe

- 4 = Visual findings of mould on surface 10-50% coverage or \>50%
  coverage under microscope

- 5 = Plenty of growth on surface \>50% visual coverage

- 6 = Heavy and tight growth, coverage almost 100%

## Details

Senstivity is related to the material surface, mould will grow on.
Options in function avaiable are:

- 'very' sensitive materials include pine and sapwood.

- 'sensitive' materials include glued wooden boards, PUR with paper
  surface, spruce

- 'medium' resistant materials include concrete, glass wool, polyester
  wool

- 'resistant' materials include PUR polished surface

## References

Hukka, A., Viitanen, H. A mathematical model of mould growth on wooden
material. Wood Science and Technology 33, 475–485 (1999).
https://doi.org/10.1007/s002260050131

Viitanen, Hannu, and Tuomo Ojanen. "Improved model to predict mold
growth in building materials." Thermal Performance of the Exterior
Envelopes of Whole Buildings X–Proceedings CD (2007): 2-7.

## Examples

``` r
# Mould growth index at 25°C (Temp) and 85% relative humidity (RH)
calcMould_VTT(Temp = 25, RH = 85)
#> [1] 0.01838254

calcMould_VTT(Temp = 18, RH = 70, M_prev = 2, sensitivity = "medium", wood = 1, surface = 1)
#> [1] 2.001801

# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |>
   dplyr::mutate(
      MouldIndex = calcMould_VTT(Temp, RH),
      MouldIndex_sensitve = calcMould_VTT(Temp, RH, sensitivity = "sensitive")
   )
#> # A tibble: 5 × 7
#>   Site   Sensor Date                 Temp    RH MouldIndex MouldIndex_sensitve
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>      <dbl>               <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8          0                   0
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7          0                   0
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6          0                   0
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6          0                   0
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5          0                   0


```
