# Tests
## Humidity formula checks
Temp = seq(0.5, 50, 0.5)
RH = seq(1, 100, 1)
testthat::test_that("Temp conversion check", {
  expect_equal(Temp, calcFtoC((Temp * 9/5) + 32))
})
testthat::test_that("RH partial pressure check", {
  expect_equal(RH, 100 * (calcPw(Temp, RH, method = "Buck") / calcPws(Temp, method = "Buck")), tolerance = 0.00000001)
})
testthat::test_that("RH partial pressure check", {
  expect_equal(RH, 100 * (calcPw(Temp, RH, method = "IAPWS") / calcPws(Temp, method = "IAPWS")), tolerance = 0.00000001)
})
testthat::test_that("RH partial pressure check", {
  expect_equal(RH, 100 * (calcPw(Temp, RH, method = "Magnus") / calcPws(Temp, method = "Magnus")), tolerance = 0.0000001)
})
testthat::test_that("RH partial pressure check", {
  expect_equal(RH, 100 * (calcPw(Temp, RH, method = "VAISALA") / calcPws(Temp, method = "VAISALA")), tolerance = 0.0000001)
})
testthat::test_that("RH partial pressure check (Pw <- Pws * RH / 100)", {
  expect_equal(calcPw(Temp, RH), calcPws(Temp) * (RH / 100), tolerance = 0.0000001)
})
testthat::test_that("calcRH_DP check", {
  expect_equal(RH, calcRH_DP(Temp, calcDP(Temp, RH)), tolerance = 0.0000001)
})
testthat::test_that("calcRH_AH check", {
  expect_equal(RH, calcRH_AH(Temp, calcAH(Temp, RH)), tolerance = 0.0000001)
})
testthat::test_that("calcTemp check", {
  expect_equal(Temp, calcTemp(RH, calcDP(Temp, calcRH_AH(Temp, calcAH(Temp, RH)))), tolerance = 0.0000001)
})
testthat::test_that("Mixing ratio and Humidity ratio", {
  expect_equal(calcHR(Temp, RH), calcMR(Temp, RH), tolerance = 0.0000001)
})
