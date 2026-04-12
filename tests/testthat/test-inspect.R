test_that("inspect returns correct structure", {
  result <- inspect(CO2)

  expect_s3_class(result, "tbl_df")
  expect_true(all(c("variables", "class", "nb_distinct", "prop_distinct",
                     "nb_na", "prop_na", "nb_void", "prop_void",
                     "nchars", "modalities") %in% names(result)))
  expect_equal(nrow(result), ncol(CO2))
})

test_that("inspect values are correct for CO2", {
  result <- inspect(CO2)

  expect_equal(result$variables, names(CO2))
  expect_equal(result$nb_na, rep(0L, ncol(CO2)))
  expect_equal(result$nb_void, rep(0L, ncol(CO2)))
  expect_equal(result$nb_distinct[result$variables == "Type"], 2L)
  expect_equal(result$nb_distinct[result$variables == "Treatment"], 2L)
})

test_that("inspect detects NAs and voids", {
  df <- data.frame(
    x = c(1, NA, 3, NA),
    y = c("a", "", "c", ""),
    stringsAsFactors = FALSE
  )
  result <- inspect(df)

  expect_equal(result$nb_na[result$variables == "x"], 2L)
  expect_equal(result$nb_void[result$variables == "y"], 2L)
  expect_equal(result$prop_na[result$variables == "x"], 0.5)
  expect_equal(result$prop_void[result$variables == "y"], 0.5)
})

test_that("inspect nrow parameter emits message", {
  expect_message(inspect(cars, nrow = TRUE), "Number of observations: 50")
})

test_that("inspect handles POSIXct columns", {
  df <- data.frame(
    ts = as.POSIXct(c("2024-01-01", "2024-06-15")),
    val = c(1, 2)
  )
  result <- inspect(df)

  expect_equal(nrow(result), 2)
  expect_true("Date-time" %in% result$class || "POSIXct" %in% result$class)
})

test_that("inspect errors on non-dataframe", {
  expect_error(inspect(as.matrix(cars)),
               "data_frame must be an object of data.frame class")
})
