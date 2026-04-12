test_that("vars_detect_not_everywhere returns non-universal variables", {
  data_list <- list(cars = cars, mtcars = mtcars)
  vdetect_table <- vars_detect(data_list)

  result <- vars_detect_not_everywhere(vdetect_table)

  # All 13 variables are non-universal (no overlap between cars and mtcars)
  expect_equal(nrow(result), 13)
})

test_that("vars_detect_not_everywhere with overlapping variables", {
  df1 <- data.frame(a = 1, b = 2, c = 3)
  df2 <- data.frame(b = 4, c = 5, d = 6)

  vdetect_table <- vars_detect(list(df1 = df1, df2 = df2))
  result <- vars_detect_not_everywhere(vdetect_table)

  # a and d are not everywhere
  expect_equal(nrow(result), 2)
  expect_true(all(c("a", "d") %in% result$vars_union))
})
