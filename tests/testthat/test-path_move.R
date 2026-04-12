test_that("path_move forward works", {
  pvector <- c(
    "level_1/level_2/level_3/file_1.ext",
    "level_1/level_2/level_3/file_2.ext"
  )

  expect_identical(path_move(pvector, "/", 1), c("level_1", "level_1"))
  expect_identical(path_move(pvector, "/", 2), c("level_1/level_2", "level_1/level_2"))
  expect_identical(path_move(pvector, "/", 3),
                   c("level_1/level_2/level_3", "level_1/level_2/level_3"))
})

test_that("path_move backward works", {
  pvector <- c(
    "level_1/level_2/level_3/file_1.ext",
    "level_1/level_2/level_3/file_2.ext"
  )

  expect_identical(path_move(pvector, "/", -1),
                   c("level_1/level_2/level_3", "level_1/level_2/level_3"))
  expect_identical(path_move(pvector, "/", -2),
                   c("level_1/level_2", "level_1/level_2"))
  expect_identical(path_move(pvector, "/", -3), c("level_1", "level_1"))
})

test_that("path_move with custom separator", {
  pvector <- c("a\\b\\c", "d\\e\\f")
  expect_identical(path_move(pvector, "\\", 2), c("a\\b", "d\\e"))
})

test_that("path_move errors correctly", {
  pvector <- c(
    "level_1/level_2/level_3/file_1.ext",
    "level_1/level_2/level_3/file_2.ext"
  )

  expect_error(path_move(pvector, "/", 0), "move must be different from 0")
  expect_error(path_move(pvector, "/", 5),
               "level must be comprised between one of these values")
  expect_error(path_move(pvector, "/", -4),
               "move absolute value must be strictly positive")
  expect_error(path_move(123, "/", 1), "path_vector must be a character vector")
  expect_error(path_move(pvector, "/", "a"), "move must be a numeric")

  # Unequal levels
  unequal <- c("a/b/c", "d/e")
  expect_error(path_move(unequal, "/", 1),
               "All path_vector elements must have the same number of levels")
})
