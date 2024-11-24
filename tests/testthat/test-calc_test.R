testthat::test_that("Temp conversion check", {
  expect_equal(20, calcFtoC((20 * 9/5) + 32))
})
testthat::test_that("RH partial pressure check", {
  expect_equal(50, 100 * (calcPw(20, 50) / calcPws(20)), tolerance = 0.001)
})
testthat::test_that("calcRH_DP check", {
  expect_equal(50, calcRH_DP(20, calcDP(20, 50)), tolerance = 0.001)
})
testthat::test_that("calcRH_AH check", {
  expect_equal(50, calcRH_AH(20, calcAH(20, 50)), tolerance = 0.001)
})
