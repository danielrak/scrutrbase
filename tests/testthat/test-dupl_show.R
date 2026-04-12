test_that("dupl_show finds duplicates on single key", {
  df <- data.frame(
    person_id = c(1, 1, 2, 3, 2, 4, 5, 5, 1),
    person_age = c(25, 25, 21, 32, 21, 48, 50, 50, 52),
    survey_month = c("jan", "feb", "mar", "apr", "apr", "may", "jun", "jul", "jan"),
    survey_answer = c("no", "yes", "no", "yes", "yes", "yes", "no", "yes", NA)
  )

  set.seed(1)
  df <- df[sample(1:nrow(df)), sample(1:ncol(df))]

  result <- dupl_show(df, "person_id")

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 7)
  expect_equal(names(result)[1], "person_id")
  expect_true(all(result$person_id %in% c(1, 2, 5)))
})

test_that("dupl_show finds duplicates on compound key", {
  df <- data.frame(
    person_id = c(1, 1, 2, 3, 2, 4, 5, 5, 1),
    person_age = c(25, 25, 21, 32, 21, 48, 50, 50, 52),
    survey_month = c("jan", "feb", "mar", "apr", "apr", "may", "jun", "jul", "jan"),
    survey_answer = c("no", "yes", "no", "yes", "yes", "yes", "no", "yes", NA)
  )

  set.seed(1)
  df <- df[sample(1:nrow(df)), sample(1:ncol(df))]

  result <- dupl_show(df, c("person_id", "survey_month"))

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_equal(names(result)[1], "person_id")
  expect_equal(names(result)[2], "survey_month")
})

test_that("dupl_show returns empty for no duplicates", {
  df <- data.frame(id = 1:5, val = letters[1:5])
  result <- dupl_show(df, "id")
  expect_equal(nrow(result), 0)
})
