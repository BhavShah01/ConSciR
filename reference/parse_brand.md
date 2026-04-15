# Parse datalogger files

Extracts temperature and humidity data from a directory of logfiles.

## Usage

``` r
parse_brand(directory, Site = "Site", Sensor = "Sensor", brand = FALSE)
```

## Arguments

- directory:

  A directory of files from a single brand, .csv or .xls only for
  Rotronic.

- Site:

  Character string specifying site name when not recoverable from the
  file. Default is "Site".

- Sensor:

  Character string specifying sensor name. Default is "Sensor".

- brand:

  The logger brand as a string.

## Value

dat, a data frame containing the raw TRH data, with columns for site,
sensor, date, temperature, and relative humidity.

## Examples

``` r
# \donttest{
# Example usage:
# parse_brand(dir("logfiles/tinytag", full.names = TRUE), "Anonymous Library", "tinytag")
# }
```
