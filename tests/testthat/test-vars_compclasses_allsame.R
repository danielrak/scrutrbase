test_that("vars_compclasses_allsame filters consistent types", {
  data_list <- list(cars = cars, mtcars = mtcars)
  vcompclasses <- vars_compclasses(data_list)

  result <- vars_compclasses_allsame(vcompclasses)

  # All variables in cars/mtcars are numeric; absent vars are "-"
  # Variables with only one non-"-" class are "allsame"
  expect_equal(nrow(result), 13)
})

test_that("vars_compclasses_allsame with mixed types", {
  df1 <- data.frame(x = 1:3, y = c("a", "b", "c"), stringsAsFactors = FALSE)
  df2 <- data.frame(x = c(1.1, 2.2, 3.3), y = factor(c("a", "b", "c")))

  vcompclasses <- vars_compclasses(list(df1 = df1, df2 = df2))
  result <- vars_compclasses_allsame(vcompclasses)

  # Neither x (integer vs numeric) nor y (character vs factor) are allsame
  expect_equal(nrow(result), 0)
})

test_that("vars_compclasses_allsame with consistent types", {
  df1 <- data.frame(x = 1.0, y = 2.0)
  df2 <- data.frame(x = 3.0, y = 4.0)

  vcompclasses <- vars_compclasses(list(df1 = df1, df2 = df2))
  result <- vars_compclasses_allsame(vcompclasses)

  expect_equal(nrow(result), 2)
})
