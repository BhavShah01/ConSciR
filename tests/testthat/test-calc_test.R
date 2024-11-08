test_that("AH calc check", {
  expect_equal(calcRH(20, calcAH(20, 50)), 50.08653)
})
test_that("Temp conversion check", {
  expect_equal(calcFtoC((20 * 9/5) + 32), 20)
})
