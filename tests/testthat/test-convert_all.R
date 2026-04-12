test_that("convert_all converts files correctly", {
  mydir <- system.file("permadir_examples_and_tests/convert_all", package = "industtry")
  outdir <- file.path(tempdir(), "test_convert_all")
  dir.create(outdir, showWarnings = FALSE)
  on.exit(unlink(outdir, recursive = TRUE))

  result <- convert_all(
    input_folderpath = mydir,
    considered_extensions = c("rds", "csv"),
    to = "csv",
    output_folderpath = outdir
  )

  csv_files <- list.files(outdir, pattern = "\\.csv$")
  expect_true(length(csv_files) > 0)
})

test_that("convert_all handles no matching files", {
  outdir <- file.path(tempdir(), "test_convert_all_empty")
  dir.create(outdir, showWarnings = FALSE)
  on.exit(unlink(outdir, recursive = TRUE))

  expect_message(
    convert_all(
      input_folderpath = outdir,
      considered_extensions = "xyz",
      to = "csv"
    ),
    "No files found"
  )
})

test_that("convert_all errors on invalid input", {
  expect_error(convert_all(input_folderpath = "noexist"),
               "input_folderpath must be a valid path")

  mydir <- system.file("permadir_examples_and_tests/convert_all", package = "industtry")

  expect_error(convert_all(input_folderpath = mydir, considered_extensions = 1),
               "considered_extensions must be a character vector")

  expect_error(convert_all(input_folderpath = mydir,
                           considered_extensions = "rds", to = 1),
               "to must be a 1L character vector")

  expect_error(convert_all(input_folderpath = mydir,
                           considered_extensions = "rds",
                           to = "csv", output_folderpath = "noexist"),
               "output_folderpath must be a valid path")
})
