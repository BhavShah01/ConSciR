# # # parse_datalogger
# Central parsing function ----
test_that(
  "Central parsing function has expected columns and rows for Meaco, discards invalid files",
  {
    # 3 warnings expected for invalid files
    expect_equal(nrow(parse_brand(test_path(
      "fixtures", "meaco"
    ), brand = "meaco")), 20)
    expect_equal(names(parse_brand(test_path(
      "fixtures", "meaco"
    ), brand = "meaco")),
    c("Site", "Sensor", "Date", "Temp", "RH"))
    expect_true(sum(is.na(
      parse_brand(test_path("fixtures", "meaco"), brand = "meaco")
    )) == 0)

  }
)

# parse_hanwell ----
test_that("Hanwell file has correct number of columns and rows",
          {
            expect_equal(nrow(parse_hanwell(
              test_path("fixtures", "hanwell", "Hanwell_1.csv")
            )), 10)
            expect_equal(names(parse_hanwell(
              test_path("fixtures", "hanwell", "Hanwell_1.csv")
            )), c("Site", "Sensor", "Date", "Temp", "RH"))
          })

test_that("Hanwell file has no NA values", {
  expect_equal(sum(is.na((
    parse_hanwell(test_path("fixtures", "hanwell", "Hanwell_1.csv"))
  ))), 0)
})

test_that("Hanwell file has correct date format", {
  expect_equal(head(parse_hanwell(
    test_path("fixtures", "hanwell", "Hanwell_1.csv")
  )[3], 1),
  tidyr::tibble(
    "Date" = lubridate::parse_date_time("2025-11-21 00:00:00", tz = "UTC", orders = "Ymd HMS")
  ))
})

# parse_meaco ----
test_that("Pre-Gingerbread Meaco file has correct columns and rows with no NA values",
          {
            expect_equal(nrow(parse_meaco(
              test_path("fixtures", "meaco", "Meaco_1.csv")
            )), 10)
            expect_equal(names(parse_meaco(
              test_path("fixtures", "meaco", "Meaco_1.csv")
            )),
            c("Site", "Sensor", "Date", "Temp", "RH"))
          })

test_that("Pre-Gingerbread Meaco file has no NA values", {
  expect_true(sum(is.na(parse_meaco(
    test_path("fixtures", "meaco", "Meaco_1.csv")[1][1]
  ))) == 0)
})

test_that("Pre-Gingerbread Meaco file has correct date format", {
  expect_equal(head(parse_meaco(
    test_path("fixtures", "meaco", "Meaco_1.csv")
  )[3], 1),
  tidyr::tibble(
    "Date" = lubridate::parse_date_time("2025-11-06 15:59:00", tz = "UTC", orders = "Ymd HMS")
  ))
})

test_that("Gingerbread Meaco file has correct number of columns and rows with no NA values",
          {
            expect_equal(nrow(parse_meaco(
              test_path("fixtures", "meaco", "Meaco_3.csv")
            )), 10)
            expect_equal(names(parse_meaco(
              test_path("fixtures", "meaco", "Meaco_3.csv")
            )),
            c("Site", "Sensor", "Date", "Temp", "RH"))
          })

test_that("Gingerbread Meaco file has no NA values", {
  expect_true(sum(is.na(parse_meaco(
    test_path("fixtures", "meaco", "Meaco_3.csv")
  ))) == 0)
})

test_that("Gingerbread Meaco file has correct date format", {
  expect_equal(head(parse_meaco(
    test_path("fixtures", "meaco", "Meaco_3.csv")
  )[3], 1), tidyr::tibble("Date" = lubridate::parse_date_time("2025-12-31 00:04:00", tz = "UTC", orders = "Ymd HMS")))
})

# parse_miniclima ----
# No miniClima sample data

# parse_rotronic ----
test_that("Rotronic csv file has correct number of columns and rows with no NA values",
          {
            expect_equal(nrow(parse_rotronic(
              test_path("fixtures", "rotronic", "Rotronic_1.csv")
            )), 10)
            expect_equal(names(parse_rotronic(
              test_path("fixtures", "rotronic", "Rotronic_1.csv")
            )),
            c("Site", "Sensor", "Date", "Temp", "RH"))
            expect_equal(sum(is.na(parse_rotronic(
              test_path("fixtures", "rotronic", "Rotronic_1.csv")
            ))), 0)
          })

test_that("Rotronic tsv file has correct number of columns and rows with no NA values",
          {
            expect_equal(nrow(parse_rotronic(
              test_path("fixtures", "rotronic", "Rotronic_2.xls")
            )), 10)
            expect_equal(names(parse_rotronic(
              test_path("fixtures", "rotronic", "Rotronic_2.xls")
            )),
            c("Site", "Sensor", "Date", "Temp", "RH"))
            expect_equal(sum(is.na(parse_rotronic(
              test_path("fixtures", "rotronic", "Rotronic_2.xls")
            ))), 0)
          })

test_that("Rotronic csv file has correct date format", {
  expect_equal(head(parse_rotronic(
    test_path("fixtures", "rotronic", "Rotronic_1.csv")
  )[3], 1),
  tidyr::tibble(
    "Date" = lubridate::parse_date_time("2020-01-24 13:37:22", tz = "UTC", orders = 'Ymd HMS')
  ))
})

test_that("Rotronic tsv file has correct date format", {
  expect_equal(head(parse_rotronic(
    test_path("fixtures", "rotronic", "Rotronic_2.xls")
  )[3], 1),
  tidyr::tibble(
    "Date" = lubridate::parse_date_time("2020-01-24 13:08:35", tz = "UTC", orders = "Ymd HMS")
  ))
})

# parse_tandd ----
test_that("T&D file has correct number of columns and rows with no NA values", {
  expect_equal(nrow(parse_tandd(
    test_path("fixtures", "tandd", "TandD_1.csv")
  )), 10)
  expect_equal(names(parse_tandd(
    test_path("fixtures", "tandd", "TandD_1.csv")
  )),
  c("Site", "Sensor", "Date", "Temp", "RH"))
  expect_equal(sum(is.na(parse_tandd(
    test_path("fixtures", "tandd", "TandD_1.csv")
  ))), 0)
})

test_that("T&D file has correct date format", {
  expect_equal(head(parse_tandd(
    test_path("fixtures", "tandd", "TandD_1.csv")
  )[3], 1),
  tidyr::tibble(
    "Date" = lubridate::parse_date_time("2021-08-21 08:06:00", tz = "UTC", orders = "Ymd HMS")
  ))
})

# parse_tinytag ----
test_that("TinyTag file has correct number of columns and rows with no NA values",
          {
            expect_equal(nrow(parse_tinytag(
              test_path("fixtures", "tinytag", "TinyTag_1.csv")
            )), 10)
            expect_equal(names(parse_tinytag(
              test_path("fixtures", "tinytag", "TinyTag_1.csv")
            )),
            c("Site", "Sensor", "Date", "Temp", "RH"))
          })

test_that("TinyTag file has no NA values", {
  expect_equal(sum(is.na(parse_tinytag(
    test_path("fixtures", "tinytag", "TinyTag_1.csv")
  ))), 0)
})

test_that("TinyTag file has correct date format", {
  expect_equal(head(parse_tinytag(
    test_path("fixtures", "tinytag", "TinyTag_1.csv")
  )[3], 1),
  tidyr::tibble(
    "Date" = lubridate::parse_date_time("2021-07-26 14:26:00", tz = "UTC", orders = "Ymd HMS")
  ))
})

# parse_trend ----
test_that("TrendBMS file has correct number of columns and rows (T or RH only)",
          {
            expect_equal(nrow(parse_trendBMS(
              test_path("fixtures", "trend", "Trend_1.csv")
            )), 10)
            expect_equal(names(parse_trendBMS(
              test_path("fixtures", "trend", "Trend_1.csv")
            )), c("Site", "Sensor", "Date", "Temp"))
          })

test_that("TrendBMS file has no NA values", {
  expect_equal(sum(is.na((
    parse_trendBMS(test_path("fixtures", "trend", "Trend_1.csv"))
  ))), 0)
})

test_that("TrendBMS file has correct date format", {
  expect_equal(head(parse_trendBMS(
    test_path("fixtures", "trend", "Trend_1.csv")
  )[3], 1),
  tidyr::tibble(
    "Date" = lubridate::parse_date_time("2021-09-01 12:30:00", tz = "UTC", orders = "Ymd HMS")
  ))
})
