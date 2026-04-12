test_that("inspect_write writes correct Excel output", {
  mydir <- file.path(tempdir(), "test_inspect_write")
  dir.create(mydir, showWarnings = FALSE)
  on.exit(unlink(mydir, recursive = TRUE))

  result_path <- inspect_write(
    data_frame = cars,
    output_path = mydir,
    output_label = "cars"
  )

  expect_true(file.exists(file.path(mydir, "inspect_cars.xlsx")))
  expect_equal(result_path, file.path(mydir, "inspect_cars.xlsx"))

  content <- readxl::read_xlsx(file.path(mydir, "inspect_cars.xlsx"))

  # First row should be "Obs = " with value
  expect_equal(content[[1]][1], "Obs =")
  expect_equal(content[[2]][1], "50")

  # Second row should be "Nvars = "
  expect_equal(content[[1]][2], "Nvars =")
  expect_equal(content[[2]][2], "2")
})

test_that("inspect_write uses deparse(substitute) when no label", {
  mydir <- file.path(tempdir(), "test_inspect_write_nolabel")
  dir.create(mydir, showWarnings = FALSE)
  on.exit(unlink(mydir, recursive = TRUE))

  inspect_write(data_frame = cars, output_path = mydir)

  expect_true(file.exists(file.path(mydir, "inspect_cars.xlsx")))
})

test_that("inspect_write errors correctly", {
  mydir <- file.path(tempdir(), "test_inspect_write_err")
  dir.create(mydir, showWarnings = FALSE)
  on.exit(unlink(mydir, recursive = TRUE))

  expect_error(inspect_write(data_frame = "not_a_df", output_path = mydir),
               "data_frame must be a data.frame")

  expect_error(inspect_write(data_frame = cars, output_path = "/nonexistent/path"),
               "output_path doesn't exist")
})
