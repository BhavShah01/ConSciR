# Tests
## Humidity formula checks
Temp = seq(0.5, 50, 0.5)
RH = seq(1, 100, 1)
testthat::test_that("Temp conversion check", {
  expect_equal(Temp, calcFtoC((Temp * 9/5) + 32))
})
testthat::test_that("Temp conversion check", {
  expect_equal(20, calcFtoC((20 * 9/5) + 32))
})
testthat::test_that("RH partial pressure check", {
  expect_equal(RH, 100 * (calcPw(Temp, RH) / calcPws(Temp)), tolerance = 0.0000001)
})
testthat::test_that("RH partial pressure check", {
  expect_equal(50, 100 * (calcPw(20, 50) / calcPws(20)), tolerance = 0.0000001)
})
testthat::test_that("calcRH_DP check", {
  expect_equal(RH, calcRH_DP(Temp, calcDP(Temp, RH)), tolerance = 0.0000001)
})
testthat::test_that("calcRH_DP check", {
  expect_equal(50, calcRH_DP(20, calcDP(20, 50)), tolerance = 0.000001)
})
testthat::test_that("calcRH_AH check", {
  expect_equal(RH, calcRH_AH(Temp, calcAH(Temp, RH)), tolerance = 0.0000001)
})
testthat::test_that("calcRH_AH check", {
  expect_equal(50, calcRH_AH(20, calcAH(20, 50)), tolerance = 0.0000001)
})
