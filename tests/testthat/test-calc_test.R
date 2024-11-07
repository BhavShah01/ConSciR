test_that("AH calc check", {
  expect_equal(calcRH(20, calcAH(20, 50)), 50.08653)
})
