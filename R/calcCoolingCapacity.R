#' Calculate Cooling Capacity
#'
#' @description
#' This function calculates the required cooling capacity based on power consumption,
#' power factor, safety factor, and efficiency.
#'
#' Cooling capacity is the amount of energy transferred during a cooling process.
#'
#'
#' @param Power Power consumption in Watts (W).
#' @param power_factor Power factor, default is 0.85.
#' @param safety_factor Safety factor, default is 1.2 (20\% extra capacity).
#' @param efficiency Efficiency of the cooling system, default is 0.7 (70\%).
#'
#' @return Required cooling capacity in kilowatts (kW).
#' @export
#'
#' @examples
#' calcCoolingCapacity(1000)
#'
#' calcCoolingCapacity(1500, power_factor = 0.9, safety_factor = 1.3, efficiency = 0.8)
#'
#'
calcCoolingCapacity <- function(Power, power_factor = 0.85, safety_factor = 1.2, efficiency = 0.7) {

  # Heat generation from power consumption
  Q = Power

  # Q (kW)
  Q = Power / 1000 * power_factor

  # Apply safety factor
  Q_safe = Q * safety_factor

  # Calculate required cooling capacity
  cooling_capacity = Q_safe / efficiency

  # Return the result in kW
  return(cooling_capacity)
}
