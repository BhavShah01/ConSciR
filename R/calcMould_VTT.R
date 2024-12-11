#' Calculate Mould Growth Index (VTT model)
#'
#' @description
#' This function calculates the mould growth index on wooden materials based on temperature,
#' relative humidity, and other factors. It implements the mathematical model
#' developed by Hukka and Viitanen, which predicts mould growth under varying
#' environmental conditions.
#'
#' @details
#' Senstivity is related to the material surface, mould will grow on. Options in function avaiable are:
#'
#' \itemize{
#'   \item 'very' sensitive materials include pine and sapwood.
#'   \item 'sensitive' materials include glued wooden boards, PUR with paper surface, spruce
#'   \item 'medium' resistant materials include concrete, glass wool, polyester wool
#'   \item 'resistant' materials include PUR polished surface
#' }
#'
#'
#'
#'
#' @references
#' Hukka, A., Viitanen, H. A mathematical model of mould growth on wooden material. Wood Science and Technology 33, 475–485 (1999). https://doi.org/10.1007/s002260050131
#'
#' Viitanen, Hannu, and Tuomo Ojanen. "Improved model to predict mold growth in building materials." Thermal Performance of the Exterior Envelopes of Whole Buildings X–Proceedings CD (2007): 2-7.
#'
#'
#' @param Temp Temperature (°Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param M_prev The previous mould index value (default is 0).
#' @param sensitivity The sensitivity level of the material to mould growth. Options are 'very', 'sensitive', 'medium', or 'resistant'. Default is 'very'.
#' @param wood The wood species; 0 for pine and 1 for spruce. Default is 0.
#' @param surface The surface quality; 0 for resawn kiln dried timber and 1 for timber dried under normal kiln drying process. Default is 0 (worst case).
#'
#' @return M Mould growth index
#'
#' \itemize{
#'   \item 0 = No mould growth
#'   \item 1 = Small amounts of mould growth on surface visible under microscope
#'   \item 2 = Several local mould growth colonies on surface visible under microscope
#'   \item 3 = Visual findings of mould on surface <10\% coverage or 50\% coverage under microsocpe
#'   \item 4 = Visual findings of mould on surface 10-50\% coverage or >50\% coverage under microscope
#'   \item 5 = Plenty of growth on surface >50\% visual coverage
#'   \item 6 = Heavy and tight growth, coverage almost 100\%
#' }
#'
#'
#' @export
#'
#' @examples
#' calcMould_VTT(Temp = 25, RH = 85)
#'
#' calcMould_VTT(Temp = 18, RH = 70, M_prev = 2, sensitivity = "medium", wood = 1, surface = 1)
#'
#' head(mydata) |>
#'    dplyr::mutate(
#'       MouldIndex = calcMould_VTT(Temp, RH),
#'       MouldIndex_sensitve = calcMould_VTT(Temp, RH, sensitivity = "sensitive")
#'    )
#'
#'
#'
calcMould_VTT <- function(Temp, RH, M_prev = 0, sensitivity = "very", wood = 0, surface = 0) {

  # Constants for M based on sensitivity
  sensitivity_df <- data.frame(
    "Sensitivity" = c("very", "sensitive", "medium", "resistant"),
    "A" = c(1, 0.3, 0, 0),
    "B" = c(7, 6, 5, 3),
    "C" = c(2, 1, 1.5, 1)
  )

  constants <- sensitivity_df[sensitivity_df$Sensitivity == tolower(sensitivity), ]
  if (nrow(constants) == 0) {
    stop("Invalid sensitivity: choose from 'very', 'sensitive', 'medium', or 'resistant'.")
  }

  A <- constants$A
  B <- constants$B
  C <- constants$C

  # Vectorized function to handle NA values
  calc_mould <- function(temp, rh, m_prev) {
    if (is.na(temp) || is.na(rh)) {
      return(NA)
    }

    # Conditions favourable to initiation of mould growth (0-50C)
    RH_crit <-
      ifelse(
        temp > 20,
        80,
        -0.00267 * temp^3 + 0.160 * temp^2 + 3.13 * temp + 100)

    # Maximum Mould growth index M
    M_max <- A + B * ((RH_crit - rh) / (RH_crit - 100)) - C * ((RH_crit - rh) / (RH_crit - 100))^2

    # Response times Viitanen (1997a)
    t_m <- exp(-0.68 * log(temp) - 13.9 * log(rh) + 0.14 * wood + 66.02)
    t_v <- exp(-0.74 * log(temp) - 12.72 * log(rh) + 0.06 * wood + 61.50)

    # Correction coefficients
    k1 <- ifelse(M_max < 1, 1,  2 / (t_v / (t_m - 1)))
    # Coefficient for the retardation of growth in the later stages
    k2 <- max(1 - exp(2.3 * (m_prev - M_max)), 0)

    # Calculate mould growth rate
    dM_dt <- k1 * k2 * (1 / (7 * exp(-0.68 * log(temp) -
                                       13.9 * log(rh) +
                                       0.14 * wood -
                                       0.33 * surface +
                                       66.02)))

    # Update mould index
    M_new <- m_prev + dM_dt

    return(M_new)
  }

  # Vectorized function
  mapply(calc_mould, Temp, RH, M_prev)
}

