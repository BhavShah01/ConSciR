# Add Conservation Risks

Appends columns for conservation-risks: mould risk, preservation
indices, equilibrium moisture, and moisture content for wood to a
dataframe with temperature and relative humidity columns.

## Usage

``` r
add_conservation_calcs(mydata, Temp = "Temp", RH = "RH", ...)
```

## Arguments

- mydata:

  A dataframe containing temperature and relative humidity data.

- Temp:

  Character string name of the temperature column (default "Temp").

- RH:

  Character string name of the relative humidity column (default "RH").

- ...:

  Additional parameters passed to humidity calculation functions.

## Value

Dataframe augmented with conservation variables:

- Mould_LIM:

  Mould risk threshold humidity from Zeng equation (numeric).

- Mould_risk:

  If there is a risk of mould from Zeng equation. Adds label: "Mould
  risk" or "No risk".

- Mould_rate:

  Mould growth rate index from Zeng equation, labelled output.

- Mould_index:

  Mould risk index from VTT model (continuous scale).

- PreservationIndex:

  Preservation Index for collection longevity.

- Lifetime:

  Lifetime Multiplier for object material degradation risk.

- EMC_wood:

  Wood equilibrium moisture content (%) under current climate
  conditions.

## See also

[`calcMould_Zeng`](https://bhavshah01.github.io/ConSciR/reference/calcMould_Zeng.md)
for \`Mould_LIM\`, \`Mould_risk\`, \`Mould_rate\`

[`calcMould_VTT`](https://bhavshah01.github.io/ConSciR/reference/calcMould_VTT.md)
for \`Mould_index\`

[`calcPI`](https://bhavshah01.github.io/ConSciR/reference/calcPI.md) for
\`PreservationIndex\`

[`calcLM`](https://bhavshah01.github.io/ConSciR/reference/calcLM.md) for
\`Lifetime\`

[`calcEMC_wood`](https://bhavshah01.github.io/ConSciR/reference/calcEMC_wood.md)
for \`EMC_wood\`

## Examples

``` r
# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> add_conservation_calcs() |> dplyr::glimpse()
#> Rows: 5
#> Columns: 12
#> $ Site              <chr> "London", "London", "London", "London", "London"
#> $ Sensor            <chr> "Room 1", "Room 1", "Room 1", "Room 1", "Room 1"
#> $ Date              <dttm> 2024-01-01 00:00:00, 2024-01-01 00:15:00, 2024-01-01…
#> $ Temp              <dbl> 21.8, 21.8, 21.8, 21.7, 21.7
#> $ RH                <dbl> 36.8, 36.7, 36.6, 36.6, 36.5
#> $ Mould_LIM         <dbl> 75.11542, 75.11542, 75.11542, 75.14014, 75.14014
#> $ Mould_risk        <chr> "No risk", "No risk", "No risk", "No risk", "No risk"
#> $ Mould_rate        <dbl> 0, 0, 0, 0, 0
#> $ Mould_index       <dbl> 0, 0, 0, 0, 0
#> $ PreservationIndex <dbl> 45.25849, 45.38181, 45.50580, 46.07769, 46.20393
#> $ Lifetime          <dbl> 1.107855, 1.108860, 1.109869, 1.109854, 1.110866
#> $ EMC_wood          <dbl> 7.201471, 7.186361, 7.171247, 7.173308, 7.158186

```
