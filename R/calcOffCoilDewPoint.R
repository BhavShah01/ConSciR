calcOffCoilDewPoint <- function(onCoilDryBulb, chwFlowTemp, chwReturnTemp, betaFactor = 0.9) {
  # Calculate average chilled water temperature
  avgChwTemp <- (chwFlowTemp + chwReturnTemp) / 2

  # Calculate potential temperature drop
  potentialTempDrop <- onCoilDryBulb - avgChwTemp

  # Apply beta factor to get actual temperature drop
  actualTempDrop <- potentialTempDrop * betaFactor

  # Calculate off-coil temperature (supply air temperature)
  offCoilTemp <- onCoilDryBulb - actualTempDrop

  return(offCoilTemp)
}


# This function takes the following inputs:
#   onCoilDryBulb: On-coil dry bulb temperature
# chwFlowTemp: Chilled water flow temperature
# chwReturnTemp: Chilled water return temperature
# betaFactor: Coil efficiency factor (default is 0.9)
# The function returns the off-coil temperature, which is often considered the dew point temperature of the supply air.
# Here's how the calculation works:
# Calculate the average chilled water temperature.
# Determine the potential temperature drop (difference between on-coil dry bulb and average chilled water temperature).
# Apply the beta factor to get the actual temperature drop.
# Subtract the actual temperature drop from the on-coil dry bulb temperature to get the off-coil temperature.
