% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calcRH_AH.R
\name{calcRH_AH}
\alias{calcRH_AH}
\title{Calculate Relative Humidity from temperature and absolute humidity}
\usage{
calcRH_AH(Temp, Abs, P_atm = 1013.25)
}
\arguments{
\item{Temp}{Temperature (°Celsius)}

\item{Abs}{Absolute Humidity (g/m³)}

\item{P_atm}{Atmospheric pressure = 1013.25 (hPa)}
}
\value{
Relative Humidity (0-100\%)
}
\description{
Function to calculate relative humidity (\%) from temperature (°C) and absolute humidity (g/m^3)
}
\examples{
# Calculate RH for temperature of 20°C and absolute humidity of 8.645471 g/m³
calcRH_AH(20, 8.630534)

calcRH_AH(20, calcAH(20, 50))

head(mydata) |> dplyr::mutate(Abs = calcAH(Temp, RH), RH2 = calcRH_AH(Temp, Abs))


}
\references{
Buck, A. L. (1981). New equations for computing vapor pressure and enhancement factor.
Journal of Applied Meteorology, 20(12), 1527-1532.
}
\seealso{
\code{\link{calcAH}} for calculating absolute humidity

\code{\link{calcTemp}} for calculating temperature

\code{\link{calcRH_DP}} for calculating relative humidity from dew point

\code{\link{calcDP}} for calculating dew point
}
