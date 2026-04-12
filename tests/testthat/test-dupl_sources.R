test_that("dupl_sources list output", {
  df <- data.frame(
    person_id = c(1, 1, 2, 3, 2, 4, 5, 5, 1),
    person_age = c(25, 25, 21, 32, 21, 48, 50, 50, 52),
    survey_month = c("jan", "feb", "mar", "apr", "apr", "may", "jun", "jul", "jan"),
    survey_answer = c("no", "yes", "no", "yes", "yes", "yes", "no", "yes", NA)
  )
  set.seed(1)
  df <- df[sample(1:nrow(df)), sample(1:ncol(df))]

  result <- dupl_sources(data_frame = df, vars = "person_id")

  expect_true(is.list(result))
  expect_equal(length(result), 3)  # 3 duplicated person_ids: 1, 2, 5
})

test_that("dupl_sources dataframe output", {
  df <- data.frame(
    person_id = c(1, 1, 2, 3, 2, 4, 5, 5, 1),
    person_age = c(25, 25, 21, 32, 21, 48, 50, 50, 52),
    survey_month = c("jan", "feb", "mar", "apr", "apr", "may", "jun", "jul", "jan"),
    survey_answer = c("no", "yes", "no", "yes", "yes", "yes", "no", "yes", NA)
  )
  set.seed(1)
  df <- df[sample(1:nrow(df)), sample(1:ncol(df))]

  result_df <- dupl_sources(data_frame = df, vars = "person_id", output_as_df = TRUE)

  expect_s3_class(result_df, "data.frame")
  expect_equal(nrow(result_df), 3)
})

test_that("dupl_sources compound key", {
  df <- data.frame(
    person_id = c(1, 1, 2, 3, 2, 4, 5, 5, 1),
    person_age = c(25, 25, 21, 32, 21, 48, 50, 50, 52),
    survey_month = c("jan", "feb", "mar", "apr", "apr", "may", "jun", "jul", "jan"),
    survey_answer = c("no", "yes", "no", "yes", "yes", "yes", "no", "yes", NA)
  )
  set.seed(1)
  df <- df[sample(1:nrow(df)), sample(1:ncol(df))]

  result <- dupl_sources(data_frame = df, vars = c("person_id", "survey_month"))

  expect_true(is.list(result))
  expect_true(length(result) >= 1)
})
