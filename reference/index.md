# Package index

## Shiny applications

Interactive applications to use and demonstrate tools in the package.

- [`run_ConSciR_app()`](https://bhavshah01.github.io/ConSciR/reference/run_ConSciR_app.md)
  : Run the ConSciR Shiny Application

## Useful tools for conservation data

Tidying, adding variables, summaries and graphing.

- [`graph_TRH()`](https://bhavshah01.github.io/ConSciR/reference/graph_TRH.md)
  : Graph temperature and humidity data
- [`graph_psychrometric()`](https://bhavshah01.github.io/ConSciR/reference/graph_psychrometric.md)
  : Create a Psychrometric Chart
- [`graph_TRHbivariate()`](https://bhavshah01.github.io/ConSciR/reference/graph_TRHbivariate.md)
  : Graph a bivariate plot of temperature and humidity data
- [`add_conservation_calcs()`](https://bhavshah01.github.io/ConSciR/reference/add_conservation_calcs.md)
  : Add Conservation Risks
- [`add_humidity_calcs()`](https://bhavshah01.github.io/ConSciR/reference/add_humidity_calcs.md)
  : Add Humidity calculations
- [`add_humidity_adjustments()`](https://bhavshah01.github.io/ConSciR/reference/add_humidity_adjustments.md)
  : Adjust Humidity and add RH zones
- [`add_time_vars()`](https://bhavshah01.github.io/ConSciR/reference/add_time_vars.md)
  : Add Time Variables
- [`tidy_TRHdata()`](https://bhavshah01.github.io/ConSciR/reference/tidy_TRHdata.md)
  : Tidy and Process Temperature and Relative Humidity data
- [`tidy_Meaco()`](https://bhavshah01.github.io/ConSciR/reference/tidy_Meaco.md)
  : Tidy Meaco sensor data
- [`tidy_Hanwell()`](https://bhavshah01.github.io/ConSciR/reference/tidy_Hanwell.md)
  : Tidy Hanwell EMS Data
- [`parse_brand()`](https://bhavshah01.github.io/ConSciR/reference/parse_brand.md)
  : Parse datalogger files
- [`combine_data()`](https://bhavshah01.github.io/ConSciR/reference/combine_data.md)
  : Combine TRH data from a list

## Conservation tools

Risk calculations; mould, preservation, lifetime, moisture equilibrium.

- [`calcMould_Zeng()`](https://bhavshah01.github.io/ConSciR/reference/calcMould_Zeng.md)
  : Calculate Mould Growth Rate Limits (Zeng et al.)
- [`calcMould_VTT()`](https://bhavshah01.github.io/ConSciR/reference/calcMould_VTT.md)
  : Calculate Mould Growth Index (VTT model)
- [`calcPI()`](https://bhavshah01.github.io/ConSciR/reference/calcPI.md)
  : Calculate Preservation Index
- [`calcLM()`](https://bhavshah01.github.io/ConSciR/reference/calcLM.md)
  : Calculate Life-time Multiplier for chemical degradation
- [`calcEMC_wood()`](https://bhavshah01.github.io/ConSciR/reference/calcEMC_wood.md)
  : Calculate Equilibrium Moisture Content for wood (EMC)

## Humidity functions

Functions for performing calculations from temperature and humidity
data.

- [`calcFtoC()`](https://bhavshah01.github.io/ConSciR/reference/calcFtoC.md)
  : Convert temperature (F) to temperature (C)
- [`calcAH()`](https://bhavshah01.github.io/ConSciR/reference/calcAH.md)
  : Calculate Absolute Humidity
- [`calcDP()`](https://bhavshah01.github.io/ConSciR/reference/calcDP.md)
  : Calculate Dew Point
- [`calcFP()`](https://bhavshah01.github.io/ConSciR/reference/calcFP.md)
  : Calculate Frost Point
- [`calcAD()`](https://bhavshah01.github.io/ConSciR/reference/calcAD.md)
  : Calculate Air Density
- [`calcSH()`](https://bhavshah01.github.io/ConSciR/reference/calcSH.md)
  : Calculate Specific Humidity
- [`calcMR()`](https://bhavshah01.github.io/ConSciR/reference/calcMR.md)
  : Calculate Mixing Ratio
- [`calcHR()`](https://bhavshah01.github.io/ConSciR/reference/calcHR.md)
  : Calculate Humidity Ratio
- [`calcPw()`](https://bhavshah01.github.io/ConSciR/reference/calcPw.md)
  : Calculate Water Vapour Pressure
- [`calcPws()`](https://bhavshah01.github.io/ConSciR/reference/calcPws.md)
  : Calculate Water Vapour Saturation Pressure
- [`calcEnthalpy()`](https://bhavshah01.github.io/ConSciR/reference/calcEnthalpy.md)
  : Calculate Enthalpy
- [`calcRH_AH()`](https://bhavshah01.github.io/ConSciR/reference/calcRH_AH.md)
  : Calculate Relative Humidity from temperature and absolute humidity
- [`calcRH_DP()`](https://bhavshah01.github.io/ConSciR/reference/calcRH_DP.md)
  : Calculate Relative Humidity from temperature and dew point
- [`calcTemp()`](https://bhavshah01.github.io/ConSciR/reference/calcTemp.md)
  : Calculate Temperature from relative humidity and dew point

## Sustainability

Tools for calculating energy consumption related to environmental
management.

- [`calcCoolingPower()`](https://bhavshah01.github.io/ConSciR/reference/calcCoolingPower.md)
  : Calculate Cooling Power
- [`calcCoolingCapacity()`](https://bhavshah01.github.io/ConSciR/reference/calcCoolingCapacity.md)
  : Calculate Cooling Capacity
- [`calcSensibleHeating()`](https://bhavshah01.github.io/ConSciR/reference/calcSensibleHeating.md)
  : Calculate Sensible Heating
- [`calcTotalHeating()`](https://bhavshah01.github.io/ConSciR/reference/calcTotalHeating.md)
  : Calculate Total Heating
- [`calcSensibleHeatRatio()`](https://bhavshah01.github.io/ConSciR/reference/calcSensibleHeatRatio.md)
  : Calculate Sensible Heat Ratio (SHR)

## Data

In-built datasets and data helper functions.

- [`mydata`](https://bhavshah01.github.io/ConSciR/reference/mydata.md) :
  Climate dataset to demonstrate functions
- [`TRHdata`](https://bhavshah01.github.io/ConSciR/reference/TRHdata.md)
  : Climate dataset to demonstrate functions
- [`data_file_path()`](https://bhavshah01.github.io/ConSciR/reference/data_file_path.md)
  : Return the file path to data files
- [`shiny_dataUploadServer()`](https://bhavshah01.github.io/ConSciR/reference/shiny_dataUploadServer.md)
  : Shiny Module Server for Data Upload and Processing
- [`shiny_dataUploadUI()`](https://bhavshah01.github.io/ConSciR/reference/shiny_dataUploadUI.md)
  : Shiny Module UI for Data Upload and Processing
