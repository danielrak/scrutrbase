test_that("convert_r converts files correctly", {
  mydir <- system.file("permadir_examples_and_tests/convert_r", package = "industtry")
  outdir <- file.path(tempdir(), "test_convert_r")
  dir.create(outdir, showWarnings = FALSE)
  on.exit(unlink(outdir, recursive = TRUE))

  mask <- data.frame(
    folder_path = rep(mydir, 2),
    file = c("original_cars.rds", "original_mtcars.csv"),
    converted_file = c("converted_cars.csv", "converted_mtcars.rds"),
    to_convert = rep(1, 2)
  )
  mask_path <- file.path(outdir, "mask.xlsx")
  writexl::write_xlsx(mask, mask_path)

  result <- convert_r(mask_filepath = mask_path, output_path = outdir)

  expect_true(file.exists(file.path(outdir, "converted_cars.csv")))
  expect_true(file.exists(file.path(outdir, "converted_mtcars.rds")))

  # Verify content is preserved
  converted_cars <- rio::import(file.path(outdir, "converted_cars.csv"))
  expect_equal(nrow(converted_cars), 50)
  expect_equal(ncol(converted_cars), 2)
})

test_that("convert_r handles to_convert filter", {
  mydir <- system.file("permadir_examples_and_tests/convert_r", package = "industtry")
  outdir <- file.path(tempdir(), "test_convert_r_filter")
  dir.create(outdir, showWarnings = FALSE)
  on.exit(unlink(outdir, recursive = TRUE))

  mask <- data.frame(
    folder_path = rep(mydir, 2),
    file = c("original_cars.rds", "original_mtcars.csv"),
    converted_file = c("converted_cars.csv", "converted_mtcars.csv"),
    to_convert = c(1, 0)  # Only convert first
  )
  mask_path <- file.path(outdir, "mask.xlsx")
  writexl::write_xlsx(mask, mask_path)

  convert_r(mask_filepath = mask_path, output_path = outdir)

  expect_true(file.exists(file.path(outdir, "converted_cars.csv")))
  expect_false(file.exists(file.path(outdir, "converted_mtcars.csv")))
})

test_that("convert_r handles empty mask", {
  mydir <- system.file("permadir_examples_and_tests/convert_r", package = "industtry")
  outdir <- file.path(tempdir(), "test_convert_r_empty")
  dir.create(outdir, showWarnings = FALSE)
  on.exit(unlink(outdir, recursive = TRUE))

  mask <- data.frame(
    folder_path = mydir,
    file = "original_cars.rds",
    converted_file = "converted.csv",
    to_convert = 0
  )
  mask_path <- file.path(outdir, "mask.xlsx")
  writexl::write_xlsx(mask, mask_path)

  expect_message(convert_r(mask_filepath = mask_path, output_path = outdir),
                 "No files marked for conversion")
})

test_that("convert_r errors on invalid paths", {
  expect_error(
    convert_r("~/noexist/mask.xlsx", output_path = tempdir()),
    "mask_filepath doesn't exist"
  )

  mydir <- system.file("permadir_examples_and_tests/convert_r", package = "industtry")
  mask <- data.frame(
    folder_path = mydir,
    file = "original_cars.rds",
    converted_file = "converted.csv",
    to_convert = 1
  )
  mask_path <- file.path(tempdir(), "test_mask_err.xlsx")
  writexl::write_xlsx(mask, mask_path)
  on.exit(file.remove(mask_path), add = TRUE)

  expect_error(
    convert_r(mask_path, paste0(tempdir(), "/noexist")),
    "output_path doesn't exist"
  )
})
