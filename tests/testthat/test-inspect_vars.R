test_that("inspect_vars creates correct Excel output", {
  mydir <- file.path(tempdir(), "test_inspect_vars")
  dir.create(mydir, showWarnings = FALSE)
  on.exit(unlink(mydir, recursive = TRUE))

  saveRDS(cars, file.path(mydir, "cars1.rds"))
  saveRDS(mtcars, file.path(mydir, "cars2.rds"))

  result_path <- inspect_vars(
    input_path = mydir,
    output_path = mydir,
    output_label = "cardata",
    considered_extensions = "rds"
  )

  expect_true(file.exists(file.path(mydir, "inspect_vars_cardata.xlsx")))

  # Read all 10 sheets
  sheets <- purrr::map(1:10, \(x)
    rio::import(file.path(mydir, "inspect_vars_cardata.xlsx"), sheet = x))

  # Sheet 1: dims
  dims <- sheets[[1]]
  expect_equal(dims$datasets, c("cars1", "cars2"))
  expect_equal(dims$nobs, c(50, 32))
  expect_equal(dims$nvar, c(2, 11))

  # Sheet 2: inspect_tot
  inspect_tot <- sheets[[2]]
  expect_true("datasets" %in% names(inspect_tot))
  expect_true("variables" %in% names(inspect_tot))
  expect_equal(nrow(inspect_tot), 13)  # 2 + 11 variables
  expect_true(all(c("cars1", "cars2") %in% inspect_tot$datasets))

  # Sheet 3: individual inspection for cars1
  inspect_cars1 <- sheets[[3]]
  expect_equal(inspect_cars1[[1]][1], "Obs =")  # First row is metadata

  # Sheet 5: vars_detect (columns should be clean names without extension)
  vars_detect_sheet <- sheets[[5]]
  expect_true("vars_union" %in% names(vars_detect_sheet))
  expect_true("cars1" %in% names(vars_detect_sheet))
  expect_true("cars2" %in% names(vars_detect_sheet))
  expect_equal(nrow(vars_detect_sheet), 13)

  # Sheet 6: vars_detect_everywhere (no common variables)
  expect_equal(nrow(sheets[[6]]), 0)

  # Sheet 7: vars_detect_not_everywhere (all 13)
  expect_equal(nrow(sheets[[7]]), 13)

  # Sheet 8: vars_compclasses
  expect_true("vars_union" %in% names(sheets[[8]]))

  # Sheet 9: vars_compclasses_allsame (all numeric -> all "same")
  expect_equal(nrow(sheets[[9]]), 13)

  # Sheet 10: vars_compclasses_not_allsame (none)
  expect_equal(nrow(sheets[[10]]), 0)
})

test_that("inspect_vars handles multiple extensions", {
  mydir <- file.path(tempdir(), "test_inspect_vars_multi")
  dir.create(mydir, showWarnings = FALSE)
  on.exit(unlink(mydir, recursive = TRUE))

  saveRDS(cars, file.path(mydir, "data1.rds"))
  rio::export(mtcars, file.path(mydir, "data2.csv"))

  # Only import rds files
  inspect_vars(
    input_path = mydir,
    output_path = mydir,
    output_label = "test",
    considered_extensions = "rds"
  )

  xlsx_path <- file.path(mydir, "inspect_vars_test.xlsx")
  expect_true(file.exists(xlsx_path))
  dims <- rio::import(xlsx_path, sheet = 1)
  expect_equal(nrow(dims), 1)  # Only one rds file
})

test_that("inspect_vars errors on empty folder", {
  mydir <- file.path(tempdir(), "test_inspect_vars_empty")
  dir.create(mydir, showWarnings = FALSE)
  on.exit(unlink(mydir, recursive = TRUE))

  expect_error(
    inspect_vars(input_path = mydir, output_path = mydir,
                 output_label = "test", considered_extensions = "rds"),
    "No files found"
  )
})

test_that("inspect_vars does not pollute global environment", {
  mydir <- file.path(tempdir(), "test_inspect_vars_noenv")
  dir.create(mydir, showWarnings = FALSE)
  on.exit(unlink(mydir, recursive = TRUE))

  saveRDS(cars, file.path(mydir, "mydata1.rds"))
  saveRDS(mtcars, file.path(mydir, "mydata2.rds"))

  before <- ls(envir = globalenv())

  inspect_vars(
    input_path = mydir,
    output_path = mydir,
    output_label = "noenv",
    considered_extensions = "rds"
  )

  after <- ls(envir = globalenv())

  # No new objects should appear in global env
  expect_equal(length(setdiff(after, before)), 0)
})
