test_that("vars_compclasses works with named list", {
  data_list <- list(cars = cars, mtcars = mtcars)

  result <- vars_compclasses(data_list)

  expect_s3_class(result, "data.frame")
  expect_true("vars_union" %in% names(result))
  expect_equal(nrow(result), 13)

  # speed is numeric in cars, absent from mtcars
  expect_equal(result$cars[result$vars_union == "speed"], "numeric")
  expect_equal(result$mtcars[result$vars_union == "speed"], "-")

  # mpg is numeric in mtcars, absent from cars
  expect_equal(result$mtcars[result$vars_union == "mpg"], "numeric")
  expect_equal(result$cars[result$vars_union == "mpg"], "-")
})

test_that("vars_compclasses detects different types", {
  df1 <- data.frame(x = 1:3, y = c("a", "b", "c"), stringsAsFactors = FALSE)
  df2 <- data.frame(x = c(1.1, 2.2, 3.3), y = factor(c("a", "b", "c")))

  result <- vars_compclasses(list(df1 = df1, df2 = df2))

  expect_equal(result$df1[result$vars_union == "x"], "integer")
  expect_equal(result$df2[result$vars_union == "x"], "numeric")
  expect_equal(result$df1[result$vars_union == "y"], "character")
  expect_equal(result$df2[result$vars_union == "y"], "factor")
})

test_that("vars_compclasses errors on invalid input", {
  expect_error(vars_compclasses(cars), "named list of data frames")
  expect_error(vars_compclasses(list(cars, mtcars)), "named list")
})
