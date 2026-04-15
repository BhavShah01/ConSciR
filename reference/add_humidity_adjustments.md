# Adjust Humidity and add RH zones

This function processes a dataframe with temperature and relative
humidity data and classifies the data into climate control zones. It
generates adjusted temperature and humidity values based on thresholds.

## Usage

``` r
add_humidity_adjustments(
  mydata,
  Temp = "Temp",
  RH = "RH",
  LowT = 16,
  HighT = 25,
  LowRH = 40,
  HighRH = 60,
  P_atm = 1013.25,
  ...
)
```

## Arguments

- mydata:

  A dataframe containing temperature and relative humidity data.

- Temp:

  Character string name of the temperature column (default "Temp").

- RH:

  Character string name of the relative humidity column (default "RH").

- LowT:

  Numeric lower temperature threshold (default 16).

- HighT:

  Numeric higher temperature threshold (default 25).

- LowRH:

  Numeric lower relative humidity threshold (default 40).

- HighRH:

  Numeric higher relative humidity threshold (default 60).

- P_atm:

  Atmospheric pressure in kPa or hPa (currently unused, default
  1013.25).

- ...:

  Additional arguments passed to internal calculation functions.

## Value

The input dataframe augmented with multiple humidity and temperature
adjustment columns.

- AH:

  Absolute Humidity (g/m³): The mass of water vapor per unit volume of
  air.

- DP:

  Dew Point (°C): The temperature at which air becomes saturated and
  water vapor condenses.

- zone:

  Categorical variable defining climate control actions based on
  temperature and RH: 'Heating only', 'Dehum or heating', 'Cooling and
  hum', etc.

- TRH_zone:

  Temperature-relative humidity category: 'Hot', 'Cold', 'Dry', 'Hot and
  humid', etc.

- T_zone:

  Temperature zone classification: 'Cold', 'Within', or 'Hot'.

- RH_zone:

  Relative humidity zone classification: 'Dry', 'Within', or 'Humid'.

- dTemp:

  Temperature difference from specified thresholds (°C), indicating
  required heating or cooling.

- dRH:

  Relative humidity difference from specified thresholds (%), indicating
  humidification or dehumidification.

- newTemp_TRHadj:

  Adjusted temperature (°C) after applying temperature and relative
  humidity correction based on zone.

- newAH_TRHadj:

  Adjusted absolute humidity (g/m³).

- newRH_TRHadj:

  Adjusted relative humidity (%) reflecting new temperature and absolute
  humidity.

- dTemp_TRHadj, dAH_TRHadj, dRH_TRHadj:

  Differences between adjusted and original temperature, absolute
  humidity, and relative humidity respectively.

- newTemp_AHadj, newAH_AHadj, newRH_AHadj:

  Adjustments based on absolute humidity only (i.e. dehumidification or
  humidification).

- newTemp_Tadj, newRH_Tadj, newAH_Tadj:

  Adjustments based on temperature only (i.e. heating or cooling).

## Examples

``` r
# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |> add_humidity_adjustments() |> dplyr::glimpse()
#> Rows: 5
#> Columns: 36
#> $ Site           <chr> "London", "London", "London", "London", "London"
#> $ Sensor         <chr> "Room 1", "Room 1", "Room 1", "Room 1", "Room 1"
#> $ Date           <dttm> 2024-01-01 00:00:00, 2024-01-01 00:15:00, 2024-01-01 00…
#> $ Temp           <dbl> 21.8, 21.8, 21.8, 21.7, 21.7
#> $ RH             <dbl> 36.8, 36.7, 36.6, 36.6, 36.5
#> $ AH             <dbl> 7.052415, 7.033251, 7.014087, 6.973723, 6.954670
#> $ DP             <dbl> 6.383970, 6.344456, 6.304848, 6.216205, 6.176529
#> $ TRH_within     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE
#> $ T_lower        <lgl> FALSE, FALSE, FALSE, FALSE, FALSE
#> $ T_higher       <lgl> FALSE, FALSE, FALSE, FALSE, FALSE
#> $ RH_lower       <lgl> TRUE, TRUE, TRUE, TRUE, TRUE
#> $ RH_higher      <lgl> FALSE, FALSE, FALSE, FALSE, FALSE
#> $ zone           <chr> "Hum or cooling", "Hum or cooling", "Hum or cooling", "…
#> $ TRH_zone       <chr> "Dry", "Dry", "Dry", "Dry", "Dry"
#> $ T_zone         <chr> "Within", "Within", "Within", "Within", "Within"
#> $ RH_zone        <chr> "Dry", "Dry", "Dry", "Dry", "Dry"
#> $ dTemp          <dbl> 0, 0, 0, 0, 0
#> $ dRH            <dbl> -3.2, -3.3, -3.4, -3.4, -3.5
#> $ newTemp_TRHadj <dbl> 21.8, 21.8, 21.8, 21.7, 21.7
#> $ newAH_TRHadj   <dbl> 7.665669, 7.665669, 7.665669, 7.621556, 7.621556
#> $ dTemp_TRHadj   <dbl> 0, 0, 0, 0, 0
#> $ dAH_TRHadj     <dbl> 0.6132535, 0.6324177, 0.6515818, 0.6478322, 0.6668861
#> $ newRH_TRHadj   <dbl> 40, 40, 40, 40, 40
#> $ dRH_TRHadj     <dbl> 3.2, 3.3, 3.4, 3.4, 3.5
#> $ newAH_AHadj    <dbl> 7.665669, 7.665669, 7.665669, 7.621556, 7.621556
#> $ dAH_AHadj      <dbl> 0.6132535, 0.6324177, 0.6515818, 0.6478322, 0.6668861
#> $ newRH_AHadj    <dbl> 40, 40, 40, 40, 40
#> $ dRH_AHadj      <dbl> 3.2, 3.3, 3.4, 3.4, 3.5
#> $ newTemp_AHadj  <dbl> 21.8, 21.8, 21.8, 21.7, 21.7
#> $ dTemp_AHadj    <dbl> 0, 0, 0, 0, 0
#> $ newTemp_Tadj   <dbl> 20.44169, 20.39760, 20.35340, 20.25449, 20.21022
#> $ dTemp_Tadj     <dbl> -1.358305, -1.402398, -1.446596, -1.445507, -1.489777
#> $ newRH_Tadj     <dbl> 39.81656, 39.81062, 39.80466, 39.80479, 39.79882
#> $ dRH_Tadj       <dbl> 3.016562, 3.110618, 3.204660, 3.204791, 3.298824
#> $ newAH_Tadj     <dbl> 6.518114, 6.483705, 6.449385, 6.412250, 6.378215
#> $ dAH_Tadj       <dbl> -0.5343015, -0.5495458, -0.5647019, -0.5614733, -0.576…
```
