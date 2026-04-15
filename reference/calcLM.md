# Calculate Life-time Multiplier for chemical degradation

Function to calculate lifetime multiplier from temperature and relative
humidity.

The \`calcLM\` function calculates the lifetime multiplier for chemical
degradation of objects based on temperature and relative humidity
conditions. This metric provides an estimate of an object’s expected
lifetime relative to standard conditions (20°C and 50% RH); values \>1
indicate conditions that prolong lifetime; values \<1 indicate higher
risk of chemical degradation.

## Usage

``` r
calcLM(Temp, RH, EA = 100)
```

## Arguments

- Temp:

  Temperature (Celsius)

- RH:

  Relative Humidity (0-100%)

- EA:

  Activation Energy (J/mol). 100 J/mol for cellulosic (paper) or 70
  J/mol yellowing varnish

## Value

Lifetime multiplier

## Details

Based on the experiments of the rate of decay of paper, films and dyes.
Activation energy, Ea = 100 J/mol (degradation of cellulose - paper), 70
J/mol (yellowing of varnish - furniture, painting, sculpture).

Gas constant, R = 8.314 J/K.mol

\$\$LM=\left(\frac{50\\RH}{RH}\right)^{1.3}.e\left(\frac{E_a}{R}.\left(\frac{1}{T_K}-\frac{1}{293}\right)\right)\$\$

The lifetime multiplier gives an indication of the speed of natural
decay of an object. It expresses an expected lifetime of an object
compared to the expected lifetime of the same object at 20°C and 50% RH.
This means that if the result = 1, the expected lifetime for your object
is 'good'. The closer you go to 0, the less suited your environment is.
The result is both expressed numerically and over time, which also gives
an idea about the period over the year when the object suffers most. The
data is based on experiments on paper, synthetic films and dyes.

## References

Michalski, S., ‘Double the life for each five-degree drop, more than
double the life for each halving of relative humidity’, in Preprints of
the 13th IcOM-cc Triennial Meeting in rio de Janeiro (22–27 September
2002), ed. r. Vontobel, James & James, London (2002) Vol. I 66–72.

Martens Marco, 2012: Climate Risk Assessment in Museums (Thesis, Tue).

## Examples

``` r
# Lifetime multiplier at 20°C (Temp) and 50% relative humidity (RH)
calcLM(20, 50)
#> [1] 1

calcLM(20, 50, EA = 70)
#> [1] 1


# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> dplyr::mutate(LifeTime = calcLM(Temp, RH))
#> # A tibble: 5 × 6
#>   Site   Sensor Date                 Temp    RH LifeTime
#>   <chr>  <chr>  <dttm>              <dbl> <dbl>    <dbl>
#> 1 London Room 1 2024-01-01 00:00:00  21.8  36.8     1.11
#> 2 London Room 1 2024-01-01 00:15:00  21.8  36.7     1.11
#> 3 London Room 1 2024-01-01 00:29:59  21.8  36.6     1.11
#> 4 London Room 1 2024-01-01 00:44:59  21.7  36.6     1.11
#> 5 London Room 1 2024-01-01 00:59:59  21.7  36.5     1.11

mydata |>
  dplyr::mutate(LM = calcLM(Temp, RH)) |>
   dplyr::summarise(LM_avg = mean(LM, na.rm = TRUE))
#> # A tibble: 1 × 1
#>   LM_avg
#>    <dbl>
#> 1   1.11

```
