test_that("vars_detect_everywhere returns common variables only", {
  data_list <- list(cars = cars, mtcars = mtcars)
  vdetect_table <- vars_detect(data_list)

  result <- vars_detect_everywhere(vdetect_table)

  # cars and mtcars have no common variables
  expect_equal(nrow(result), 0)
  expect_true("vars_union" %in% names(result))
})

test_that("vars_detect_everywhere with overlapping variables", {
  df1 <- data.frame(a = 1, b = 2, c = 3)
  df2 <- data.frame(b = 4, c = 5, d = 6)

  vdetect_table <- vars_detect(list(df1 = df1, df2 = df2))
  result <- vars_detect_everywhere(vdetect_table)

  # b and c are in both
  expect_equal(nrow(result), 2)
  expect_true(all(c("b", "c") %in% result$vars_union))
})
