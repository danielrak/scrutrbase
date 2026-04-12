test_that("vars_compclasses_not_allsame filters inconsistent types", {
  data_list <- list(cars = cars, mtcars = mtcars)
  vcompclasses <- vars_compclasses(data_list)

  result <- vars_compclasses_not_allsame(vcompclasses)

  # All numeric on both sides -> no inconsistencies
  expect_equal(nrow(result), 0)
})

test_that("vars_compclasses_not_allsame with mixed types", {
  df1 <- data.frame(x = 1:3, y = c("a", "b", "c"), stringsAsFactors = FALSE)
  df2 <- data.frame(x = c(1.1, 2.2, 3.3), y = factor(c("a", "b", "c")))

  vcompclasses <- vars_compclasses(list(df1 = df1, df2 = df2))
  result <- vars_compclasses_not_allsame(vcompclasses)

  # x (integer vs numeric) and y (character vs factor) are inconsistent
  expect_equal(nrow(result), 2)
  expect_true(all(c("x", "y") %in% result$vars_union))
})
