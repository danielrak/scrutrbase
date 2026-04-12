test_that("table_prop works with single variable", {
  df <- data.frame(
    x = c("a", "a", "b", "b", "b", "c")
  )

  result <- table_prop(df$x)
  expect_true(is.matrix(result))
  expect_equal(nrow(result), 3)
})

test_that("table_prop works with two variables", {
  df <- data.frame(
    variable_1 = c("v1_1", "v1_1", "v1_2", "v1_2", "v1_2", "v1_2"),
    variable_2 = c("v2_1", "v2_1", "v2_1", "v2_1", "v2_2", "v2_2")
  )

  result <- table_prop(df$variable_1, df$variable_2)
  expect_true(is.matrix(result))
  expect_equal(dim(result), c(2, 2))
})

test_that("table_prop margin and rounding", {
  df <- data.frame(
    x = c("a", "a", "b", "b"),
    y = c("c", "d", "c", "d")
  )

  result <- table_prop(df$x, df$y, margin = 2, round = 4)
  expect_true(is.matrix(result))
  # Each proportion within a column should sum to 1
  expect_true(all(grepl("\\(0\\.5\\)", result)))
})

test_that("table_prop noquote option", {
  result <- table_prop(c("a", "a", "b"), noquote = TRUE)
  expect_s3_class(result, "noquote")

  result2 <- table_prop(c("a", "a", "b"), noquote = FALSE)
  expect_false(inherits(result2, "noquote"))
})
