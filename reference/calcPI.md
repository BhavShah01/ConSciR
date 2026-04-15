# Calculate Preservation Index

Calculates the Preservation Index (PI) to estimate the natural decay
speed of objects.

The Preservation Index, developed by the Image Permanence Institute, is
a chemical kinetics metric that determines the rate of deterioration of
materials based on temperature and relative humidity. The \`calcPI\`
function returns the estimated years to deterioration, with higher
values indicating conditions that are more hygro-thermodynamically
favorable for an object.

## Usage

``` r
calcPI(Temp, RH, EA = 90300)
```

## Arguments

- Temp:

  Temperature (°Celsius)

- RH:

  Relative Humidity (0-100%)

- EA:

  Activation Energy (J/mol). Default is 90300 J/mol for cellulose
  acetate film

## Value

PI Preservation Index, the expected lifetime (1/rate,k)

## Details

The formula is based on Arrhenius equation (for molecular energy) and an
equivalent for E (best fit to the cellulose triacetate deterioration
data). The other parameters are integrated to mimic the results from the
experiments. The result is an average chemical lifetime at one point in
time of chemically unstable object (based on experiments on acetate
film). This means it is the expected lifetime for a specific T, RH and
theoretical object if this remains stable (no fluctuations). The chosen
activation energy (Ea) has a larger impact at low temperature.

Developed by the Image Permance Institute, the model is based on the
chemical degradation of cellulose acetate (Reilly et al., 1995):

\- Rate, k = \[RH%\] × 5.9 × 10^12 × exp(-90300 / (8.314 × TempK))

\- Preservation Index, PI = 1/k

This metric is an early version of a lifetime multiplier based on
chemical deterioration of acetate film. This last object is naturally
relatively unstable and there lies the biggest difference with other
chemical metrics together with the fact that it is not relative to the
lifetime of the object. All lifetime multipliers give similar results
between 20% and 60% RH. The results at very low and high RH can be
unreliable.

## References

Reilly, James M. New Tools for Preservation: Assessing Long-Term
Environmental Effects on Library and Archives Collections. Commission on
Preservation and Access, 1400 16th Street, NW, Suite 740, Washington, DC
20036-2217, 1995.

Padfield, T. 2004. The Preservation Index and The Time Weighted
Preservation Index.
https://www.conservationphysics.org/twpi/twpi_01.html

Activation Energy: ASHRAE, 2011.

Image Permanence Institute, eClimateNotebook

## Examples

``` r
# Preservation Index at 20°C (Temp) and 50% relative humidity (RH)
calcPI(20, 50)
#> [1] 41.76134


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(PI = calcPI(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH    PI
#>   <chr>  <chr>  <dttm>              <dbl> <dbl> <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8  45.3
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7  45.4
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6  45.5
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6  46.1
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5  46.2

```
