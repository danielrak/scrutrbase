test_that("ljoin_checks performs correct join", {
  left_table <- data.frame(
    person_id = c(1, 1, 2, 3, 2, 4, 5, 5, 1),
    person_age = c(25, 25, 21, 32, 21, 48, 50, 50, 52)
  )
  right_table <- data.frame(
    person_id = c(2, 5, 4, 3, 1),
    person_name = c("John", "Marie", "Pierre", "Marc", "Jimmy")
  )

  result <- suppressMessages(ljoin_checks(left_table, right_table, by = "person_id"))

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), nrow(left_table))
  expect_true("person_name" %in% names(result))
  expect_equal(result$person_name[result$person_id == 1][1], "Jimmy")
})

test_that("ljoin_checks emits correct messages", {
  left <- data.frame(id = 1:3, x = c("a", "b", "c"))
  right <- data.frame(id = 2:4, y = c("d", "e", "f"))

  expect_message(ljoin_checks(left, right, by = "id"), "ltable rows")
  expect_message(ljoin_checks(left, right, by = "id"), "rtable rows")
  expect_message(ljoin_checks(left, right, by = "id"), "id are common var names")
})
