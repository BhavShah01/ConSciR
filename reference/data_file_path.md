# Return the file path to data files

Access mydata.xlsx and other files in inst/extdata folder

## Usage

``` r
data_file_path(path = NULL)
```

## Arguments

- path:

  Name of file in quotes with extension, e.g. "mydata.xlsx"

## Value

String of the path to the specified file

## Examples

``` r
data_file_path()
#> [1] "ConSciR_hexsticker.png" "mydata.xlsx"           

data_file_path("mydata.xlsx")
#> [1] "/home/runner/work/_temp/Library/ConSciR/extdata/mydata.xlsx"
```
