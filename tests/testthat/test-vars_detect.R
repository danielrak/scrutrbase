test_that("vars_detect works with named list", {
  data_list <- list(cars = cars, mtcars = mtcars)

  result <- vars_detect(data_list)

  expect_s3_class(result, "data.frame")
  expect_true("vars_union" %in% names(result))
  expect_true("cars" %in% names(result))
  expect_true("mtcars" %in% names(result))

  # cars has speed and dist; mtcars does not

  expect_equal(result$cars[result$vars_union == "speed"], "ok")
  expect_equal(result$cars[result$vars_union == "dist"], "ok")
  expect_equal(result$mtcars[result$vars_union == "speed"], "-")

  # mtcars has mpg; cars does not
  expect_equal(result$mtcars[result$vars_union == "mpg"], "ok")
  expect_equal(result$cars[result$vars_union == "mpg"], "-")

  # All 13 variables (2 from cars + 11 from mtcars, no overlap)
  expect_equal(nrow(result), 13)
})

test_that("vars_detect with overlapping variables", {
  df1 <- data.frame(a = 1, b = 2, c = 3)
  df2 <- data.frame(b = 4, c = 5, d = 6)

  result <- vars_detect(list(df1 = df1, df2 = df2))

  expect_equal(nrow(result), 4)  # a, b, c, d
  expect_equal(result$df1[result$vars_union == "a"], "ok")
  expect_equal(result$df2[result$vars_union == "a"], "-")
  expect_equal(result$df1[result$vars_union == "b"], "ok")
  expect_equal(result$df2[result$vars_union == "b"], "ok")
  expect_equal(result$df1[result$vars_union == "d"], "-")
  expect_equal(result$df2[result$vars_union == "d"], "ok")
})

test_that("vars_detect errors on invalid input", {
  expect_error(vars_detect(cars), "named list of data frames")
  expect_error(vars_detect(list(cars, mtcars)), "named list")
  expect_error(vars_detect("cars"), "named list of data frames")
})
