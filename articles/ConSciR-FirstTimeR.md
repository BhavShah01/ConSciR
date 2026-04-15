# Using R for the first time

## Installation

To get started with R, you need to install both R and RStudio, which is
a user-friendly interface for R. First, download R from the
Comprehensive R Archive Network (CRAN), then follow the installation
instructions for your operating system. After installing R, download
RStudio and follow the prompts to complete the installation. There are
plenty of online resources available to guide you through each step.

- R: <https://cloud.r-project.org/>
- RStudio: <https://posit.co/download/rstudio-desktop/>

Useful starting point from RStudio Education: [Finding Your Way To
R](https://education.rstudio.com/learn/)

## Loading a Package and Basic Introduction to RStudio

When you first open RStudio, you’ll see a layout with multiple panes.
The main areas are the Console (where you can type and execute R
commands), the Source Editor (where you write and edit R scripts), the
Environment/History pane, and the Files/Plots/Packages/Help pane.

### Loading a Package for the First Time

To load a package in R for the first time, follow these two steps:

1.  **Installing a package:** Open the Console in RStudio and type:

    ``` r
    install.packages("tidyverse")
    ```

2.  **Loading the package:** After installation, load the package into
    your R session using the
    [`library()`](https://rdrr.io/r/base/library.html) function:

    ``` r
    library(tidyverse)
    ```

### Basic RStudio Features

1.  **Creating a new R script:** Click on File \> New File \> R Script.

2.  **Running code:** Place your cursor on a line of code and press
    Ctrl+Enter (Cmd+Enter on Mac).

3.  **Viewing installed packages:** In the bottom-right pane, click on
    the “Packages” tab.

4.  **Getting help:** Type `?function_name` in the Console. For example:

    ``` r
    ?mean
    ```

5.  **Viewing plots:** Created plots appear in the “Plots” tab in the
    bottom-right pane.

6.  **Managing files:** Use the “Files” tab in the bottom-right pane to
    navigate your project directory.

## Tidy data

To ensure optimal functionality of ConSciR functions, it is crucial to
maintain your data in a tidy and consistently formatted structure. This
allows the code to easily locate and process your variables. Please note
the specific naming conventions for the columns as they are essential
for the package to work correctly. The following formats are
recommended:

##### Temperature and Relative Humidity Data

    #>     Site  Sensor                Date Temp RH
    #> 1 London Gallery 2023-01-01 00:00:00 20.5 45
    #> 2 London Gallery 2023-01-01 01:00:00 21.0 47
    #> 3   York    Room 2023-01-01 00:00:00 19.8 50
    #> 4   York    Room 2023-01-01 02:00:00 20.2 49

##### Light and UV Data

    #>     Site Sensor                Date Lux UV
    #> 1 Museum  Store 2023-01-01 00:00:00  45  0
    #> 2 Museum  Store 2023-01-01 01:00:00  56  0
    #> 3   Case  Shelf 2023-01-01 00:00:00 200 20
    #> 4   Case  Shelf 2023-01-01 02:00:00 199 49

Key Points:

- Column Names: Try to use the exact column names as shown above (Site,
  Sensor, Date, Temp, RH, Lux, UV). These names are case-sensitive.
  Tools to tidy files are being developed.
- Date Format: The Date column should ideally be in a datetime format
  (YYYY-MM-DD HH:MM:SS) but the software will attempt to interpret your
  date column. Check the behaviour of dates if this format hasn’t been
  used.
- Numeric Data: Ensure that Temp, RH, Lux, and UV columns contain only
  numeric data.
- Categorical Data: Site and Sensor are categorical variables and should
  be character strings.
- Tidy Structure: Each row represents a single observation, and each
  column represents a single variable.
- No Missing Columns: Include all relevant columns, even if some data
  points are missing (leave blank or use NA for missing values).
