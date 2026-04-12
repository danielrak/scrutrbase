test_that("replace_multiple first occurrence", {
  input <- c("one-one", "two-two-one", "three-three-two")

  expect_identical(
    replace_multiple(input, replacements = c("one" = "1", "two" = "2", "three" = "3")),
    c("1-one", "2-two-one", "3-three-two")
  )
})

test_that("replace_multiple all occurrences", {
  input <- c("one-one", "two-two-one", "three-three-two")

  expect_identical(
    replace_multiple(input, replacements = c("one" = "1", "two" = "2", "three" = "3"),
                     replace_all = TRUE),
    c("1-1", "2-2-one", "3-3-two")
  )
})

test_that("replace_multiple errors on invalid input", {
  expect_error(replace_multiple(1:2, c("A" = "B")),
               "input_vector must be a character vector")

  expect_error(replace_multiple(c("A", "B"), 1:2),
               "replacements must be a character vector")
})

test_that("replace_multiple errors on duplicate patterns", {
  expect_error(
    replace_multiple(c("a", "b"), c("a" = "1", "a" = "2")),
    "Original values must be unique"
  )
})
