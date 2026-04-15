# Add Time Variables

This function adds multiple time-related variables to a dataframe with a
Date column. It creates standard factors such as season, month-year,
day-hour, and determines summer/winter. It also allows flexible
specification of summer and winter start/end dates, and a custom time
period.

## Usage

``` r
add_time_vars(
  mydata,
  Date = "Date",
  openair_vars = c("seasonyear", "season", "monthyear", "daylight"),
  summer_start = "04-15",
  summer_end = "10-15",
  period_start = NULL,
  period_end = NULL,
  period_label = "Period",
  latitude = 51,
  longitude = -0.5,
  ...
)
```

## Arguments

- mydata:

  A dataframe containing a date/time column labelled "Date" and "Sensor"
  column.

- Date:

  The name of the date/time column in \`mydata\` (default "Date").

- openair_vars:

  Variables from \`openair::cutData()\` to add (default includes
  seasonyear, season, monthyear, daylight).

- summer_start:

  Start date for summer season in "MM-DD" format or full date (default
  "04-15").

- summer_end:

  End date for summer season in "MM-DD" format or full date (default
  "10-15").

- period_start:

  Start date of custom period in "MM-DD" format or full date (optional).

- period_end:

  End date of custom period in "MM-DD" format or full date (optional).

- period_label:

  Label to assign for dates within the custom period, e.g. if there is
  an Exhibition or a property is open/closed to the public (default
  "Period").

- latitude:

  Latitude for daylight calculations (default 51).

- longitude:

  Longitude for daylight calculations (default -0.5).

- ...:

  Additional arguments passed to \`openair::cutData()\`.

## Value

A data frame with additional time-related columns appended:

- seasonyear:

  Combined year and season factor created by
  [`openair::cutData()`](https://openair-project.github.io/openair/reference/cutData.html);
  useful for seasonal analyses.

- season:

  Season factor (e.g., Spring, Summer) from
  [`openair::cutData()`](https://openair-project.github.io/openair/reference/cutData.html).

- monthyear:

  Factor combining month and year, created by
  [`openair::cutData()`](https://openair-project.github.io/openair/reference/cutData.html)
  to assist month-based grouping.

- daylight:

  Boolean or factor indicating daylight presence/absence, derived using
  [`openair::cutData()`](https://openair-project.github.io/openair/reference/cutData.html)
  with latitude and longitude inputs.

- day:

  Date part of the timestamp, rounded down to day boundary, useful for
  daily aggregation.

- hour:

  Hour of the day extracted from the datetime.

- dayhour:

  Datetime floored to the hour; useful for hourly time series analysis.

- weekday:

  Weekday name/factor, abbreviated, extracted from the date.

- month:

  Month number and its labelled factor version; useful for
  calendar-based grouping.

- year:

  Year extracted from the datetime for annual analyses.

- DayYear:

  Date with the current year but month and day taken from the original
  date; used to assign seasons and periods relative to current year.

- Summer:

  A factor ("Summer" or "Winter") determined by comparison of `DayYear`
  with user-defined `summer_start` and `summer_end` dates, for custom
  seasonality modelling.

- Period:

  Character flag identifying whether the date falls within a
  user-defined custom period (e.g., an exhibition), labelled by
  `period_label`. Returns `NA` if no period defined.

## Details

The variables `seasonyear`, `season`, `monthyear`, and `daylight` are
created using the
[`openair::cutData()`](https://openair-project.github.io/openair/reference/cutData.html)
function internally and rely on geographic coordinates (latitude,
longitude) to calculate daylight status. Be sure `openair` is installed
and loaded for these variables.

## Examples

``` r
# mydata file
filepath <- data_file_path("mydata.xlsx")
mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)

mydata |>
  add_time_vars(period_start = "05-01", period_end = "06-30", period_label = "Exhibition") |>
  dplyr::glimpse()
#> Rows: 5
#> Columns: 20
#> $ Site       <chr> "London", "London", "London", "London", "London"
#> $ Sensor     <chr> "Room 1", "Room 1", "Room 1", "Room 1", "Room 1"
#> $ date       <dttm> 2024-01-01 00:00:00, 2024-01-01 00:15:00, 2024-01-01 00:29:…
#> $ Temp       <dbl> 21.8, 21.8, 21.8, 21.7, 21.7
#> $ RH         <dbl> 36.8, 36.7, 36.6, 36.6, 36.5
#> $ seasonyear <ord> winter
#> (DJF)-2024, winter
#> (DJF)-2024, winter
#> (DJF)-2024, wi…
#> $ season     <ord> winter (DJF), winter (DJF), winter (DJF), winter (DJF), wi…
#> $ monthyear  <ord> January 2024, January 2024, January 2024, January 2024, Jan…
#> $ daylight   <fct> nighttime, nighttime, nighttime, nighttime, nighttime
#> $ Date       <dttm> 2024-01-01 00:00:00, 2024-01-01 00:15:00, 2024-01-01 00:29:…
#> $ day        <dttm> 2024-01-01, 2024-01-01, 2024-01-01, 2024-01-01, 2024-01-01
#> $ hour       <int> 0, 0, 0, 0, 0
#> $ dayhour    <dttm> 2024-01-01, 2024-01-01, 2024-01-01, 2024-01-01, 2024-01-01
#> $ weekday    <ord> Mon, Mon, Mon, Mon, Mon
#> $ Month      <dbl> 1, 1, 1, 1, 1
#> $ month      <ord> Jan, Jan, Jan, Jan, Jan
#> $ year       <dbl> 2024, 2024, 2024, 2024, 2024
#> $ DayYear    <date> 2026-01-01, 2026-01-01, 2026-01-01, 2026-01-01, 2026-01-01
#> $ Summer     <chr> "Winter", "Winter", "Winter", "Winter", "Winter"
#> $ Period     <chr> "Outside Exhibition", "Outside Exhibition", "Outside Exhibi…
```
