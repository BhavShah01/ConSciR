#' Calculate Life-time Multiplier for chemical degradation
#'
#' @description
#' Function to calculate lifetime multiplier from temperature and relative humidity.
#'
#' The `calcLM` function calculates the lifetime multiplier for chemical degradation of
#' objects based on temperature and relative humidity conditions.
#' This metric provides an estimate of an object’s expected lifetime relative to
#' standard conditions (20°C and 50\% RH); values >1 indicate conditions
#' that prolong lifetime; values <1 indicate higher risk of chemical degradation.
#'
#'
#'
#' @details
#' Based on the experiments of the rate of decay of paper, films and dyes.
#' Activation energy, Ea = 100 J/mol (degradation of cellulose - paper),
#' 70 J/mol (yellowing of varnish - furniture, painting, sculpture).
#'
#' Gas constant, R = 8.314 J/K.mol
#'
#' \deqn{LM=\left(\frac{50\%RH}{RH}\right)^{1.3}.e\left(\frac{E_a}{R}.\left(\frac{1}{T_K}-\frac{1}{293}\right)\right)}
#'
#' The lifetime multiplier gives an indication of the speed of natural decay of an object.
#' It expresses an expected lifetime of an object compared to the expected lifetime of
#' the same object at 20°C and 50\% RH. This means that if the result = 1, the expected
#' lifetime for your object is 'good'. The closer you go to 0, the less suited your environment is.
#' The result is both expressed numerically and over time, which also gives an idea
#' about the period over the year when the object suffers most.
#' The data is based on experiments on paper, synthetic films and dyes.
#'
#'
#' @references
#' Michalski, S., ‘Double the life for each five-degree drop,
#' more than double the life for each halving of relative humidity’,
#' in Preprints of the 13th IcOM-cc Triennial Meeting in rio de Janeiro (22–27 September 2002),
#' ed. r. Vontobel, James & James, London (2002) Vol. I 66–72.
#'
#' Martens Marco, 2012: Climate Risk Assessment in Museums (Thesis, Tue).
#'
#'
#' @param Temp Temperature (Celsius)
#' @param RH Relative Humidity (0-100\%)
#' @param EA Activation Energy (J/mol).
#'  100 J/mol for cellulosic (paper) or 70 J/mol yellowing varnish
#'
#' @return Lifetime multiplier
#' @export
#'
#' @examples
#' # Lifetime multiplier at 20°C (Temp) and 50% relative humidity (RH)
#' calcLM(20, 50)
#'
#' calcLM(20, 50, EA = 70)
#'
#'
#' # mydata file
#' filepath <- data_file_path("mydata.xlsx")
#' mydata <- readxl::read_excel(filepath, sheet = "mydata", n_max = 5)
#'
#' mydata |> dplyr::mutate(LifeTime = calcLM(Temp, RH))
#'
#' mydata |>
#'   dplyr::mutate(LM = calcLM(Temp, RH)) |>
#'    dplyr::summarise(LM_avg = mean(LM, na.rm = TRUE))
#'
#'
calcLM = function(Temp, RH, EA = 100) {

  # EA = Activation energy J/mol
  # R = 8.314 J/K.mol

  TempK = Temp + 273.15

  LM = (50 / RH) ^ (1/3) * exp((-EA / 8.314) * (1 / TempK - 1 / 293.15))

  return(LM)
}
